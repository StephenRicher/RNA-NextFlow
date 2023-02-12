process SALMON_QUANT {
    input:
    tuple val(id), path(fastq)
    path index

    output:
    tuple val(id), path('*'), emit: quants
    tuple val(id), path('*/lib_format_counts.json'), emit: info

    script:
    """
    salmon quant -i $index --libType A \
    -1 ${fastq[0]} -2 ${fastq[1]} -o ${id}
    """
}