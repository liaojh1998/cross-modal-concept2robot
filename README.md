# Improving Concept2Robot
This project is done by Jay Liao (jl64465) and Shivang Singh (ss82789) from the University of Texas at Austin for the course [CS 391R: Robot Learning](https://www.cs.utexas.edu/~yukez/cs391r_fall2021/) taught by Professor Yuke Zhu. We aim to improve upon the prior [Concept2Robot](https://github.com/stanford-iprl-lab/Concept2Robot) by incorporating better visual feature and text feature extractors in the agent (actor and critic) instead of ResNet18.

## Previous Work
You can find the previous Concept2Robot README at [README_C2R.md](README_C2R.md).

## Training and Testing Commands
Our training and testing commands can be found at `rl/train_scripts/` and `rl/test_scripts/`, respectively. The training and testing code cannot run for now because we did not release the pre-trained video classifiers' model weights provided from authors of the prior Concept2Robot. Please email us about these models if needed.

Here's an example of train run (you need to first `cd rl`):
```bash
python3 run.py\
        --task_id 104\
        --exp_name "clip"\
        --model_type clip\
        --stage train\
        --recordGif \
        --force_term \
        --max_ep 10000\
        --batch_size 64\
        --action_penalty 0.2\
        --start_learning_episode 1000\
        --task_dim 77\
        --comment "action_penalty_0.2"
```
1. `--task_id 104` correspond to running the single-task agent on Task 104, which, as found in `Languages/labels.txt`, stands for "putting sth behind sth".
2. `--exp_name "clip"` will save the trained agent to a directory that ends with `clip`. E.g. `save_dir/104_clip`.
3. `--model_type clip` indicates that you'll use CLIP for feature extraction. You can use `resnet18`, `resnet50`, `virtex`, and `clip` as an argument here.
4. `--stage train` indicate this is training run.
5. `--recordGif` will record GIFs of the run for every successful completion of the task.
6. `--force_term` will make the model predict both the goal pose and the forces at every timestep instead of predicting only the goal pose.
7. `--max_ep 10000` indicates to run for 10,000 episodes.
8. `--batch_size 64` will sample 64 trajectories from the replay buffer in DDPG.
9. `--action_penalty 0.2` is the action penalty applied during training.
10. `--start_learning_episode 1000` indicates to use random sampled actions instead of actor actions for the first 1000 episodes. These are trajectories stored in the replay buffer that may be useful for provide information on bad trajectories.
11. `--task_dim 77` is a parameter specific to CLIP, which indicates that CLIP will output 77 tokens as input to the text transformer.
12. `--comment "action_penalty_0.2"` is just an extra comment that will be used in naming the directory for saves.

These parameters can be modified for the different experiments we did using VirTex, ResNet50, ResNet18, and CLIP.

## Dataset
Download the 20bn-something-something-v2 dataset to `data/20bn-something-something-v2` in this repository. The directory should look like:
```
repository-dir:
    data:
        20bn-something-something-v2:
            annotations:
                something-something-v2-labels.json
                something-something-v2-train.json
                something-something-v2-test.json
                something-something-v2-validation.json
            videos:
                1.webm
                ...
                99999.webm
    other directories and files...
```

## Environment Setup
1. Login to `eldar-11.cs.utexas.edu`.
2. Download the latest miniconda into your scratch space on Condor:
```
cd /scratch/cluster/${USER}/
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod 755 Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
```
3. Follow through the installation process:
    * `yes` to the license agreement.
    * Install miniconda3 to `/scratch/cluster/${USER}/miniconda3`.
    * `yes` to conda init.
    * `conda config --set auto_activate_base false` to not run `conda` all the time.
    * Do anything else it tells you to do for `.bashrc` if needed.
    * Add `conda`'s path to your `PATH` environment variable. One way of doing this is to add `PATH=${PATH}:/scratch/cluster/${USER}/miniconda3/bin/` to your `~/.profile`.
3. Clone this repository to anywhere in your Condor scratch space.
4. `cd` the `env_setup/` folder of this repository and run `./install.sh`.
5. Run `conda activate cmc2r`, and test that your environment works by running the following in `python`:
```python3
>>> import torch
>>> torch.cuda.is_available()
True
>>>
```
