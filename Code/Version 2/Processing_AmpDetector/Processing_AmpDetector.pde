import netP5.*;
import oscP5.*;
import processing.sound.*;

/* Connection Variables*/
OscP5 oscP5;
NetAddress myRemoteLocation;
  int timed;


/* Sound variable */
Amplitude amp;
AudioIn in;

void setup () {
  /*Connection Setup*/
  oscP5 = new OscP5(this,4560);
  myRemoteLocation = new NetAddress("127.0.0.1",4560);


  /* Sound Setup*/
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
}

void draw() {

   if( millis() > timed ){
      timed = millis() + 500; 
  OscMessage myMessage = new OscMessage("/wek7/outputs");
  myMessage.add(floor(amp.analyze()*100));
  
  /* invio messaggio */
  oscP5.send(myMessage,myRemoteLocation);
   }

/*print 
println (floor(amp.analyze()*100));*/
}
