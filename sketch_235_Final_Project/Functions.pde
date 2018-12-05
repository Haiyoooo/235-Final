/*----------------------DEBUG-----------------*/

void debugger()
{
  fill(100);
  textSize(20);
  text("sugar "  + nf(player.sugar, 0, 0)
       + "\nwetness " + nf(player.wetness, 0, 0)
       + "\ngame timer " + nf(gameTimer/60, 0, 0)
       + "\nEASING" + nf(ease, 0, 0)
       + "\nGame obj " + gameObject.size()
       //+ "\nisUP " + isUp
       //+ "\nisUP " + isDown
       //+ "\nisLEFT " + isLeft
       //+ "\nisRight " + isRight
       //+ "\nSpeed " + player.speed
       + "\nPhotosytnethesis " + player.state
       + "\nEnemy1 " + enemy1.state
       + "\nEnemy2 " + enemy2.state
       + "\nEnemy3 " + enemy3.state
       , 10, 300);

}
/*--------------------DAY AND NIGHT----------------------*/
void skyBox()
{ 
  step += sunSpeed;  //0.05
  
  x = 150 * cos(step) + width/2 + shake;
  y = 150 * sin(step) + 200 + shake;
  x1 = 150 * cos(step + PI) + width/2 + shake;
  y1 = 150 * sin(step + PI) + 200 + shake;
  
  colorMode(HSB, 100);
  color c1 = color(55, 50, 100); //blue
  color c2 = color(90, 20, 100); //pink
  color c3 = color(80, 100, 10); //dark
  if(step % (2 * PI) > PI)
    {
      //sky day
      fill(lerpColor(c1, c2, map(y, 50, 200, 0, 1)));
      night = false;
      println(x);
    }
  else 
    {
      //sky night
      fill(lerpColor(c3, c2, map(y1, 50, 200, 0, 1))); //easeOut(0, 1, y1/250)
      night = true;
      println(x);
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
}

void ground()
{
  //GROUND
  fill(15, easeOut(40, 10, y/300), 80);
  rect(0 + shake, 200 + shake, width, height);
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

//"Ease In-Out" moves slowly at first, accelerates near t=0.5, and then decelerates again.
float easeInOut(float start, float end, float t)
{
  return start + (end - start) *
(t * t * (3.0f - 2.0f * t));
}

//"Ease Out Bounce" bounces a few times before coming to a rest at end.
float easeOutBounce(float start, float end, float t)
{
  if (t < (1 / 2.75f)) {
    return start + (end - start) *
(7.5625f*t*t);
  }
  else if (t < (2 / 2.75f)) {
    float postFix = t -= (1.5f / 2.75f);
    return start + (end - start) *
(7.5625f*(postFix)*t + .75f);
  }
  else if (t < (2.5 / 2.75)) {
    float postFix = t -= (2.25f / 2.75f);
    return start + (end - start) *
(7.5625f*(postFix)*t + .9375f);
  }
  else {
    float postFix = t -= (2.625f / 2.75f);
    return start + (end - start) *
(7.5625f*(postFix)*t + .984375f);
  }
}



/*---------------MAKE PUDDLES--------------------------*/
void puddleSpawner()
{
  if(gameTimer - puddleSpawnDelay > timer)
  {
    gameObject.add( new Puddle() );
    timer = gameTimer;
  }
}
/*--------------------HUD-------------------------*/
float shake = 0;

void hud()
{

  float x = 50 + shake;
  float y = 650 + shake;

  stroke(0);
  strokeWeight(5);
  
  //Screen Warnings
  if(player.wetness < player.wetness_wither)
  {
    // dry effect
    tint(100);
    image(screen_brown, width/2, height/2);
  }
  else if(player.wetness > player.wetness_drown)
  {
    //wave effect
    tint(100, easeOut(10, 50, (player.wetness - player.wetness_drown)/(player.wetness_death - player.wetness_drown)));
    image(screen_waves, width/2, easeOut(800, 400, (player.wetness - player.wetness_drown)/(player.wetness_death - player.wetness_drown))); 
  }
  
  imageMode(CORNER);
  
  //Water
  fill(60, 80, 70);
  rect(x + 60, y + 20, map(player.wetness, 0, player.wetness_death, 0, 500), 30, 50);
  fill(100, 80, 80);
  image(HUD_water, x - 20, y - 30, 80, 80);
  
  strokeWeight(3);
  //Sugar
  fill(100);
  rect(x + 60, y + 50, map(player.sugar, 0, 100, 0, 500), 20, 10);
  image(HUD_sugar, x, y + 50, 40, 40);
 
  
  imageMode(CENTER);

  
  
  noStroke();
}

/*--------------------IMAGES-------------------------*/
PImage player_body, player_leaves, player_faceHappy, player_faceSick, player_faceScared, player_leavesClosed;
PImage HUD_water, HUD_sugar, add_water, add_sugar;
PImage enemy_cow;
PImage arrow_down_red, arrow_down_red2, arrow_up_green, arrow_up_green2;
PImage screen_brown, screen_waves;
PImage instructions;

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
  screen_brown = loadImage("brownBorder.png");
  screen_waves = loadImage("Waves.png");
  instructions = loadImage("instructions2.jpg");
}

/*--------------------SOUNDS-------------------------*/

import ddf.minim.*;
Minim minim;
AudioPlayer slurpSound;
AudioPlayer roosterSound;
AudioPlayer cricketSound;

void loadSounds()
{
  minim = new Minim(this);

  slurpSound = minim.loadFile("166158__adam-n__slurp.wav");
  roosterSound = minim.loadFile("Rooster-crowing-sound.mp3");
  cricketSound = minim.loadFile("121511__damonmensch__cricket-sound.mp3");
}

/*--------------------FOG-------------------------*/
void fogOfWar()
{
  // Begin shape
  beginShape();
  
  // darkness
  fill(0, easeIn(100, 5, y1/200));
  vertex(0, 200);
  vertex(width, 200);
  vertex(width, height);
  vertex(0, height);
  
  // circular area of vision
  beginContour();
  for(int i = 0; i < 360; i ++)
  {
   float a = radians(i);
   float x = easeIn(200, width, y1/50) * sin(a) + player.position.x + shake;
   float y = easeIn(200, height, y1/50) * cos(a) + player.position.y + shake;
   vertex(x, y);
  }
  endContour();
  
  // finish off the shape
  endShape(CLOSE);
}
