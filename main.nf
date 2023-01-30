include { FASTQC } from './modules/fastqc'
include { CUTADAPT } from './modules/cutadapt'
include { MULTIQC } from './modules/multiqc'

workflow ANALYSIS {
    take:
    data
    
    main:
    FASTQC(data)
    CUTADAPT(data)

    // Gather qc output
    qc_reports = Channel.of().concat( 
      FASTQC.out.zip,
      CUTADAPT.out.qc
    ).collect{ it[1] }
    MULTIQC(qc_reports)

    emit:
    MULTIQC.out
}

workflow {
    data = Channel
        .fromPath(params.samples)
        .ifEmpty { exit 1, "ERROR: Cannot find file: ${params.samples}" }
        .splitCsv(header: ['id', 'fastq_r1', 'fastq_r2'])
        .map{ create_channels(it) }
    ANALYSIS(data)
}

// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def create_channels(LinkedHashMap row) {
  def array = []
  if (!file(row.fastq_r1).exists()) {
    exit 1, "ERROR: Cannot find file: ${row.fastq_r1}"
  }
  if (row.fastq_r2 == null) {
    array = [ row.id, file(row.fastq_r1) ]
  } else if (!file(row.fastq_r2).exists()) {
    exit 1, "ERROR: Cannot find file: ${row.fastq_r2}"
  } else {
    array = [ row.id, [file(row.fastq_r1), file(row.fastq_r2)]]
  }
  return array
}


// https://nf-co.re/docs/contributing/modules