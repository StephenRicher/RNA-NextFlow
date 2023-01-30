# RNA-NextFlow (in early development)

## A Nextwork workflow for automated processing and quality control of RNA-seq data.

*Note: This workflow is in early development and is not yet suitable for analysis.*

RNA-NextFlow aims to provide an accessible and user-friendly experience to analyse RNA-seq and will utilise a wide range of published tools.

 * [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) - A quality control tool for high throughput sequence data.
 * [FastQ Screen](https://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/) - A tool to screen for species composition in FASTQ sequences.
 * [Cutadapt](https://cutadapt.readthedocs.io/en/stable/) - Remove adapter sequences, primers, poly-A tails and others from high-throughput sequencing data.
 * [Kallisto](https://pachterlab.github.io/kallisto/about) - Quantify abundances of transcripts from RNA-Seq data using pseudoalignment.
 * [HISAT2](https://daehwankimlab.github.io/hisat2/manual/) - A fast and sensitive spliced aligner.
 * [Samtools](http://www.htslib.org/doc/samtools.html) - Interact with high-throughput sequencing data in SAM, BAM and CRAM formats.
 * [deepTools](https://deeptools.readthedocs.io/en/develop/) - Tools for analysis and quality control of high-throughput sequencing data.
 * [RSeQC](http://rseqc.sourceforge.net/) - Comprehensively evaluate and quality check high-throughput RNA sequencing data.
 * [featureCounts](http://subread.sourceforge.net/) - Count reads to genomic features such as genes, exons, promoters and genomic bins.
 * [MultiQC](https://multiqc.info/) - Aggregate results from bioinformatics analyses across many samples into a single report.

## Table of contents

  * [Installation](#installation)
  * [Configuration](#configuration)
  * [Usage](#usage)
  * [References](#references)

## Installation

RNA-NextFlow requires [NextFlow](https://www.nextflow.io/docs/latest/getstarted.html).

The RNA-NextFlow repository can be downloaded from GitHub as follows:

```bash
$ git clone https://github.com/StephenRicher/RNA-NextFlow.git
```

## Configuration
The RNA-NextFlow pipeline is fully controlled through a single configuration file that describes parameter settings and paths to relevant files in the system.
The configuration file for this example dataset can be found at [nextflow.config](./nextflow.config).

## Usage
Once NextFlow is installed the example dataset can be processed using the following command.

```bash
nextflow run main.nf
```

## References
* Köster, J. and Rahmann, S., 2012. Snakemake-a scalable bioinformatics workflow engine. Bioinformatics [Online]. Available from: https://doi.org/10.1093/bioinformatics/bts480.
* Hemphill, W., Rivera, O. and Talbert, M., 2018. RNA-sequencing of Drosophila melanogaster head tissue on high-sugar and high-fat diets. G3: Genes, Genomes, Genetics [Online]. Available from: [https://doi.org/10.1534/g3.117.300397](https://doi.org/10.1534/g3.117.300397).
* Simon Andrews, 2020. Babraham Bioinformatics - FastQC A Quality Control tool for High Throughput Sequence Data. Soil.
* Wingett, S.W. and Andrews, S., 2018. FastQ Screen: A tool for multi-genome mapping and quality control. F1000Research [Online]. Available from: https://doi.org/10.12688/f1000research.15931.2.
* Martin, M., 2011. Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal [Online]. Available from: https://doi.org/10.14806/ej.17.1.200.
* Bray, N.L., Pimentel, H., Melsted, P. and Pachter, L., 2016. Near-optimal probabilistic RNA-seq quantification. Nature Biotechnology [Online]. Available from: https://doi.org/10.1038/nbt.3519.
* Kim, D., Langmead, B. and Salzberg, S.L., 2015. HISAT: A fast spliced aligner with low memory requirements. Nature Methods [Online]. Available from: https://doi.org/10.1038/nmeth.3317.
* Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G. and Durbin, R., 2009. The Sequence Alignment/Map format and SAMtools. Bioinformatics [Online]. Available from: https://doi.org/10.1093/bioinformatics/btp352.
* Ramírez, F., Dündar, F., Diehl, S., Grüning, B.A. and Manke, T., 2014. DeepTools: A flexible platform for exploring deep-sequencing data. Nucleic Acids Research [Online]. Available from: https://doi.org/10.1093/nar/gku365.
* Wang, L., Wang, S. and Li, W., 2012. RSeQC: Quality control of RNA-seq experiments. Bioinformatics [Online]. Available from: https://doi.org/10.1093/bioinformatics/bts356.
* Liao, Y., Smyth, G.K. and Shi, W., 2014. FeatureCounts: An efficient general purpose program for assigning sequence reads to genomic features. Bioinformatics [Online]. Available from: https://doi.org/10.1093/bioinformatics/btt656.
* Ewels, P., Magnusson, M., Lundin, S. and Käller, M., 2016. MultiQC: Summarize analysis results for multiple tools and samples in a single report. Bioinformatics [Online]. Available from: https://doi.org/10.1093/bioinformatics/btw354.
* Pimentel, H., Bray, N.L., Puente, S., Melsted, P. and Pachter, L., 2017. Differential analysis of RNA-seq incorporating quantification uncertainty. Nature Methods [Online]. Available from: https://doi.org/10.1038/nmeth.4324.
* Robinson, M.D., McCarthy, D.J. and Smyth, G.K., 2009. edgeR: A Bioconductor package for differential expression analysis of digital gene expression data. Bioinformatics [Online]. Available from: https://doi.org/10.1093/bioinformatics/btp616.
* Love, M.I., Huber, W. and Anders, S., 2014. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology [Online]. Available from: https://doi.org/10.1186/s13059-014-0550-8.
