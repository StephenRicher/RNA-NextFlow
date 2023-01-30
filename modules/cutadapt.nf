process CUTADAPT {
    input:
    tuple val(id), path(fastq)

    output:
    tuple val(id), path('*.fastq.gz'), emit: fastq
    tuple val(id), path('*.txt'),      emit: qc

    script:
    """
    cutadapt \\
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \\
        -o trimmed.fastq.gz $fastq > qc.txt
    """
}