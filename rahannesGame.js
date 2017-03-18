var bouncyBugYellow;
var bouncyBugRed;
var bagGray;
var spawnTime = 1000; //milli seconds

function setup(){
	createCanvas(375,667);
	setTimeout(createNewBugYellow,1000);
	setTimeout(createNewBugRed,1000);

	createBasketYellow();
	createBasketRed();

	bouncyBugYellow = new Group();	
	bouncyBugRed = new Group();
};

function draw() {
	background(0);	
	setTimeout(drawSprites(),spawnTime);
	if (mouseIsPressed) {
		createBoard();
	}
};


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