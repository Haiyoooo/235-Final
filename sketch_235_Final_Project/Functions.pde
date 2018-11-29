/*--------------------------------------------------
                       DEBUGGING
--------------------------------------------------*/

void debugger()
{
  fill(100);
  textSize(20);
  text("selfEsteem "  + nf(player.selfEsteem, 0, 0)
       + "\napproval " + nf(player.approval, 0, 0)
       + "\ngame timer " + nf(gameTimer/60, 0, 0)
       , 20, 100);
}
/*--------------------------------------------------*/

float step = PI;

// day and night cycles
void dayTime()
{
  float x, y, x1, y1;
  
  step += 0.005;
  
  x = 150 * cos(step) + width/2;
  y = 150 * sin(step) + 200;
  x1 = 150 * cos(step + PI) + width/2;
  y1 = 150 * sin(step + PI) + 200;
  
  if(step % (2 * PI) > PI)
  {
    background(55, 40, 90);
    fill(10, 80, 80);
    ellipse(x, y, 70, 70); //sun
    night = false;
  }
  else 
  {
    background(0);
    fill(50, 20, 90);
    ellipse(x1, y1, 30, 30); //moon
    night = true;
  }

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
