process HISAT2 {
    input:
    tuple val(id), path(fastq)
    path index

    output:
    tuple val(id), path('*.bam'),      emit: bam
    tuple val(id), path('*.txt'),      emit: qc

    script:
    def args = task.ext.args ?: ''
    basename = index[0].toString().replaceFirst('...ht2$',"")
    """
    hisat2 $args -1 ${fastq[0]} -2 ${fastq[1]} -x $basename --summary-file ${id}.summary.txt \
    | samtools view -b > ${id}.aligned.bam
    """
}