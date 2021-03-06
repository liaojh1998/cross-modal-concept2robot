python3 run.py \
        --task_id 42 \
        --exp_name "resnet50" \
        --model_type resnet50 \
        --restore_path /srv/data/cross-modal-concept2robot/save_dir/42_resnet50/rl_action_penalty_0.2_2021-11-30_21-23-28/ \
        --recordGif \
        --stage test \
        --batch_size 64 \
        --action_penalty 0.2 \
        --force_term \
        --restore_episode 10000 \
        --max_ep_test 500 \
        --comment "action_penalty_0.2"
