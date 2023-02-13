#### Jevonne Peters 

## Proposal: Autonomous Orchestra Performer

### I. Objective
The aim is to create a performer within the class' acoustic electronic orchestra, that can perform autonomously, and harmoniously. This is a non-deterministic, generative, aleatoric, autonomous, interactive musical performer. 

---

### II. Rationale
The idea is to demonstrate, and experiment with, the idea of influence. This instrument is a representation of an individual that is fully and completely influenced by the actions of the those surrounding it. As a subject within the environment, it demonstrates a desire to conform, even when presented with opportunities to branch out. In this case, this is a very desirable trait as it lends to beautiful music.

This performer, acts as a responder, and I do not anticipate it taking lead within the orchestra. Other players, however, end up being influenced by its actions. The performer is both influence and acts by chance similar to aleatoric music.

---

### III. Approach
#### A. System & Input data
Option 1) **Sonic Pi**'s line-in and/or OSC on local network
Option 2) **Max MSP** line-in and/or local network

For local network, will need to collaborate with at least 5 other performers to get their local IP address. As an initial approach, I intend to use the line-in (or microphone) as the input.

#### B. Steps
Step 1 - Input live sound data through line-in or microphone
Step 2 - Process the live data through an algorithm that I will develop
Step 3 - Use the output data to produce synthesised sound

#### C. Input 
The key inputs, I will be extracting live from the environment, will be pitch and amp. That is, what note is being played, and how loudly (from silence to full blast). Using that, I should be able to have it play a sound or melody at an appropriate time, and at an appropriate volume. This input will feed the processing algorithm.

The main sound input will be the sound made my the orchestra, but the input also includes the orchestra's surrounding space, and the soundscape of that space.

Later, more inputs could be included to help with decision making. 

#### D. Algorithm
The algorithm will take in the input (pitch and amp), and through loops, ring, choose, look, seeds, random generators, and probability calculations, it will decide whether to make a sound, and what type of sound to make.

It will choose to be silent more often than it will choose to make a sound. The sound would match the amplitude of the sound that is fed in, so its participation doesn't overpower the orchestra.

To ensure it is melodic, the pitch will be processed. It may return the same pitch, or a harmoniously-linked pitch. 

If using Max MSP, this will be done using a trained neural network. In Sonic Pi, a simulation of a neural network will be made. 

#### E. Sound Synthesis
I will be use imported wav sounds, in addition to the built-in sound pi suite of synths and sound FX. The choice of sound will be randomised, and based on the input data.

It could also randomly delay its response to the stimulus, however, in the event that it is delayed, if there is silence, or sound at a lower volume, that will overpower the delayed decision. The length of the response could also be randomised.
 
To aid with making the generative sound produced is aesthetic, I will be implementing some melodic math.

---
 
### IV. Testing 
Testing will be done with using the videos of previous iterations of this class in concert, to simulate a sound environment. I will also make use of the weekly class practices. 

I will be testing to make sure 
1. The performer blends in harmoniously when there will be sound
2. Is silent when there is no sound. 

---

### V. Considerations and Possible Issues

When making the algorithm and sound synthesis, I will need to take the following into consideration:
1. Picking up (too much) non-orchestra background noise
2. Cutting off sustained sound. Limiting length of response
3. Audio feedback
4. Determining a threshold for what is "silence".
5. I anticipate a bit of a learning curve, as I have never worked with Sonic Pi or Max MSP before, but I have done sufficient research, and designed a backup proposal (titled "Player/Player") incase this plan fails or I run into too many difficulties. 

---

### VI. Artistic & Scholarly Research
Below are excerpts of works that are relevant and related to this project

**A. In C, by Terry Riley** 
**Links:** https://en.wikipedia.org/wiki/In_C ; https://www.youtube.com/watch?v=DpYBhX0UH04
**Relevance:** an example of aleatoric music in a 
**Summary:** "_In C_ consists of 53 short numbered musical phrases, lasting from half a beat to 32 beats; each phrase may be repeated an arbitrary number of times at the discretion of each [musician](https://en.wikipedia.org/wiki/Musician "Musician") in the ensemble. Each musician thus has control over which phrase they play, and players are encouraged to play the phrases starting at different times, even if they are playing the same phrase. In this way, although the melodic content of each part is predetermined, _In C_ has elements of [aleatoric music](https://en.wikipedia.org/wiki/Aleatoric_music "Aleatoric music") to it."



