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

setup_test = 0
live_test = 1

define :rfiles do
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/replicator.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/o1_player.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/o2_player.rb"
  run_file "/Users/jevi/GitHub/EOA/Code/Version 10/o3_player.rb"
end

define :test_o1 do
  set :o1_ready, 1    
  osc "/play/hit1", 1
  sleep 1
  osc "/play/hit2", 1
  sleep 1
  osc "/play/drone1", 1
  sleep 1
  osc "/play/drone2", 1
  sleep 1
  osc "/play/improv_burst", 1
  
  sleep 2
  
  set :loop_this, 1   
  osc "/play/hit1", 1
  sleep 3
  set :loop_this, 0   
  sleep 3
  set :loop_this, 1   
  osc "/play/hit2", 1
  sleep 3
  set :loop_this, 0   
  sleep 3
  set :loop_this, 1   
  osc "/play/drone1", 1
  sleep 3
  set :loop_this, 0   
  sleep 3
  set :loop_this, 1  
  osc "/play/drone2", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
end

define :test_o2_m1 do
  set :o1_ready, 1
  set :o2_ready, 1    
  set :mut1, 0   
  
  osc "/play/hit1", 1
  sleep 1
  osc "/play/hit2", 1
  sleep 1
  osc "/play/drone1", 1
  sleep 1
  osc "/play/drone2", 1

  sleep 2
  
  set :loop_this, 1   
  osc "/play/hit1", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
  set :loop_this, 1  
  osc "/play/hit2", 1
  sleep 3
  set :loop_this, 0   
  sleep 3
  set :loop_this, 1   
  osc "/play/drone1", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
  set :loop_this, 1  
  osc "/play/drone2", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
end

define :test_o2_m2 do
  set :o1_ready, 1
  set :o2_ready, 1    
  set :mut1, 1    
  
  osc "/play/hit1", 1
  sleep 1
  osc "/play/hit2", 1
  sleep 1
  osc "/play/drone1", 1
  sleep 1
  osc "/play/drone2", 1
  
  sleep 2
  
  set :loop_this, 1  
  osc "/play/hit1", 1
  sleep 3
  set :loop_this, 0   
  sleep 3
  set :loop_this, 1  
  osc "/play/hit2", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
  set :loop_this, 1  
  osc "/play/drone1", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
  set :loop_this, 1  
  osc "/play/drone2", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
end

define :test_o3 do
  set :o1_ready, 1
  set :o2_ready, 1
  set :o3_ready, 1   
  
  osc "/play/hit1", 1
  sleep 1
  osc "/play/hit2", 1
  sleep 1
  osc "/play/drone1", 1
  sleep 1
  osc "/play/drone2", 1
  
  sleep 2
  
  set :loop_this, 1   
  osc "/play/hit1", 1
  sleep 3
  set :loop_this, 0   
  sleep 3
  set :loop_this, 1   
  osc "/play/hit2", 1
  sleep 3
  set :loop_this, 0 
  sleep 3
  set :loop_this, 1  
  osc "/play/drone1", 1
  sleep 3
  set :loop_this, 0  
  sleep 3
  set :loop_this, 1   
  osc "/play/drone2", 1
  sleep 3
  set :loop_this, 0   
  sleep 3
end


# Run Test Setup
if setup_test == 1 then
  loop do
    play :c4, pan: -1
    sleep 1
    play :d4, pan: 1
    sleep 1
  end
end

# Run Live
if live == 1 then
  rfiles
end


# Run Live Test
if live_test == 1 then
  rfiles
  sleep 4
  
  use_osc "localhost", 4560
  
  test_o1
  #test_o2_m1
  #test_o2_m2
  #test_o3
  
end
