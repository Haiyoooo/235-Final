 //<>//
/*--------------------------------------------------
                    ENEMY CLASS
--------------------------------------------------*/
class Enemy extends GameObject
{
  PVector position;
  PVector zonePos;
  float zone;
  
  Enemy(float posX, float posY)
  {
    position = new PVector(posX, posY);
    zonePos = new PVector(posX, posY);
    zone = 400;
  }
  
  void update()
  {
    isAggro();
    zonePos.add( random(-10, 10), random( -3, 3) ); //TODO: Restrict enemies from roaming off screen
  }
  
  void render()
  {
    if(isAggro())
    {
      fill(100, 80, 80, 20); //red
    }else{
      fill(50, 50, 50, 10); //white
    }
    ellipse(zonePos.x, zonePos.y, zone, zone);
    
    fill(100, 80, 80);
    ellipse(position.x, position.y, 50, 50);
  }
  
  boolean isAggro()
  {
    if(playerDistanceTo(zonePos) < zone/2)
    {
      //chase
      position.x = easeIn(position.x, player.position.x, ease);  //0.006
      position.y = easeIn(position.y, player.position.y, ease);  //0.006
      return true;
    }
    //return home
    position.x = easeOut(position.x, zonePos.x, 0.002);
    position.y = easeOut(position.y, zonePos.y, 0.002);
    return false;
  }
  
}