**B. Joseph Nechvatal's Viral symphOny**
**Link**: https://continuo.wordpress.com/2009/01/16/joseph-nechvatal-viral-symphony-complete/
**Relevance:** An example of using code within an symphony.
**Summary**: "viral symphOny is a collaborative electronic [noise music](https://en.wikipedia.org/wiki/Noise_music "Noise music") symphony created by the [postconceptual](https://en.wikipedia.org/wiki/Postconceptual "Postconceptual") artist [Joseph Nechvatal](https://en.wikipedia.org/wiki/Joseph_Nechvatal "Joseph Nechvatal").[[1]](https://en.wikipedia.org/wiki/Viral_symphOny#cite_note-1)[[2]](https://en.wikipedia.org/wiki/Viral_symphOny#cite_note-2) It was created between the years 2006 and 2008 using custom [artificial life](https://en.wikipedia.org/wiki/Artificial_life "Artificial life") C++ [software](https://en.wikipedia.org/wiki/Software "Software") based on the [viral phenomenon](https://en.wikipedia.org/wiki/Viral_phenomenon "Viral phenomenon") model."



**C. Steve Reich, "Music for 18 Musicians"**
**Link:** https://www.youtube.com/watch?v=ZXJWO2FQ16c
**Relevance:** An example of simple melodies and loops. 


**D.** Voegelin, S. (2010). _Listening to noise and silence: Towards a philosophy of sound art_. Bloomsbury Publishing USA.

**E.** Xenakis, Iannis. Formalized music: thought and mathematics in composition (rev. ed). Pendragon Press, 1992. [​](http://dispersionlab.org/14-LMJ_a_00965_van%20Nort-web.pdf)[Xenakis – Formalized Music  
](https://monoskop.org/images/7/74/Xenakis_Iannis_Formalized_Music_Thought_and_Mathematics_in_Composition.pdf)

**F.** Ryan, J. (1991). Some remarks on musical instrument design at STEIM. _Contemporary music review_, _6_(1), 3-17.


---

### VII. Technical Research

**Machine Learning & Neural Networks**
https://towardsdatascience.com/making-music-with-machine-learning-908ff1b57636
https://www.flucoma.org/
https://learn.flucoma.org/learn/regression-neural-network
[youtube.com/watch?v=XfNZzQPdPG0](youtube.com/watch?v=XfNZzQPdPG0)
[youtube.com/watch?v=yGWMSkaCoS0&list=PLU-my99CRHU3ZAUwkD-do_1yTJr9WD-y9](youtube.com/watch?v=yGWMSkaCoS0&list=PLU-my99CRHU3ZAUwkD-do_1yTJr9WD-y9)

**Samples**
https://www.youtube.com/watch?v=3eLo8qORiMQ
Envato
https://in-thread.sonic-pi.net/t/generative-melodies/5698/2
http://synth.is
https://freesound.org

**Receiving OSC**
https://github.com/sonic-pi-net/sonic-pi/blob/dev/etc/doc/tutorial/12.1-Receiving-OSC.md
https://github.com/sonic-pi-net/sonic-pi/blob/dev/etc/doc/tutorial/12.1-Receiving-OSC.mdOSC 
https://hexler.net/touchosc

**Using Mics**
[youtube.com/watch?v=oRB561XNSIM](youtube.com/watch?v=oRB561XNSIM)

**Syncing**
https://in-thread.sonic-pi.net/t/midi-in-issues-real-time-sync-of-cc-values-not-working/2199

**Touch OSC**
https://hexler.net/touchosc

**Books**
McLean, A., & Dean, R. T. (Eds.). (2018). _The Oxford handbook of algorithmic music_. Oxford University Press.

Manzo, Vincent J. Max/MSP/Jitter for Music: A Practical Guide to Developing Interactive Music Systems for Education and More. Oxford University Press, 2016.

---

#### Keywords
live rule-based computer composition, generative sound, neural networks, machine learning, generative music, acoustic sound, influence, society, algorithms, aleatoric music, non-deterministic


### VIII. Backup Plan
In the event that I run into too many difficulties, my alternative proposal is titled "Player/Player", and uses a game controller as part of an interactive instrument that allows me to perform within the ensemble.



