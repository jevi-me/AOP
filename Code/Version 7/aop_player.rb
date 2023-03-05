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


### UNEDITTED

p_name=["mode1","mode2","improvise1","improveise2",
        "mode3","mode4","i_play","aop+play"] #pads

k_name=["ctrl_d1","ctrl_d2","pitch", "volume"
        "decay","sustain","release","density"] #knobs

c_names=["hit1", "hit2", "drone1", "drone2"
         "impro_burst","trigger1", "trigger2"] #game controller

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


# ---------------------------------------------------------
#### INITIALISE AND DEFINE
## Define and Initialise values used to communicate with the live_loops
# ---------------------------------------------------------

# Pan Position of Player and AOP in sound environment
set :i_pos, -1 #left channel
set :aop_pos, 1 #right channel

# Values for Pads
set :drone1, 0    #drone 1, on or off
set :drone2, 0     # drone 2, on of off
set :improvise, 0 #improvise, on or off
set :trigger, 0   #trigger, on or off
set :i_ready, 1    #I play, on or off
set :aop_ready, 0  #aop plays, on or off


# Value for Knobs
set :ctrl_d1, 0   #control drone 1 rate  between 0 and 1
set :adjdec, 0    #decay between 0 and 1
set :adjsus, 0    #sustain between 0 and 1
set :adjrel, 0.8    #release between 0+0.8 and 1+ 0.8

set :ctrl_d2, 0    #control drone 2 rate  between 0 and 1
set :adjpitch, 50  #pitch between 0*50 +50 and 1*50 + 50
set :adjdens, 0.2   #denisty between 0+0.2 and 1+ 0.2
set :adjvol, 1    #volume between 0 and 1

# ---------------------------------------------------------
#### CAPTURE MIDI CONTROLS
## Function to Normalise Knob Inputs
# ---------------------------------------------------------

define :norm do |n| #scale 0->127 to 0->1
  return n.to_f/127
end

## Capture knob change
live_loop :con_chg do
  use_real_time
  knb_no, val = sync "/midi*/control_change"
  val = norm(val)
  
  if knb_no == 1 then
    set :ctrl_d1, val
    puts k_name[0], val
  end
  if knb_no == 2 then
    set :adjdec, val
    puts k_name[1], val
  end
  if knb_no == 3 then
    set :adjsus, val
    puts k_name[2], val
  end
  if knb_no == 4 then
    set :adjrel, (val + 0.08)
    puts k_name[3], (val + 0.08)
  end
  
  
  if knb_no == 5 then
    set :ctrl_d2, val
    puts k_name[4], val
  end
  if knb_no == 6 then
    set :adjpitch, (val*50 + 50)
    puts k_name[5], (val*50 + 50)
  end
  if knb_no == 7 then
    set :adjdens, val*2 + 0.2
    puts k_name[6], val*2 + 0.2
  end
  if knb_no == 8 then
    set :adjvol, val
    puts k_name[7], val
  end
  
end


# ---------------------------------------------------------
#### SECTION PLAYERS
# Play when a pad is pressed, only if the player is ready to play.
# ---------------------------------------------------------

## Hit 1
live_loop :c5_on do
  use_real_time
  pad_no, vel = sync "/midi*5/note_on"
  if get(:i_ready) == 1 then
    puts p_name[0]
    use_synth :pretty_bell
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:i_pos)
  end
  if get(:aop_ready) == 1 then
    use_synth :dull_bell
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:aop_pos)
  end
end

live_loop :c5_cp do
  use_real_time
  sync "/midi*5/channel_pressure"
  if get(:i_ready) == 1 then
    use_synth :pretty_bell
    sleep get(:adjdens)
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:i_pos)
  end
  if get(:aop_ready) == 1 then
    use_synth :dull_bell
    sleep get(:adjdens)+rrand_i(0,1)
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:aop_pos)
  end
end

## Hit 2
live_loop :c6_on do
  use_real_time
  pad_no, vel = sync "/midi*6/note_on"
  if get(:i_ready) == 1 then
    puts p_name[1]
    use_synth :fm
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:i_pos)
  end
  if get(:aop_ready) == 1 then
    use_synth :fm
    play chord(:F, :major7), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:aop_pos)
  end
end

live_loop :c6_cp do
  use_real_time
  sync "/midi*6/channel_pressure"
  if get(:i_ready) == 1 then
    use_synth :fm
    sleep get(:adjdens)
    play get(:adjpitch), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:i_pos)
  end
  if get(:aop_ready) == 1 then
    use_synth :fm
    sleep get(:adjdens)
    play chord(:F, :major7), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel), amp: get(:adjvol), pan: get(:aop_pos)
  end
end


## Drone 1 & 2
live_loop :c7_on do
  use_real_time
  sync "/midi*7/note_on"
  puts p_name[2]

  if get(:drone1) == 1 then
    set :drone1, 0
  elsif get(:drone1) == 0 then
    set :drone1, 1
  end
