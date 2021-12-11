python3 run.py \
        --task_id 42 \
        --exp_name "virtex_goal_only" \
        --model_type virtex \
        --restore_path /srv/data/cross-modal-concept2robot/save_dir/42_virtex_goal_only/rl_action_penalty_0.2_critic_goal_only_2021-11-29_03-59-34/ \
        --recordGif \
        --stage test \
        --batch_size 64 \
        --action_penalty 0.2 \
        --restore_episode 3000 \
        --max_ep_test 500 \
        --comment "action_penalty_0.2_critic_goal_only"
