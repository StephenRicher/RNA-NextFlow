process FASTQC {
    input:
    tuple val(id), path(fastq)

    output:
    tuple val(id), path('*.zip') , emit: zip
    tuple val(id), path('*.html'), emit: html

    script:
    """
    fastqc $fastq
    """
}