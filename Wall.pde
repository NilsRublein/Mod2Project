// Class to display the lines on the sides
class Wall {
  // Minimum and maximum position Z
  float startingZ = -10000;
  float maxZ = 50;
  
  // Position values
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructor
  Wall(float x, float y, float sizeX, float sizeY) {
    // Show the line at the specified location
    this.x = x;
    this.y = y;
    // Random Depth
    this.z = random(startingZ, maxZ);  
    
    // The size is determined because the walls on the floors have a different size than those on the sides
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  // Display function
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    // Color determined by low, medium and high sounds
    // Opacity determined by the global volume
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);
    
    // Make the lines disappear in the distance to give an illusion of fog
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    
    // First band, that which moves according to the force
    // Transformation matrix
    pushMatrix();
    
    //Shifting
    translate(x, y, z);
    
    // Enlargement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    
    // Creating the "box"
    box(1);
    popMatrix();
    
    // Second strip, the one that is always the same size
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    // Transformation matrix
    pushMatrix();
    
    //Shifting
    translate(x, y, z);
    
    // Enlargement
    scale(sizeX, sizeY, 10);
    
    // Creating the "box"
    box(1);
    popMatrix();
    
    // Move Z
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}