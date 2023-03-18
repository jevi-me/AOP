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


live = 0
test = 0

# Test Set up
if test == 1 then
  loop do
    play :c4, pan: -1
    sleep 1
    play :d4, pan: 1
    sleep 1
  end
end

# Run Files
if live == 1 then
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/replicator.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/o1_player.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/o2_player.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/o3_player.rb"
end