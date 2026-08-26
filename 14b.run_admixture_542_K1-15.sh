mkdir -p logs

echo "=================================================="
echo "ADMIXTURE analysis"
echo "=================================================="
echo "Date:       $(date)"
echo "Host:       $(hostname)"
echo "K:          ${K}"
echo "Threads:    ${SLURM_CPUS_PER_TASK}"
echo "Input BED:  ${INPUT_PREFIX}.bed"
echo "Container:  ${ADMIXTURE_IMAGE}"
echo "=================================================="

# ------------------------------------------------------------
# Check required input files
# ------------------------------------------------------------

test -f "${INPUT_PREFIX}.bed"
test -f "${INPUT_PREFIX}.bim"
test -f "${INPUT_PREFIX}.fam"
test -f "${ADMIXTURE_IMAGE}"

echo
echo "Input sample count:"
wc -l "${INPUT_PREFIX}.fam"

echo
echo "Input SNP count:"
wc -l "${INPUT_PREFIX}.bim"

echo
echo "Starting ADMIXTURE for K=${K}"
echo

# ------------------------------------------------------------
# Run ADMIXTURE
#
# --cv
#   default 5-fold cross-validation
#
# --haploid="*"
#   all individuals/chromosomes treated as haploid
#
# -j
#   number of CPU threads
#
# -s 12345
#   fixed seed for reproducibility
# ------------------------------------------------------------

singularity run \
  /scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/12.ADMIXTURE/admixture:1.3.0--0 \
    admixture \
    --cv \
    --haploid="*" \
    -j"${SLURM_CPUS_PER_TASK}" \
    -s 12345 \
    "${INPUT_PREFIX}.bed" \
    "${K}" \
  |& tee "logs/admixture_K${K}.log"

echo
echo "=================================================="
echo "Finished ADMIXTURE K=${K}"
echo "Date: $(date)"
echo "=================================================="
