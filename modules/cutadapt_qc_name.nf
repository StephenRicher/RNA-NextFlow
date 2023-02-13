process CUTADAPT_QC_NAME {
    input:
    tuple val(id), path(qc, stageAs: 'qc.in')

    output:
    tuple val(id), path('qc.out'), emit: qc

    script:
    """
    #!/usr/bin/python

    with open('qc.in', 'r') as f, open('qc.out', 'w') as out:
        for line in f:
            line = line.strip()
            if line.startswith('Command line parameters'):
                line += f' # ${id}'
            out.write(f'{line}\\n')
    """
}