#!/bin/bash

set -ex

source ~/.bashrc

conda env create -f environment.yml
conda activate smth
pip3 install -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html
