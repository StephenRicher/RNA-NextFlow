process SALMON_INDEX {
    input:
    path transcriptome

    output:
    path 'index', emit: index

    script:
    """
    salmon index -t $transcriptome -i index
    """
}