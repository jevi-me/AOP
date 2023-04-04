#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# "Evo"
# Uses a Akai LPD8 Mk2 Laptop Pad Controller and Game Controller
# as part of a collection of instruments that performs within an ensemble.

# Sound: Smooth Creature

use_debug false
use_cue_logging false

# ---------------------------------------------------------
#### INITIALISE AND DEFINE
## Define and Initialise the values used to control the intrument
# ---------------------------------------------------------

# Local Variables 
set :o3_pos, 1      #Play in the left channel
set :o3_loop1, 0    #Determines whether the O3 will play loop1 sound
set :o3_loop2, 0    #Determines whether the O3 will play loop2 sound



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

set :ctrl_d1, 0     #control drone 1 rate  between 0 and 1
set :ctrl_d2, 0     #control drone 2 rate  between 0 and 1
set :adjpitch, 50   #pitch between 0*50 +50 and 1*50 + 50
set :adjdens, 0.2   #denisty between 0+0.2 and 1+ 0.2

set :adjdec, 0      #decay between 0 and 1
set :adjsus, 0      #sustain between 0 and 1
set :adjrel, 0.8    #release between 0+0.8 and 4
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
    set :mut_o2, val
  end
end

live_loop :o3_modes_6 do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/6"
  if pad_no == 6 then
    set :chaos0, val
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
    set :env_ready, val
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

# Start Loop 1
live_loop :o3_loop1_on_trigger do        #o3 loop1 is triggered to go on
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/button1"
  set :o3_loop1, 1
  sleep 0.01                       #turn the loop1 switch on
  if get(:env_ready) == 1 then
    if get(:o3_ready) == 1 then
      live_loop :o3_env_l1 do            #liveloop for l1
        while get(:o3_loop2) == 1 do     #while o3 loop2 value is 1
            use_synth :growl
            play get(:adjpitch) + 4, decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), pan: get(:o2_pos), amp: get(:adjvol)
            use_synth :dark_ambience
            with_fx :vowel, vowel_sound: 5, voice: 4 do
              play get(:adjpitch) + 4, decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), pan: get(:o2_pos), amp: get(:adjvol)
            end            end
        stop
        sleep get(:adjdens) + 0.2
      end
    end
  end
  sleep get(:adjdens) + 0.2
end

# Stop Loop 1
live_loop :o3_loop1_off_trigger do       #o3 loop1 is triggered to go off
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/button3"
  if get(:o3_loop1) == 1 then 
    set :o3_loop1, 0                     #turn the loop1 switch off
  end
  sleep 0.2
end



## Start Loop 2
live_loop :o3_loop2_on_trigger do        #o3 loop2 is triggered to go on
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/button4"
  set :o3_loop2, 1 
  sleep 0.01                       #turn the loop2 switch on
  if get(:env_ready) == 1 then
    if get(:o3_ready) == 1 then
      live_loop :o3_env_l2 do            #liveloop for l2
        while get(:o3_loop2) == 1 do     #while o3 loop2 value is 1
          use_synth :dark_ambience
            play get(:adjpitch) + 8, decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), pan: get(:o2_pos), amp: get(:adjvol)
            use_synth :hollow
            play get(:adjpitch) + 8, decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), pan: get(:o2_pos), amp: get(:adjvol)
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    end
  end
  sleep get(:adjdens) + 0.2
end

## Stop Loop 2
live_loop :o3_loop2_off_trigger do       #o3 loop2 is triggered to go off
  use_real_time
  btn_no, vel = sync "/osc*/o2_prop/button2"
  if get(:o3_loop2) == 1 then
    set :o3_loop2, 0                     #turn the loop2 switch off
  end
  sleep 0.2
end

