//Cowardly Bullets
//by Eunice Lim
//14 Dec 2018
// Click the mouse to spawn bullets
// Press 1 or 2 to switch between repel strength


import ddf.minim.*;
Minim minim;
AudioPlayer explosion; //Recorded by Mark DiAngelo @ http://soundbible.com/1807-Explosion-Ultra-Bass.html
AudioPlayer ding; //https://freesound.org/people/InspectorJ/sounds/339822/
AudioPlayer bgMusic; //Recorded by Kevin MacLeod @ https://freesound.org/people/Andromadax24/sounds/178347/

ArrayList <GameObjects> gameObjects = new ArrayList<GameObjects>();
ArrayList <Bullets> bullets = new ArrayList<Bullets>();
Earth earth;
Enemy enemy1;
Bullets bullet;

PImage enemy1img; //https://es.kisspng.com/kisspng-tr43ze/
PImage enemy2img; //https://es.kisspng.com/kisspng-tr43ze/

int gamestate;
final int START = 0;
final int RUNNING = 1;
final int GAMEOVER = 2;

float bulletCount;
float bulletMax;
float timer;
float levelTimer;
boolean DEBUG = false;
int score;

void setup()
{
  size(800, 600);
  colorMode(HSB, 100);
  imageMode(CENTER);
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  
  minim = new Minim(this);
  explosion = minim.loadFile("Explosion_Ultra_Bass-Mark_DiAngelo-1810420658.mp3");
  ding = minim.loadFile("339822__inspectorj__hand-bells-cluster.wav");
  bgMusic = minim.loadFile("Kevin_MacLeod_-_01_-_Impact_Prelude.mp3");
  
  enemy1img = loadImage("enemy1.png");
  enemy2img = loadImage("enemy2.png");
  
  gameObjects.add(bullet = new Bullets(width/2, height/2));
  
  initialize();
}

void initialize()
{
  gamestate = 0;
  levelTimer = 0;
  timer = 0;
  score = 0;
  bulletMax = 3;
  
  gameObjects.add(earth = new Earth()); 
}

void draw()
{ 
  switch(gamestate)
  {
    case START:
      gameStart();
      break;
    case RUNNING:
      gameRunning();
      break;
    case GAMEOVER:
      gameOver();
      break;
  }
  
  if(DEBUG)
  {
    fill(0);
    text("Bullets " + bulletCount, 20, 20);
    text(levelTimer, 100, 100);
  }
}

void gameStart()
{
  background(0);
  
  
  fill(100);
  textSize(40);
  text("COWARDLY BULLETS", width/2, height/2);
  textSize(20);
  text("\n These bullets will run away from your mouse.", width/2, height*0.55);
  textSize(15);
  text("\nClick anywhere to start", width/2, height*0.6);
  renderWall();
  bullet.update();
  bullet.render();
  
  if(mousePressed)
  {
    gameObjects.remove(0);
    gamestate++;
  }
}

void gameRunning()
{
  background(0);
  if(!bgMusic.isPlaying()) bgMusic.play(1);
  timer++;
  levelTimer++;
  showScore();
  
  //spawn bullets
  if(mousePressed && bulletCount < bulletMax && timer - 10 > 0)
  {
    timer = 0;
    gameObjects.add( new Bullets(earth.position.x, earth.position.y) );
    bulletCount++;
  }
  
  //out of bullets msg
  if(mousePressed && bulletCount == bulletMax)
  {
    fill(100);
    textSize(15);
    text("Still regenerating! \n TIP: Don't let bullets leave the screen!", earth.position.x, earth.position.y);
  }
  
  //spawn enemies
  fill(100);
  if(frameCount % 180 == 0) gameObjects.add(new Enemy(0.001));
  if(levelTimer > 3000 && frameCount % 100 == 0) gameObjects.add(new Enemy(0.001));
  if(levelTimer > 6000 && frameCount % 180 == 0) gameObjects.add(new Enemy(0.0015));
  if(levelTimer > 10000 && frameCount % 150 == 0) gameObjects.add(new Enemy(0.0025));
  
  if(levelTimer == random(500, 1000)) gameObjects.add(new SpecialEnemy(1));
  if(levelTimer == random(1000, 2000)) gameObjects.add(new SpecialEnemy(1));
  if(levelTimer == random(2000, 3000)) gameObjects.add(new SpecialEnemy(3));
  if(levelTimer == random(2000, 3000)) gameObjects.add(new SpecialEnemy(3));
  if(levelTimer > 5000 && frameCount % 200 == 0) gameObjects.add(new SpecialEnemy(5));
  
  //game object manager
  for(int i = gameObjects.size() - 1; i > -1; i--)
  {
    GameObjects obj = gameObjects.get(i);
    obj.update();
    obj.render();
    
    if(obj.isDead()) gameObjects.remove(i);
  }
  
  //gameover
  if(earth.health == 0) gamestate++;
}

void gameOver()
{
  //text
  fill(100);
  textSize(40);
  text("GAMEOVER", width/2, height/2);
  textSize(20);
  text("Click anywhere to restart", width/2, height*0.55);
  
  if(mousePressed)
  {
    initialize();
    gamestate--;
  }
}
