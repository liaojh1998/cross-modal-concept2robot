# CMC2R Runs

## Installation
1. `cd /scratch/cluster/$USER`
2. `mkdir -p /scratch/cluster/$USER/.singularity/tmp`.
3. Install this environment with
```bash
TMPDIR=/scratch/cluster/$USER/.singularity/tmp SINGULARITY_CACHEDIR=/scratch/cluster/$USER/.singularity/cache singularity build -s cmc2r docker://liaojh/cmc2r:1.1.1
```

## Visualization
From [https://stackoverflow.com/questions/12050021/how-to-make-xvfb-display-visible](https://stackoverflow.com/questions/12050021/how-to-make-xvfb-display-visible).

1. Start the singularity image: `singularity exec -w cmc2r bash`.
2. Set the `HOME` variable: `export HOME=/root`.
3. On any Condor cluster (e.g. `eldar-11.cs.utexas.edu`), run `scripts/vis_server.sh`.
4. SSH to that host with the following host example: `ssh -N -T -L 5900:localhost:5900 liaojh@eldar.cs.utexas.edu`.
5. Use a VNC Viewer to connect to `localhost:5900` to view the Fluxbox.
6. Open a terminal in Fluxbox and play with Robosuite or `python3`.

## Robosuite Run
1. Start the singularity image: `singularity exec -w cmc2r bash`.
2. Set the `HOME` variable: `export HOME=/root`.
3. Running Robosuite requires running `xvfb-run -a -s "-screen 0 1024x768x16" bash` first to create a `bash` shell with virtual graphics for Robosuite to run.
