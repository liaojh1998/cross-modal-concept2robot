# Instructions
1. Install `miniconda3` from https://docs.conda.io/en/latest/miniconda.html into your scratch space. (e.g. at `/scratch/cluster/liaojh/miniconda3` but with `liaojh` replaced with your UTCS login username)
2. Do the `.bashrc` change required from installing `miniconda3`.
3. Change anywhere that has `{username}` in the `environment.yml` file with your UTCS login username. (e.g. `{username}` --> `liaojh` so that `prefix: /scratch/cluster/liaojh/miniconda3/envs/smth`)
4. Run `install.sh`.
5. Check that your environment is properly install by calling `conda activate smth`.
6. Run `python` in your environment and see if you can import `torch` and check if `torch.cuda.is_available()` is true on `eldar-11.cs.utexas.edu`.
