import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Eunice_RainbowEarthDefend extends PApplet {

//Cowardly Bullets
//by Eunice Lim
//14 Dec 2018
// Click the mouse to spawn bullets
// Press 1 or 2 to switch between repel strength



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
PImage earthimg;
PImage titleimg;

int gamestate;
final int START = 0;
final int RUNNING = 1;
final int GAMEOVER = 2;

float bulletCount;
float bulletMax;
float timer;
float levelTimer;
float tutorialTimer;
boolean DEBUG = false;
int score;

public void setup()
{
  
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
  earthimg = loadImage("earth100x100.png");
  titleimg = loadImage("title.png");
  initialize();
}

public void initialize()
{
  gamestate = 0;
  levelTimer = 0;
  tutorialTimer = 0;
  timer = 0;
  score = 0;
  bulletMax = 3;
  bulletCount = 0;
  
  gameObjects.add(bullet = new Bullets(width/2, height/2));
  gameObjects.add(earth = new Earth());
}

public void draw()
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
    fill(50);
    text("Bullets " + bulletCount, 20, 20);
    text(levelTimer, 100, 100);
    text("No of game obejcts :" +  gameObjects.size(), 100, 200);
  }
}

//*---------------- GAME START *--------------///
public void gameStart()
{
  background(0);
  
  //text
  fill(100);
  textSize(40);
  text("EARTH DEFENSE", width/2, height/2);
  textSize(20);
  text("\nBullets run away from your mouse", width/2, height*0.55f);
  textSize(15);
  text("\nClick anywhere to start", width/2, height*0.6f);
  image(titleimg, width/2, height*0.3f);
  
  //border
  renderWall();
  
  //bullet
  bullet.update();
  bullet.render();
  
  //switch states
  if(mousePressed)
  {
    gameObjects.remove(0);
    gamestate++;
  }
}

//*---------------- GAME RUNNING *--------------///
public void gameRunning()
{
  background(0);
  if(!bgMusic.isPlaying()) bgMusic.play(1);
  timer++;
  levelTimer++;
  tutorialTimer++;
  showScore();
  
  //spawn bullets
  if(mousePressed && bulletCount < bulletMax && timer - 10 > 0)
  {
    timer = 0;
    gameObjects.add( new Bullets(earth.position.x, earth.position.y) );
    bulletCount++;
  }
  
  //out of bullets text
  if(mousePressed && bulletCount == bulletMax)
  {
    fill(100);
    textSize(15);
    text("Still regenerating! \n TIP: Don't let bullets leave the screen!", earth.position.x, earth.position.y);
  }
  
  //tutorial text
  textSize(15);
  if(tutorialTimer < 2000) text("Click anywhere to spawn bullets!", earth.position.x, earth.position.y + 200);
  if(tutorialTimer > 2000 && tutorialTimer < 5000) text("Press 1 or 2 to change bullet speed", earth.position.x, earth.position.y + 200);
  if(mousePressed && tutorialTimer > 10) tutorialTimer = 2000; //next tutorial
  if(keyPressed && tutorialTimer > 2000 && tutorialTimer < 5000) tutorialTimer+=1000;  //after enough keypresses, move onto next tutorial
  textAlign(LEFT);
  if(key == '1') text("Speed 1", 10, 20);
  if(key == '2') text("Speed 2", 10, 20);
  
  //avaliable bullets UI
  text("Bullets avaliable: ", 10, 40);
  strokeWeight(1);
  fill(1);
  ellipse(140, 35, 10, 10);
  ellipse(150, 35, 10, 10);
  ellipse(160, 35, 10, 10);
  fill(100, 50);
  if(bulletCount < 3) ellipse(140, 35, 10, 10);
  if(bulletCount < 2) ellipse(150, 35, 10, 10);
  if(bulletCount < 1) ellipse(160, 35, 10, 10);
  
  
  //spawn enemies
  if(frameCount % 180 == 0) gameObjects.add(new Enemy(0.001f));
  if(levelTimer > 3000 && frameCount % 100 == 0) gameObjects.add(new Enemy(0.001f));
  if(levelTimer > 6000 && frameCount % 180 == 0) gameObjects.add(new Enemy(0.0015f));
  if(levelTimer > 10000 && frameCount % 150 == 0) gameObjects.add(new Enemy(0.0025f));
  
  //spawn special enemies
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

//*---------------- GAME OVER *--------------///
public void gameOver()
{
  //text
  fill(100);
  textSize(40);
  text("GAMEOVER", width/2, height/2);
  textSize(20);
  text("Press R to restart", width/2, height*0.55f);
  
  if(keyPressed && key == 'r')
  {
    //destroy all objects
    for(int i = gameObjects.size() - 1; i > -1; i--)
    {
      gameObjects.remove(i);
    }
    
    //reset the game
    initialize();
  }
}
class Bullets extends GameObjects
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector mouse;
  PVector force;
  float lifespan;
  float r;
  float mouseMag;


  Bullets(float tempX, float tempY)
  {
    position = new PVector(tempX, tempY);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    lifespan = 500;
    r = 30;
  }

  public void update()
  {
    lifespan -= 1;
    
    velocity.add(accelerationCalculator());
    position.add(velocity);
    velocity.mult(0.9f); //air resistance
    velocity.limit(2);
    
    dealDamage();

  }
  
  public void render()
  {
    // Particles fade as time passes
    // Particles change colour depending on their position on the screen
    float xPos = map(position.x, 0, width, 0, 100);
    float yPos = map(position.y, 0, height, 0, 100);
    float dying = map(lifespan, 0, 500, 10, 40);
    stroke(xPos, 50, 100, dying);
    strokeWeight(5);
    fill(xPos, yPos, 80, dying);
    ellipse(position.x, position.y, r, r);
  }
  

  //*--------- Acceleration -------------*//
  
  //For the direction, get the vector pointing from particle to mouse
  //For the magnitude, artifically set it based on which key is pressed
  public PVector accelerationCalculator()
  {
    //direction
    mouse = new PVector(mouseX, mouseY);
    mouse.sub(position);
    float dist = constrain(mouse.mag(), 0.01f, 30);
    
    //magnitude
    keyPressed(dist); //magitude of vector = distance between points
    mouse.setMag(mouseMag);
    
    return mouse;
  }
  
  //Particles react differently to the mouse depending on which Key is selected
  public float keyPressed(float relativeDistance)
  {   
    switch(key)
    {
      case '2': //fast
        mouseMag = -2;
        return mouseMag;
      case '1': //slower
        mouseMag = 200/(relativeDistance * relativeDistance) * -1;
        return mouseMag;
      default:
        mouseMag = 200/(relativeDistance * relativeDistance) * -1;
        return mouseMag;
    }
  }
  
  public void dealDamage()
  {
    for(int i = gameObjects.size() - 1; i > -1; i--)
    {
      GameObjects obj = gameObjects.get(i);
      if(obj.tab == "Enemy" && checkCollision(position, obj.position, size, obj.size) ) obj.health -= 10;
    }
  }

  public boolean isDead()
  {
    if(lifespan < 0)
    {
      bulletCount--;
      return true;
    }
    else return false;
  }
}
class Earth extends GameObjects
{
  Earth()
  {
    tab = "Earth";
    health = 1;
    size = 100;
    position = new PVector (width/2, height/2);
  }
  
