#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# "Evo"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller and Game Controller
# as part of a collection of instruments that performs within an ensemble.

# Controls:
#  (8) Midi RGB-lit pads
#  (8) Midi 270° knobs
#  (6) Game Controller buttons
#  (1) Game Controller 4-button rudder
#  (4) Game Controller Bumpers

# ---------------------------------------------------------
#### INITIALISE AND DEFINE STATES
## Define and Initialise values used to communicate with the players
# ---------------------------------------------------------
use_debug false
use_cue_logging false

use_osc "localhost", 4560

# Values for Game Controller
c_name=["hit1","drone2", "hit2", "drone1",
        "improv_burst","bumper-up", "bumper-down"] #game controller


# Values for Pads (Toggle Mode, Note Play)
p_name=["env_ready","o1_ready","o2_ready","o3_ready", #pads
        "mut_o2","chaos0","chaos1","chaos2"]

set :mut_o2, 0      #O2 mut0 or mut1
set :chaos0, 0      #on of off
set :chaos1, 0      #on or off
set :chaos2, 0      #on or off

set :env_ready, 0   #env ready, on or off
set :o1_ready, 0    #o1 play, on or off
set :o2_ready, 0    #o2 plays, on or off
set :o3_ready, 0    #o3 plays, on or off

# Value for Knobs
k_name=["ctrl_d1","ctrl_d2","pitch", "density",
        "decay","sustain","release","volume"] #knobs

set :ctrl_d1, 0     #control O1 randomisation between 0 and 1
set :ctrl_d2, 0     #control O3 randomisation between 0 and 1
set :adjpitch, 50   #pitch between 50 and 100
set :adjdens, 0.2   #denisty between 0.2 and 1.2

set :adjdec, 0      #decay between 0 and 1
set :adjsus, 0      #sustain between 0 and 1
set :adjrel, 0.8    #release between 0.8 and 4
set :adjvol, 0.5    #volume between 0.5 and 1

# ---------------------------------------------------------
#### CAPTURE CONTROLS
# ---------------------------------------------------------

## Function to Normalise Inputs
define :normf do |n| #scale 0->127 to 0->1
  return n.to_f/127
end
define :norm do |n| #scale 0->127 to 0->1
  return n/127
end

## Capture knob change (Channel 9 - 16)
live_loop :knb_chg9 do
  use_real_time
  knb_no, val = sync "/midi*9/control_change"
  val = normf(val)
  if knb_no == 1 then
    set :ctrl_d1, val
    #puts k_name[0], val
    osc "/enviro/1", knb_no, "ctrl_d1", val
  end
end

live_loop :knb_chg10 do
  use_real_time
  knb_no, val = sync "/midi*10/control_change"
  val = normf(val)
  if knb_no == 2 then
    set :ctrl_d2, val
    #puts k_name[1], val
    osc "/enviro/2", knb_no, "ctrl_d2", val
  end
end

live_loop :knb_chg11 do
  use_real_time
  knb_no, val = sync "/midi*11/control_change"
  val = normf(val)
  if knb_no == 3 then
    set :adjpitch, (val*50 + 50)
    #puts k_name[2], (val*50 + 50)
    osc "/enviro/3", knb_no, "adjpitch", (val*50 + 50)
  end
end

live_loop :knb_chg12 do
  use_real_time
  knb_no, val = sync "/midi*12/control_change"
  val = normf(val)
  if knb_no == 4 then
    set :adjdens, val
    #puts k_name[3], val
    osc "/enviro/4", knb_no, "adjdens", val
  end
end

live_loop :knb_chg13 do
  use_real_time
  knb_no, val = sync "/midi*13/control_change"
  val = normf(val)
  if knb_no == 5 then
    set :adjdec, (val*2 + 0.2)
    #puts k_name[4], (val*2 + 0.2)
    osc "/enviro/5", knb_no, "adjdec", (val*2 + 0.2)
  end
end

live_loop :knb_chg14 do
  use_real_time
  knb_no, val = sync "/midi*14/control_change"
  val = normf(val)
  if knb_no == 6 then
    set :adjsus, val
    #puts k_name[5], val
    osc "/enviro/6", knb_no, "adjsus", val
  end
end

live_loop :knb_chg15 do
  #  use_real_time
  knb_no, val = sync "/midi*15/control_change"
  val = normf(val)
  
  if knb_no == 7 then
    set :adjrel, (val + 0.08)
    #puts k_name[6], (val + 0.08)
    osc "/enviro/7", knb_no, "adjrel", (val*60 + 0.08)
  end
  
end

live_loop :knb_chg16 do
  use_real_time
  knb_no, val = sync "/midi*16/control_change"
  val = normf(val)
  if knb_no == 8 then
    set :adjvol, val
    #puts k_name[7], val
    osc "/enviro/8", knb_no, "adjvol", (val*0.5 +0.5)
  end
