class Enemy extends GameObject
{
  PVector zonePos;
  float zone;
  
  Enemy(float posX, float posY)
  {
    tab = "enemy";
    wetness = 50;
    position = new PVector(posX, posY);
    size = 100;
    
    zonePos = new PVector(posX, posY);
    zone = 400;
  }
  
  void update()
  {
    zonePos.add( random(-5, 5), random(-3, 3) );
    
    //teleport offscreen enemies to random position
    if (zonePos.x < 0 || zonePos.x > width || zonePos.y > height || zonePos.y < 230 )
    {
      zonePos.set(random(0, width), random(230, height));
    }
    
    if(night)
    {
      isAggro();
    }
  }
  
  void render()
  {
    if(night)
    {
      if(isAggro())
      {
        fill(100, 80, 80, 20); //red
      }else{
        fill(50, 50, 50, 10); //white
      }
      ellipse(zonePos.x, zonePos.y, zone, zone);
      
      fill(100, 80, 80);
      image(enemy_cow, position.x, position.y, size, size);
    }
  }
  
  boolean isAggro()
  {
    if(playerDistanceTo(zonePos) < zone/2)
    {
      //chase
      position.x = easeOut(position.x, player.position.x, ease);  //0.006
      position.y = easeOut(position.y, player.position.y, ease);  //0.006
      return true;
    }
    //return home
    position.x = easeOut(position.x, zonePos.x, 0.002);
    position.y = easeOut(position.y, zonePos.y, 0.002);
    return false;
  }
  
  void checkCollision()
  {
    if(playerDistanceTo(position) < size/2 && night == true)
    {
      player.wetness--;
      wetness ++;
      translate(random(-1,1), random(-5,5) ); //screenshake
    }
  }
  
}
