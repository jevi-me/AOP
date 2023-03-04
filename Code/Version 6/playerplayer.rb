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
# p5 - short sound
# p6 - short sound
# p7 - drone
# p8 - drone

# p1 - improvise
# p2 - trigger
# p3 - i play
# p4 - aop plays

#Knob Control Assigments
# k1 - k[1] attack - time from 0 amplitude to the attack_level,
# k2 - k[2] decay - time to move amplitude from attack_level to decay_level,
# k3 - k[3] sustain - time to move the amplitude from decay_level to sustain_level,
# k4 - k[4] release - time to move amplitude from sustain_level to 0

# k5 - k[5] cutoff
# k6 - k[6] pitch
# k7 - k[7] density
# k8 - k[8] volume


#### INITIALISE AND DEFINE
## Define and Initialise values used to communicate with the live_loops

# Pan Position of Player and AOP in sound environment
set :i_pos, -1 #left channel
set :aop_pos, 1 #right channel

# Values for Pads
set :improvise, 0 #improvise, on or off
set :trigger, 0   #trigger, on or off
set :i_ready, 1    #I play, on or off
set :aop_ready, 0  #aop plays, on or off


# Values for Knobs
set :adjatt, 1    #attack between 0 and 2
set :adjdec, 1    #decay between 0 and 2
set :adjsus, 1    #sustain between 0 and 2
set :adjrel, 1    #release between 0 and 2

set :adjcut, 1    #cutoff between 0 and 2
set :adjvol, 1    #volume between 0 and 2
set :adjdens, 1   #denisty between 0 and 2
set :adjpitch, 1  #pitch between 0 and 2

# Store Input Data
knobs = [:adjatt, :adjdec, :adjsus, :adjrel, :adjcut, :adjvol, :adjdens, :adjpitch]
pads = Array.new(8, '0') #initilised to amp 0


#### CAPTURE MIDI CONTROLS

## Function to Normalise Knob Inputs
define :norm do |n| #scale 0->127 to 0->2
  return n.to_f/127/2
end

## Capture knob change
live_loop :con_chg do
  use_real_time
  portid, portn, knb_no, val = sync "/midi*/control_change"
  knobs[knb_no] = norm(val)
  puts "knob #:", knb_no, "value:", val, "norm:", norm(val) #add to log
end

## Capture pad change
live_loop :note_on do
  use_real_time
  portid, portn, pad_no, vel = sync "/midi*/note_on"
  amp = vel/127.0 # button pressure, sets play volume
  pads[pad_no] = amp
  puts "pad #", pad_no, "vel", vel, "amp", amp #add to log
end


#### SECTION PLAYERS
# Play when a pad is pressed, if the player is ready.

#live_loop :iplayer do
#end

#live_loop :aopplayer do
#end