end


## Capture Pad Change (Channel 1 - 6)
live_loop :pad_chg5 do
  use_real_time
  pad_no, val = sync "/midi*1/note*"
  val = norm(val)
  if pad_no == 5 then
    #puts p_name[4], val
    set :mut_o2, val
    osc "/modes/5", pad_no, "mut_o2", val
  end
end

live_loop :pad_chg6 do
  use_real_time
  pad_no, val = sync "/midi*2/note*"
  val = norm(val)
  if pad_no == 6 then
    #puts p_name[5]
    set :chaos0, val
    osc "/modes/6", pad_no, ",chaos0", val
  end
end

live_loop :pad_chg7 do
  use_real_time
  pad_no, val = sync "/midi*3/note*"
  val = norm(val)
  if pad_no == 7 then
    #puts p_name[6], val
    set :chaos1, val
    osc "/modes/7", pad_no, "chaos1", val
  end
end

live_loop :pad_chg8 do
  use_real_time
  pad_no, val = sync "/midi*4/note*"
  val = norm(val)
  if pad_no == 8 then
    #puts p_name[7], val
    set :chaos2, val
    osc "/modes/8", pad_no, "chaos2", val
  end
end

live_loop :pad_chg1 do
  use_real_time
  pad_no, val = sync "/midi*5/note*"
  val = norm(val)
  if pad_no == 1 then
    #puts p_name[0], val
    set :env_ready, val
    osc "/modes/1", pad_no, "env_ready", val
  end
end

live_loop :pad_chg2 do
  use_real_time
  pad_no, val = sync "/midi*6/note*"
  val = norm(val)
  if pad_no == 2 then
    #puts p_name[1], val
    set :o1_ready, val
    osc "/modes/2", pad_no, "o1_ready", val
  end
end

live_loop :pad_chg3 do
  use_real_time
  pad_no, val = sync "/midi*7/note*"
  val = norm(val)
  if pad_no == 3 then
    #puts p_name[2], val
    set :o2_ready, val
    osc "/modes/3", pad_no, "o2_ready", val
  end
end

live_loop :pad_chg4 do
  use_real_time
  pad_no, val = sync "/midi*8/note*"
  val = norm(val)
  if pad_no == 4 then
    #puts p_name[3], val
    set :o3_ready, val
    osc "/modes/4", pad_no, "o3_ready", val
  end
end


## Capture Game Controller Buttons (OSC)

live_loop :bt0 do #1
  use_real_time
  b= sync "/osc*/b0"
  #puts c_name[0]
  osc "/play/button1", 1
end

live_loop :bt1 do #2
  use_real_time
  b= sync "/osc*/b1"
  #puts c_name[1]
  osc "/play/button2", 1
end

live_loop :bt2 do #3
  use_real_time
  b= sync "/osc*/b2"
  #puts c_name[2]
  osc "/play/button3", 1
end

live_loop :bt3 do #4
  use_real_time
  b= sync "/osc*/b3"
  #puts c_name[3]
  osc "/play/button4", 1
end

live_loop :rud do #up/down
  use_real_time
  b= sync "/osc*/rud"
  if b[0] > 0
    #puts c_name[0]
    osc "/play/rudup", 1
  end
  if b[0] < 0
    #puts c_name[2]
    osc "/play/ruddown", 1
  end
end


live_loop :rlr do # left/right
  use_real_time
  b= sync "/osc*/rlr"
  if b[0] > 0
    #puts c_name[1]
    osc "/play/rudleft", 1
  end
  if b[0] < 0
    #puts c_name[3]
    osc "/play/rudright", 1
  end
end


live_loop :bt9 do #Start
  use_real_time
  b= sync "/osc*/b9"
  #puts c_name[4]
  osc "/play/improv_burst", 1
  
end

live_loop :bt8 do #Select
  use_real_time
  b=sync "/osc*/b8"
  #puts c_name[4]
  osc "/play/improv_burst", 1
end


live_loop :bt6 do  #Left Up
  use_real_time
  b=sync "/osc*/b6"
  #puts c_name[5]
  osc "/play/bumper-l-up", 1
end

live_loop :bt4 do #Left down
  use_real_time
  b=sync "/osc*/b4"
  #puts c_name[6]
  osc "/play/bumper-l-down", 1
  
end

live_loop :bt7 do  #Right Up
  use_real_time
  b=sync "/osc*/b7"
  #puts c_name[5]
  osc "/play/bumper-r-up", 1
  
end

live_loop :bt5 do #Right Down
  use_real_time
  b=sync "/osc*/b5"
  #puts c_name[6]
  osc "/play/bumper-r-down", 1
end