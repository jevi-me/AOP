# Experimental program to control Sonic Pi from the keyboard
# Written by Jevi, Jan 2023
# Adapted from Robin Newman, April 2016, https://gist.github.com/rbnpi/7e01964ab8110e6df1e6d823bd9c4dcb
# Keyboard polling routine by Alex Chaffee, http://stackoverflow.com/questions/174933/how-to-get-a-single-character-without-pressing-enter
# Chords from http://sonic-pi.mehackit.org/exercises/en/09-keys-chords-and-scales/01-piano.html

#########################################
# SOCKETS
#########################################
require 'socket'
use_synth :saw #used for directly played notes
notes=Hash.new #set up hash to contain notes


#########################################
# NOTES & INPUT
#########################################
# List of notes
l=[:c4,:cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4, :c5, :cs5, :d5, :ds5, :e5, :f5, :fs5, :g5]

# List of associated note keys
n=["a", "w", "s", "e",  "d", "f",  "t", "g",  "y", "h",  "u", "j", "k",  "o", "l", "p",  ";", "'",  "[", "]"]

# Loop to create the hash
20.times do |i|
  notes[n[i].ord]=l[i]
end


k=0 # Set initial value of k, making it a global variable
norj = :major7 # Set intial value for major or minor


#########################################
# CHORD DEFINITIONS
#########################################
cMjI =      chord(:C, :major7)
cMjII =     chord(:D, :minor7)
cMjIII =    chord(:E, :minor7)
cMjIV =     chord(:F, :major7)
cMjV =      chord(:G, "7")
cMjVI =     chord(:A, :minor7)

dbMjI = 	chord(:Db, :major7)
dbMjII = 	chord(:Eb, :minor7)
dbMjIII = 	chord(:F, :minor7)
dbMjIV = 	chord(:Gb, :major7)
dbMjV = 	chord(:Ab, "7")
dbMjVI = 	chord(:Bb, :minor7)

dMjI = 	    chord(:D, :major7)
dMjII = 	chord(:E, :minor7)
dMjIII = 	chord(:Gb, :minor7)
dMjIV = 	chord(:G, :major7)
dMjV = 	    chord(:A, "7")
dMjVI = 	chord(:B, :minor7)


#########################################
# LIVE LOOP FOR INPUT
#########################################
live_loop :tcp do #loop to poll tcp input
  s = TCPSocket.new 'localhost', 2023 #create socket
  k= s.gets.to_f #get input
  s.close #close socket
  cue :p if k !=0 # if value is not 0 cue play loop
  cue :one if k.to_i.chr == "1"
  cue :two if k.to_i.chr == "2"
  cue :three if k.to_i.chr == "3"
  cue :four if k.to_i.chr == "4"
  cue :five if k.to_i.chr == "5"
  cue :six if k.to_i.chr == "6"
  cue :seven if k.to_i.chr == "7"
  cue :eight if k.to_i.chr == "8"
  cue :nine if k.to_i.chr == "9"
  cue :zero if k.to_i.chr == "0"
  sleep 0.5 #short sleep before repeating
end


#########################################
# LIVE LOOP FOR NOTES
#########################################
live_loop :x do #loop to play the notes
  sync :p #wait for sync to say note is ready
  np = k.to_i #note played
  
  use_synth :dark_ambience
  with_fx :vowel, vowel_sound: 5, voice: 4 do
    play chord(notes[np], norj), attack: 1, release: 2, amp: 1 if k>0
  end
  
  use_synth :piano
  with_fx :vowel, vowel_sound: 1, voice: 1 do
    play chord(notes[np], norj), attack: 2, release: 2, amp: 1 if k>0
  end
  
  use_synth :growl
  with_fx :vowel, vowel_sound: 4, voice: 2 do
    play chord(notes[np], norj), attack: 1,  release: 2, amp: 1 if k>0
  end
  
  use_synth :organ_tonewheel
  with_fx :ping_pong do
    play chord(notes[np], norj), attack: 3, release: 4, amp: 1 if k>0
  end
  
  sleep 2
end


#########################################
# LIVE LOOP TO FLIP FROM MAJOR TO MINOR
#########################################
live_loop :nj1 do
  sync :eight
  makeminor
end

live_loop :nj2 do
  sync :nine
  makemajor
end


#########################################
# LIVE LOOPS FOR SAMPLE CUES
#########################################

live_loop :s1 do
  sync :one
  l= (sample_duration :ambi_drone )
  with_fx :level,amp: 1 do |v|
    control v,amp_slide: 2*l,amp: 0
    sample :ambi_drone
    sleep l+1
  end
end


live_loop :s2 do
  sync :two
  l= (sample_duration :ambi_glass_hum )
  with_fx :level,amp: 1 do |v|
    control v,amp_slide: 2*l,amp: 0
    sample :ambi_glass_hum
    sleep l+1
  end
end


live_loop :s3 do
  sync :three
  l= (sample_duration :ambi_haunted_hum )
  with_fx :level,amp: 1 do |v|
    control v,amp_slide: 2*l,amp: 0
    sample :ambi_haunted_hum
    sleep l+1
  end
end


live_loop :s4 do
  sync :four
  l= (sample_duration :ambi_piano )
  with_fx :level,amp: 1 do |v|
    control v,amp_slide: 2*l,amp: 0
    sample :ambi_piano
    sleep l+1
  end
end


live_loop :s0 do
  sync :zero
  l1= (sample_duration :guit_e_slide )
  l2= (sample_duration :guit_em9)
  l= l1+l2
  with_fx :level,amp: 1 do |v|
    control v,amp_slide: 2*l,amp: 0
    sample :guit_e_slide
    sample :guit_e_fifths
    sleep 2
    sample :guit_em9
    sleep 3
    sample :guit_harmonics
  end
end


#########################################
# LIVE LOOPS FOR MELODIES CUES
#########################################

live_loop :mldy1 do
  sync :five
  melody = [cMjI, cMjVI, cMjIV, cMjV] #chord progression I, VI, IV, V
  # Loop that plays each chord in the progression
  2. times do
    4.times do |i|
      chord_player melody[i]
      sleep 8
    end
  end
  sleep 8
end


live_loop :mldy2 do
  sync :six
  melody = [cMjI, cMjIV, cMjV] #chord progression I, IV, V
  # Loop that plays each chord in the progression
  3.times do |i|
    chord_player melody[i]
    sleep 8
  end
  melody = [cMjII, cMjV, cMjI] #chord progression II, V, I
  # Loop that plays each chord in the progression
  3.times do |i|
    chord_player melody[i]
    sleep 8
  end
end


live_loop :mldy3 do
  sync :seven
  cue :five
  sleep 64
  cue :six
end


#########################################
# FUNCTIONS
#########################################

define :chord_player do |c|
  use_synth :dark_ambience
  with_fx :vowel, vowel_sound: 5, voice: 4 do
    play c, attack: 1, release: 2, amp: 0.7
  end
  
  use_synth :piano
  with_fx :vowel, vowel_sound: 1, voice: 1 do
    play c, attack: 2, release: 2, amp: 0.7
  end
  
  use_synth :growl
  with_fx :vowel, vowel_sound: 4, voice: 2 do
    play c, attack: 1,  release: 2, amp: 0.7
  end
  
  use_synth :organ_tonewheel
  with_fx :ping_pong do
    play c, attack: 3, release: 4, amp: 0.7
  end
end

define :makeminor do
  norj = :minor7
end

define :makemajor do
  norj = :major7
end
