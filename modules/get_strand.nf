process GET_STRAND {
    input:
    tuple val(id), path(lib_format)

    output:
    tuple val(id), env(strand) , emit: strand

    script:
    """
    strand=`infer_strand.py ${lib_format}`
    """
}