  public void update()
  {
  }
  
  public void render()
  {
    stroke(2);
    stroke(mouseX, 50, 100, 50);
    rectMode(CENTER);
    image(earthimg, position.x, position.y);
  } 
  
  public boolean isDead()
  {
    if(health<1)
    { 
      explosion.play(1);
      for(int i = 0; i < 10; i++) gameObjects.add(new Particles(earth.position.x, earth.position.y, 60) );
      return true;
    }
    return false;
  }
}
class Enemy extends GameObjects
{
  float orbitSpeed;
  float angle;
  float approachSpeed;
  float distToEarth;

  Enemy(float tempOrbit)
  {
    tab = "Enemy";
    health = 1;
    size = 50;
    angle = random(0, PI); //start position on the circumference
    
    position = new PVector(0,0);
    
    distToEarth = random(250, 300);
    orbitSpeed = tempOrbit;
    approachSpeed = 20;

  }
  
  public void update()
  {
    //rotates closer to earth
    position.x = distToEarth * cos(angle += orbitSpeed) + width/2;
    position.y = distToEarth * sin(angle += orbitSpeed) + height/2;
    if(frameCount % 120 == 0)
    {
      distToEarth -= approachSpeed;
      orbitSpeed += 0.001f; //approach in sudden jumps
    }
    
    //attack earth, deal damage
    if(checkCollision(position, earth.position, size, earth.size) ) 
    {
      earth.health -= 1;
      health = 0;
    }
  }
  
  public void render()
  {   
    noStroke();
    image(enemy1img, position.x, position.y, size, size);
  }
    
  public boolean isDead()
  {
    if(health<1)
    {
      ding.play(60);
      score += 100;
      for(int i = 0; i < 10; i++) gameObjects.add(new Particles(position.x, position.y, 100) );
      return true;
    }
    return false;
  }
}

class SpecialEnemy extends Enemy
{
  SpecialEnemy(float tempOrbit)
  {
    super(tempOrbit);
    position = new PVector(0, height/2);
    size = 50;
    orbitSpeed = tempOrbit;
    health = 1;
  }
  
  public void update()
  {
    //moves across screen
    position.add(orbitSpeed,0);
  }
  
  public void render()
  {   
    noStroke();
    image(enemy2img, position.x, position.y, size, size);
  }
      
  public boolean isDead()
  {
    if(health<1)
    {
      ding.play(60);
      score += 5000;
      for(int i = 0; i < 10; i++) gameObjects.add(new Particles(position.x, position.y, 90) );
      return true;
    }
    return false;
  }

}
public boolean checkCollision(PVector position, PVector other, float size, float otherSize)
{
  float distance = pow(position.y - other.y, 2) + pow(position.x - other.x, 2);
  float sumRadiusSq = pow(size/2 + otherSize/2, 2);
  
  if(distance < sumRadiusSq) return true;
  else return false;
}

public void renderWall()
{
    float xPos = map(mouseX, 0, width, 0, 100);
    stroke(xPos, 50, 100, 50);
    strokeWeight(5);
    noFill();
    rectMode(CENTER);
    rect(width/2, height/2, width* .8f, height * .8f);
}

public void showScore()
{
  fill(100);
  textSize(30);
  text(score, width/2, 50);
}
abstract class GameObjects
{
  PVector position;
  int size;
  String tab;
  int health;
  
  public abstract void update();
  public abstract void render();
  public abstract boolean isDead();
}
class Particles extends GameObjects
{
  PVector position;
  PVector velocity;
  float lifespan;
  float hue;
  String string;
  
  Particles(float posX, float posY, float tempHue)
  {
    tab = "Particles";
    lifespan = 30;
    position = new PVector(posX, posY);
    velocity = new PVector( random(-10, 10), random(-10, 10) );
    hue = tempHue;
    string = "";
  }
  
  public void update()
  {
    lifespan--;
    position.add(velocity);
  }
  
  public void render()
  {
    fill(hue, 80, 80, 5);
    ellipse(position.x, position.y, 5, 5);
  }
  
  public boolean isDead()
  {
    if(lifespan<0) return true;
    return false;
  }
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Eunice_RainbowEarthDefend" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
