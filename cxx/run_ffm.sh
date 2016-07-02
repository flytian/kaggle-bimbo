#!/bin/bash

#SBATCH -p shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH -t 24:00:00
#SBATCH --mem=16gb
######PBS -l nodes=1:ppn=16:walltime=24:00:00:mem=64gb



export PYTHONPATH=$PYTHONPATH:/home/jxy198/xgboost/python-package
module load gsl
module load gnutools

PHOME=/home/jxy198/kaggle-inventory

echo "Start Feature Eng!"
cd $PHOME/cxx/valid81_cache
#$PHOME/cxx/main t1 wrr
#tail -31190083 ffm_tr.txt > ffm_tr.last3.txt #validation8
#tail -30981554 ffm_tr.txt > ffm_tr.last3.txt #validation9
#tail -31198430 ffm_tr.txt > ffm_tr.last3.txt #test

k=60
echo "Start FFM k=$k"
$PHOME/libffm-regression/ffm-train -l 0.002 --no-norm --auto-stop -p ffm_te2.txt -k $k ffm_tr.txt ffm_k${k}_sel.txt
#$PHOME/libffm-regression/ffm-predict ffm_te.txt ffm_k${k}_sel.txt ffm_te_pred.txt > ffm_te_fact.txt
#$PHOME/libffm-regression/ffm-predict ffm_tr.txt ffm_k${k}_sel.txt ffm_tr_pred.txt > ffm_tr_fact.txt

$PHOME/libffm-regression/ffm-train -l 0.002 --no-norm --auto-stop -p ffm_te2.txt -k $k ffm_tr.last3.txt ffm_k${k}_sel.last3.txt
#$PHOME/libffm-regression/ffm-predict ffm_te.txt ffm_k${k}_sel.last3.txt ffm_te_pred.last3.txt > /tmp/null

#pr -mts ffm_tr.txt ffm_tr_fact.txt| awk '{print $6,$7,$8,$9,$10,$11,$1}' > ffm_tr_knn_data.txt
#pr -mts ffm_te.txt ffm_te_fact.txt| awk '{print $6,$7,$8,$9,$10,$11,$1}' > ffm_te_knn_data.txt