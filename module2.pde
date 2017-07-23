/*End of module 2 Assignment for Physical Computing, Creative Technology, University Twente

 This programm has 2 tasks: 
 1). Make 3 animations to any song ( song needs to be in the data folder an then loaded in the setup)
 We looked for many sources of inspiration and got a lot of help from this source url https://github.com/samuellapointe/ProcessingCubes by samuellapointe. 
 In order for us to make sense out of it, we had to translate the example code from French to English and modiﬁed it to our needs.
 
 2). Trigger soundsamples via piezo-electric sensors and arduino ( See the class "TriggerSound"). 
 We use Firmata as a protocol system to communicate between processing and the Arduino IDE.

 by John Kim and Nils Rublein
 11.01.2017
 */

import processing.sound.*;       //import librabies for sound and for communication between Arduino and Processing
import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;

Arduino arduino;                

// sensor objects
TriggerSound soundKit;            
TriggerSound soundKit1;
TriggerSound soundKit2;
TriggerSound soundKit3;
TriggerSound soundKit4;
TriggerSound soundKit5;
TriggerSound soundKit6;
TriggerSound soundKit7;
TriggerSound soundKit8;

                          
int threshhold = 500;       //Threshholds for the sensors
int threshhold3 = 1000;     //some sensors aren't as sensitive as the others and need therefore special threshholds
int threshhold8 = 20;

String soundSample0;       // 2 samples for each sensor-button, *sensornumber*+1 is the second sample
String soundSample01;      // with the first the tap on the sensor you trigger the first sample, if you tap it again,  
String soundSample1;       // it plays the second sample and resets afterwards
String soundSample11;
String soundSample2;
String soundSample21;
String soundSample3;
String soundSample31;
String soundSample4;
String soundSample41;
String soundSample5;
String soundSample51;
String soundSample6;
String soundSample61;
String soundSample7;
String soundSample71;
String soundSample8;
String soundSample81;

/////////////////////////////////////////////////////////////////////////////////////////////
//The following variables are used for the 3D visuals
////////////////////////////////////////////////////////////////////////////////////////////
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;

ddf.minim.analysis.FFT fft;  //using the full path of the library due to FFT fft being ambiguous

/*FFT stands for Fast Fourier Transform, which is a method of analyzing audio that allows you to visualize 
 the frequency content of a signal. e.g visualizations in music players and car stereos*/

// Variables that define the "areas" of the spectrum
// For example, for bass, one takes only the first 4% of the total spectrum
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// This leaves 64% of the possible spectrum left unused.
// These values are usually too high for the human ear anyway.

// Scoring values for each zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Previous values, to soften the reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Softening value
float scoreDecreaseRate = 25;

// Cubes that appear in space
int nbPyramids;
Pyramid[] pyramids;

// Lines that appear on the sides
int nbWalls = 500;
Wall[] walls;

///////////////////////////////////////////////////////////////////////////////////////////
//end of the global variables for the 3D visuals
///////////////////////////////////////////////////////////////////////////////////////////



void setup() {
  fullScreen(P3D);

  // Check available serial ports and print in the serial monitor
  println("Available serial ports:");
  for (int i = 0; i<Serial.list ().length; i++) { 
    print("[" + i + "] ");
    println(Serial.list()[i]);
  }

  //write number of the port inside the array 
  arduino = new Arduino(this, Arduino.list()[0], 57600);  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);

  loadSampleKits();

  soundKit = new TriggerSound(0, soundSample0, soundSample01, this, threshhold);                //load samples for each sensor
  soundKit1 = new TriggerSound(1, soundSample1, soundSample11, this, threshhold);
  soundKit2 = new TriggerSound(2, soundSample2, soundSample21, this, threshhold);
  soundKit3 = new TriggerSound(3, soundSample3, soundSample31, this, threshhold3);
  soundKit4 = new TriggerSound(4, soundSample4, soundSample41, this, threshhold);
  soundKit5 = new TriggerSound(5, soundSample5, soundSample51, this, threshhold);
  soundKit6 = new TriggerSound(6, soundSample6, soundSample61, this, threshhold);
  soundKit7 = new TriggerSound(7, soundSample7, soundSample71, this, threshhold);
  soundKit8 = new TriggerSound(8, soundSample8, soundSample81, this, threshhold8);


  //////////////////////////////////////////////////////////////////////////////////////////////
  //The following is code for the 3D visuals that uses the minim library.
  //////////////////////////////////////////////////////////////////////////////////////////////

  // Loading the minim library
  minim = new Minim(this);

  //loading song
  song = minim.loadFile("daftpunk.mp3");

  // Create the FFT object to analyze the song
  fft = new ddf.minim.analysis.FFT(song.bufferSize(), song.sampleRate());

  // One pyramid per frequency band
  nbPyramids = (int)(fft.specSize()*specHi);
  pyramids = new Pyramid[nbPyramids];

  // As many walls as we want
  walls = new Wall[nbWalls];

  // Creating all objects
  // Creating pyramid objects
  for (int i = 0; i < nbPyramids; i++) {
    pyramids[i] = new Pyramid();
  }

  // Creating wall objects
  // Left Wall
  for (int i = 0; i < nbWalls; i+=4) {
    walls[i] = new Wall(0, height/2, 10, height);
  }

  //Right Wall
  for (int i = 1; i < nbWalls; i+=4) {
    walls[i] = new Wall(width, height/2, 10, height);
  }

  //Bottom Wall
  for (int i = 2; i < nbWalls; i+=4) {
    walls[i] = new Wall(width/2, height, width, 10);
  }

  //Top Wall
  for (int i = 3; i < nbWalls; i+=4) {
    walls[i] = new Wall(width/2, 0, width, 10);
  }

  //Black background
  background(0);

  //start song
  song.play(0);

  /////////////////////////////////////////////////////////////////////////////////////  
  //end of the setup for the 3D visuals
  ////////////////////////////////////////////////////////////////////////////////////
}

