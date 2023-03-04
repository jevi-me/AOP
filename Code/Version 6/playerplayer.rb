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
# k2 - k[6] decay - time to move amplitude from attack_level to decay_level,
# k3 - k[32] sustain - time to move the amplitude from decay_level to sustain_level,
# k4 - k[71] release - time to move amplitude from sustain_level to 0

# k5 - k[83] cutoff
# k6 - k[74] pitch
# k7 - k[52] density
# k8 - k[52] volume 


#### INITIALISE AND DEFINE
## Define and Initialise values used to communicate with the live_loops

# Pan Position of Player and AOP in sound environment 
i_pos = -1 #left channel
aop_pos = 1 #right channel

# Values for Pads
set :improvise, 0 #improvise, on or off
set :trigger, 0   #trigger, on or off
set :aop_play, 0  #aop plays, on or off 
set :i_play, 0    #I play, on or off

# Values for Knobs
set :adjatt, 1    #attack between 0 and 2
set :adjdec, 1    #decay between 0 and 2
set :adjsus, 1    #sustain between 0 and 2
set :adjrel, 1    #release between 0 and 2

set :adjcut, 1    #cutoff between 0 and 2
set :adjvol, 1    #volume between 0 and 2, this will not be changed. <- don't think I want this
set :adjdens, 1   #denisty between 0 and 2
set :adjpitch, 1  #pitch between 0 and 2

set :knobs = [[],[],[],[],
              [],[],[],[]] 


#### CONTROLS: MIDI

## Buttons
live_loop :buttons do 
  use_real_time
  pad, vel = sync "/midi*/note_on"
  amp = vel/127.0 # button pressure, sets play volume
  #if k.. play whatever sample assigned to that button at that volume
end


## Knobs
live_loop :knobs do 
  use_real_time
  knob,val = sync "/midi*/control_change"
end


