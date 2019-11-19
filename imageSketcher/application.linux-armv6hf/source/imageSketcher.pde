PImage img, newImg;       // The source image //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
float offsetX, offsetY;

PImage openButton, anamorpherLogo, settingsButton, saveButton, aboutButton, minimizeButton, exitButton, loadingImage;
int cell = 1; // Dimensions of each cell in the grid
int cols, rows;   // Number of columns and rows in our system
PVector V, P, I, ref, N;
PVector newImageDimensions;
float minY, maxY, minX, maxX;

int currentButton;
float xScale;

boolean loading = false;

void setup() {
  fullScreen(P3D); 
  openButton = loadImage("logos/open.svg.png");
  anamorpherLogo = loadImage("logos/anamorpherLogo.svg.png");
  settingsButton = loadImage("logos/settings.svg.png");
  saveButton = loadImage("logos/save.svg.png");
  aboutButton = loadImage("logos/about.svg.png");
  minimizeButton = loadImage("logos/minimize.svg.png");
  exitButton = loadImage("logos/exit.svg.png");
  loadingImage = loadImage("logos/loading.svg.png");
  currentButton = 0;
  xScale = width/14; // I am basing the placing of the logos on a 14-column layout
  anamorphImage("samples/tree.jpeg"); // this is a default image
}

void anamorphImage(String filePath) {
  background(0);
  img  = loadImage(filePath); // Load the default image
  V = new PVector(img.width*1.15, 0, img.height*2.55);
  P = new PVector(0, -(img.width / 2), img.height); // "starting position"
  I = L(0); 
  ref = new PVector(0, 0, 0);
  N = new PVector(0, 0, 0);
  minY = findMinY(img.width, img.height); 
  maxY = findMaxY(img.width, img.height);
  minX = findMinX(img.width, img.height);
  maxX = findMaxX(img.width, img.height);

  println("minX: "+minX+", maxX: "+maxX);
  println("minY: "+minY+", maxY: "+maxY);
  newImg = createImage((int)(maxX-minX), (int)(maxY-minY), ARGB);


  cols = img.width/cell;             // Calculate # of columns
  rows = img.height/cell;            // Calculate # of rows
  println("newImgDimensions: ("+newImg.width+", "+newImg.height+")");
  for (int i=0; i<newImg.width; i++) {
    for (int j=0; j<newImg.height; j++) {
      newImg.pixels[(int)(i+j*newImg.width)] = color(0, 0, 0, 0); // make all pixels transparent
    }
  }
  calculatePixels();

  //drawLines();
  image(newImg, offsetX, offsetY);
}


void draw() {
  background(30);
  //drawLines();

  imageMode(CENTER);

  if (newImg.height>height-xScale) {
    float ratio = newImg.height/(height-xScale);
    image(newImg, width/2, height/2+xScale/2, img.width/ratio, height-xScale);
  } else if (newImg.width>width) {
    float ratio = newImg.width/width;
    image(newImg, width/2, height/2+xScale/2, width, img.height/ratio);
  } else {
    image(newImg, width/2, height/2+xScale/2);
  }

  imageMode(CORNER);
  //image(openImg, 0,0,50,50);

  noStroke();
  fill(100);
  rect(0, 0, width, xScale); 
  highlightButtons();
  image(openButton, 0, 0, xScale, xScale);
  image(anamorpherLogo, xScale, 0, xScale*3, xScale);
  image(settingsButton, xScale*10, 0, xScale, xScale);
  image(saveButton, xScale*11, 0, xScale, xScale);
  image(aboutButton, xScale*12, 0, xScale, xScale);
  image(exitButton, xScale*13, 0, xScale, xScale);

  if (loading) {
    fill(255);
    rect(width/2-xScale*1.5, height/2, xScale*3, xScale);
    image(loadingImage, width/2-xScale*1.5, height/2, xScale*3, xScale);
  }
}

void mouseMoved() {
  if (mouseY<xScale) {
    if (mouseX<xScale) { // openButton
      currentButton = 1;
    } else if (mouseY<xScale && mouseX>xScale*10 && mouseX<xScale*11) { // settingsButton
      currentButton = 2;
    } else if (mouseY<xScale && mouseX>xScale*11 && mouseX<xScale*12) {// saveButton
      currentButton = 3;
    } else if (mouseY<xScale && mouseX>xScale*12 && mouseX<xScale*13) {  // aboutButton
      currentButton = 4;
    } else if (mouseY<xScale && mouseX>xScale*13) { // exitButton
      currentButton = 5;
    } else {
      cursor(ARROW);
      currentButton = 0;
    }
  } else {
    cursor(ARROW);
    currentButton = 0;
  }
}



void highlightButtons() {
  if (currentButton==1) {
    // open file
    fill(255, 200, 120);
    rect(0, 0, xScale, xScale);
    cursor(HAND);
  } else if (currentButton==2) {
    // settings
    fill(200, 100, 200);
    rect(xScale*10, 0, xScale, xScale);
    cursor(HAND);
  } else if (currentButton==3) {
    // save image
    fill(100, 200, 200);
    rect(xScale*11, 0, xScale, xScale);
    cursor(HAND);
  } else if (currentButton==4) {
    // about
    fill(100, 200, 100);
    rect(xScale*12, 0, xScale, xScale);
    cursor(HAND);
  } else if (currentButton==5) {
    // close
    fill(200, 100, 100);
    rect(xScale*13, 0, xScale, xScale);
    cursor(HAND);
  }
}