void draw() {
  background(0);


  //play samples
  soundKit.play();   //play samples
  soundKit1.play();
  soundKit2.play();
  soundKit3.play();
  soundKit4.play();
  soundKit5.play();
  soundKit6.play();
  soundKit7.play();
  soundKit8.play();

  ///////////////////////////////////////////////////////////////////////////////////////
  //following code is for the draw() for 3D visuals
  //////////////////////////////////////////////////////////////////////////////////////

  // Advance the song. On draw () for each "frame" of the song ...
  fft.forward(song.mix);

  // Calculation of "scores" (power) for three categories of sound; the low(bass), mid and high sounds
  // First, to save the old values
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;

  // Reset values
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;

  // Calculate the new "scores"
  //the function getBand returns the amplitude of the given frequency band, and 'i' is the index of the frequency band
  for (int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }

  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }

  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }

  // Slow down the descent.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }

  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }

  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }

  // Volume for all frequencies at this time, with higher sounds higher.
  // This allows the animation to go faster for the more acute sounds, which are more noticeable
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;

  // Subtle background color, slight hints of red, green and blue.
  background(scoreLow/100, scoreMid/100, scoreHi/100);

  // Pyramid for each frequency band
  for (int i = 0; i < nbPyramids; i++)
  {
    // Value of the frequency band
    float bandValue = fft.getBand(i);

    // The color is represented as red for bass, green for middle sounds and blue for highs.
    // Opacity is determined by the volume of the tape and the overall volume.
    pyramids[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }

  // Wall lines, here we keep the value of the previous band and the next one to connect them together
  float previousBandValue = fft.getBand(0);

  // Distance between each line point, negative because on the dimension z
  float dist = -25;

  // Multiply the height by this constant
  float heightMult = 2;

  // For each band
  for (int i = 1; i < fft.specSize(); i++)
  {
    // The value of the frequency band, the more distant bands are multiplied so that they are more visible.
    float bandValue = fft.getBand(i)*(1 + (i/50));

    // Selection of the color according to the strengths of the different types of sounds
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i);
    strokeWeight(1 + (scoreGlobal/100));

    // Bottom left line
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i);
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i);

    // top left line
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);

    // bottom right line
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);

    //top right line
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);

    // Save the value for the next loop revolution
    previousBandValue = bandValue;
  }

  // Rectangular walls
  for (int i = 0; i < nbWalls; i++)
  {
    // A band is assigned to each wall, and its force is sent to it.
    float intensity = fft.getBand(i%((int)(fft.specSize()*specHi)));
    walls[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  }

  ////////////////////////////////////////////////////////////////////////////////////
  //end of the draw() for 3D visuals
  ////////////////////////////////////////////////////////////////////////////////////
}

void loadSampleKits() {
  //To load a sample kit, just comment the current on out and comment yours in

//daft punk sound kit
  soundSample0 = "1.wav";       
  soundSample01 = "10.wav";      
  soundSample1 = "2.wav";       
  soundSample11 = "11.wav";
  soundSample2 = "3.wav";
  soundSample21 = "13.wav";
  soundSample3 = "4.wav";
  soundSample31 = "14.wav";
  soundSample4 = "5.wav";
  soundSample41 = "15.wav";
  soundSample5 = "6.wav";
  soundSample51 = "16.wav";
  soundSample6 = "7.wav";
  soundSample61 = "7.wav";
  soundSample7 = "8.wav";
  soundSample71 = "8.wav";
  soundSample8 = "9.wav";
  soundSample81 = "9.wav";

  /*
  //a normal drum sound kit
      soundSample0 = "kick.mp3";       
   soundSample01 = "kick.mp3";      
   soundSample1 = "snare.mp3";       
   soundSample11 = "snare.mp3" ;
   soundSample2 = "hihat.mp3";
   soundSample21 = "hihat.mp3";
   soundSample3 = "crash.mp3";
   soundSample31 = "crash.mp3";
   soundSample4 = "clap.mp3";
   soundSample41 = "clap.mp3";
   soundSample5 = "maracas.mp3";
   soundSample51 = "maracas.mp3";
   soundSample6 = "cowbell.mp3";
   soundSample61 = "cowbell.mp3";
   soundSample7 = "rimshot.mp3";
   soundSample71 = "rimshot.mp3";
   soundSample8 = "rimshot.mp3";
   soundSample81 = "rimshot.mp3";
   */

  /*
  // a dank meme sound kit
      soundSample0 = "2SAD4ME.mp3";       
   soundSample01 = "2SAD4ME.mp3"; 
   soundSample1 = "AIRHORN.mp3";       
   soundSample11 = "AIRHORN.mp3";
   soundSample2 = "HITMARKER.mp3";
   soundSample21 = "HITMARKER.mp3";
   soundSample3 = "Oh Baby A Triple.mp3";
   soundSample31 = "Oh Baby A Triple.mp3";
   soundSample4 = "SPOOKY";
   soundSample41 = "SPOOKY";
   soundSample5 = "SANIC.mp3";
   soundSample51 = "SANIC.mp3";
   soundSample6  = "OMG TRICKSHOT CHILD.mp3";
   soundSample61 = "OMG TRICKSHOT CHILD.mp3";
   soundSample7 = "SMOKE WEEK EVERYDAY.mp3";
   soundSample71 = "SMOKE WEEK EVERYDAY.mp3";
   soundSample8 = "2SED4AIRHORN.mp3";
   soundSample81 = "2SED4AIRHORN.mp3";
   */
}