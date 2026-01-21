#!/bin/bash
#SBATCH --job-name=s3_upload_WPM
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=12:00:00
#SBATCH --output=s3_upload_%j.out
#SBATCH --error=s3_upload_%j.err
#SBATCH --mail-user=grace.fang@curtin.edu.au
#SBATCH --mail-type=ALL

set -euo pipefail

# Load AWS CLI module if needed
module load awscli/1.29.41   # adjust if your cluster uses a different version

# Define variables
LOCAL_DIR="/scratch/y95/gracefang/WPM_project/WPM_population_genetics"
BUCKET_PATH="s3://wpm.store.curtin.io/WPM_population_genetics"
PROFILE="wpm"

echo "=== Starting S3 upload job at $(date) ==="
echo "Local directory:  $LOCAL_DIR"
echo "Bucket target:    $BUCKET_PATH"
echo "Profile:          $PROFILE"
echo "Node:             $(hostname)"
echo

# Run sync (adds checksumming and multi-threading)
aws s3 sync "$LOCAL_DIR" "$BUCKET_PATH" --profile "$PROFILE" --only-show-errors

echo
echo "=== Upload complete at $(date) ==="
