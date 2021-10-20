require 'rbbt-util'
require 'rbbt/workflow'

Misc.add_libdir if __FILE__ == $0

Workflow.require_workflow "Sample"
Workflow.require_workflow "HTS"
Workflow.require_workflow "HTSBenchmark"

require 'rbbt/workflow/util/data'

module ARGO
  extend Workflow
  extend Workflow::Data

  data_dir Rbbt.data.find(:lib)

  data :evolution, :extension => :yaml
  dep_task :clonal_evolution_simulation, HTSBenchmark, :population, :evolution => :evolution

  dep_task :synthetic, HTSBenchmark, :bundle_tumor_normal, :evolution => :evolution

end

module Sample
  extend Workflow::Data

  data_dir Rbbt.data.find(:lib)

  dep ARGO, :clonal_evolution_simulation, :not_overriden => true
  dep_task :synthetic_BAM, HTS, :BAM, :fastq1 => :placeholder, :fastq2 => :placeholder do |jobname,options,dependencies|
    population = dependencies.flatten.select{|d| d.task_name == :clonal_evolution_simulation }.first
    fastq1 = population.file('tumor_read1.fq.gz')
    fastq2 = population.file('tumor_read2.fq.gz')
    {:inputs => options.merge(:fastq1 => fastq1, :fastq2 => fastq2), :jobname => jobname}
  end

  dep ARGO, :clonal_evolution_simulation, :not_overriden => true
  dep_task :synthetic_BAM_normal, HTS, :BAM, :fastq1 => :placeholder, :fastq2 => :placeholder do |jobname,options,dependencies|
    population = dependencies.flatten.select{|d| d.task_name == :clonal_evolution_simulation }.first
    fastq1 = population.file('normal_read1.fq.gz')
    fastq2 = population.file('normal_read2.fq.gz')
    {:inputs => options.merge(:fastq1 => fastq1, :fastq2 => fastq2), :jobname => jobname}
  end

  data :synthetic_BAM, :extension => :bam
  data :synthetic_BAM_normal, :extension => :bam
  dep_task :mutect2, HTS, :mutect2, :normal => :synthetic_BAM_normal, :tumor => :synthetic_BAM

  input :regions_to_slice, :file, "Regions to slice", nil, :required => true
  dep :BAM
  dep_task :slice_BAM, HTS, :extract_BAM_region_with_mates_samtools, :bam => :BAM, :bed_file => :regions_to_slice

  input :regions_to_slice, :file, "Regions to slice", nil, :required => true
  dep :BAM_normal
  dep_task :slice_BAM_normal, HTS, :extract_BAM_region_with_mates_samtools, :bam => :BAM_normal, :bed_file => :regions_to_slice
end

module ARGO

  TEXAS_SAMPLE = "TCRBOA7-WGS"

  input :regions_to_slice, :file, "Regions to slice", nil, :required => true
  dep Sample, :slice_BAM, :jobname => TEXAS_SAMPLE
  dep Sample, :slice_BAM_normal, :jobname => TEXAS_SAMPLE
  dep HTS, :revert_BAM, :bam_file => :slice_BAM, :jobname => TEXAS_SAMPLE, :by_group => false
  dep HTS, :revert_BAM, :bam_file => :slice_BAM_normal, :jobname => TEXAS_SAMPLE + "_normal", :by_group => false
  dep HTSBenchmark, :sliceref, :bed_file => :regions_to_slice, :reference => 'hg38', :do_vcf => true
  task :texas_benchmark => :text do
    bam, bam_normal, fastq, fastq_normal, ref = dependencies

    bam_dir = file('BAM')
    Open.link bam.path, bam_dir['Texas.bam']
    Open.link bam_normal.path, bam_dir['Texas_normal.bam']

    fastq_dir = file('FASTQ')
    Open.mkdir fastq_dir.tumor
    Open.mkdir fastq_dir.normal
    CMD.cmd(:samtools, "fastq -1 #{fastq_dir.tumor["tumor_read1.fq.gz"]} -2 #{fastq_dir.tumor["tumor_read2.fq.gz"]} -0 /dev/null -s /dev/null #{fastq.path}")
    CMD.cmd(:samtools, "fastq -1 #{fastq_dir.normal["normal_read1.fq.gz"]} -2 #{fastq_dir.normal["normal_read2.fq.gz"]} -0 /dev/null -s /dev/null #{fastq_normal.path}")

    Open.link ref.file('hg38'), File.join(files_dir, 'hg38')
    Dir.glob(files_dir + "/*") * "\n"
  end
end

#require 'MODULE/tasks/basic.rb'

#require 'rbbt/knowledge_base/MODULE'
#require 'rbbt/entity/MODULE'

