var img;
let V, P, a, b, c, r, ti, I, N, ref;
function preload() {
  img = loadImage("https://i.imgur.com/ffPsu0H.jpg");
  
}

function setup() {
  // viewer position in 3d space
  V = createVector(img.width*2,0,img.height*1.0);
  createCanvas(img.width, img.height);
  // single pixel position
  P = new ImgPixel(color(0,0,0), createVector(0,-(img.width/2), img.height));
  background(40);
  pixelDensity(1);
  img.loadPixels();
  loadPixels();
  background(50);
}

function draw() {
  calculateStuff();
  noLoop();
}

function L(t) {
//   as t goes from 0 to 1, we trace out the line segment PV
  return createVector(P.location.x+t*(V.x-P.location.x), P.location.y+t*(V.y-P.location.y), P.location.z+t*(V.z-P.location.z));
}

function R(t) {
  return p5.Vector.add(I, p5.Vector.mult(ref, t));
}

function calculateStuff () {
  
  for (var i = 0; i < img.width; i++) {
    for (var j = 0; j < img.height; j++ ) {
      // Calculate the 1D location from a 2D grid
      var loc = (i + j*img.width)*4;
      let pix = img.get(i,j);
      let colr = color(pix[0], pix[1], pix[2]);
           
      
      
      
      pixels[loc] =   colr.levels[0];
      pixels[loc+1] = colr.levels[1];
      pixels[loc+2] = colr.levels[2];
      pixels[loc+3] = 255;
      
      
      
    
    
    }
  }
  
  
  updatePixels();
}


function calcAtPoint(i,j) {
      var loc = (i + j*img.width)*4;
     
      let pix = img.get(i,j);
      let colr = color(pix[0], pix[1], pix[2]);
      // calculate pixel coordinates relative to actual coordinate grid
    
      P = new ImgPixel(colr, createVector(0,i-(img.width/2), img.height-j));
      // x^2+y^2 = r^2
      // we are deciding to make the cylinder touch tangenetially
      // to the image's right and left edges this produces:
      r = img.width/2;
      // now, sub in the x and y component parts 
      // of L(t) into x^2+y^2 = r^2
      // (px+t(vx−px))^2+ (py+t(vy−py))^2 = r^2
      // this can be put into polynomial form 
      // a*t^2 + b*t + c = r^2
      a = sq(P.location.x)+sq(P.location.y)-2*P.location.x*V.x+sq(V.x)-2*P.location.y*V.y+sq(V.y);
      b = -2*sq(P.location.x)-2*sq(P.location.y)+2*P.location.x*V.x+2*P.location.y*V.y;
      c = sq(P.location.x)+sq(P.location.y);
      // t is the "time" we plug in to find the intersection with 
      // the cylinder. However, we only care about one intersection
      // with the cylinder and the projected line, the intersection 
      // that is between 0<t<1
      // t = (-b ± sqrt(sq(b)-4a(c-sq(r)))) / 2*a
      // the way the lines have been set up, we know that 
      // we only want the positive solution for t
      // this is ti = (-b + sqrt(sq(b)-4a(c-sq(r)))) / 2*a
      // a*t^2 + b*t + (c-r^2) = 0
      // since (c-r^2) is our actual "c" in the quadratic formula,
      
      // ti = ( -b + Math.sqrt(sq(b) - 4*a*(c-sq(r))) ) / 2*a ;
      ti = (-b + sqrt( (sq(b)-4*a*(c-sq(r))) ) ) / (2 *a);
      // let I be the intersection of L(t) with the cylinder
      I = L(ti);
      // the normal vector passes through I and <0,0,I.z>
      N = p5.Vector.sub(I, createVector(0,0,I.z));
      // with V and N, we can calculate ref, which is the reflection
      // vector. 
      // downmove = (proj V onto N)
      let dm = p5.Vector.mult(N, p5.Vector.dot(N,V) / N.magSq());
      ref=p5.Vector.add(V, p5.Vector.mult(dm, 2));
      // with the reflection vector, we can now form the line
      // that reflects off the cylinder with I as a starting point
      // and ref as the multiplier
      // R(t) = I + t*ref
      // We want to find a t where the z component of R(t)=0
      // because that is where R(t) intersects with our 'paper'
      // I.z + t*ref.z =0
      let tz0 = -I.z/ref.z;
      
      
      return R(tz0);
}


class ImgPixel {
  constructor(c, l) {
    this.color = c;
    this.location = l
  }
}


function mouseClicked(){
  calcAtPoint(mouseX,mouseY);
  
}


