
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


wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_43/gencode.v43.transcripts.fa.gz

curl https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_43/gencode.v43.transcripts.fa.gz \
| zcat \
| sed s'/|.*//' \
| bgzip > gencode.v43.transcripts.fa.gz
samtools faidx gencode.v43.transcripts.fa.gz

curl https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_43/gencode.v43.basic.annotation.gff3.gz \
| zcat \
| awk '$1=="chr22" && $3=="transcript" {print $9}' \
| awk -v FS=";|=" '{print $2}' \
> gencode.v43.txid.chr22.txt

samtools faidx gencode.v43.transcripts.fa.gz $(cat gencode.v43.txid.chr22.txt) \
> gencode.v43.transcripts.chr22.fa