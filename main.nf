// RNA-NextFlow
// Best Practice Guidelines: https://nf-co.re/docs/contributing/modules

include { FASTQC } from './modules/fastqc'
include { CUTADAPT } from './modules/cutadapt'
include { CUTADAPT_QC_NAME } from './modules/cutadapt_qc_name'
include { HISAT2 } from './modules/hisat2'
include { MULTIQC } from './modules/multiqc'
include { SALMON_INDEX } from './modules/salmon_index'
include { SALMON_QUANT } from './modules/salmon_quant'
include { GET_STRAND } from './modules/get_strand'

workflow ANALYSIS {
    take:
    data
    
    main:
    data_flat = data.flatMap{ flatten_sample(it) }
    FASTQC(data_flat)
    CUTADAPT(data)
    CUTADAPT_QC_NAME(CUTADAPT.out.qc)

    transcriptome = Channel.fromPath( params.transcriptome )
    SALMON_INDEX(transcriptome)
    salmon_idx = SALMON_INDEX.out.index.collect()
    SALMON_QUANT(CUTADAPT.out.fastq, salmon_idx)
    GET_STRAND(SALMON_QUANT.out.info)
    
    index = Channel.fromPath( "${params.index}*.ht2" ).collect()
    HISAT2(CUTADAPT.out.fastq, index, GET_STRAND.out.strand)

    // Combine + Collect QC reports
    qc_reports = Channel.of().concat( 
      FASTQC.out.zip,
      CUTADAPT_QC_NAME.out.qc,
      SALMON_QUANT.out.quants,
      HISAT2.out.qc
    ).collect{ it[1] }
    MULTIQC(qc_reports)

    emit:
    multiqc_report = MULTIQC.out
}

workflow {
    // Validate mandatory parameters
    params.each{ k, v -> if (v==null) { exit 1, "Error: parameter '$k' not set." } }
    // Read FASTQ data table
    data = Channel
        .fromPath(params.samples)
        .ifEmpty { exit 1, "ERROR: Cannot find file: ${params.samples}" }
        .splitCsv(header: ['id', 'fastq_r1', 'fastq_r2'])
        .map{ create_channels(it) }

    ANALYSIS(data)
}

// Function to get channel of (ID, samples)
// Single-end: [ ID, [ fastq_R1 ] ]
// Paired-end: [ ID, [ fastq_R1, fastq_R2 ] ]
def create_channels(LinkedHashMap row) {
  def array = []
  if (!file(row.fastq_r1).exists()) {
    exit 1, "ERROR: Cannot find file: ${row.fastq_r1}"
  }
  if (row.fastq_r2 == null) {
    array = [ row.id, [file(row.fastq_r1)] ]
  } else if (!file(row.fastq_r2).exists()) {
    exit 1, "ERROR: Cannot find file: ${row.fastq_r2}"
  } else {
    array = [ row.id, [file(row.fastq_r1), file(row.fastq_r2)]]
  }
  return array
}

// Flattens multi-file sample channels
// [ ID, [ fastq_R1, fastq_R2 ] ]  
// -> [ [ ID, [ fastq_R1 ] ], [ ID, [ fastq_R2 ] ] ]
def flatten_sample(List sample) {
  def array = []
  sample_id = sample[0]
  if (sample[1].size == 1) {
    array = [ [sample_id, [sample[1][0]] ] ]
  } else {
    sample[1].eachWithIndex { sub, i ->
      array.add(["${sample_id}_R${i+1}", [sub] ])
    }
  }
  return array
}
