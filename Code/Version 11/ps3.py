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


pygame.display.init()
pygame.joystick.init()
isReady = pygame.joystick.get_init();
joyNum = pygame.joystick.get_count();
#print(isReady)
#print(joyNum)
clock=pygame.time.Clock()
ps3 = pygame.joystick.Joystick(0)
#joyName = print(ps3.get_name())
#print(joyName)

ps3.init()

def control(spip):
 gate=0.1
 sender=udp_client.SimpleUDPClient(spip, 4560) #sender set up for specified IP

 while True:
    try:
        #print("ps3.py: Python ps3-> OSC interface")
        #print ("Specify external Sonic Pi with  ./ps3.py --sp [SP3 IP ADDRESS] on command line")
        #print("For local Sonic Pi 3 just use ./ps3.py")
        print("Running...")
        print ("Ctrl-C to exit")

        pygame.event.pump()
        lud=ps3.get_axis(1)
        llr=ps3.get_axis(0)
        rud=ps3.get_axis(3)
        rlr=ps3.get_axis(2)

        if abs(rud) > gate:
            sender.send_message('/rud',-rud)
        if abs(lud) > gate:
            sender.send_message('/lud',-lud)
        if abs(rlr) > gate:
            sender.send_message('/rlr',rlr)
        if abs(llr) > gate:
            sender.send_message('/llr',llr)


        b0=ps3.get_button(0)
        if b0>0:
            sender.send_message('/b0',b0)
        b1=ps3.get_button(1)
        if b1>0:
            sender.send_message('/b1',b1)
        b2=ps3.get_button(2)
        if b2>0:
            sender.send_message('/b2',b2)
        b3=ps3.get_button(3)
        if b3>0:
            sender.send_message('/b3',b3)
        b4=ps3.get_button(4)
        if b4>0:
            sender.send_message('/b4',b4)
        b5=ps3.get_button(5)
        if b5>0:
            sender.send_message('/b5',b5)
        b6=ps3.get_button(6)
        if b6>0:
            sender.send_message('/b6',b6)
        b7=ps3.get_button(7)
        if b7>0:
            sender.send_message('/b7',b7)
        b8=ps3.get_button(8)
        if b8>0:
            sender.send_message('/b8',b8)
        b9=ps3.get_button(9)
        if b9>0:
            sender.send_message('/b9',b9)


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
    print("Sonic Pi on ip ",spip)
    sleep(2)
    control(spip)
