include { FASTQC } from './modules/fastqc'
include { MULTIQC } from './modules/multiqc'

workflow PREPARE {
    take:
    data
    
    main:
    FASTQC(data)
    MULTIQC(FASTQC.out.zip.map{ it[1] }.collect())

    emit:
    MULTIQC.out
}

workflow {
    data = Channel
        .fromPath(params.samples)
        .ifEmpty { exit 1, "Cannot find file: ${params.samples}" }
        .splitCsv(header: ['id', 'fastq_r1', 'fastq_r2'])
        .map{ create_channels(it) }
    PREPARE(data)
}


// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def create_channels(LinkedHashMap row) {
  def array = []
  if (!file(row.fastq_r1).exists()) {
    exit 1, "ERROR: Please check input samplesheet -> File does not exist!\n${row.fastq_r1}"
  }
  if (row.fastq_r2 == null) {
    array = [ row.id, file(row.fastq_r1) ]
  } else if (!file(row.fastq_r2).exists()) {
    exit 1, "ERROR: Please check input samplesheet -> File does not exist!\n${row.fastq_r2}"
  } else {
    array = [ row.id, [file(row.fastq_r1), file(row.fastq_r2)]]
  }
  return array
}

// https://nf-co.re/docs/contributing/modules