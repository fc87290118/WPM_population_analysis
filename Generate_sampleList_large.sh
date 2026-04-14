#!/bin/bash
set -euo pipefail

# Output file
OUT_TSV="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/sample_list_illumina"

# Directories
AUS_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/Aus_WPM_rawFastq"
EURO_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/Euro_WPM_rawFastq"
GLOBAL_DIR="/scratch/pawsey1142/gracefang/WPM_project/WPM_population_genetics/illumina_raw/Global_rawFastq"

# ensure output dir exists and truncate file
mkdir -p "$(dirname "$OUT_TSV")"
: > "$OUT_TSV"

make_pairs() {
    local DIR="$1"
    cd "$DIR"

    shopt -s nullglob

    for f in *.fastq *.fastq.gz; do
        [ -e "$f" ] || continue

        # R1 patterns: *_R1.fastq[.gz] OR *_1.fastq[.gz]
        if [[ "$f" =~ _R1\.fastq(.gz)?$ ]]; then
            r1="$f"
            r2="${f/_R1./_R2.}"
        elif [[ "$f" =~ _1\.fastq(.gz)?$ ]]; then
            r1="$f"
            r2="${f/_1./_2.}"
        else
            continue
        fi

        # skip if R2 missing
        [ -f "$r2" ] || continue

        # SAMPLE name: strip extensions and trailing _R1/_1
        sample="${f%.fastq}"
        sample="${sample%.fastq.gz}"
        sample="${sample%_R1}"
        sample="${sample%_1}"

        r1_path=$(realpath "$r1")
        r2_path=$(realpath "$r2")

        printf "%s\t%s\t%s\n" "$sample" "$r1_path" "$r2_path" >> "$OUT_TSV"
    done
}

make_pairs "$AUS_DIR"
make_pairs "$EURO_DIR"
make_pairs "$GLOBAL_DIR"
