process MULTIQC {
    input:
    path files

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc .
    """
}