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

use_debug false
use_cue_logging false

# ---------------------------------------------------------
#### INITIALISE AND DEFINE
## Define and Initialise the values used to control the intrument
# ---------------------------------------------------------

# Pan Position of Player and AOP in sound environment
set :i_pos, -1 #left channel
#set :aop_pos, 1 #right channel


# Values for Pads (Toggle Mode, Note Play)
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
#### CAPTURE OSC DIRECTIONS
# ---------------------------------------------------------

## Capture environemnt - knob changes
live_loop :enviro do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro"
  #puts knb_name, val
  
  if knb_no == 1 then
    set :ctrl_d1, val
  end
  if knb_no == 2 then
    set :ctrl_d2, val
  end
  if knb_no == 3 then
    set :adpitch, val
  end
  if knb_no == 4 then
    set :adjdens, val
  end
  
  
  if knb_no == 5 then
    set :adjdec, val
  end
  if knb_no == 6 then
    set :adjsus, val
  end
  if knb_no == 7 then
    set :adjrel, val
  end
  if knb_no == 8 then
    set :adjvol, val
  end
end


## Capture modes - pad changes
live_loop :modes do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes"
  #puts pad_name, val
  
  if pad_no == 5 then
    set :mode1, val
  end
  if pad_no == 6 then
    set :mode2, val
  end
  if pad_no == 7 then
    set :improv1, val
  end
  if pad_no == 8 then
    set :improv2, val
  end
  
  if pad_no == 1 then
    set :mode3, val
  end
  if pad_no == 2 then
    set :mode4, val
  end
  if pad_no == 3 then
    set :i_ready, val
  end
  if pad_no == 4 then
    set :aop_ready, val
  end
end


# ---------------------------------------------------------
#### PLAY
# ---------------------------------------------------------

## Hit 1
live_loop :hit1_on do
  use_real_time
  pad_no, vel = sync "/osc*/play/hit1"
  if get(:i_ready) == 1 then
    use_synth :pretty_bell
    play get(:adjpitch), pan: get(:i_pos), amp: get(:adjvol)
  end
  sleep get(:adjdens) + 0.2
end


## Hit 2
live_loop :hit2_on do
  use_real_time
  pad_no, vel = sync "/osc*/play/hit2"
  if get(:i_ready) == 1 then
    use_synth :fm
    play get(:adjpitch), pan: get(:i_pos), amp: get(:adjvol)
    sleep get(:adjdens) + 0.2
  end
end

## Drone 1
live_loop :drone1_on do
  use_real_time
  pad_no, vel = sync "/osc*/play/drone1"
  if get(:i_ready) == 1 then
    use_synth :mod_beep
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol)/2, pan: get(:i_pos)
  end
  sleep (get(:adjdens) + get(:adjdec) + get(:adjsus))
end


## Drone 2
live_loop :drone2_on do
  use_real_time
  pad_no, vel = sync "/osc*/play/drone2"
  if get(:i_ready) == 1 then
    use_synth :mod_tri
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol)/2, pan: get(:i_pos)
    sleep (get(:adjdens) + get(:adjdec) + get(:adjsus))
  end
end

# Improvise
live_loop :c1_on do
  use_real_time
  sync "osc*/play/improv_burst"
end


#########################################
# CHORD DEFINITIONS
#########################################
cMjI =      chord(:C, :major7)
cMjII =     chord(:D, :minor7)
cMjIII =    chord(:E, :minor7)
cMjIV =     chord(:F, :major7)
cMjV =      chord(:G, "7")
cMjVI =     chord(:A, :minor7)

define :chord_player do |c|
  use_synth :dark_ambience
  with_fx :vowel, vowel_sound: 5, voice: 4 do
    play c, attack: 0.1, release: get(:adjrel), amp: get(:adjvol)
  end
  
  use_synth :piano
  with_fx :vowel, vowel_sound: 1, voice: 1 do
    play c, attack: 0.2, release: get(:adjrel), amp: get(:adjvol)
  end
  
  use_synth :growl
  with_fx :vowel, vowel_sound: 4, voice: 2 do
    play c, attack: 0.1,  release: get(:adjrel), amp: get(:adjvol)
  end
  
  use_synth :organ_tonewheel
  with_fx :ping_pong do
    play c, attack: 0.3, release: get(:adjrel) , amp: get(:adjvol)
  end
  sleep (get(:adjsus) + get(:adjrel) + get(:adjdec))*(1-get(:adjdens))
end
