awk '$4 >= 20' coverage_per_sample.tsv > coverage_ge20x.tsv
awk '$4 < 20'  coverage_per_sample.tsv > coverage_lt20x.tsv

cd /scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics

# 1) get list of high‑cov sample IDs
cut -f1 coverage_ge20x.tsv | sort > keep_samples.txt

# 2) sort the sample list
sort sample_list_coverage_stats > sample_list_coverage_stats.sorted

# 3) keep only rows whose SAMPLE is in keep_samples.txt
join -t $'\t' -j 1 keep_samples.txt sample_list_coverage_stats.sorted \
  > sample_list_coverage_ge20x
