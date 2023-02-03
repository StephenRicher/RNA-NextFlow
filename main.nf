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
    data.flatMap{ flatten_sample(it) }.view()
    //ANALYSIS(data)
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

// Flattens read samples
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
