**DIGM 5070 – Interactive Performance and the Electro-Acoustic Orchestra  
**
**Student**: Jevonne Peters

**Submission Note:**: *The following includes my report from the week before, which was initially submitted as part of the a GitHub link, albeit somewhat buried.* 

---

### Week 4 Report –  Preclass Notes


My Autonomous Orchestra Performer (AOP) this week uses Processing js, Sonic PI, NexusUI, OSC, and Drum RNN to make a generated soundscape is controlled by the sound emitted by the environment.

Currently, there are problems with feedback as expected, hence I will need a cable for line in, and have processing calculate the amp from there.

For now, I will be testing the system using headphones. 

My goal this class, is to make sure my system will blend into the soundscape of the class. I will be participating, but as a silent member of the orchestra until I can manage the tweaks. Some tweaks I already know I want:

 - I need a quick mute in Processing, a visualisation that it is sending, a print out of the amp value being send in processing.
 
 - In NexusUI, I need a quicker way to start up the sending, a single button that selects a kit and generates a pattern and sends both the original and generated pattern along with the kit selected - a quick boot after making a pattern. I also want a quick generate button for the original pattern.
 
- In Sonic Pi, I want to reduce the log outputs.

Other things to do
- [ ] Fix the documentation of the project, including the diagram of the various parts and how they communicate with each other.
- [ ] After this first class run, write a review of how my performer worked.
	- [ ] Did the sounds blend, which sounds in the soundscape kit should I use?
	- [ ] Do I need to adjust the volumes?
	- [ ] Can it pick up the sound well?
	- [ ] Is it overbearing?
	- [ ] What other tweaks are needed?
	- [ ] How can I fix the UI (Both Processing and the NexasUI) to make start up and control easier to manage
	- [ ] What other controls do I need? 


---

### Week 5 Report – Preclass Notes

I missed last week's class as I was ill. However, I made some improvements on my rig from the previous week, and observations from the class before. 

I've been working on experiments to pull inputs from a local network. From previous discussion with the professor, this is one possible solution that I could use as an input for the AOP. 

Other things to look into based on the in class exercise: polyrhythms and varying the beat duration of the instrument involved in the sound produced to create for interesting overlays in sound. For now these are mere sketches, scribbles and ideas as I was not able to perform the preliminary tests to determine the appropriate direction.

I also updated the documented of this project. (See Below)

In my **TECH** research: I looked into some of the new functionalities that NEXUS had to see what I could utilise for my implementation, and https://www.collab-hub.io/ which was suggested by Prof Doug.

In **HARDWARE** research: I purchased both a 3.5mm to Dual 1/4 Inch Cable 1/8" TRS to 2 6.35mm TS Mono Y Splitter Male to Male , and a single of the same type. I also researched macropads and way to build my own macropad by repurposing a USB numpad and using Karabiner on Mac. 

IN **LITERATURE** research: I started reading  "***Listening to noise and silence: Towards a philosophy of sound art***" by Salome Voegelin (2010). Bloomsbury Publishing USA. Its chapters titled: “Listening”, “Noise”, “Silence”, “Time and Space”, and “Now”, correlate beautifully with what I am trying to do with this AOP. 

---

## Updated Project Documentation


### Autonomous Orchestra Performer

A GUI that uses Magenta Drum RNN to create and generate patterns to send to Sonic Pi via OSC.

### I. Objective
The aim is to create a performer within the class' acoustic electronic orchestra, that can perform autonomously, and harmoniously. This is a non-deterministic, generative, aleatoric, autonomous, interactive musical performer. 

### II. Rationale
The idea is to demonstrate, and experiment with, the idea of influence. This instrument is a representation of an individual that is fully and completely influenced by the actions of the those surrounding it. As a subject within the environment, it demonstrates a desire to conform, even when presented with opportunities to branch out. In this case, this is a very desirable trait as it lends to beautiful music.

This performer, acts as a responder, and I do not anticipate it taking lead within the orchestra. Other players, however, end up being influenced by its actions. The performer is both influence and acts by chance similar to aleatoric music.


### III. Approach

#### A. High Level Steps
Step 1 - Input live sound data through line-in or microphone.
Step 2 - Process the live data through a series of algorithms to determine a) how loud to play and b) what to play. Output as variables.  
Step 3 - Use the output variables to produce synthesised sound.

#### B. Libraries and Tools
- All created sounds and timing are handled in **[Sonic Pi]**(https://sonic-pi.net/).
- **Processing.js** assesses the sound in the room which determines how loud Sonic.Pi plays through OSC messagin.
- A **interactive GUI** provides an accessible way to engage with Machine learning, and shows a visual representations of the generated beat patterns that Sonic.Pi will play to. Machine learning is used to generate patterns. The graphic user interface is a mix of HTML, CSS and [NexusUI](https://nexus-js.github.io/ui/)
- This project uses the **p5js-OSC** library (by [Gene Kogan](https://github.com/genekogan/p5js-osc)) to handle the OSC messaging between the GUI and Sonic Pi.

### IV. Testing 
Testing will be done with using the videos of previous iterations of this class in concert, to simulate a sound environment. I will also make use of the weekly class practices. 

Testing is to guarantee two conditions:
1. The performer blends in harmoniously when there will be sound
2. The performer is silent when there is no sound.

### V. Running the Code
1. Start **p5js**-osc in terminal
2. Using **Brackets**, create local server and launch the **GUI** in browser.
3.  Open and run the **Processing.js** sketch.
4. Open and run Sonic.Pi
5. Select soundscape kit using drop down menu
6. Enter  soundscape in **Original Pattern** Grid then press **send**
7. Generate a soundscape and press **send**



**Note:** You will not hear any sounds until you have chosen a soundscape kit and have sent at least one pattern from the GUI.