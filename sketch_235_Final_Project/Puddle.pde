/*--------------------------------------------------
                    MAKE PUDDLE
--------------------------------------------------*/
void puddleSpawner()
{
  if(millis() - 1000 > timer)
  {
    puddle.add( new Puddle() );
    timer = millis();
  }
}
/*--------------------------------------------------
                    PUDDLE CLASS
--------------------------------------------------*/
class Puddle
{
  PVector position;
  float approval;
  
  Puddle()
  {
    approval = random(60, 100);
    position = new PVector(random(0, width), random(250, height));
  }
  
  void update()
  {
    // puddle gets smaller as time passes
    approval -= 0.1;
  }
  
  void render()
  {
    fill(60, 80, 70);
    ellipse(position.x, position.y, approval, approval);
  }
  
  void checkPlayer()
  {
    //if the player is touching the puddle, the player absorbs the puddle
    if(playerDistanceTo(position) < 25)
    {
      approval-= 1;
      player.approval += 1;
    }
  }
}


/*--------------------------------------------------
                    UPDATE PUDDLE
--------------------------------------------------*/
void puddleUpdater() 
{
  for(int i = puddle.size() - 1; i >= 0; i--)
  {
    Puddle pu = puddle.get(i);
    pu.update();
    pu.render();
    pu.checkPlayer();

    if(pu.approval <= 10)
    {
      puddle.remove(i);
    }
  }
}
