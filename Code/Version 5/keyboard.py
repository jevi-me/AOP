#!/usr/bin/python
# -*- coding: utf-8 -*-
# https://stackoverflow.com/questions/24072790/how-to-detect-key-presses
# https://www.rapidtables.com/code/text/ascii-table.html?viewsel=on

import sys
import tty
import os
import termios
import subprocess
from pythonosc import osc_message_builder
from pythonosc import udp_client
import argparse
from time import sleep

gate = 0.1
spip = '10.0.0.240' #Change me
sender = udp_client.SimpleUDPClient(spip, 4560)  # sender set up for specified IP
print(">>> Note: IP address is hardcoded. Be sure to change.")

def getkey():
    old_settings = termios.tcgetattr(sys.stdin)
    tty.setcbreak(sys.stdin.fileno())
    try:
        while True:
            b = os.read(sys.stdin.fileno(), 3).decode()
            if len(b) == 3:
                k = ord(b[2])
            else:
                k = ord(b)
            key_mapping = {
                127: 'backspace',
                10: 'return',
                32: 'space',
                9: 'tab',
                27: 'esc',
                65: 'up',
                66: 'down',
                67: 'right',
                68: 'left'
            }
            return key_mapping.get(k, chr(k))
    finally:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)
try:
    while True:
        k = getkey()
        if k == 'esc':
            quit()
        else:
            sender.send_message('/key', k)

except (KeyboardInterrupt, SystemExit):
    os.system('stty sane')
    print('stopping.')