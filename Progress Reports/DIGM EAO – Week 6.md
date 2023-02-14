**DIGM 5070 – Interactive Performance and the Electro-Acoustic Orchestra  
**
**Student**: Jevonne Peters

**Code Link:**: https://github.com/jevi-me/eao

---

### Week 6 Report  (Feb 7)

#### In Class ~ Stream of Thoughts 
Today I up picked on the gestures that will be used in class. I found a few shortcomings in my system. For example, I did not account for gestures and instructions to improvise, pointalise, sustain, make a sound when pointed at, density, tone, relate, with, fade out, and volume.

To address, this I spent the class observing the orchestra, and designing a new orchestra player that could work with what the system wants. For now, I will be manually interpreting these instructions through the UI I will create with NEXUS. In my system, I will have to act as an interface to provide input to the AOP. Translating each of the gestures or set of gestures to a button/set of buttons that will be pressed.  

~~Later I can see, if I can link the gesture interpretation tool to my system, or pull from https://dispersionreceiver.b4a.app/~~   (Idea scrapped based on Key Observations below)

&rarr; **Key Observations** 
The directions on the receiver are in natural language, and may be parsed over many lines, and includes humour! :). Natural language processing is not be a good option. 

&rarr; **Decisions**
~~The best solution is to join the orchestra myself. The AOP will be *relating* to me. AOP and I are Group 5.~~ Project ultimately abandoned, and replaced with backup plan.

&rarr; **Sample of Scribbled Notes**
![[Screenshot 2023-02-12 at 9.00.05 PM.png]]

&rarr; **Sample of directions**
dispersion.caster.receiver

d: //,,,
d: ./
d: //
d: ///
d: ok lets have thet whole group move towards more sparse over 60 seconds
d: G4 relate to G3
d: G1+G2 go NOW
d: ,
d: G1+G2 prepare sudden entry with noise......but wait a moment
d: i meant g4
d: G3
d: not G#
d: G1,G2,G3 fade out for now
d: G1 and G2 vary density between very sparse and med sparse
d: G3 transition to relate to processing
d: whole group: transition to medium-dense pointillism over 60 seconds
d: group keep it up..
d: whole
d: OK whole group, keep improvising off of this, relate to the whole group
d: G2 can you get slightly louder?
d: fade in
d: G1 come back in, relate to G4
d: G3 acoustic relate to G4

---
#### Summary of Code Updates

**In Version 3**: I tried to accomplish this using Tone.js and NexusUI to reduce the osc communications that would be needed between the myself and the AOP. I got a functioning prototype. Success is attainable, but ultimately decided to abandon the project. 
![[Screenshot 2023-02-13 at 5.55.12 AM.png]]

**For Version 4**: Using what I observed on how the orchestra is conducted and works together, I reverted to the backup project plan stated in week 2 proposal, Player/Player which would be a better fit. Project works!

&rarr; **Quick Notes**
- Controller used is the Tremon Gamepad. (PS4, and Logitech controllers were tried without success.)
- Mapping is directed related to the common commands from the conductor.

![[tremon-usb-joypad-800x800-3954157190.jpeg]]
![[Screenshot 2023-02-13 at 7.56.45 PM.png]]