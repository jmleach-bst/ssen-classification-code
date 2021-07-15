#!/bin/bash
#SBATCH --share
#SBATCH --partition=short
#SBATCH --job-name=tau_cn_d_en
#SBATCH --error=tau_cn_d_en.err
#SBATCH --output=tau_cn_d_en.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jleach@uab.edu
#SBATCH --time=11:59:00
#SBATCH --mem-per-cpu=50GB

module load R/3.6.0-foss-2018a-X11-20180131-bare
srun R CMD BATCH /data/user/jleach/adni/Rcode/tau_cn_d_en.R
