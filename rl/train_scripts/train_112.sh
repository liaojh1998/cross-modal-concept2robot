python3 run.py \
        --task_id 112 \
        --exp_name "something_onto_something_without_force_goal_only" \
        --stage train \
	--restore_episode_goal 1000 \
        --recordGif \
        --max_ep 50000 \
        --batch_size 64 \
        --action_penalty 0.2 \
        --start_learning_episode 1000 \
        --force_term \
        --comment "action_penalty_0.2_critic"
