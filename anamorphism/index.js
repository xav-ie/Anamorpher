var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

camera.position.set( 0, 0, 50);
camera.lookAt( 0, 0, 0 );

var renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );

var geometry = new THREE.BoxGeometry( 10, 10, 10 );
var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
var cube = new THREE.Mesh( geometry, material );
scene.add( cube );

var mat = new THREE.LineBasicMaterial( { color: 0x0000ff } );
var geo = new THREE.Geometry();
geo.vertices.push(new THREE.Vector3( -10, 0, 0) );
geo.vertices.push(new THREE.Vector3( 0, 10, 0) );
geo.vertices.push(new THREE.Vector3( 10, 0, 0) );
var line = new THREE.Line( geo, mat );
scene.add( line );



let mouseX = 0;
let mouseY = 0;

document.addEventListener("mousemove", function(e) {
    mouseX = e.clientX;
    mouseY = e.clientY;
});


document.addEventListener("keydown", function(e) {
    if (e.keyCode == '38') {
        camera.position.y+=1;
    }
    else if (e.keyCode == '40') {
        camera.position.y-=1;
    }
    else if (e.keyCode == '37') {
        camera.position.x-=1;
    }
    else if (e.keyCode == '39') {
        camera.position.x+=1;
    } else {
        alert(e.keyCode);
    }
});



function animate() {
	requestAnimationFrame( animate );
    cube.rotation.y +=0.01;
    cube.rotation.x +=0.01; 
    renderer.render( scene, camera );
}
animate();




