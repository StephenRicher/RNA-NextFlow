process CUTADAPT {
    input:
    tuple val(id), path(fastq)

    output:
    tuple val(id), path('*.fastq.gz'), emit: fastq
    tuple val(id), path('*.txt'),      emit: qc

    script:
    def args = task.ext.args ?: ''
    """
    cutadapt $args -o trimmed.fastq.gz $fastq > qc.txt
    """
}