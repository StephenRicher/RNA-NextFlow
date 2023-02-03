// RNA-NextFlow
// Best Practice Guidelines: https://nf-co.re/docs/contributing/modules

include { FASTQC } from './modules/fastqc'
include { CUTADAPT } from './modules/cutadapt'
include { MULTIQC } from './modules/multiqc'

workflow ANALYSIS {
    take:
    data
    
    main:
    data_flat = data.flatMap{ flatten_samples(it) }
    FASTQC(data_flat)
    CUTADAPT(data)

    // Combine + Collect QC reports
    qc_reports = Channel.of().concat( 
      FASTQC.out.zip,
      CUTADAPT.out.qc
    ).collect{ it[1] }
    MULTIQC(qc_reports)

    emit:
    multiqc_report = MULTIQC.out
}

workflow {
    // Read FASTQ data table
    data = Channel
        .fromPath(params.samples)
        .ifEmpty { exit 1, "ERROR: Cannot find file: ${params.samples}" }
        .splitCsv(header: ['id', 'fastq_r1', 'fastq_r2'])
        .map{ create_channels(it) }
    ANALYSIS(data)
}

// Function to get list of samples
// Single-end: [ ID, [ fastq_R1, fastq_R2 ] ]
// Paired-end: [ ID, [ fastq_R1 ] ]
def create_channels(LinkedHashMap row) {
  //def array = []
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

// Flattens paired read samples
def flatten_samples(List sample) {
  sample_id = sample[0]
  fastq_r1 = sample[1][0]
  fastq_r2 = sample[1][1]
  if (fastq_r2 == null) {
    array = [
      ["${sample_id}_R1", [fastq_r1] ]
    ]
  } else {
    array = [ 
      ["${sample_id}_R1", [fastq_r1] ], 
      ["${sample_id}_R2", [fastq_r2] ]
    ]
  }

  return array
}
