#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# "Evo"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller and Game Controller
# as part of a collection of instruments that performs within an ensemble.

# Pitch: Higher than creature1 by 10 semitones
# Sound: Mutation 0 – Pointillism Creature
# Sound: Mutation 1 – Rough Sounding Creature

use_debug false
use_cue_logging false
use_osc "localhost", 4560

# ---------------------------------------------------------
#### INITIALISE AND DEFINE
## Define and Initialise the values used to control the intrument
# ---------------------------------------------------------

# Local Variables 
set :o2_pos, -1 #Play in the left channel
set :o2_on, 1       #Determines whether the O1 will play any sound (Allows for it to be muted)
set :o2_loop1, 0    #Determines whether the O1 will play loop1 sound
set :o2_loop2, 0    #Determines whether the O1 will play loop2 sound

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
live_loop :o2_enviro_1 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/1"
  if knb_no == 1 then
    set :ctrl_d1, val
  end
end

live_loop :o2_enviro_2 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/2"
  if knb_no == 2 then
    set :ctrl_d2, val
  end
end

live_loop :o2_enviro_3 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/3"
  if knb_no == 3 then
    set :adpitch, val+10  # Is a bit higher pitch
  end
end

live_loop :o2_enviro_4 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/4"
  if knb_no == 4 then
    set :adjdens, val
  end
end

live_loop :o2_enviro_5 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/5"
  if knb_no == 5 then
    set :adjdec, val
  end
end

live_loop :o2_enviro_6 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/6"
  if knb_no == 6 then
    set :adjsus, val
  end
end

live_loop :o2_enviro_7 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/7"
  if knb_no == 7 then
    set :adjrel, val
  end
end

live_loop :o2_enviro_8 do
  use_real_time
  knb_no, knb_name, val = sync "/osc*/enviro/8"
  if knb_no == 8 then
    set :adjvol, val
  end
end


## Capture modes - pad changes
live_loop :o2_modes_5 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/5"
  if pad_no == 5 then
    set :mut_o2, val
  end
end

live_loop :o2_modes_6 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/6"
  if pad_no == 6 then
    set :chaos0, val
  end
end

live_loop :o2_modes_7 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/7"
  if pad_no == 7 then
    set :chaos1, val
    if val == 0 then
      set :o2_on, 1
    else
      set :o2_on, 0
    end
  end
end

live_loop :o2_modes_8 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/8"
  if pad_no == 8 then
    set :chaos2, val
  end
end

live_loop :o2_modes_1 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/1"
  if pad_no == 1 then
    set :env_ready, val
  end
end

live_loop :o2_modes_2 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/2"
  if pad_no == 2 then
    set :o1_ready, val
  end
end

live_loop :o2_modes_3 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/3"
  if pad_no == 3 then
    set :o2_ready, val
  end
end

live_loop :o2_modes_4 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/4"
  if pad_no == 4 then
    set :o3_ready, val
  end
end


# ---------------------------------------------------------
#### PLAY
### TODO: Fix below
# ---------------------------------------------------------

