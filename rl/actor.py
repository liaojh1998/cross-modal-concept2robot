import copy
import numpy as np
import os
import sys
import time
np.set_printoptions(precision=4,suppress=False)

import importlib
import glob
import imageio
import math
import datetime

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

import clip
import torchvision.models as models
import torch
import torch.nn as nn
import torch.nn.functional as F

from torchvision import transforms

def set_init(layers):
  for layer in layers:
    nn.init.normal_(layer.weight, mean=0., std=0.05)
    nn.init.constant_(layer.bias, 0.)

class Actor(nn.Module):
  def __init__(self, model_type, state_dim, action_dim, task_dim, max_action, params):
    super(Actor, self).__init__()
    self.params = params

    print(f"initiating actor with model: {model_type}")
    self.model_type = model_type
    if model_type == "resnet18":
      self.model = models.resnet18(pretrained=True)
      self.feature_extractor = torch.nn.Sequential(*list(self.model.children())[:-2])
      self.img_feat_block1 = nn.Sequential(
        nn.Conv2d(in_channels=512,out_channels=256,kernel_size=(3,3),stride=(2,2),padding=(1,1),bias=True),
        nn.ReLU(),
        nn.BatchNorm2d(256),
      )
    elif model_type == "resnet50":
      self.model = models.resnet50(pretrained=True)
      self.feature_extractor = torch.nn.Sequential(*list(self.model.children())[:-2])
      self.img_feat_block1 = nn.Sequential(
        nn.Conv2d(in_channels=2048,out_channels=256,kernel_size=(3,3),stride=(2,2),padding=(1,1),bias=True),
        nn.ReLU(),
        nn.BatchNorm2d(256),
      )
    elif model_type == "virtex":
      self.model = torch.hub.load("kdexd/virtex", "resnet50", pretrained=True)
      self.feature_extractor = torch.nn.Sequential(*list(self.model.children())[:-2])
      self.img_feat_block1 = nn.Sequential(
        nn.Conv2d(in_channels=2048,out_channels=256,kernel_size=(3,3),stride=(2,2),padding=(1,1),bias=True),
        nn.ReLU(),
        nn.BatchNorm2d(256),
      )
    elif model_type == "clip":
      self.model, self.preprocess = clip.load("ViT-B/32")
    else:
      raise NotImplementedError(f"{model_type} model is not implemented yet")

    self.action_dim = action_dim
    self.max_action = max_action
    if model_type == "clip":
      self.img_feat_block2 = nn.Linear(512, 256)
    else:
      self.img_feat_block2 = nn.Linear(256 * 2 * 3, 256)

    self.task_feat_block1 = nn.Linear(1024, 512)
    self.task_feat_block2 = nn.Linear(512, 256)
    self.task_feat_block3 = nn.Linear(256, 128)

    self.action_feat_block1 = nn.Linear(256 + 128, 256)
    self.action_feat_block2 = nn.Linear(256, 128)
    self.action_feat_block3 = nn.Linear(128, 64)
    self.action_feat_block4 = nn.Linear(64, 7)

    #####3 Force
    # 1
    self.force_feat_block1 = nn.Sequential(
      nn.ConvTranspose1d(in_channels=256 + 128, out_channels=256, kernel_size=4, stride=1, bias=True),
      nn.ReLU(),
    )

    # 3
    self.force_feat_block2 = nn.Sequential(
      nn.ConvTranspose1d(in_channels=256, out_channels=128, kernel_size=3, stride=2, padding=1, bias=True),
      nn.ReLU(),
    )

    # 7
    self.force_feat_block3 = nn.Sequential(
      nn.ConvTranspose1d(in_channels=128, out_channels=64, kernel_size=3, stride=2, padding=1, bias=True),
      nn.ReLU(),
    )

    #
    self.force_feat_block4 = nn.Sequential(
      nn.ConvTranspose1d(in_channels=64, out_channels=64, kernel_size=3, stride=2, padding=1, bias=True),
      nn.ReLU(),
    )

    self.force_feat_block5 = nn.Sequential(
      nn.ConvTranspose1d(in_channels=64, out_channels=self.params.a_dim, kernel_size=3, stride=2, padding=1),
    )

    set_init([self.img_feat_block2, self.task_feat_block1, self.task_feat_block2, self.task_feat_block3,\
      self.action_feat_block1, self.action_feat_block2, self.action_feat_block3, \
      self.action_feat_block4])

  def forward(self, state, task_vec, training=False):
    bs = state.size(0)
    if self.model_type == "clip":
      with torch.no_grad():
        img_feat = self.model.encode_image(state)
        img_feat = img_feat / img_feat.norm(dim=-1, keepdim=True)
        img_feat = img_feat.float()
        task_feat = self.model.encode_text(task_vec)
        task_feat = task_feat / task_feat.norm(dim=-1, keepdim=True)
        task_feat = task_feat.float()
    else:
      img_feat = self.feature_extractor(state)
      img_feat = self.img_feat_block1(img_feat)
      img_feat = img_feat.view(-1,256 * 2 * 3)
      task_feat = F.relu(self.task_feat_block1(task_vec))

    img_feat = self.img_feat_block2(img_feat)
    task_feat = F.relu(self.task_feat_block2(task_feat))
    task_feat = F.relu(self.task_feat_block3(task_feat))

    action_feat_raw = torch.cat([img_feat,task_feat],-1)

    ### generate goal
    action_feat = F.relu(self.action_feat_block1(action_feat_raw))
    action_feat = F.relu(self.action_feat_block2(action_feat))
    action_feat = F.relu(self.action_feat_block3(action_feat))
    weights_goal = np.ones((1,7))
    weights_goal[0,:3] *= self.max_action
    weights_goal[0,3:6] *= self.params.rotation_max_action
    weights_goal = torch.FloatTensor(weights_goal).to("cuda")
    goal = torch.tanh(self.action_feat_block4(action_feat)) * weights_goal
    #transl_action = torch.tanh(self.action_feat_block4(action_feat)) * self.max_action
    #rot_action = torch.tanh(self.action_feat_block5(action_feat)) * self.params.rotation_max_action
    #gripper_action = torch.tanh(self.action_feat_block6(action_feat))
    #goal = torch.cat([transl_action, rot_action, gripper_action],axis=-1)

    ### generate force
    force_feat = action_feat_raw.unsqueeze(2)
    force_feat = F.relu(self.force_feat_block1(force_feat))
    force_feat = F.relu(self.force_feat_block2(force_feat))
    force_feat = F.relu(self.force_feat_block3(force_feat))
    force_feat = F.relu(self.force_feat_block4(force_feat))
    force_feat = torch.tanh(self.force_feat_block5(force_feat))
    _, n_dim, timesteps = force_feat.size()
    force = torch.transpose(force_feat, 1, 2)
    weights = np.linspace(1, 0, self.params.traj_timesteps).reshape((1, self.params.traj_timesteps, 1)) * float(
      self.params.traj_timesteps)
    weights = torch.FloatTensor(weights).to("cuda")
    force = weights * force

    #print("training is", training)

    if training:
      force = force.reshape((bs,-1))
      action = torch.cat([goal, force],axis=-1)
      return action
    else:
      return goal, force
