#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# "Evo"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller and Game Controller
# as part of an instrument that allows both me (left channel)
# and the AOP (right channel) to perform within an ensemble.

use_debug false
use_cue_logging false

# ---------------------------------------------------------
#### INITIALISE AND DEFINE
## Define and Initialise the values used to control the intrument
# ---------------------------------------------------------

# Pan Position in sound environment
set :o3_pos, 1 #right channel


# Values for Pads (Toggle Mode, Note Play)
set :mut1, 0     #on or off
set :mut2, 0     #on of off
set :chaos1, 0   #on or off
set :chaos2, 0   #on or off

set :loop_this, 0   #loop on or off
set :o1_ready, 0    #o1 play, on or off
set :o2_ready, 0    #o2 plays, on or off
set :o3_ready, 0    #o3 plays, on or off


# Value for Knobs

set :ctrl_d1, 0     #control drone 1 rate  between 0 and 1
set :ctrl_d2, 0     #control drone 2 rate  between 0 and 1
set :adjpitch, 50   #pitch between 0*50 +50 and 1*50 + 50
set :adjdens, 0.2   #denisty between 0+0.2 and 1+ 0.2

set :adjdec, 0      #decay between 0 and 1
set :adjsus, 0      #sustain between 0 and 1
set :adjrel, 0.8    #release between 0+0.8 and 1+ 0.8
set :adjvol, 0.5    #volume between 0.5 and 1

# ---------------------------------------------------------
#### CAPTURE OSC DIRECTIONS
# ---------------------------------------------------------

## Capture environemnt - knob changes
live_loop :o3_enviro_1 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/1"
  if knb_no == 1 then
    set :ctrl_d1, val
  end
end
live_loop :o3_enviro_2 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/2"
  if knb_no == 2 then
    set :ctrl_d2, val
  end
end

live_loop :o3_enviro_3 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/3"
  if knb_no == 3 then
    set :adpitch, val
  end
end

live_loop :o3_enviro_4 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/4"
  if knb_no == 4 then
    set :adjdens, val
  end
end

live_loop :o3_enviro_5 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/5"
  if knb_no == 5 then
    set :adjdec, val
  end
end

live_loop :o3_enviro_6 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/6"
  if knb_no == 6 then
    set :adjsus, val
  end
end

live_loop :o3_enviro_7 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/7"
  if knb_no == 7 then
    set :adjrel, val
  end
end

live_loop :o3_enviro_8 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/8"
  if knb_no == 8 then
    set :adjvol, val
  end
end


## Capture modes - pad changes
live_loop :o3_modes_5 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/5"
  if pad_no == 5 then
    set :mut1, val
  end
end

live_loop :o3_modes_6 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/6"
  if pad_no == 6 then
    set :mut2, val
  end
end
live_loop :o3_modes_7 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/7"
  if pad_no == 7 then
    set :chaos1, val
  end
end

live_loop :o3_modes_8 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/8"
  if pad_no == 8 then
    set :chaos2, val
  end
end

live_loop :o3_modes_1 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/1"
  if pad_no == 1 then
    set :loop_this, val
  end
end

live_loop :o3_modes_2 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/2"
  if pad_no == 2 then
    set :o1_ready, val
  end
end

live_loop :o3_modes_3 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/3"
  if pad_no == 3 then
    set :o2_ready, val
  end
end

live_loop :o3_modes_4 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/4"
  if pad_no == 4 then
    set :o3_ready, val
  end
end


# ---------------------------------------------------------
#### PLAY
# ---------------------------------------------------------

## Hit 1
live_loop :o3_hit1_on do
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/hit1"
  if get(:o3_ready) == 1 then
    if get(:loop_this) == 1 then
      live_loop :o3_hit1_loop_on do
        while get(:loop_this) == 1 do
          use_synth :dsaw
          with_fx :vowel, vowel_sound: 2, voice: 0 do
            play get(:adjpitch), pan: get(:o3_pos), amp: get(:adjvol)
          end
          sleep get(:adjdens) + 0.2
        end
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :dsaw
      with_fx :vowel, vowel_sound: 2, voice: 0 do
        play get(:adjpitch), pan: get(:o3_pos), amp: get(:adjvol)
      end
    end
  end
  sleep get(:adjdens) + 0.2
end


## Hit 2
live_loop :o3_hit2_on do
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/hit2"
  if get(:o3_ready) == 1 then
    if get(:loop_this) == 1 then
      live_loop :o3_hit1_loop_on do
        while get(:loop_this) == 1 do
          use_synth :dsaw
          with_fx :vowel, vowel_sound: 2, voice: 0 do
            play get(:adjpitch) + 4, pan: get(:o3_pos), amp: get(:adjvol)
            play get(:adjpitch) + 8, pan: get(:o3_pos), amp: get(:adjvol)
          end
          sleep get(:adjdens) + 0.2
        end
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :dsaw
      with_fx :vowel, vowel_sound: 2, voice: 0 do
        play get(:adjpitch) + 4, pan: get(:o3_pos), amp: get(:adjvol)
        play get(:adjpitch) + 8, pan: get(:o3_pos), amp: get(:adjvol)
      end
    end
  end
  sleep get(:adjdens) + 0.2
end

## Drone 1
live_loop :o3_drone1_on do
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/drone1"
  if get(:o3_ready) == 1 then
    if get(:loop_this) == 1 then
      live_loop :o3_drone1_loop_on do
        while get(:loop_this) == 1 do
          use_synth :dsaw
          with_fx :vowel, vowel_sound: 3, voice: 3 do
            play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o3_pos)
          end
          sleep get(:adjdens) + 0.2
        end
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :dsaw
      with_fx :vowel, vowel_sound: 3, voice: 3 do
        play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o3_pos)
      end
    end
  end
  sleep get(:adjdens) + 0.2
end


## Drone 2
live_loop :o3_drone2_on do
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/drone2"
  if get(:o3_ready) == 1 then
    if get(:loop_this) == 1 then
      live_loop :o3_drone2_loop_on do
        while get(:loop_this) == 1 do
          use_synth :dsaw
          with_fx :vowel, vowel_sound: 5, voice: 4 do
            play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o3_pos)
          end
          sleep get(:adjdens) + 0.2
        end
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :dsaw
      with_fx :vowel, vowel_sound: 5, voice: 4 do
        play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o3_pos)
      end
    end
  end
  sleep get(:adjdens) + 0.2
end