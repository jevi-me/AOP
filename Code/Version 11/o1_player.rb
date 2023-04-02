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

# Sound: Smooth Sounding Creature


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
set :chaos0, 0   #on of off
set :chaos1, 0   #on or off
set :chaos2, 0   #on or off

set :loop_on, 0   #loop on or off
set :o1_ready, 0    #o1 play, on or off
set :o2_ready, 0    #o2 plays, on or off
set :o3_ready, 0    #o3 plays, on or off

set :o1_on, 1 

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
    set :mut1, val
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
    set :loop_on, val
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

## Hit 1
live_loop :o1_hit1_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/hit1"
  if get(:o1_ready) == 1 then
    if get(:loop_on) == 1 then
      live_loop :o1_hit1_loop_on do
        while get(:loop_on) == 1 do
          use_synth :pretty_bell
          play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol), on: get(:o1_on)
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :pretty_bell
      play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol), on: get(:o1_on)
    end
  end
  sleep get(:adjdens) + 0.2
end

## Hit 2
live_loop :o1_hit2_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/hit2"
  if get(:o1_ready) == 1 then
    if get(:loop_on) == 1 then
      live_loop :o1_hit2_loop_on do
        while get(:loop_on) == 1 do
          use_synth :fm
          play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol), on: get(:o1_on)
          sleep get(:adjdens) + 0.2
        end
        stop
        sleep get(:adjdens) + 0.2
      end
    else
      use_synth :fm
      play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol), on: get(:o1_on)
    end
  end
  sleep get(:adjdens) + 0.2
end

## Drone 1
live_loop :o1_drone1_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/drone1"
  if get(:o1_ready) == 1 then
    if get(:loop_on) == 1 then
      live_loop :o1_drone1_loop_on do
        while get(:loop_on) == 1 do
          use_synth :fm
          with_fx :vowel, vowel_sound: 1, voice: 1 do
          play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos), on: get(:o1_on)
        end
        sleep get(:adjdens) + 0.2
      end
      sleep get(:adjdens) + 0.2
      stop
    end
  else
    use_synth :fm
    with_fx :vowel, vowel_sound: 1, voice: 1 do
      play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos), on: get(:o1_on)
    end
  end
  sleep get(:adjdens) + 0.2
end
end

## Drone 2
live_loop :o1_drone2_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/drone2"
  if get(:o1_ready) == 1 then
    if get(:loop_on) == 1 then
      live_loop :o1_drone2_loop_on do
        while get(:loop_on) == 1 do
          use_synth :fm
          with_fx :vowel, vowel_sound: 5, voice: 4 do
          play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos), on: get(:o1_on)
        end
        sleep get(:adjdens) + 0.2
      end
      sleep get(:adjdens) + 0.2
      stop
    end
  else
    use_synth :fm
    with_fx :vowel, vowel_sound: 5, voice: 4 do
      play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos), on: get(:o1_on)
    end
  end
end
sleep get(:adjdens) + 0.2
end


## Improvise
live_loop :o1_improv_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/improv_burst"
  
  slist= [:mod_beep, :growl, :dark_ambience, :growl, :fm]
  
  ranSyn=     [rrand_i(0, slist.length-1), rrand_i(0,slist.length-1), rrand_i(0, slist.length-1)]
  ranNote=    [get(:adjpitch),get(:adjpitch),get(:adjpitch)]  #[rrand_i(50, 120), rrand_i(50,120), rrand_i(50, 120)]
  ranAttack=  [rrand(0, 1), rrand(0,1), rrand(0, 1)]
  ranRelease= [rrand(0, 1), rrand(0,1), rrand(0, 1)]
  ranPan=     [rrand_i(-1, 1), rrand(-1,1), rrand_i(-1, 1)]
  
  if rrand_i(0,20) > 1 then
    synth slist[ranSyn[0]],note: ranNote[0],attack: ranAttack[0], release: ranRelease[0], pan: ranPan[0], amp:  get(:adjvol)
    synth slist[ranSyn[1]],note: ranNote[1],attack: ranAttack[1], release: ranRelease[1], pan: ranPan[1], amp:  get(:adjvol)
    synth slist[ranSyn[2]],note: ranNote[2],attack: ranAttack[2], release: ranRelease[2], pan: ranPan[2], amp:  get(:adjvol)
  else
    synth :cnoise, sustain: 0.5, amp: get(:adjvol)
  end
  sleep get(:adjdens) + 0.2
end


## Trigger Up – Choir
live_loop :trigger_l_up_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/trigger-l-up" 
  sample :ambi_choir, amp: get(:adjvol)  
  sleep get(:adjdens) + 0.2
end

## Trigger Down – Long Braxton Hit
live_loop :trigger_l_down_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/trigger-l-down"  
  sample :ambi_lunar_land, amp: get(:adjvol)
  sample :vinyl_rewind , amp: get(:adjvol)*0.75
  sample :misc_cineboom, amp: get(:adjvol)*0.75
  sample :bass_drop_c , amp: get(:adjvol)*0.75
  sleep get(:adjdens) + 0.2
