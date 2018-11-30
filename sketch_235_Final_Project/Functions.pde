/*--------------------------------------------------
                       DEBUGGING
--------------------------------------------------*/

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
       , 20, 100);
       
 fill(15, 50, 80);
 rectMode(CORNER);
 rect(10, 10, player.sugar * 10, 10);
 
 fill(60, 80, 70);
  rect(10, 20, player.wetness, 10);
 
 
}
/*--------------------------------------------------*/


// day and night cycles
void dayTime()
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
      background(easeIn(55, 90, y/250), 50, 100);
  
      night = false;
    }
  else 
    {
      background(90 * y/250, 50, easeIn(0, 100, y1/250));
  
      night = true;
    }

    //SUN
    fill(10, 80, 100, 5);     
    for(int i = 10; i > 0; i--)
    {   
      float rng = random(20, 50);
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

// check collision
float playerDistanceTo(PVector position)
{
  float distance = sqrt( pow(player.position.y - position.y, 2) + pow(player.position.x - position.x, 2) ) - (player.size * .5);
  return distance;
}

// game over screen
void displayHighscore()
{
  background(0);
  text("GAME OVER"
  + "\n you survived for " + nf(gameTimer/60, 0, 2) + " seconds", width/2, height/2);
}

/*-----------------------------------------------------------------*/
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

/*--------------------------------------------------
                    MAKE PUDDLE
--------------------------------------------------*/
void puddleSpawner()
{
  if(millis() - 1000 > timer)
  {
    gameObject.add( new Puddle() );
    timer = millis();
  }
}
