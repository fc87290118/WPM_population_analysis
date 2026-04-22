INPUT_TSV="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_qualimap"
QC_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/4b.qualimap_QC"
OUT_TSV="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_multibamqc.tsv"

awk -v qcdir="$QC_DIR" 'BEGIN{FS=OFS="\t"} {print $1, qcdir "/" $1 ".markdup_stats"}' "$INPUT_TSV" > "$OUT_TSV"