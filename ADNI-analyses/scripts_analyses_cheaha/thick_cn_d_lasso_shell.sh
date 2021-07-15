#!/bin/bash
#SBATCH --share
#SBATCH --partition=short
#SBATCH --job-name=thick_cn_d_lasso
#SBATCH --error=thick_cn_d_lasso.err
#SBATCH --output=thick_cn_d_lasso.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jleach@uab.edu
#SBATCH --time=11:59:00
#SBATCH --mem-per-cpu=50GB

module load R/3.6.0-foss-2018a-X11-20180131-bare
srun R CMD BATCH /data/user/jleach/adni/Rcode/thick_cn_d_lasso.R
