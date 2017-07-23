// Class for the pyramids that float in space
class Pyramid {
  // Z position of "spawn" and maximum position Z
  float startingZ = -10000;
  float maxZ = 1000;

  // Position values
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;

  //Constructor
  Pyramid() {
    // Show the pyramid at a random place
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);

    // Give the pyramid a random rotation
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }

  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Selection of the color, opacity determined by the intensity (volume of the strip)
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*5);
    fill(displayColor, 255);

    // Color lines, they disappear with the individual intensity of the pyramid
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));

    // Creating a transformation matrix to perform rotations, enlargements
    pushMatrix();

    //Shifting
    translate(x, y, z);

    // Calculate the rotation according to the intensity for the pyramid
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);

    // Application of rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);

    // Creation of the box, variable size according to the intensity for the pyramid
    drawPyramid(70+(intensity/2));


    // Application of the matrix
    popMatrix();

    // Move Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));

    // Replace the box in the rear when it is no longer visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}

void drawPyramid(float t) {

  //programming the 4 sides of a pyramid
  //side 1
  beginShape(TRIANGLES);
  vertex(-t, -t, -t);
  vertex(t, -t, -t);
  vertex(0, 0, t);

  //side 2
  vertex(t, -t, -t);
  vertex(t, t, -t);
  vertex(0, 0, t);

  //side 3 
  vertex(t, t, -t);
  vertex(-t, t, -t);
  vertex(0, 0, t);

  //side 4
  vertex(-t, t, -t);
  vertex(-t, -t, -t);
  vertex(0, 0, t);
  endShape();

  //bottom side
  pushMatrix();
  translate(0, 0, -t);
  rectMode(CENTER);
  rect(0, 0, 2*t, 2*t);
  popMatrix();
}