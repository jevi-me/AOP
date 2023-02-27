<pre> 
             ..                          ..
          .''..''.      .--~~--.      .``..``.
         .:''     `----'        `----'     ``:.
         |       .    ( * )  ( * )    .       |
        .' ....   `.  L1/L2  R1/R2  .'     _  `.
       : .;\  /;.  :  ( * )  ( * )  :   _ (B) _ :
      :  :) () (:   :              :   (A) _ (D) :
       : `:/  \:'  :       B        :     (C)   :
        :  ''''   .'   A ( * ) D    `.         :
       .'        '   ( * ) C ( * )    `        `.
      .'        .''.     ( * )      .``.        `.
    .'        .'   `. (o)      (o) .'   `.        `.
   .'       .'      `.   1(* )2   .'      `.       `.
 .'       .'         `............'         `.       `.
 `.      .' 	     PLAYER/PLAYER             `.      .'
   `....'              by Jevi                   `....'

</pre>
# Player/Player

Uses a game controller as part of an interactive instrument that allows me to perform within the ensemble.


## Latest Progress - Verison 5
#### Major Additions:
 - Added 3 extra modes.
 - Code update for changing modes using the keyboard. Also built-in space to allow for the keyboard to do trigger other things down the line.
 - Added a multimedia controller to the mix which has a button for volume control and quick mute. 


#### System Sound
Mode 1: Choose from 8 synths three-note-chords at 3 different pitches = 24 unique sounds
Mode 2: Choose from 4 electronic single note sounds = 4 unique sounds
Mode 3: Choose from 4 glitchy single note sounds = 4 unique sounds

Improvise/Noise: Cycles between 3 note combinations of 5 sounds, at random pitch (between 50-120), attack (between 0.0 and 1.0), release (between 0.0 and 1.0) and pan (-1, 0, 1). Injects "cnoise" instead of playing sound, once every 10 cycles.


### System Controllers
Keyboard: 
- keys 1, 2, 3: change the mode.

Game Controller: 
- buttons 1, 2, 3, 4: trigger sounds based on mode
- up/down rudder: changes synth selection (8 options)
- left/right rudder: changes pitch of one of the notes in the chord when in mode 1. 
-  two left bumpers: increase or decrease volume by 0.05
- two right bumpers: quickly set to high or low volume
- select button: quick mute
- slow button: continuous improvise/noise on or off. 
- start button: plays a burst of  improvise/noise

Vaydeer Multimedia Controller:
- volume button: turn adjust volume (with fine to coarse sensitivity control - three buttons above toggle)
- volume button: push to mute/unmute