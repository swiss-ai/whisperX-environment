#!/bin/bash
#SBATCH --job-name=thorsten_shard
#SBATCH --account=infra01
#SBATCH --partition=normal       # Use 'normal' for full runs
#SBATCH --time=12:00:00
#SBATCH --array=0-3             # Run 4 jobs (indices 0, 1, 2, 3)
#SBATCH --nodes=1               # 1 node per job
#SBATCH --ntasks=1
#SBATCH --gpus=1                # 1 GPU per job (Total 4 GPUs used)
#SBATCH --cpus-per-task=12
#SBATCH --environment=ngc-24.11-whisperx
#SBATCH --output=logs/slurm-%A_%a.out  # Separate log for each job


# Logs
mkdir -p logs

# Define total number of shards
NUM_SHARDS=4

# Download dataset
curl https://openslr.trmal.net/resources/95/thorsten-de_v02.tgz | tar -xz

# Run the script
srun bash -c "source .venv-whisperx/bin/activate && \
     python generatetimestamps.py \
     --shard_id ${SLURM_ARRAY_TASK_ID} \
     --num_shards ${NUM_SHARDS}"