end

## Trigger Up – Guitar
live_loop :trigger_r_up_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/trigger-r-up" 
  sample :guit_e_slide, amp: get(:adjvol) 
  sleep get(:adjdens) + 0.2
end 

## Trigger Down – Weirdo
live_loop :trigger_r_down_on do
  use_real_time
  btn_no, vel = sync "/osc*/play/trigger-r-down"  
  sample :loop_weirdo, amp: get(:adjvol) 
  sleep get(:adjdens) + 0.2
end


## Chaos1 Loop
live_loop :chaos1_loop do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/7"
 
  if get(:chaos1) == 1 then
  end
end

## Chaos2 Loop
live_loop :chaos2_loop do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/8"
  samp_sels = [:ambi_soft_buzz,:ambi_swoosh,:ambi_piano,:ambi_dark_woosh,:ambi_choir,:bd_ada,:bd_pure,:bd_808,:bd_zum,:bd_gas,:bd_sone,:bd_haus,:bd_zome,:bd_boom,:bd_klub,:bd_fat,:bd_tek,:bd_mehackit,:bass_hit_c,:bass_hard_c,:bass_drop_c,:bass_woodsy_c,:bass_voxy_hit_c,:bass_dnb_f,:bass_trance_c,:drum_heavy_kick,:drum_tom_mid_soft,:drum_tom_mid_hard,:drum_tom_lo_soft,:drum_tom_lo_hard,:drum_tom_hi_soft,:drum_tom_hi_hard,:drum_splash_soft,:drum_splash_hard,:drum_snare_soft,:drum_snare_hard,:drum_cymbal_soft,:drum_cymbal_hard,:drum_cymbal_open,:drum_cymbal_closed,:drum_cymbal_pedal,:drum_bass_soft,:drum_bass_hard,:drum_cowbell,:elec_triangle,:elec_snare,:elec_lo_snare,:elec_hi_snare,:elec_mid_snare,:elec_cymbal,:elec_soft_kick,:elec_filt_snare,:elec_fuzz_tom,:elec_chime,:elec_bong,:elec_twang,:elec_wood,:elec_pop,:elec_beep,:elec_blip,:elec_blip2,:elec_ping,:elec_bell,:elec_flip,:elec_tick,:elec_hollow_kick,:elec_twip,:elec_plip,:elec_blup,:glitch_bass_g,:glitch_perc1,:glitch_perc2,:glitch_perc3,:glitch_perc4,:glitch_perc5,:glitch_robot1,:glitch_robot2,:mehackit_phone1,:mehackit_phone2,:mehackit_phone3,:mehackit_phone4,:mehackit_robot1,:mehackit_robot2,:mehackit_robot3,:mehackit_robot4,:mehackit_robot5,:mehackit_robot6,:mehackit_robot7,:misc_crow,:perc_bell,:perc_bell2,:perc_snap,:perc_snap2,:perc_swash,:perc_till,:perc_door,:perc_impact1,:perc_impact2,:perc_swoosh,:sn_dub,:sn_dolf,:sn_zome,:sn_generic,:guit_harmonics,:guit_e_fifths,:guit_e_slide,:guit_em9,:tabla_tas1,:tabla_tas2,:tabla_tas3,:tabla_ke1,:tabla_ke2,:tabla_ke3,:tabla_na,:tabla_na_o,:tabla_tun1,:tabla_tun2,:tabla_tun3,:tabla_te1,:tabla_te2,:tabla_te_ne,:tabla_te_m,:tabla_ghe1,:tabla_ghe2,:tabla_ghe3,:tabla_ghe4,:vinyl_backspin,:vinyl_rewind,:vinyl_scratch]
  syn_sels  = [:bass_foundation, :bass_highend, :beep, :blade, :bnoise, :chipbass, :chiplead, :chipnoise, :cnoise, :dark_ambience, :dpulse, :dsaw, :dtri, :dull_bell, :fm, :gnoise, :growl, :hollow, :hoover, :kalimba,  :noise, :organ_tonewheel, :piano, :pluck, :pnoise, :pretty_bell, :prophet, :pulse, :rodeo, :saw, :sine, :sound_in, :sound_in_stereo, :square, :subpulse, :supersaw, :tb303, :tech_saws, :tri, :winwood_lead, :zawa]
  
  if get(:chaos2) == 1 then
    live_loop :o1_chaos2_loop_on do
      while get(:chaos2) == 1 do
        a = rrand_i(0,chord_names.length-1)
        b = rrand_i(0,syn_sels.length-1)
        c = rrand_i(0,26)
        d = rrand_i(0,samp_sels.length-1)

        with_fx :compressor, slope_above: 0, slope_below: 0.1, amp: 0.1   do
          with_fx fx_names[c] do
            use_synth syn_sels[b]
            play (chord get(:adjpitch), chord_names[a]), amp: get(:adjvol) 
            sample samp_sels[d], amp: get(:adjvol)
          end
        end
        sleep get(:adjdens) + 0.2

      end
      stop
      sleep get(:adjdens) + 0.2
    end
  end
end       

