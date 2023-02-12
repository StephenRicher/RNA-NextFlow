process MULTIQC {
    input:
    // Use custom dir per file to avoid name collision
    path 'dir??/*' 

    output:
    path 'multiqc_report.html', emit: html

    script:
    """
    multiqc .
    """
}