
# Download and build a hisat2 transcript index for GRCh38 chr22.
wget ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip -c Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz | bgzip -c > GRCh38.fa.gz
rm Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
samtools faidx GRCh38.fa.gz 22 > GRCh38.chr22.fa

wget ftp://ftp.ensembl.org/pub/release-84/gtf/homo_sapiens/Homo_sapiens.GRCh38.84.gtf.gz  
gzip -d Homo_sapiens.GRCh38.84.gtf.gz
mv Homo_sapiens.GRCh38.84.gtf GRCh38.gtf
hisat2_extract_splice_sites.py GRCh38.gtf | awk '$1==22' > GRCh38.ss
hisat2_extract_exons.py GRCh38.gtf | awk '$1==22' > GRCh38.exon

hisat2-build --exon GRCh38.exon --ss GRCh38.ss GRCh38.chr22.fa GRCh38