void clickButton() {
  if (currentButton==1) {
    // open file
    selectInput("Select an image to process:", "imageSelected");
  } else if (currentButton==2) {
    // settings
    println("settings opened");
  } else if (currentButton==3) {
    // save image
    selectOutput("Select a file to write to:", "fileSelected");
  } else if (currentButton==4) {
    // about
    link("http://www.dichopter.com");
  } else if (currentButton==5) {
    // close
    exit();
  }
}


void imageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    loading=true;
    anamorphImage(selection.getAbsolutePath());
    loading=false;
  }
}

void keyReleased() {
  if (keyCode==10) {
    clickButton();
  } else if (keyCode==9) {
    currentButton= (currentButton+1)%6;
    println(currentButton);
  }
}
void mousePressed() {
  clickButton();
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    newImg.save(selection.getAbsolutePath());
    println("image saved!");
  }
}



void calculatePixels() {
  newImg.loadPixels();
  for ( int i = 0; i < cols; i++) {
    for ( int j = 0; j < rows; j++) {
      int x = i*cell + cell/2;    // x position
      int y = j*cell + cell/2;    // y position
      PVector res = calcAtPoint(x, y);
      int loc = x + y*img.width;  // Pixel array location
      color c = img.pixels[loc];  // Grab the color
      res.add(-2*res.x-minX, (newImg.height/2));
      //int newLoc = (int)(res.x+res.y*newImg.width); DO NOT MAKE THE MISTAKE OF CASTING WHOEL THING TO INT, YOU WILL GET BAD RESULTS
      int newLoc = (int)res.x + (int)res.y * newImg.width;
      try { 
        newImg.pixels[newLoc] = c;
      }
      catch (Throwable e) {
        println("oops");
      }
      //pushMatrix();
      //translate(res.x-offsetX, res.y+offsetY, 0); 
      //fill(c);
      //noStroke();
      //rectMode(CENTER);
      //rect(0, 0, cell, cell);
      //popMatrix();
    }
  }
  newImg.updatePixels();
}




void drawLines() {
  stroke(255);
  line(0, minY, width, minY);
  line(0, maxY, width, maxY);
  line(minX, 0, minX, height);
  line(maxX, 0, maxX, height);
  stroke(0, 0, 255);
  line(0, 0, width, 0);
  line(0, maxY+(maxY-minY)/2, width, maxY+(maxY-minY)/2);
  line(0, 0, 0, height);
  line(maxX-minX, 0, maxX-minX, height);
}

float findMinY(int w, int h) {
  float max = calcAtPoint(0, 0).y;
  for (int x=0; x<w; x++) {
    for (int y=0; y<h; y++) {
      if (calcAtPoint(x, y).y<max) {
        max = calcAtPoint(x, y).y;
      }
    }
  }

  return max;
}


float findMaxY(int w, int h) {
  float max = calcAtPoint(0, 0).y;
  for (int x=0; x<w; x++) {
    for (int y=0; y<h; y++) {
      if (calcAtPoint(x, y).y>max) {
        max = calcAtPoint(x, y).y;
      }
    }
  }

  return max;
}

float findMinX(int w, int h) {
  float max = calcAtPoint(0, 0).x;
  for (int x=0; x<w; x++) {
    for (int y=0; y<h; y++) {
      if (calcAtPoint(x, y).x>max) {
        max = calcAtPoint(x, y).x;
      }
    }
  }
  return -max;
}

float findMaxX(int w, int h) {
  float max = calcAtPoint(0, 0).x;
  for (int x=0; x<w; x++) {
    for (int y=0; y<h; y++) {
      if (calcAtPoint(x, y).x<max) {
        max = calcAtPoint(x, y).x;
      }
    }
  }
  return -max;
}

PVector L(float t) {
  return PVector.add(P, PVector.mult(PVector.sub(V, P), t));
}

PVector R(float t) {
  return PVector.add(I, PVector.mult(ref, t));
} 

PVector calcAtPoint(float i, float j) {
  P = new PVector(0, i-img.width/2, img.height-j);
  float r=img.width/2;
  float a = sq(P.x) + sq(P.y) - 2 * P.x * V.x + sq(V.x) - 2 * P.y * V.y + sq(V.y);
  float b = -2 * sq(P.x) - 2 * sq(P.y) + 2 * P.x * V.x + 2 * P.y * V.y;
  float c = sq(P.x) + sq(P.y);
  float ti = (-b + sqrt(sq(b) - 4 * a * (c - sq(r)))) / (2 * a);
  I = L(ti);
  N = PVector.sub(I, new PVector(0, 0, I.z));
  PVector dm = PVector.mult(N, PVector.dot(N, V) / N.magSq());
  ref = PVector.add(V, PVector.mult(dm, 2));
  float tz0 = -I.z / ref.z;
  return R(tz0);
}
