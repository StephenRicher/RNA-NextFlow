process FASTQC {
    input:
    tuple val(id), path(filename)

    output:
    tuple val(id), path('*.zip') , emit: zip
    tuple val(id), path('*.html'), emit: html

    script:
    """
    fastqc $filename
    """
}