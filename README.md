# Cross Modal Transformers for Concept2Robot
Jay Liao (jl64465) and Shivang Singh (ss82789)

## Previous Work
You can find the previous Concept2Robot README at [README_C2R.md](README_C2R.md).

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
