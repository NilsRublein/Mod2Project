
//Class to trigger sound effects based on the out put of piezoeletric sensors

class TriggerSound {
//Variables for sensors, threshholds and (different kinds of) sample packs  
  SoundFile file; 
  SoundFile file2;
  int sensor;
  String sample;
  String sample2;
  int threshhold;
  boolean nextSample = false;



//explanation on PApplet p
//We need access to the PApplet instance that is automatically created for us in our Processing sketch.
//When we're in another class, the 'this' keyword refers to the instance of that class, not the sketch's PApplet instance.

  TriggerSound(int tempSensor, String tempSample, String tempSample2, PApplet p, int tempThreshhold) {    //constructor

    sensor = tempSensor;
    sample = tempSample;
    sample2 = tempSample2;
    threshhold = tempThreshhold;
    file = new SoundFile(p, tempSample);
    file2 = new SoundFile(p, tempSample2);
  }

  void play() {

    arduino.analogRead(sensor);                //read and print the output of the sensors
    println(arduino.analogRead(sensor));


    //if the output is higher then our threshhold and the boolean nextSample is false, play sample 1 and the change the boolean to true;
    // if you then tap at the same sensor again, you will play sample 2 and reset the boolean to false
    
    if (arduino.analogRead(sensor) > threshhold && nextSample == false) {  //if the output is higher then our threshhold and the boolean nextSample is false
      file.play();
      delay(100);
      nextSample = true;
    } else if ( arduino.analogRead(sensor) > threshhold && nextSample == true) {
      file2.play();
      delay(100);
      nextSample = !nextSample;
    }
  }
}