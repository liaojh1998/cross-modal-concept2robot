# CMC2R Runs

## Visualization
From [https://stackoverflow.com/questions/12050021/how-to-make-xvfb-display-visible](https://stackoverflow.com/questions/12050021/how-to-make-xvfb-display-visible).

1. Start singularity image with port 5900 open.
2. On any Condor cluster (e.g. `eldar-11.cs.utexas.edu`), run `scripts/vis_server.sh`.
3. SSH to that host with the following host example: `ssh -N -T -L 5900:localhost:5900 liaojh@eldar.cs.utexas.edu`.
4. Use a VNC Viewer to connect to `localhost:5900` to view the Fluxbox.
5. Open a terminal in Fluxbox and play with Robosuite or `python3`.

## Robosuite Run
Running Robosuite requires running `xvfb-run -a -s "-screen 0 1024x768x16" bash` first to create a `bash` shell with virtual graphics for Robosuite to run.
