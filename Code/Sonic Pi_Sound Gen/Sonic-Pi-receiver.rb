#      ____._______________   ____.___
#     |    |\_   _____/\   \ /   /|   |
#     |    | |    __)_  \   Y   / |   |
# /\__|    | |        \  \     /  |   |
# \________|/_______  /   \___/   |___|
#                   \/
# ________  .___  ________    _____     ._______________________________
# \______ \ |   |/  _____/   /     \    |   ____/\   _  \______  \   _  \
#  |    |  \|   /   \  ___  /  \ /  \   |____  \ /  /_\  \  /    /  /_\  \
#  |    `   \   \    \_\  \/    Y    \  /       \\  \_/   \/    /\  \_/   \
# /_______  /___|\______  /\____|__  / /______  / \_____  /____/  \_____  /
#         \/            \/         \/         \/        \/              \/
#
# AUTONOMOUS ORCHESTRA PERFORMER
# The aim is to create a performer within the class' acoustic electronic orchestra,
# that can perform autonomously, and harmoniously. This is a non-deterministic, generative,
# aleatoric, autonomous, interactive musical performer.


# Adapted from https://github.com/mrbombmusic/sonic-pi-drum-rnn-gui
# Uses: p5js-osc, Magenta Drum RNN, NexusUI, Sonic Pi
#
# Open the index.html and start the bridge in terminal:
# cd p5js-osc/;node bridge.js

# Steps:
# A. Determine How to Play:
#   1. Trains a melodic soundscape breath pattern (a sound made in by the machine) based on original pattern in interface.
#   2. This pattern is randomly sampled for playback:
#       a. played at random lengths
#       b. played with random soundscapes
# B. Determine When to Play:
#   1. Uses the sound-in as input, and determines when to play. (global amp)
#   2. When it is allowed to play, it may or not not play. (local amp)

use_osc "localhost", 12004

#Set intiial amp value
instrAmp = 1.4
orchestraAmp = 0

# --------------------------------------
# DEFINE SOUNDSCAPE KITS
# --------------------------------------

samples = [
  [
    :ambi_drone,
    :elec_triangle,
    :ambi_piano,
    :elec_soft_kick,
    :elec_beep,
    :perc_bell,
    :elec_triangle,
    :tabla_tas1,
    :tabla_tas2,
  ]
  ,[
    :bd_haus,
    :drum_snare_hard,
    :drum_cymbal_closed,
    :elec_ping,
    :elec_bell,
    :elec_twip,
    :glitch_perc4,
    :perc_swoosh,
    :tabla_ghe2,
  ], [
    :perc_bell,
    :perc_bell2,
    :perc_snap,
    :perc_snap2,
    :perc_swash,
    :perc_till,
    :perc_door,
    :perc_impact2,
    :perc_swoosh
  ], [
    :elec_twang,
    :elec_wood,
    :elec_pop,
    :elec_beep,
    :elec_blip,
    :elec_blip2,
    :elec_ping,
    :elec_bell,
    :elec_twip
  ],
  [
    :ambi_soft_buzz,
    :ambi_swoosh,
    :ambi_drone,
    :ambi_glass_hum,
    :ambi_glass_rub,
    :ambi_haunted_hum,
    :ambi_piano,
    :ambi_dark_woosh,
    :ambi_choir
    
  ], [
    :tabla_tas1,
    :tabla_tas2,
    :tabla_tas3,
    :tabla_ke1,
    :tabla_ke2,
    :tabla_ke3,
    :tabla_na,
    :tabla_ghe1,
    :tabla_ghe2
  ], [
    :perc_bell,
    :perc_bell2,
    :perc_snap,
    :drum_tom_hi_hard,
    :drum_tom_mid_hard,
    :elec_ping,
    :elec_bell,
    :elec_twip,
    :perc_bell
  ],
  [
    :elec_twang,
    :elec_wood,
    :elec_pop,
    :elec_beep,
    :elec_blip,
    :elec_blip2,
    :ambi_piano,
    :ambi_dark_woosh,
    :ambi_choir
  ]
]

step = []
midiNotes = []


# --------------------------------------
# RECEIVE OSC VARIABLES
# --------------------------------------

live_loop :receivedNewPattern do
  use_real_time
  a = sync "/osc*/wek/outputs"
  b = sync "/osc*/wek2/outputs"
  set :notes, a
  set :steps, b
  puts a
end

live_loop :receivedGenPattern do
  use_real_time
  c = sync "/osc*/wek3/outputs"
  d = sync "/osc*/wek4/outputs"
  set :genNotes, c
  set :genSteps, d
end

live_loop :playGenPatternOrNot do
  use_real_time
  e = sync "/osc*/wek5/outputs"
  set :playGenOrNot, e
end

live_loop :selectSoundscape do
  use_real_time
  f = sync "/osc*/wek6/outputs"
  set :kit, f
end

live_loop :receivedAmp do
  use_real_time
  g = sync "/osc*/wek7/outputs"
  orchestraAmp = g
end


#Sync amp to the input volume or return 0.
live_loop :syncAmp do
  instrAmp = orchestraAmp[0] || [0]
  sleep 0.4
end

#Randomise amp every 4 beats if it is not silent
#live_loop :randomiseamp do
#  instrAmp = rrand(0.1,1.0) if instrAmp != 0
#  sleep 4
#end

#Every two breaths, it may be silent for two breaths
live_loop :randomisesilence do  
  instrAmp = choose([0, instrAmp])
  sleep 8
end


# --------------------------------------
# PLAY SOUNDSCAPE PATTERNS
# --------------------------------------

live_loop :playPatterns, sync: :selectSoundscape do
  midiNotes = get[:notes] || []
  step = get[:steps] || []
  genNotes = get[:genNotes] || []
  genStep = get[:genSteps] || []
  playGen = get[:playGenOrNot]
  
  # Override soundkit choice to be a random selection
  # This week for simiplicity, the choice of sound will fixed by the GUI
  # set :kit, choose([["0"],["1"],["2"],["3"],["4"],["5"],["6"]])
  
  i = get[:kit][0].to_i
  
  dr = { samples[i][0] => 36,
         samples[i][1] =>  46,
         samples[i][2] =>  38,
         samples[i][3] => 42,
         samples[i][4] => 51,
         samples[i][5] =>  48,
         samples[i][6] =>  50,
         samples[i][7] =>  49,
         samples[i][8] => 45
         }
  
  if playGen
    if playGen[0] == 1 || playGen[0] == 2
      bl = rrand_i(1, 4)*4 #randomise breath length as a multiple of 4, between 4 and 16
      bl.times do |i|
        for x in 0..midiNotes.length do
          if step[x] == i
            sample dr.select{|k,v| v == midiNotes[x]}.keys.first, amp: instrAmp
          end
        end
        osc "/druminfo", i, 0
        sleep 0.25
      end
    end
    
    if playGen[0] == 0 || playGen[0] == 2
      bl = rrand_i(1, 4)*4 #randomise breath length as a multiple of 4, between 4 and 16
      bl.times do |i|
        for x in 0..genNotes.length do
          if genStep[x] == i
            sample dr.select{|k,v| v == genNotes[x]}.keys.first, amp: instrAmp
          end
        end
        osc "/druminfo", i, 1
        sleep 0.25
      end
    end
  else
    sleep 0.25
  end
end
