#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/


# "AOP"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller
# as part of an instrument that allows both me (left channel)
# and the AOP (right channel) to perform within the ensemble.
# Similar: https://gist.github.com/rbnpi/f995f7d9bf176e6b5d0f62baff257dc8

# Midi Controls:
#  (8) velocity-sensitive, RGB-lit pads
#  (8) 270° knobs
#  (4) UI buttons

# Pad Control Assignments
# p5 - 40 - hit
# p6 - 41 - hit
# p7 - 42 - drone
# p8 - 43 - drone

# p1 - improvise
# p2 - trigger
# p3 - i play
# p4 - aop plays

#Knob Control Assigments
# k1 - unassigned
# k2 - decay - time to move amplitude from attack_level to decay_level,
# k3 - sustain - time to move the amplitude from decay_level to sustain_level,
# k4 - release - time to move amplitude from sustain_level to 0

# k5 - unassigned
# k6 - pitch
# k7 - density
# k8 - volume

p_name=["improvise","trigger","i_play","aop+play","hit1","hit2","drone1","drone2"]
k_name=["unassigned","decay","sustain","release","unassigned","pitch","density","volume"]
# ---------------------------------------------------------
#### INITIALISE AND DEFINE
## Define and Initialise values used to communicate with the live_loops
# ---------------------------------------------------------

# Pan Position of Player and AOP in sound environment
set :i_pos, -1 #left channel
set :aop_pos, 1 #right channel

# Values for Pads
set :improvise, 0 #improvise, on or off
set :trigger, 0   #trigger, on or off
set :i_ready, 1    #I play, on or off
set :aop_ready, 0  #aop plays, on or off


# Value for Knobs
set :adjdec, 0    #decay between 0 and 1
set :adjsus, 0    #sustain between 0 and 1
set :adjrel, 0.8    #release between 0+0.8 and 1+ 0.8

set :adjpitch, 50  #pitch between 0*50 +50 and 1*50 + 50
set :adjdens, 1   #denisty between 0 and 1
set :adjvol, 1    #volume between 0 and 1


# Initial Ready Check

# if get(:i_ready) == 1 then puts "Ready Player I" else puts "Player I silent" end
# if get(:aop_ready) == 1 then puts "Ready Player AOP" else puts "Player AOP silent" end


# ---------------------------------------------------------
#### CAPTURE MIDI CONTROLS
## Function to Normalise Knob Inputs
# ---------------------------------------------------------

define :norm do |n| #scale 0->127 to 0->1
  return n.to_f/127
end

## Capture knob change
live_loop :con_chg do
  use_real_time
  knb_no, val = sync "/midi*/control_change"
  val = norm(val)
  
  if knb_no == 1 then
    puts k_name[0], val
  end
  if knb_no == 2 then
    set :adjdec, val
    puts k_name[1], val
  end
  if knb_no == 3 then
    set :adjsus, val
    puts k_name[2], val
  end
  if knb_no == 4 then
    set :adjrel, (val + 0.08)
    puts k_name[3], (val + 0.08)
  end
  
  
  if knb_no == 5 then
    puts k_name[4], val
  end
  if knb_no == 6 then
    set :adjpitch, (val*50 + 50)
    puts k_name[5], (val*50 + 50)
  end
  if knb_no == 7 then
    set :adjdens, val
    puts k_name[6], val
  end
  if knb_no == 8 then
    set :adjvol, val
    puts k_name[7], val
  end
  
end


# ---------------------------------------------------------
#### SECTION PLAYERS
# Play when a pad is pressed, only if the player is ready to play.
# ---------------------------------------------------------

## Capture pad change
live_loop :note_on do
  use_real_time
  pad_no, vel = sync "/midi*2/note_on"
  #Cue the sound for each pad
  if get(:i_ready) == 1 then
    puts p_name[4], vel
    use_synth :dsaw
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:i_pos)
    
  end
end

live_loop :hit1 do
  use_real_time
  vel = sync "/midi*2/channel_pressure"
  use_synth :dsaw
  play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:i_pos) if vel > 0
end

