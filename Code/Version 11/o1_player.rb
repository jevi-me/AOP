#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# "Evo"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller and Game Controller
# as part of a collection of instruments that performs within an ensemble.

# Sound: Smooth Sounding Creature

use_debug false
use_cue_logging false

# ---------------------------------------------------------
#### INITIALISE AND DEFINE
## Define and Initialise the values used to control the intrument
# ---------------------------------------------------------

# Local Variables 
set :o1_pos, -1     #Play in the left channel
set :o1_on, 1       #Determines whether the O1 will play any sound (Allows for it to be muted)
set :o1_loop1, 0    #Determines whether the O1 will play loop1 sound
set :o1_loop2, 0    #Determines whether the O1 will play loop2 sound

# Values for Pads (Toggle Mode, Note Play)
set :mut_o2, 0      #O2 mut0 or mut1
set :chaos0, 0      #on of off
set :chaos1, 0      #on or off
set :chaos2, 0      #on or off

set :env_ready, 0   #env ready, on or off
set :o1_ready, 0    #o1 play, on or off
set :o2_ready, 0    #o2 plays, on or off
set :o3_ready, 0    #o3 plays, on or off

# Value for Knobs
set :ctrl_d1, 0     #control O1 randomisation between 0 and 1
set :ctrl_d2, 0     #control O3 randomisation between 0 and 1
set :adjpitch, 50   #pitch between 50 and 100
set :adjdens, 0.2   #denisty between 0.2 and 1.2

set :adjdec, 0      #decay between 0 and 1
set :adjsus, 0      #sustain between 0 and 1
set :adjrel, 0.8    #release between 0.8 and 4
set :adjvol, 0.5    #volume between 0.5 and 1

# ---------------------------------------------------------
#### CAPTURE OSC DIRECTIONS
# ---------------------------------------------------------

## Capture environemnt - knob changes
live_loop :o1_enviro_1 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/1"
  if knb_no == 1 then
    set :ctrl_d1, val
  end
end

live_loop :o1_enviro_2 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/2"
  if knb_no == 2 then
    set :ctrl_d2, val
  end
end

live_loop :o1_enviro_3 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/3"
  if knb_no == 3 then
    set :adpitch, val
  end
end

live_loop :o1_enviro_4 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/4"
  if knb_no == 4 then
    set :adjdens, val
  end
end

live_loop :o1_enviro_5 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/5"
  if knb_no == 5 then
    set :adjdec, val
  end
end

live_loop :o1_enviro_6 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/6"
  if knb_no == 6 then
    set :adjsus, val
  end
end

live_loop :o1_enviro_7 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/7"
  if knb_no == 7 then
    set :adjrel, val
  end
end

live_loop :o1_enviro_8 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/8"
  if knb_no == 8 then
    set :adjvol, val
  end
end


## Capture modes - pad changes
live_loop :o1_modes_5 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/5"
  if pad_no == 5 then
    set :mut_o2, val
  end
end

live_loop :o1_modes_6 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/6"
  if pad_no == 6 then
    set :chaos0, val
    if val == 0 then
      set :o1_on, 1
    else
      set :o1_on, 0
    end
  end
end

live_loop :o1_modes_7 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/7"
  if pad_no == 7 then
    set :chaos1, val
  end
end

live_loop :o1_modes_8 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/8"
  if pad_no == 8 then
    set :chaos2, val
  end
end

live_loop :o1_modes_1 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/1"
  if pad_no == 1 then
    set :env_ready, val
  end
end

live_loop :o1_modes_2 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/2"
  if pad_no == 2 then
    set :o1_ready, val
  end
end

live_loop :o1_modes_3 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/3"
  if pad_no == 3 then
    set :o2_ready, val
  end
end

live_loop :o1_modes_4 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/4"
  if pad_no == 4 then
    set :o3_ready, val
  end
end

# ---------------------------------------------------------
#### PLAY
# ---------------------------------------------------------

# Start Loop 1
live_loop :o1_loop1_on_trigger do        #o1 loop1 is triggered to go on
  use_real_time
  btn_no, vel = sync "/osc*/play/button1"
  set :o1_loop1, 1                       #turn the loop1 switch on
  if get(:env_ready) == 1 then
    if get(:o1_ready) == 1 then
      live_loop :o1_env_l1 do            #liveloop for l1
        while get(:o1_loop1) == 1 do     #while o1 loop1 value is 1
          use_synth :pretty_bell
          play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol), on: get(:o1_on)
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    else
     stop
    end
  else
     stop
  end
  sleep get(:adjdens) + 0.2
end

# Stop Loop 1
live_loop :o1_loop1_off_trigger do       #o1 loop1 is triggered to go off
  use_real_time
  btn_no, vel = sync "/osc*/play/button3"
  if get(:o1_loop1) == 1 then 
    set :o1_loop1, 0                       #turn the loop1 switch off
  end
  sleep 0.2
end

## Start Loop 2
live_loop :o1_loop2_on_trigger do        #o1 loop2 is triggered to go on
  use_real_time
  btn_no, vel = sync "/osc*/play/button4"
  set :o1_loop2, 1                       #turn the loop2 switch on
  if get(:env_ready) == 1 then
    if get(:o1_ready) == 1 then
      live_loop :o1_env_l2 do            #liveloop for l2
        while get(:o1_loop2) == 1 do     #while o1 loop2 value is 1
          use_synth :fm
          with_fx :vowel, vowel_sound: 5, voice: 4 do
            play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos), on: get(:o1_on)
          end
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    else
     stop
    end
  else
     stop
  end
  sleep get(:adjdens) + 0.2
end

## Stop Loop 2
live_loop :o1_loop2_off_trigger do       #o1 loop2 is triggered to go off
  use_real_time
  btn_no, vel = sync "/osc*/play/button2"
  if get(:o1_loop2) == 1 then
    set :o1_loop2, 0                       #turn the loop2 switch off
  end
  sleep 0.2
end




# -----------------------------------------------------------------------
#### HITS 
#### DEFINED ONCE, AND SET TO BE PLAYABLE DESPITE WHICH ORGANISM IS LIVE
#### PLAYS IN BOTH AUDIO OUTPUT CHANNELS
# -----------------------------------------------------------------------

## Left Bumper Up – Choir
live_loop :bumper_l_up_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/bumper-l-up" 
  sample :ambi_choir, amp: get(:adjvol)  
  sleep get(:adjdens) + 0.2
end

## Left Bumper Down – Long Braxton Hit
live_loop :bumper_l_down_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/bumper-l-down"  
  sample :ambi_lunar_land, amp: get(:adjvol)
  sample :vinyl_rewind , amp: get(:adjvol)*0.75
  sample :misc_cineboom, amp: get(:adjvol)*0.75
  sample :bass_drop_c , amp: get(:adjvol)*0.75
  sleep get(:adjdens) + 0.2
end

## Right Bumper Up – Guitar
live_loop :bumper_r_up_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/bumper-r-up" 
  sample :guit_e_slide, amp: get(:adjvol) 
  sleep get(:adjdens) + 0.2
end 

## Right Bumper Down – Weirdo
live_loop :bumper_r_down_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/bumper-r-down"  
  sample :loop_weirdo, amp: get(:adjvol) 
  sleep get(:adjdens) + 0.2
end