## Chaos2 Loop
live_loop :chaos2_loop do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/8"
  samp_sels = [:ambi_soft_buzz,:ambi_swoosh,:ambi_piano,:ambi_dark_woosh,:ambi_choir,:bd_ada,:bd_pure,:bd_808,:bd_zum,:bd_gas,:bd_sone,:bd_haus,:bd_zome,:bd_boom,:bd_klub,:bd_fat,:bd_tek,:bd_mehackit,:bass_hit_c,:bass_hard_c,:bass_drop_c,:bass_woodsy_c,:bass_voxy_hit_c,:bass_dnb_f,:bass_trance_c,:drum_heavy_kick,:drum_tom_mid_soft,:drum_tom_mid_hard,:drum_tom_lo_soft,:drum_tom_lo_hard,:drum_tom_hi_soft,:drum_tom_hi_hard,:drum_splash_soft,:drum_splash_hard,:drum_snare_soft,:drum_snare_hard,:drum_cymbal_soft,:drum_cymbal_hard,:drum_cymbal_open,:drum_cymbal_closed,:drum_cymbal_pedal,:drum_bass_soft,:drum_bass_hard,:drum_cowbell,:elec_triangle,:elec_snare,:elec_lo_snare,:elec_hi_snare,:elec_mid_snare,:elec_cymbal,:elec_soft_kick,:elec_filt_snare,:elec_fuzz_tom,:elec_chime,:elec_bong,:elec_twang,:elec_wood,:elec_pop,:elec_beep,:elec_blip,:elec_blip2,:elec_ping,:elec_bell,:elec_flip,:elec_tick,:elec_hollow_kick,:elec_twip,:elec_plip,:elec_blup,:glitch_bass_g,:glitch_perc1,:glitch_perc2,:glitch_perc3,:glitch_perc4,:glitch_perc5,:glitch_robot1,:glitch_robot2,:mehackit_phone1,:mehackit_phone2,:mehackit_phone3,:mehackit_phone4,:mehackit_robot1,:mehackit_robot2,:mehackit_robot3,:mehackit_robot4,:mehackit_robot5,:mehackit_robot6,:mehackit_robot7,:misc_crow,:perc_bell,:perc_bell2,:perc_snap,:perc_snap2,:perc_swash,:perc_till,:perc_door,:perc_impact1,:perc_impact2,:perc_swoosh,:sn_dub,:sn_dolf,:sn_zome,:sn_generic,:guit_harmonics,:guit_e_fifths,:guit_e_slide,:guit_em9,:tabla_tas1,:tabla_tas2,:tabla_tas3,:tabla_ke1,:tabla_ke2,:tabla_ke3,:tabla_na,:tabla_na_o,:tabla_tun1,:tabla_tun2,:tabla_tun3,:tabla_te1,:tabla_te2,:tabla_te_ne,:tabla_te_m,:tabla_ghe1,:tabla_ghe2,:tabla_ghe3,:tabla_ghe4,:vinyl_backspin,:vinyl_rewind,:vinyl_scratch]
  syn_sels  = [:bass_foundation, :bass_highend, :beep, :blade, :bnoise, :chipbass, :chiplead, :chipnoise, :cnoise, :dark_ambience, :dpulse, :dsaw, :dtri, :dull_bell, :fm, :gnoise, :growl, :hollow, :hoover, :kalimba,  :noise, :organ_tonewheel, :piano, :pluck, :pnoise, :pretty_bell, :prophet, :pulse, :rodeo, :saw, :sine, :sound_in, :sound_in_stereo, :square, :subpulse, :supersaw, :tb303, :tech_saws, :tri, :winwood_lead, :zawa]
  
  if get(:chaos2) == 1 then
    live_loop :o3_chaos2_env_ready do
      while get(:chaos2) == 1 do
        a = rrand_i(0,chord_names.length-1)
        b = rrand_i(0,syn_sels.length-1)
        c = rrand_i(0,26)
        d = rrand_i(0,samp_sels.length-1)

        with_fx :compressor, slope_above: 0, slope_below: 0.1, amp: 0.1   do
          with_fx fx_names[c] do
            use_synth syn_sels[b]
            play (chord get(:adjpitch), chord_names[a]), amp: get(:adjvol)
            sample samp_sels[d], amp: get(:adjvol), rate: get(:ctrl_d2)
          end
        end
        sleep get(:adjdens) + 0.2

      end
      stop
      sleep get(:adjdens) + 0.2
    end
  end
end    