## Hit 1
live_loop :o2_hit1_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/button1"
  if get(:o2_ready) == 1 then
    osc "/o2_prop/button1", 1
    if get(:env_ready) == 1 then
      live_loop :o2_hit1_env_ready do
        while get(:env_ready) == 1 do
          if get(:mut_o2) == 0 then
            use_synth :growl
            play get(:adjpitch) +4, pan: get(:o2_pos), amp: get(:adjvol)
            use_synth :dark_ambience
            with_fx :vowel, vowel_sound: 5, voice: 4 do
              play get(:adjpitch) + 4, pan: get(:o2_pos), amp: get(:adjvol)
            end
          end
          if get(:mut_o2) == 1 then
            use_synth :growl
            play get(:adjpitch) +8, pan: get(:o2_pos), amp: get(:adjvol)
            use_synth :dark_ambience
            with_fx :vowel, vowel_sound: 5, voice: 4 do
              play get(:adjpitch) + 12, pan: get(:o2_pos), amp: get(:adjvol)
            end
          end
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2   
      end
    else
      if get(:mut_o2) == 0 then
        use_synth :growl
        play get(:adjpitch) +4, pan: get(:o2_pos), amp: get(:adjvol)
        use_synth :dark_ambience
        with_fx :vowel, vowel_sound: 5, voice: 4 do
          play get(:adjpitch) + 4, pan: get(:o2_pos), amp: get(:adjvol)
        end
      end
      if get(:mut_o2) == 1 then
        use_synth :growl
        play get(:adjpitch) +8, pan: get(:o2_pos), amp: get(:adjvol)
        use_synth :dark_ambience
        with_fx :vowel, vowel_sound: 5, voice: 4 do
          play get(:adjpitch) + 12, pan: get(:o2_pos), amp: get(:adjvol)
        end
      end
    end
  end
  sleep get(:adjdens) + 0.2
end


## Hit 2
live_loop :o2_hit2_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/button3"
  if get(:o2_ready) == 1 then
    osc "/o2_prop/button3", 1
    if get(:env_ready) == 1 then
      live_loop :o2_hit2_env_ready do
        while get(:env_ready) == 1 do
          if get(:mut_o2) == 0 then
            use_synth :piano
            play get(:adjpitch) + 4, pan: get(:o2_pos), amp: get(:adjvol)
            use_synth :growl
            play get(:adjpitch) + 4, pan: get(:o2_pos), amp: get(:adjvol)
          end
          if get(:mut_o2) == 1 then
            use_synth :piano
            play get(:adjpitch) + 8, pan: get(:o2_pos), amp: get(:adjvol)
            use_synth :growl
            play get(:adjpitch) + 12, pan: get(:o2_pos), amp: get(:adjvol)
          end
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    else
      if get(:mut_o2) == 0 then
        use_synth :piano
        play get(:adjpitch) + 4, pan: get(:o2_pos), amp: get(:adjvol)
        use_synth :growl
        play get(:adjpitch) + 4, pan: get(:o2_pos), amp: get(:adjvol)
      end
      if get(:mut_o2) == 1 then
        use_synth :piano
        play get(:adjpitch) + 8, pan: get(:o2_pos), amp: get(:adjvol)
        use_synth :growl
        play get(:adjpitch) + 12, pan: get(:o2_pos), amp: get(:adjvol)
      end
    end
  end
  sleep get(:adjdens) + 0.2
end

## Drone 1
live_loop :o2_drone1_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/button4"
  if get(:o2_ready) == 1 then
    osc "/o2_prop/button4", 1
    if get(:env_ready) == 1 then
      live_loop :o2_drone1_env_ready do
        while get(:env_ready) == 1 do
          use_synth :prophet
          with_fx :vowel, vowel_sound: 5, voice: 4 do
          play get(:adjpitch), sustain: get(:adjdens), pan: get(:o2_pos), amp: get(:adjvol)*0.75
          end
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :prophet
      with_fx :vowel, vowel_sound: 5, voice: 4 do
      play get(:adjpitch), sustain: get(:adjdens), pan: get(:o2_pos), amp: get(:adjvol)*0.75
      end
    end
  end
  sleep get(:adjdens) + 0.2
end

## Drone 2
live_loop :o2_drone2_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/button2"
  if get(:o2_ready) == 1 then
    osc "/o2_prop/button2", 1
    if get(:env_ready) == 1 then
      live_loop :o2_drone2_env_ready do
        while get(:env_ready) == 1 do
          use_synth :prophet
          play get(:adjpitch)+4, sustain: get(:adjdens), pan: get(:o2_pos), amp: get(:adjvol)*0.75
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :prophet
      play get(:adjpitch)+4, sustain: get(:adjdens), pan: get(:o2_pos), amp: get(:adjvol)*0.75
    end
  end
  sleep get(:adjdens) + 0.2
end
