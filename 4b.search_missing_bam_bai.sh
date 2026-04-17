cd /scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/2b.MarkDuplicates

# 1) BAMs without BAI (from before, for completeness)
for b in *.bam; do
  [[ -e "$b" ]] || continue
  if [[ ! -f "${b}.bai" ]]; then
    echo "Missing index for BAM: $b"
  fi
done

# 2) BAIs without BAM
for i in *.bam.bai; do
  [[ -e "$i" ]] || continue
  bam="${i%.bai}"
  if [[ ! -f "$bam" ]]; then
    echo "Index without BAM: $i"
  fi
done
