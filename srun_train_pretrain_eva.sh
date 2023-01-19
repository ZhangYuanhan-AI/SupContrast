
#!/bin/sh

mkdir -p logs
currenttime=`date "+%Y%m%d_%H%M%S"`



for folderid in 0 1 2 3 #3 #0 1 2 3
do
    for seed in 0
    do
        for lr in 0.005
        do
            export MASTER_PORT=$((12000 + $RANDOM % 20000))
            srun -p ntu --mpi=pmi2 --gres=gpu:1 -n1 -w SG-IDC2-10-51-5-63 \
            python main_supcon.py --batch_size 64 --learning_rate ${lr} --epochs 200 --temp 0.1 --dataset path --seed 0 --folder_id ${folderid} --model eva_large_patch14_196.in22k_ft_in22k_in1k --size 196 --cosine --pretrain \
            2>&1 | tee -a logs/${folderid}-${seed}-${lr}-${currenttime}.log > /dev/null &
            echo -e "\033[32m[ Please check log: \"logs/${folderid}-${seed}-${lr}-${currenttime}.log\" for details. ]\033[0m"
        done
    done
done