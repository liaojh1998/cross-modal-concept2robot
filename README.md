# Cross Modal Transformers for Concept2Robot
Jay Liao (jl64465) and Shivang Singh (ss82789)

# Environment Setup
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
4. `cd` the `env/` folder of this repository and run `./install.sh`.
5. Run `conda activate cmc2r`, and test that your environment works by running the following in `python`:
```python3
>>> import torch
>>> torch.cuda.is_available()
True
>>>
```
