  use_synth :pretty_bell
          play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol), on: get(:o1_on)
          sleep get(:adjdens) + 0.2




use_synth :fm
          with_fx :vowel, vowel_sound: 5, voice: 4 do
          play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos), on: get(:o1_on)



———


use_synth :fm
          with_fx :vowel, vowel_sound: 1, voice: 1 do
          play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:o1_pos), on: get(:o1_on)
        end




use_synth :fm
          play get(:adjpitch), pan: get(:o1_pos), amp: get(:adjvol), on: get(:o1_on)
          sleep get(:adjdens) + 0.2

———



## Chaos1 Loop
live_loop :chaos1_loop do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/7"
 
  if get(:chaos1) == 1 then
  end
end

## Chaos2 Loop (TODO: move this to O3)
live_loop :chaos2_loop do
  use_real_time
  pad_no, pad_name, val = sync "/osc*/modes/8"
  samp_sels = [:ambi_soft_buzz,:ambi_swoosh,:ambi_piano,:ambi_dark_woosh,:ambi_choir,:bd_ada,:bd_pure,:bd_808,:bd_zum,:bd_gas,:bd_sone,:bd_haus,:bd_zome,:bd_boom,:bd_klub,:bd_fat,:bd_tek,:bd_mehackit,:bass_hit_c,:bass_hard_c,:bass_drop_c,:bass_woodsy_c,:bass_voxy_hit_c,:bass_dnb_f,:bass_trance_c,:drum_heavy_kick,:drum_tom_mid_soft,:drum_tom_mid_hard,:drum_tom_lo_soft,:drum_tom_lo_hard,:drum_tom_hi_soft,:drum_tom_hi_hard,:drum_splash_soft,:drum_splash_hard,:drum_snare_soft,:drum_snare_hard,:drum_cymbal_soft,:drum_cymbal_hard,:drum_cymbal_open,:drum_cymbal_closed,:drum_cymbal_pedal,:drum_bass_soft,:drum_bass_hard,:drum_cowbell,:elec_triangle,:elec_snare,:elec_lo_snare,:elec_hi_snare,:elec_mid_snare,:elec_cymbal,:elec_soft_kick,:elec_filt_snare,:elec_fuzz_tom,:elec_chime,:elec_bong,:elec_twang,:elec_wood,:elec_pop,:elec_beep,:elec_blip,:elec_blip2,:elec_ping,:elec_bell,:elec_flip,:elec_tick,:elec_hollow_kick,:elec_twip,:elec_plip,:elec_blup,:glitch_bass_g,:glitch_perc1,:glitch_perc2,:glitch_perc3,:glitch_perc4,:glitch_perc5,:glitch_robot1,:glitch_robot2,:mehackit_phone1,:mehackit_phone2,:mehackit_phone3,:mehackit_phone4,:mehackit_robot1,:mehackit_robot2,:mehackit_robot3,:mehackit_robot4,:mehackit_robot5,:mehackit_robot6,:mehackit_robot7,:misc_crow,:perc_bell,:perc_bell2,:perc_snap,:perc_snap2,:perc_swash,:perc_till,:perc_door,:perc_impact1,:perc_impact2,:perc_swoosh,:sn_dub,:sn_dolf,:sn_zome,:sn_generic,:guit_harmonics,:guit_e_fifths,:guit_e_slide,:guit_em9,:tabla_tas1,:tabla_tas2,:tabla_tas3,:tabla_ke1,:tabla_ke2,:tabla_ke3,:tabla_na,:tabla_na_o,:tabla_tun1,:tabla_tun2,:tabla_tun3,:tabla_te1,:tabla_te2,:tabla_te_ne,:tabla_te_m,:tabla_ghe1,:tabla_ghe2,:tabla_ghe3,:tabla_ghe4,:vinyl_backspin,:vinyl_rewind,:vinyl_scratch]
  syn_sels  = [:bass_foundation, :bass_highend, :beep, :blade, :bnoise, :chipbass, :chiplead, :chipnoise, :cnoise, :dark_ambience, :dpulse, :dsaw, :dtri, :dull_bell, :fm, :gnoise, :growl, :hollow, :hoover, :kalimba,  :noise, :organ_tonewheel, :piano, :pluck, :pnoise, :pretty_bell, :prophet, :pulse, :rodeo, :saw, :sine, :sound_in, :sound_in_stereo, :square, :subpulse, :supersaw, :tb303, :tech_saws, :tri, :winwood_lead, :zawa]
  
  if get(:chaos2) == 1 then
    live_loop :o1_chaos2_env_ready do
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





use_synth :growl
            play get(:adjpitch) +4, pan: get(:o2_pos), amp: get(:adjvol), on: get(:o2_on)
            use_synth :dark_ambience
            with_fx :vowel, vowel_sound: 5, voice: 4 do
              play get(:adjpitch) + 4, pan: get(:o2_pos), amp: get(:adjvol), on: get(:o2_on)
            end




            use_synth :growl
            play get(:adjpitch) +8, pan: get(:o2_pos), amp: get(:adjvol), on: get(:o2_on)
            use_synth :dark_ambience
            with_fx :vowel, vowel_sound: 5, voice: 4 do
              play get(:adjpitch) + 12, pan: get(:o2_pos), amp: get(:adjvol), on: get(:o2_on)
            end



                  use_synth :prophet
      with_fx :vowel, vowel_sound: 5, voice: 4 do
      play get(:adjpitch), sustain: get(:adjdens), pan: get(:o2_pos), amp: get(:adjvol)*0.75
      end

