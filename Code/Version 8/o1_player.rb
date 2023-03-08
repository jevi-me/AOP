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
set :o1_pos, -1 #left channel


# Values for Pads (Toggle Mode, Note Play)
set :mut1, 0     #on or off
set :mut2, 0     #on of off
set :chaos1, 0   #on or off
set :chaos2, 0   #on or off

set :mut3, 0     #on or off
set :o1_ready, 0  #o1 play, on or off
set :o2_ready, 0  #o2 plays, on or off
set :o3_ready, 0  #o3 plays, on or off


# Value for Knobs

set :ctrl_d1, 0   #control drone 1 rate  between 0 and 1
set :ctrl_d2, 0    #control drone 2 rate  between 0 and 1
set :adjpitch, 50  #pitch between 0*50 +50 and 1*50 + 50
set :adjdens, 0.2   #denisty between 0+0.2 and 1+ 0.2

set :adjdec, 0    #decay between 0 and 1
set :adjsus, 0    #sustain between 0 and 1
set :adjrel, 0.8    #release between 0+0.8 and 1+ 0.8
set :adjvol, 0.5   #volume between 0.5 and 1

# ---------------------------------------------------------
#### CAPTURE OSC DIRECTIONS
# ---------------------------------------------------------

## Capture environemnt - knob changes
live_loop :o1_enviro do
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
live_loop :o1_modes do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes"
  #puts pad_name, val
  
  if pad_no == 5 then
    set :mut1, val
  end
  if pad_no == 6 then
    set :mut2, val
  end
  if pad_no == 7 then
    set :chaos1, val
  end
  if pad_no == 8 then
    set :chaos2, val
  end
  
  if pad_no == 1 then
    set :mut3, val
  end
  if pad_no == 2 then
    set :o1_ready, val
  end
  if pad_no == 3 then
    set :o2_ready, val
  end
  if pad_no == 4 then
    set :o3_ready, val
  end
end


# ---------------------------------------------------------
#### PLAY
# ---------------------------------------------------------

## Hit 1
live_loop :o1_hit1_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/hit1"
  if get(:o1_ready) == 1 then
    use_synth :pretty_bell
    play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol)
  end
  sleep get(:adjdens) + 0.2
end


## Hit 2
live_loop :o1_hit2_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/hit2"
  if get(:o1_ready) == 1 then
    use_synth :fm
    play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol)
  end
      sleep get(:adjdens) + 0.2

end

## Drone 1
live_loop :o1_drone1_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/drone1"
  if get(:o1_ready) == 1 then
    use_synth :fm
    with_fx :vowel, vowel_sound: 1, voice: 1 do
      play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos)
    end
  end
      sleep get(:adjdens) + 0.2

end


## Drone 2
live_loop :o1_drone2_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/drone2"
  if get(:o1_ready) == 1 then
    use_synth :fm
    with_fx :vowel, vowel_sound: 5, voice: 4 do
      play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos)
    end
  end
        sleep get(:adjdens) + 0.2
end

live_loop :o1_improv_on do
  use_real_time
  btn_no, vel = sync "/play/improv_burst"
  
  slist= [:mod_beep, :growl, :dark_ambience, :growl, :fm]
  
  ranSyn= [rrand_i(0, slist.length-1), rrand_i(0,slist.length-1), rrand_i(0, slist.length-1)]
  ranNote=[rrand_i(50, 120), rrand_i(50,120), rrand_i(50, 120)]
  ranAttack=[rrand(0, 1), rrand(0,1), rrand(0, 1)]
  ranRelease=[rrand(0, 1), rrand(0,1), rrand(0, 1)]
  ranPan= [rrand_i(-1, 1), rrand(-1,1), rrand_i(-1, 1)]
  
  if(rrand_i(0,10) > 1)
    synth slist[ranSyn[0]],note: ranNote[0],attack: ranAttack[0], release: ranRelease[0], pan: ranPan[0], amp:  get(:adjvol) 
    synth slist[ranSyn[1]],note: ranNote[1],attack: ranAttack[1], release: ranRelease[1], pan: ranPan[1], amp:  get(:adjvol)  
    synth slist[ranSyn[2]],note: ranNote[2],attack: ranAttack[2], release: ranRelease[2], pan: ranPan[2], amp:  get(:adjvol) 
  else
    synth :cnoise, sustain: 0.5, amp: get(:adjvol) 
  end
    sleep 0.4
end