end

live_loop :c8_on do
  use_real_time
  sync "/midi*8/note_on"
  puts p_name[3]
  if get(:drone2) == 1 then
    set :drone2, 0
  elsif get(:drone2) == 0 then
    set :drone2, 1
  end
end

live_loop :playdrones do
  use_real_time
  if get(:i_ready) == 1 then
    if get(:drone1) == 1
      d1 = sample :ambi_drone, amp: get(:adjvol), pan: get(:i_pos), rate: get(:ctrl_d1), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel)
    end
    if get(:drone2) == 1
      d2 = sample :ambi_haunted_hum, amp: get(:adjvol), pan: get(:i_pos), rate: get(:ctrl_d2), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel)
    end
  end
  if get(:aop_ready) == 1 then
    if get(:drone1) == 1
      d3 = play chord(:C, :major7), amp: get(:adjvol)/2, pan: get(:aop_pos), rate: get(:ctrl_d1), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel)
    end
    if get(:drone2) == 1
      d4 = play chord(:A, :minor7), amp: get(:adjvol)/2, pan: get(:aop_pos), rate: get(:ctrl_d2), decay: get(:adjdec), sustain: get(:adjsus), release: get(:adjrel)
    end
  end
  sleep get(:adjdens)
end

# Improvise
live_loop :c1_cp do
  use_real_time
  sync "/midi*1/channel_pressure"
  puts p_name[4]
  
  if get(:i_ready) == 1 then
    slist= [:mod_beep, :growl]
    
    ranSyn= [rrand_i(0, slist.length-1), rrand_i(0,slist.length-1), rrand_i(0, slist.length-1)]
    ranNote=[rrand_i(50, 120), rrand_i(50,120), rrand_i(50, 120)]
    ranAttack=[rrand(0, 1), rrand(0,1), rrand(0, 1)]
    ranRelease=[rrand(0, 1), rrand(0,1), rrand(0, 1)]
    
   # if(rrand_i(0,10) > 1)
      synth slist[ranSyn[0]],note: ranNote[0],attack: ranAttack[0], release: ranRelease[0], pan: get(:i_pos), amp: get(:adjvol)/6
      synth slist[ranSyn[1]],note: ranNote[1],attack: ranAttack[1], release: ranRelease[1], pan: get(:i_pos), amp: get(:adjvol)/6
      synth slist[ranSyn[2]],note: ranNote[2],attack: ranAttack[2], release: ranRelease[2], pan: get(:i_pos), amp: get(:adjvol)/6
   # else
   #   synth :cnoise, sustain: 0.5, amp: 0.001, pan: get(:i_pos)
      sleep ranAttack[0]+ ranRelease[0] + get(:adjdens)
   # end
  end
  if get(:aop_ready) == 1 then
    slist= [:dark_ambience, :growl, :fm]
    
    ranSyn= [rrand_i(0, slist.length-1), rrand_i(0,slist.length-1), rrand_i(0, slist.length-1)]
    ranNote=[rrand_i(40, 50), rrand_i(40,50), rrand_i(40, 50)]
    ranAttack=[rrand(0, 1), rrand(0,1), rrand(0, 1)]
    ranRelease=[rrand(0, 0.5), rrand(0,0.5), rrand(0, 0.5)]
    
    #if(rrand_i(0,10) > 1)
      synth slist[ranSyn[0]],note: ranNote[0],attack: ranAttack[0], release: ranRelease[0], pan: get(:aop_pos), amp: get(:adjvol)/6
      synth slist[ranSyn[1]],note: ranNote[1],attack: ranAttack[1], release: ranRelease[1], pan: get(:aop_pos), amp: get(:adjvol)/6
      synth slist[ranSyn[2]],note: ranNote[2],attack: ranAttack[2], release: ranRelease[2], pan: get(:aop_pos), amp: get(:adjvol)/6
    #else
    #  synth :cnoise, sustain: 0.5, amp: 0.001, pan: get(:aop_pos)
      sleep ranAttack[0]+ ranRelease[0] + get(:adjdens)
    #end
  end
end

live_loop :c2_on do
  use_real_time
  sync "/midi*2/note_on"
  puts p_name[5]
  
  osc_send "localhost",4560,"/stop-all-jobs"
  
end

live_loop :c3_on do
  use_real_time
  sync "/midi*3/note_on"
  puts p_name[6]
  
  if get(:i_ready) == 1 then
    set :i_ready, 0
  elsif get(:i_ready) == 0 then
    set :i_ready, 1
  end
end

live_loop :c4_on do
  use_real_time
  sync "/midi*4/note_on"
  puts p_name[7]
  
  if get(:aop_ready) == 1 then
    set :aop_ready, 0
  elsif get(:aop_ready) == 0 then
    set :aop_ready, 1
  end
end


