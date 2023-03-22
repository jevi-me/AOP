#!/usr/bin/env python3
# Adapted by Jevi from Robin Newman July 2017 for use with Tremon Controllor 
# converts controller inputs to OSC messages
# Run using python3.10 .ps3.py --sp 10.0.0.240


import subprocess,pygame,sys,argparse
from getkey import getkey
from signal import pause
from pythonosc import osc_message_builder
from pythonosc import udp_client
from time import sleep

ps3.init()

def control(spip):
 gate=0.1
 sender=udp_client.SimpleUDPClient(spip, 4560) #sender set up for specified IP

 while True:
    try:
        UdpClient udpClient = new UdpClient(6666);
        sender.send_message('6666',1)
        clock.tick(20)
        subprocess.call("clear")
        
    except KeyboardInterrupt:
        print("\nStopping...")
        sys.exit()

    

if __name__=="__main__":
    parser = argparse.ArgumentParser()
    #This arg gets the server IP address to use. 127.0.0.1 or
    #The local IP address of the Pi, required when using external Sonic Pi
    parser.add_argument("--sp",
    default="127.0.0.1", help="The ip to listen on")
    args = parser.parse_args()
    spip=args.sp
    print("Doug on ip ",spip)
    sleep(2)
    control(spip)
