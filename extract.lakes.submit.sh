#!/bin/bash
####################################
# Supposed to work on the PIK cluster
####################################

ROUNDS="ISIMIP3a ISIMIP3b"
LAKES_FILE="Local_Lakes_ISIMIP3.csv"
OUTDIR_BASE="/p/tmp/buechner/extract_lakes_local"

DATA_TIER="InputData"
#DATA_TIER="SecondaryInputData"

for ROUND in $ROUNDS;do
  if [ "$DATA_TIER" == "InputData" ];then
    case $ROUND in
      ISIMIP3a)
        DATATYPES="obsclim counterclim"
        CLIMS="20CRv3 20CRv3-ERA5 20CRv3-W5E5 GSWP3-W5E5"
        EXPS="historical"
        ;;
      ISIMIP3b)
        DATATYPES="bias-adjusted"
        CLIMS="GFDL-ESM4 IPSL-CM6A-LR MPI-ESM1-2-HR MRI-ESM2-0 UKESM1-0-LL"
        EXPS="historical picontrol ssp126 ssp370 ssp585"
        ;;
    esac
  elif [ "$DATA_TIER" == "SecondaryInputData" ] && [ $ROUND == "ISIMIP3b" ];then
    DATATYPES="bias-adjusted"
    CLIMS="CNRM-CM6-1 CanESM5 GFDL-ESM4 IPSL-CM6A-LR MIROC6 MRI-ESM2-0"
    EXPS="hist-nat"
  fi

  for DATATYPE in $DATATYPES;do
    for CLIM in $CLIMS;do
      for EXP in $EXPS;do
        echo -n "submit $ROUND $DATA_TIER $DATATYPE $CLIM $EXP :: "
        OUTDIR=$OUTDIR_BASE/$ROUND/$DATA_TIER/$DATATYPE/lake-sites/daily/$EXP/$CLIM
        mkdir -p $OUTDIR
        sed -e s/_ROUND_/$ROUND/g \
          -e s/_DATATIER_/$DATA_TIER/g \
          -e s/_DATATYPE_/$DATATYPE/g \
          -e s/_CLIM_/$CLIM/g \
          -e s/_EXP_/$EXP/g \
          -e s/_LAKES_FILE_/"$LAKES_FILE"/g \
          -e s#_OUTDIR_#$OUTDIR#g < \
          extract.lakes.sh > \
          extract.lakes.sh.job

        chmod +x extract.lakes.sh.job
	sbatch ./extract.lakes.sh.job

        rm ./extract.lakes.sh.job
      done
    done
  done
done
