
/*--------------------------------------------------
                    PUDDLE CLASS
--------------------------------------------------*/
class Puddle extends GameObject
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
    
    checkPlayer();
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
