var bouncyBugYellow;
var bouncyBugRed;
var lines;
var bagGray;
var spawnTime = 1000; //milli seconds

// Drawing states
var isDrawing = false;
var lastMousePos = null;

function setup(){
	createCanvas(375,667);
	// setTimeout(createNewBugYellow,1000);
	// setTimeout(createNewBugRed,1000);

	createBasketYellow();
	createBasketRed();

	bouncyBugYellow = new Group();
	bouncyBugRed = new Group();
	lines = new Group();

	background(50);

	strokeWeight(10)
	stroke(255);
};

function draw() {

	// setTimeout(drawSprites(),spawnTime);
	if (mouseIsPressed) {
		drawLine();
		createBoard();
	} else {
		// lastMousePos = null;
	}

	// for( var i = 0; i < lines.length; i++) {
	// 	var line = lines[i];
	// 	line.
	// }
};

// Drawing

// var lines = [];

function drawLine() {
	// if (lastMousePos == null) {
	// 	lastMousePos = {
	// 		x: mouseX,
	// 		y: mouseY
	// 	};
	// 	return;
	// }
	// line(mouseX, mouseY, lastMousePos.x, lastMousePos.y);
	var newLine = line(mouseX, mouseY, pmouseX, pmouseY);
	newLine.
	// lines.push(newLine);
	// lines[lines.length - 1].add(newLine);
}


function createNewBugYellow () {
	newBugYellow = createSprite(random(30,330),0,10,10);
	newBugYellow.setSpeed(2,90);

	newBugYellow.draw = function() {
		var c = color(255, 204, 0);
		fill(c);
		ellipse(0,0,10,10);
	};

	bouncyBugYellow.add(newBugYellow);
	setTimeout(createNewBugYellow,random(1000,4000));
};


function createNewBugRed () {
	newBugRed = createSprite(random(30,330),0,10,10);
	newBugRed.setSpeed(2,90);

	newBugRed.draw = function() {
		var c = color(255, 100, 0);
		fill(c);
		ellipse(0,0,10,10);
	};

	bouncyBugRed.add(newBugRed);
	setTimeout(createNewBugRed,random(1000,4000));
};


function createBasketYellow () {
	newBasketYellow = createSprite(1,334,5,667);
	newBasketYellow.shapeColor = color(255,204,0);
};


function createBasketRed () {
	newBasketRed = createSprite(374,334,5,667);
	newBasketRed.shapeColor = color(255,100,0);
};


function createBoard () {
	var newThing = createSprite(mouseX,mouseY,50,2);
	newThing.rotation = 10;
};
