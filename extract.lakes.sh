#!/bin/bash

#SBATCH --qos=medium
#SBATCH --partition=standard
#SBATCH --account=isimip
#SBATCH --mem=80000
#SBATCH --time=12:00:00
#SBATCH --job-name=ISIMIPIO
#SBATCH --output=slurm.logs/extract.lakes._ROUND_._TYPE_._CLIM_._EXP_.%j.out
#SBATCH --error=slurm.logs/extract.lakes._ROUND_._TYPE_._CLIM_._EXP_.%j.err

module load python/3.9.12

python3 extract_lakes_xarray.py -p _ROUND_ -t _DATATIER_ -d _DATATYPE_ -m _CLIM_ -c _EXP_ -f _LAKES_FILE_ -o _OUTDIR_
