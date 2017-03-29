var bouncyBugYellow;
var bouncyBugRed;
var bottomWall;
var topWall;
var board;
var bagGray;
var lastBug = 0;
var spawnTime = 1000; //milli seconds
var mouseDown = false;

var boards = [];

// Drawing states
var isDrawing = false;
var lastMousePos = null;

function setup(){
	createCanvas(375,667);
	drawBottomWall();
	drawTopWall();

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
	background(0);	
	if (millis() > spawnTime + lastBug){
		lastBug = millis();
		createNewBugYellow();
	};

	if (mouseIsPressed && !mouseDown) {
		mouseDown = true;
		createBoard();
		console.log(bouncyBugYellow.length);
	} else if (!mouseIsPressed) {
		mouseDown = false;
	}

	for (var i = 0; i < boards.length; i++) {
		bouncyBugYellow.bounce(boards[i], overlapTrue);	
	}
	

	bouncyBugYellow.bounce(bottomWall,killIt);
	bouncyBugYellow.bounce(topWall,killIt);

	drawSprites();
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
	var newBugYellow = createSprite(random(30,330),0,10,10);
	newBugYellow.setSpeed(2,90);

	newBugYellow.draw = function() {
		var c = color(255, 204, 0);
		fill(c);
		ellipse(0,0,10,10);
	};

	bouncyBugYellow.add(newBugYellow);
};


function overlapTrue () {
	console.log("called");
}



function drawTopWall () {
	topWall = createSprite(170,-10,667,5);
	topWall.shapeColor = color(0);
	topWall.immovable = true;
}

function drawBottomWall () {
	bottomWall = createSprite(170,665,667,5);
	bottomWall.shapeColor = color(100);
	bottomWall.immovable = true;
}

function killIt (bouncyBugYellow) {
	bouncyBugYellow.remove();
};

function createNewBugRed () {
	var newBugRed = createSprite(random(30,330),0,10,10);
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
	var newBasketYellow = createSprite(1,334,5,667);
	newBasketYellow.shapeColor = color(255,204,0);
};


function createBasketRed () {
	var newBasketRed = createSprite(374,334,5,667);
	newBasketRed.shapeColor = color(255,100,0);
};


function createBoard () {
	var newBoard = createSprite(mouseX,mouseY,50,10);
	newBoard.immovable = true;
	newBoard.life = 10000;
	boards.push(newBoard);
};
