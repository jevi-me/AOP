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

use_debug true
use_cue_logging true

#### INITIALISE AND DEFINE

# Set values used to communicate with the live_loops
set :adjtone, 0 #between 0 and 2
set :adjvol, 2 #volume between 0 and 2
set :mutectrl, 0 #mute on, or mute off
set :syn_pointer,0 #current synth pointer
set :syn, :dark_ambience #current synth name
set :pitch_pointer, 0 # current pitch pointer
set :pitch, 1 #curent pitch
set :improvise, 0 #on or off
set :mutectrl, 0 #mute on, or mute off


# Pretty Printing function
define :p_prnt do |n|
  return (n.to_f*100).round.to_f/100
end

#### CONTROLS

# -- Mute and Volume 
 live_loop :bt6 do  #Vol up
    use_real_time
    b=sync "/osc*/b6"
    p = get(:adjvol)+0.10
    set :adjvol, [p,2].min
    puts "volume set",p_prnt(get(:adjvol))
    sleep 0.4
  end

 live_loop :bt4 do #Vol down
    use_real_time
    b=sync "/osc*/b4"
    p = get(:adjvol)-0.10 
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

# -- Cycle Synth --
live_loop :rud do 
  use_real_time
  slist=[:dark_ambience,:sine,:tri,:fm,:saw,:prophet,:mod_fm,:mod_saw,:tb303] #listed in order or softest to loudest
  b= sync "/osc*/rud"
  p=get(:syn_pointer)
  p=[p+1,slist.length-1].min if b[0] > 0.4
  p=[p-1,0].max if b[0] < -0.4
  set :syn_pointer,p
  set(:syn,slist[p])
  puts "syn is",get(:syn)
  sleep 0.4
end

# -- Adjust Pitch --
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

# -- Improvise and Noise --
  live_loop :bt9 do
    use_real_time
    b= sync "/osc*/b9"
    slist= [:dark_ambience,:sine,:tri,:fm,:saw,:prophet,:mod_fm,:mod_saw,:tb303]
    ranSyn= [rrand_i(0, 8), rrand_i(0,8), rrand_i(0, 8)]
    ranNote=[rrand_i(1, 120), rrand_i(1,120), rrand_i(1, 120)]
    synth slist[ranSyn[0]],note: ranNote[0],attack: 0.1,release: 0.2,amp: get(:adjvol)  if b[0]==1
    synth slist[ranSyn[1]],note: ranNote[1],attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth slist[ranSyn[2]],note: ranNote[2],attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
  end

#### PLAYING
  live_loop :bt0 do
    use_real_time
    b= sync "/osc*/b0"
    synth get(:syn),note: :g4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: :c4,attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1

  end

  live_loop :bt1 do
    b= sync "/osc*/b1"
    use_real_time
    synth get(:syn),note: :a4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: :d4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1

  end

  live_loop :bt2 do
    use_real_time
    b= sync "/osc*/b2"
    synth get(:syn),note: :b4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: :e4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1

  end
  
  live_loop :bt3 do
    use_real_time
    b= sync "/osc*/b3"
    synth get(:syn),note: :c5,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: :f4,attack: 0.1,release: 0.2,amp: get(:adjvol)   if b[0]==1
    synth get(:syn),note: get(:pitch),attack: 0.1,release: 0.2,amp: get(:adjvol)    if b[0]==1

  end

