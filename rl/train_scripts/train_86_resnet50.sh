python3 run.py\
        --task_id 86\
        --exp_name "resnet50"\
        --model_type resnet50\
        --stage train\
        --recordGif \
        --force_term \
        --max_ep 10000\
        --batch_size 64\
        --action_penalty 0.2\
        --start_learning_episode 1000\
        --comment "action_penalty_0.2"
