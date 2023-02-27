#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
#
#
# "Player/Player"
# Uses a game controller as part of an interactive
# instrument that allows me to perform within the ensemble.

# Supporting Scripts
# python3.10 ps3.py --sp 10.0.0.240
# python3.10 keyboard.py;     

# Mode 1: Choose from 8 synths three-note-chords at 3 different pitches = 24 unique sounds
# Mode 2: Choose from 4 electronic single note sounds = 4 sounds
# Mode 3: Choose from 4 glitchy single note sounds = 4 sounds
# Sustain Play: Cycles between 3 note combinations of 5 sounds, at random pitch (between 50-120), attack (between 0.0 and 1.0), release (between 0.0 and 1.0) and pan (-1, 0, 1).

use_debug true
use_cue_logging true

#### INITIALISE AND DEFINE

# Set values used to communicate with the live_loops
set :adjtone, 0 #between 0 and 2
set :adjvol, 1 #volume between 0 and 2
set :mutectrl, 0 #mute on, or mute off
set :syn_pointer,0 #current synth pointer
set :syn, :dark_ambience #current synth name
set :pitch_pointer, 0 # current pitch pointer
set :pitch, 1 #curent pitch
set :improvise, 0 #on or off
set :mutectrl, 0 #mute on, or mute off
set :mode, 1 #mode 1, 2 or 3

# Pretty Printing function
define :p_prnt do |n|
  return (n.to_f*100).round.to_f/100
end



#### CONTROLS: KEYBOARD AND CONTROLLER

# -- Keyboard
live_loop :key do 
  use_real_time
  b = sync "/osc*/key"
  print b[0]
  if b[0] == "1"
    set :mode, 1
  elsif b[0] == "2"
    set :mode, 2
  elsif b[0] == "3"
    set :mode, 3
  end
end

# -- Mute and Volume
live_loop :bt6 do  #Vol up
  use_real_time
  b=sync "/osc*/b6"
  p = get(:adjvol)+0.05
  set :adjvol, [p,2].min
  puts "volume set",p_prnt(get(:adjvol))
  sleep 0.4
end

live_loop :bt4 do #Vol down
  use_real_time
  b=sync "/osc*/b4"
  p = get(:adjvol)-0.05
  set :adjvol, [p, 0].max
  puts "volume set",p_prnt(get(:adjvol))
  sleep 0.4
end

live_loop :bt7 do  #Quick High 1.0
  use_real_time
  b=sync "/osc*/b7"
  set :adjvol, 1
  puts "volume set",p_prnt(get(:adjvol))
  sleep 0.4
end

live_loop :bt5 do #Quick Low 0.2
  use_real_time
  b=sync "/osc*/b5"
  set :adjvol, 0.2
  puts "volume set",p_prnt(get(:adjvol))
  sleep 0.4
end

live_loop :bt8 do #Mute
  use_real_time
  b=sync "/osc*/b8"
  set :adjvol, 0
  puts "volume set",p_prnt(get(:adjvol))
  sleep 0.4
end

# -- Improvise and Noise --
live_loop :bt9 do
  use_real_time
  b= sync "/osc*/b9"
  
  slist= [:mod_beep, :growl, :dark_ambience, :growl, :fm]
  
  ranSyn= [rrand_i(0, slist.length-1), rrand_i(0,slist.length-1), rrand_i(0, slist.length-1)]
  ranNote=[rrand_i(50, 120), rrand_i(50,120), rrand_i(50, 120)]
  ranAttack=[rrand(0, 1), rrand(0,1), rrand(0, 1)]
  ranRelease=[rrand(0, 1), rrand(0,1), rrand(0, 1)]
  ranPan= [rrand_i(-1, 1), rrand(-1,1), rrand_i(-1, 1)]
  
  if(rrand_i(0,10) > 1)
    synth slist[ranSyn[0]],note: ranNote[0],attack: ranAttack[0], release: ranRelease[0], pan: ranPan[0], amp: 0.01  if b[0]==1
    synth slist[ranSyn[1]],note: ranNote[1],attack: ranAttack[1], release: ranRelease[1], pan: ranPan[1], amp: 0.01  if b[0]==1
    synth slist[ranSyn[2]],note: ranNote[2],attack: ranAttack[2], release: ranRelease[2], pan: ranPan[2], amp: 0.01  if b[0]==1
  else
    synth :cnoise, sustain: 0.5, amp: 0.001 if b[0]==1
    sleep 0.4
  end
end

# -- Mode 1 Synth Cycle  --
live_loop :rud do
  use_real_time
  slist=[:dark_ambience, :growl, :beep, :mod_beep, :tri, :fm, :mod_fm, :pretty_bell] #listed in order or softest to loudest
  b= sync "/osc*/rud"
  p=get(:syn_pointer)
  p=[p+1,slist.length-1].min if b[0] > 0.4
  p=[p-1,0].max if b[0] < -0.4
  set :syn_pointer,p
  set(:syn,slist[p])
  puts "syn is",get(:syn)
  sleep 0.4
end

# -- Mode 1 Adjust Pitch --
live_loop :rlr do
  use_real_time
  plist=[-1,0,1]
  b= sync "/osc*/rlr"
  p=get(:pitch_pointer)
  p=[p+1,plist.length-1].min if b[0] > 0.4
  p=[p-1,0].max if b[0] < -0.4
  set :pitch_pointer,p
  set(:pitch,plist[p]*24+60)
  puts "pitch is",get(:pitch)
  sleep 0.4
end


#### PLAYING
## Mode 1: Combination Notes
## Mode 2: Electric Single Notes
## Mode 3: Glitchy Single Notes

live_loop :bt0 do
  use_real_time
  b= sync "/osc*/b0"
  if get(:mode) == 1
    synth get(:syn),note: :g4,attack: 0.1,release: 0.2,amp: get(:adjvol)  if b[0]==1
    synth get(:syn),note: :c4,attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
  end
  if get(:mode)  == 2
    sample :elec_triangle, amp: get(:adjvol)
  end
  if get(:mode)  == 3
    sample :glitch_perc1, amp: get(:adjvol)
  end
end
live_loop :bt1 do
  b= sync "/osc*/b1"
  use_real_time
  if get(:mode)  == 1
    synth get(:syn),note: :a4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: :d4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1
  end
  if get(:mode)  == 2
    sample :elec_chime , amp: get(:adjvol)
  end
  if get(:mode)  == 3
    sample :glitch_perc2, amp: get(:adjvol)
  end
end

live_loop :bt2 do
  use_real_time
  b= sync "/osc*/b2"
  if get(:mode)  == 1
    synth get(:syn),note: :b4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: :e4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1
  end
  if get(:mode)  == 2
    sample :elec_snare, amp: get(:adjvol)
  end
  if get(:mode)  == 3
    sample :glitch_perc3, amp: get(:adjvol)
  end
end

live_loop :bt3 do
  use_real_time
  b= sync "/osc*/b3"
  if get(:mode)  == 1
    synth get(:syn),note: :c5,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: :f4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1
  end
  if get(:mode) == 2
    sample :elec_filt_snare, amp: get(:adjvol)
  end
  if get(:mode)  == 3
    sample :glitch_perc4, amp: get(:adjvol)
  end
end
