#!/bin/bash

set -euo pipefail

# ============================================================
# Convert Bgt chromosome labels in a PLINK .bim file to numeric
# chromosome codes required by ADMIXTURE v1.3+
#
# Input:
#   Bgt_542_MAF005_LDpruned.bed
#   Bgt_542_MAF005_LDpruned.bim
#   Bgt_542_MAF005_LDpruned.fam
#
# Output:
#   Bgt_542_MAF005_LDpruned_admixture.bed
#   Bgt_542_MAF005_LDpruned_admixture.bim
#   Bgt_542_MAF005_LDpruned_admixture.fam
#   admixture_chromosome_mapping.txt
#
# Original PLINK files are not modified.
# ============================================================

WORKDIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/12.ADMIXTURE"

INPUT_PREFIX="${WORKDIR}/Bgt_542_MAF005_LDpruned"
OUTPUT_PREFIX="${WORKDIR}/Bgt_542_MAF005_LDpruned_admixture"

MAPPING="${WORKDIR}/admixture_chromosome_mapping.txt"

cd "${WORKDIR}"

echo "============================================"
echo "Converting chromosome labels for ADMIXTURE"
echo "Start: $(date)"
echo "============================================"

# ------------------------------------------------------------
# Check input files
# ------------------------------------------------------------

for EXT in bed bim fam
do
    if [[ ! -f "${INPUT_PREFIX}.${EXT}" ]]; then
        echo "ERROR: Missing ${INPUT_PREFIX}.${EXT}"
        exit 1
    fi
done

echo
echo "Original chromosome labels:"
cut -f1 "${INPUT_PREFIX}.bim" | sort -u

# ------------------------------------------------------------
# Create explicit Bgt chromosome mapping
# ------------------------------------------------------------

cat > "${MAPPING}" <<EOF
Bgt_USA_2_chr-01        1
Bgt_USA_2_chr-02        2
Bgt_USA_2_chr-03        3
Bgt_USA_2_chr-04        4
Bgt_USA_2_chr-05        5
Bgt_USA_2_chr-06        6
Bgt_USA_2_chr-07        7
Bgt_USA_2_chr-08        8
Bgt_USA_2_chr-09        9
Bgt_USA_2_chr-10        10
Bgt_USA_2_chr-11        11
EOF

echo
echo "Chromosome mapping:"
cat "${MAPPING}"

# ------------------------------------------------------------
# Copy BED and FAM unchanged
# ------------------------------------------------------------
cp "${INPUT_PREFIX}.bed" "${OUTPUT_PREFIX}.bed"
cp "${INPUT_PREFIX}.fam" "${OUTPUT_PREFIX}.fam"

# ------------------------------------------------------------
# Replace chromosome column in BIM
# ------------------------------------------------------------

awk '
BEGIN {
    OFS="\t"
}

NR==FNR {
    chr[$1]=$2
    next
}

{
    if (!($1 in chr)) {
        print "ERROR: unmapped chromosome label: " $1 > "/dev/stderr"
        exit 1
    }

    $1=chr[$1]
    print
}
' "${MAPPING}" "${INPUT_PREFIX}.bim" \
> "${OUTPUT_PREFIX}.bim"

# ------------------------------------------------------------
# Sanity checks
# ------------------------------------------------------------

echo
echo "Numeric chromosome labels after conversion:"
cut -f1 "${OUTPUT_PREFIX}.bim" | sort -n -u

echo
echo "Sample count:"
wc -l "${OUTPUT_PREFIX}.fam"

echo
echo "SNP count:"
wc -l "${OUTPUT_PREFIX}.bim"

echo
echo "BED file size:"
ls -lh "${OUTPUT_PREFIX}.bed"

echo
echo "============================================"
echo "Finished: $(date)"
echo "============================================"
