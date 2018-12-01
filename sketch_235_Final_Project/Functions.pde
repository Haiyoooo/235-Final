/*----------------------DEBUG-----------------*/

void debugger()
{
  fill(100);
  textSize(20);
  text("sugar "  + nf(player.sugar, 0, 0)
       + "\nwetness " + nf(player.wetness, 0, 0)
       + "\ngame timer " + nf(gameTimer/60, 0, 0)
       + "\nEASING" + nf(ease, 0, 0)
       //+ "\nEnemies " + enemy.size()
       //+ "\nPuddles " + puddle.size()
       + "\nGame objects" + gameObject.size()
       , 10, 500);
       

 

 
 
}
/*--------------------DAY AND NIGHT----------------------*/
void skyBox()
{
  float x, y, x1, y1;
  
  step += 0.01;  //0.05
  
  x = 150 * cos(step) + width/2;
  y = 150 * sin(step) + 200;
  x1 = 150 * cos(step + PI) + width/2;
  y1 = 150 * sin(step + PI) + 200;
  
  color blue = color(55, 30, 100); //blue
  color orange = color(90, 10, 100); //orange
  if(step % (2 * PI) > PI)
    {
      fill(easeIn(55, 90, y/250), 50, 100, 1);
      night = false;
    }
  else 
    {
      fill(90 * y/250, 50, easeIn(0, 100, y1/250), 1);
      night = true;
    }
    
    rect(0, 0, width, 200);

    //SUN //<>//
    fill(10, 80, 100, 5);     
    for(int i = 5; i > 0; i--)
    {   
      float rng = random(1, 100);
      ellipse(x, y, i * 20 + rng, i * 20 + rng); //sun's animated burning halo
    }
    fill(10, 80, 80);
    ellipse(x, y, 70, 70); //sun

    //MOON
    fill(50, 20, 90);
    ellipse(x1, y1, 30, 30); //moon
    
    fill(100, 100, 100, 10);
    for(int i = 10; i > 0; i--)
    {   
      ellipse(x1, y1, i * 5, i * 5); //moon's static red glow
    }
    
    
    
    //GROUND
    fill(15, easeOut(40, 10, y/300), 80);
    rect(0, 200, width, height);
    
}

/*------------------------DISTANCE COLLISION---------------------------*/
float playerDistanceTo(PVector position)
{
  float distance = sqrt( pow(player.position.y - position.y, 2) + pow(player.position.x - position.x, 2) ) - (player.size * .5);
  return distance;
}

/*------------------------GAME OVER---------------------------*/
void displayHighscore()
{
  background(0);
  text("GAME OVER"
  + "\n you survived for " + nf(gameTimer/60, 0, 2) + " seconds", width/2, height/2);
}

/*------------------------TWEENING---------------------------*/
/*
Enemy chase
easeOut --> 0.06
easeIn --> 0.30
easeOutBack -->
*/

//slow then fast
float easeOut(float start, float end, float t)
{
  --t;
  return start + (end - start) * (t * t * t + 1);
}

//fast then slow
float easeIn(float start, float end, float t)
{
  return start + (end - start) * t * t * t * t * t;
}

//slow then fast with overshoot
float easeOutBack(float start, float end, float t)
{
  final float s = 1.70158f;
  --t;
  return start + (end - start) * (t * t * ((s + 1) * t + s) + 1);
}

/*---------------MAKE PUDDLES--------------------------*/
void puddleSpawner()
{
  if(millis() - 1000 > timer)
  {
    gameObject.add( new Puddle() );
    timer = millis();
  }
}
/*--------------------HUD-------------------------*/

void hud()
{
  float x = 710;
  float y = 730;

  stroke(0);
  strokeWeight(5);
  
  //Water
  fill(60, 80, 70);
  rect(x, y, 20, -player.wetness, 10);  //TODO: Restrict max length. Change tint.
  image(HUD_water, x + 10, y + 33, 60, 60);
  
  //Sugar
  fill(15, 50, 80);
  rect(x + 40, y, 20, -player.sugar * 10, 10); //TODO: Restrict max length. Remove tint.
  image(HUD_sugar, x + 56, y + 33, 60, 60);
  println(mouseX + " " + mouseY);
  

  
  noStroke();
}

/*--------------------IMAGES-------------------------*/
PImage player_body;
PImage player_leaves;
PImage player_faceHappy;
PImage player_faceSick;
PImage player_faceScared;
PImage player_leavesClosed;
PImage HUD_water;
PImage HUD_sugar;
PImage add_water;
PImage add_sugar;
PImage enemy_cow;
PImage arrow_down_red;
PImage arrow_down_red2;
PImage arrow_up_green;
PImage arrow_up_green2;


void loadImages()
{
  player_body = loadImage("Player_bodyW.png");
  player_leaves = loadImage("Player_leaves.png");
  player_faceHappy = loadImage("Player_facehappy.png");
  player_faceSick = loadImage("Player_facesick.png");
  player_faceScared = loadImage("Player_facescared.png");
  HUD_water = loadImage("HUD_water.png");
  HUD_sugar = loadImage("HUD_sugar.png");
  add_water = loadImage("add_water.png");
  add_sugar = loadImage("add_sugar.png");
  player_leavesClosed = loadImage("Player_leavesClosed.png");
  enemy_cow = loadImage("Enemy.png");
  arrow_down_red = loadImage("downArrow_red.png");
  arrow_down_red2 = loadImage("downArrow_red2.png");
  arrow_up_green = loadImage("upArrow.png");
  arrow_up_green2 = loadImage("upArrow2.png");
}

/*--------------------SOUNDS-------------------------*/

import ddf.minim.*;
Minim minim;
AudioPlayer slurpSound;
AudioPlayer bgSound;
AudioPlayer teleportSound;
AudioPlayer dramaticSound;

void loadSounds()
{
  minim = new Minim(this);
  slurpSound = minim.loadFile("166158__adam-n__slurp.wav");
  slurpSound.loop();
}

/*--------------------FOG-------------------------*/
void fogOfWar()
{
  // Begin shape
  beginShape();
  
  // darkness
  fill(0);
  vertex(0, 0);
  vertex(width, 0);
  vertex(width, height);
  vertex(0, height);
  
  // circular area of vision
  beginContour();
  for(int i = 0; i < 360; i ++)
  {
   float a = radians(i);
   float x = 200 * sin(a) + player.position.x;
   float y = 200 * cos(a) + player.position.y;
   vertex(x, y);
  }
  endContour();
  
  // finish off the shape
  endShape(CLOSE);
}
