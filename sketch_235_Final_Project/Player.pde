class Player
{
  float approval;
  float selfEsteem;
  float size;
  float speed;
  PVector position;
  
  Player()
  {
    approval = 10000;
    selfEsteem = 30;
    size = 50;
    position = new PVector(width/2, height/2);
  }
  
  void update()
  {
    selfEsteem = constrain(selfEsteem, 0, 100);
    approval -=0.01;
    
    if(selfEsteem > 0)
    {
      speed = 5;
    } else
    {
      speed = 1;
    }

    if (isLeft  && position.x > 0     )position.add(-speed,0);
    if (isRight && position.x < width )position.add(speed,0);
    if (isDown  && position.y < height)position.add(0,speed);
    if (isUp    && position.y > 230   )position.add(0,-speed);
    
    if(approval < 0)
    {
      gamestate = GAMEEND;
    }
  }
  
  void render()
  {
    fill(30, approval, selfEsteem);
    ellipse(position.x, position.y, size, size);
  }
  
  void getSelfEsteem()
  {
    approval -= 10;
    selfEsteem += 10;
  }
 

}
