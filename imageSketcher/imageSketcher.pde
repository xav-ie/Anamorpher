PImage img, newImg;        //<>//
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
  size(800, 400, P3D); 
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
  //anamorphImage("samples/tree.jpeg"); // this is a default image
}

void anamorphImage(String filePath) {
  background(0);
  img  = loadImage(filePath); // Load the default image
  float smallestDimension = Math.min(img.width, img.height);
  V = new PVector(smallestDimension, 0, smallestDimension);
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
      newImg.pixels[(int)(i+j*newImg.width)] = color(255, 0, 0, 0); // make all pixels transparent
    }
  }
  calculatePixels();

  //drawLines();
  image(newImg, offsetX, offsetY);
}


void draw() {
  background(30);
  //drawLines();


  imageMode(CORNER);
  //image(openImg, 0,0,50,50);
  noFill();

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


  imageMode(CENTER);
  if (newImg!=null) {
    stroke(255);
    ellipse(mouseX, mouseY, img.width, img.width);
    if (newImg.height>height-xScale) {
      float ratio = newImg.height/(height-xScale);
      image(newImg, width/2, height/2+xScale/2, img.width/ratio, height-xScale);
    } else if (newImg.width>width) {
      float ratio = newImg.width/width;
      image(newImg, width/2, height/2+xScale/2, width, img.height/ratio);
    } else {
      image(newImg, width/2, height/2+xScale/2);
    }
  }
}

void mouseMoved() {
  println("mouseMoved event");
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




void imageSelected(File selection) {
  println("Yo I am here!!!!");
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());

    loading=true;
    //anamorphImage(selection.getAbsolutePath());
    //anamorphImage("samples/tree.jpeg");
    loading=false;
  }
}

void keyReleased() {
  if (keyCode==10) {
    mousePressed();
  } else if (keyCode==9) {
    currentButton= (currentButton+1)%6;
    println(currentButton);
  }
}
void mousePressed() {
  println("mousePressed event");
  selectInput("Select an image to process:", "imageSelected");
  
  //println("Hey, I got here!");
  //clickButton();
/*
  if (currentButton==1) {
    println("ayyyy here rn");
    // open file
    try {
      anamorphImage("samples/tree.jpeg");
      //selectInput("Select an image to process:", "imageSelected");
    } 
    catch (Exception e) {
      e.printStackTrace();
      println("wowowowowo");
    }
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
  }*/
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

boolean loggedDiff=false;

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
      if (x<10&&y==0) {
        PVector nextPoint = calcAtPoint(x+1, y);
        nextPoint.add(-2*nextPoint.x-minX, (newImg.height/2));
        float dist = res.dist(nextPoint);
        float scale = 1/dist;

        println("Scale:"+ scale);
      }
      if (res.x>0&&res.y>0&&res.x<newImg.width&&res.y<newImg.height) {
        int newLoc = (int)res.x + (int)res.y * newImg.width;
        if ( ((newImg.pixels[newLoc]>>24)&0XFF) == 0)
        {
          newImg.pixels[newLoc] = c;
        }
      }

      //int newLoc = (int)(res.x+res.y*newImg.width); DO NOT MAKE THE MISTAKE OF CASTING WHOEL THING TO INT, YOU WILL GET BAD RESULTS
      color red = color(255, 0, 0);
      PVector res2 = calcAtPoint(x+0.5, y);
      res2.add(-2*res2.x-minX, (newImg.height/2));
      int newLoc2 = (int)res2.x + (int)res2.y * newImg.width;

      PVector res3 = calcAtPoint(x-0.5, y);
      res3.add(-2*res3.x-minX, (newImg.height/2));
      int newLoc3 = (int)res3.x + (int)res3.y * newImg.width;


      try {
        newImg.pixels[newLoc2] = c;
      } 
      catch (Throwable e) {
        println("oops2");
      }
      try {
        newImg.pixels[newLoc3] = c;
      } 
      catch (Throwable e) {
        println("oops2");
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
  // as t goes from 0 to 1, we trace out the line segment PV
  return PVector.add(P, PVector.mult(PVector.sub(V, P), t));
  // P + (V-P)t
}

PVector R(float t) {
  // I + ref*t
  return PVector.add(I, PVector.mult(ref, t));
} 

PVector calcAtPoint(float i, float j) {
  // calculate pixel coordinates relative to actual coordinate grid
  P = new PVector(0, i-img.width/2, img.height-j); // I am centering the image on the y-z plane 
  // x^2+y^2 = r^2
  // we are deciding to make the cylinder touch tangenetially
  // to the image's right and left edges this produces:
  float r=img.width/2; 
  // now, sub in the x and y component parts
  // of L(t) into x^2+y^2 = r^2
  // (px+t(vx−px))^2+ (py+t(vy−py))^2 = r^2
  // this can be put into polynomial form
  // a*t^2 + b*t + c = r^2
  float a = sq(P.x) + sq(P.y) - 2 * P.x * V.x + sq(V.x) - 2 * P.y * V.y + sq(V.y);
  float b = -2 * sq(P.x) - 2 * sq(P.y) + 2 * P.x * V.x + 2 * P.y * V.y;
  float c = sq(P.x) + sq(P.y);
  // t = (-b ± sqrt(sq(b)-4a(c-sq(r)))) / 2*a
  // the way the lines have been set up, we know that
  // we only want the positive solution for t
  // this is ti = (-b + sqrt(sq(b)-4a(c-sq(r)))) / 2*a 
  // a*ti^2 + b*ti + (c-r^2) = 0
  // note (c-r^2) is our actual "c" in the quadratic formula,
  float ti = (-b + sqrt(sq(b) - 4 * a * (c - sq(r)))) / (2 * a);
  // let I be the intersection of L(t) with the cylinder
  I = L(ti);
  // the normal vector passes through I and <0,0,I.z>, so it can be represented as the difference
  // of these two points
  N = new PVector(I.x, I.y, 0);
  // with V and N, we can calculate ref, which is the reflection vector
  // downmove = dm = (proj V onto N)
  PVector dm = PVector.sub(PVector.mult(N, PVector.dot(N, V) / N.magSq()), V);
  // I believe this is where my math goes awry. I have a 
  ref = PVector.add(V, PVector.mult(dm, 2));
  // with the reflection vector, we can now form the line
  // that reflects off the cylinder with I as a starting point
  // and ref as the multiplier
  // R(t) = I + t*ref
  // We want to find a t where the z component of R(t)=0
  // because that is where R(t) intersects with our 'paper'
  // I.z + t*ref.z =0
  float tz0 = -I.z / ref.z;
  return R(tz0);
}
