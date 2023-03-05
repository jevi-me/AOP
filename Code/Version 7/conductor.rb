#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# "AOP"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller and Game Controller
# as part of an instrument that allows both me (left channel)
# and the AOP (right channel) to perform within an ensemble.


p_name=["mode3","mode4","i_play","aop+play", #pads
        "mode1","mode2","improvise1","improvise2"]

k_name=["ctrl_d1","ctrl_d2","pitch", "density",
        "decay","sustain","release","volume"] #knobs

c_name=["hit1","drone2", "hit2", "drone1",
        "improv_burst","trigger-up", "trigger-down"] #game controller

# ---------------------------------------------------------
#### INITIALISE AND DEFINE STATES
## Define and Initialise values used to communicate with the players
# ---------------------------------------------------------

# Pan Position of Player and AOP in sound environment
set :i_pos, -1 #left channel
set :aop_pos, 1 #right channel

# Values for Game Controller


# Values for Pads (Toggle Mode)
set :mode1, 0     #on or off
set :mode2, 0     #on of off
set :improv1, 0   #on or off
set :improv2, 0   #on or off

set :mode3, 0     #on or off
set :mode4, 0     #on or off
set :i_ready, 0    #I play, on or off
set :aop_ready, 0  #aop plays, on or off


# Value for Knobs
set :ctrl_d1, 0   #control drone 1 rate  between 0 and 1
set :ctrl_d2, 0    #control drone 2 rate  between 0 and 1
set :adjpitch, 50  #pitch between 0*50 +50 and 1*50 + 50
set :adjdens, 0.2   #denisty between 0+0.2 and 1+ 0.2

set :adjdec, 0    #decay between 0 and 1
set :adjsus, 0    #sustain between 0 and 1
set :adjrel, 0.8    #release between 0+0.8 and 1+ 0.8
set :adjvol, 0    #volume between 0 and 1

# ---------------------------------------------------------
#### CAPTURE CONTROLS
# ---------------------------------------------------------

## Function to Normalise Knob Inputs
define :normf do |n| #scale 0->127 to 0->1
  return n.to_f/127
end

define :norm do |n| #scale 0->127 to 0->1
  return n/127
end

## Capture knob change
live_loop :knb_chg do
  use_real_time
  knb_no, val = sync "/midi*/control_change"
  val = normf(val)
  
  if knb_no == 1 then
    set :ctrl_d1, val
    puts k_name[0], val
  end
  if knb_no == 2 then
    set :ctrl_d2, val
    puts k_name[1], val
  end
  if knb_no == 3 then
    set :adjpitch, (val*50 + 50)
    puts k_name[2], (val*50 + 50)
  end
  if knb_no == 4 then
    set :adjdens, val
    puts k_name[3], val
  end
  
  
  if knb_no == 5 then
    set :adjdec, (val*2 + 0.2)
    puts k_name[4], (val*2 + 0.2)
  end
  
  if knb_no == 6 then
    set :adjsus, val
    puts k_name[5], val
  end
  
  if knb_no == 7 then
    set :adjrel, (val + 0.08)
    puts k_name[6], (val + 0.08)
  end
  if knb_no == 8 then
    set :adjvol, val
    puts k_name[7], val
  end
end

## Capture Pad Change
live_loop :pad_chg do
  use_real_time
  pad_no, val = sync "/midi*/note*"
  val = norm(val)
  
  if pad_no == 5 then
    puts p_name[4], val
    set :mode1, val
  end
  if pad_no == 6 then
    puts p_name[5]
    set :mode2, val
  end
  if pad_no == 7 then
    puts p_name[6], val
    set :improv1, val
  end
  
  if pad_no == 8 then
    puts p_name[7], val
    set :improv2, val
  end
  
  if pad_no == 1 then
    puts p_name[0], val
    set :mode3, val
  end
  if pad_no == 2 then
    puts p_name[1], val
    set :mode4, val
  end
  if pad_no == 3 then
    puts p_name[2], val
    set :i_ready, val
  end
  if pad_no == 4 then
    puts p_name[3], val
    set :aop_ready, val
  end
end


## Capture Game Controller Buttons
# Hits
live_loop :bt0 do #1
  use_real_time
  b= sync "/osc*/b0"
  puts c_name[0]
end

live_loop :bt2 do #3
  use_real_time
  b= sync "/osc*/b2"
  puts c_name[2]
end


live_loop :rud do #up/down
  use_real_time
  b= sync "/osc*/rud"
  if b[0] > 0
    puts c_name[0]
  end
  if b[0] < 0
    puts c_name[2]
  end
end

# Drones
live_loop :bt3 do #4
  use_real_time
  b= sync "/osc*/b3"
  puts c_name[3]
end

live_loop :bt1 do #2
  use_real_time
  b= sync "/osc*/b1"
  puts c_name[1]
end


live_loop :rlr do # left/right
  use_real_time
  b= sync "/osc*/rlr"
  if b[0] > 0
    puts c_name[1]
  end
  if b[0] < 0
    puts c_name[3]
  end
end

# Improvise
live_loop :bt9 do #Start
  use_real_time
  b= sync "/osc*/b9"
  puts c_name[4]
end

live_loop :bt8 do #Select
  use_real_time
  b=sync "/osc*/b8"
  puts c_name[4]
end


# Triggers
live_loop :bt6 do  #Left Up
  use_real_time
  b=sync "/osc*/b6"
  puts c_name[5]
end

live_loop :bt4 do #Left down
  use_real_time
  b=sync "/osc*/b4"
  puts c_name[6]
end

live_loop :bt7 do  #Right Up
  use_real_time
  b=sync "/osc*/b7"
  puts c_name[5]
end

live_loop :bt5 do #Right Down
  use_real_time
  b=sync "/osc*/b5"
  puts c_name[6]
end