
# Autonomous Orchestra Performer

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