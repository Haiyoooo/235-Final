class Player extends GameObject
{
  float sugar;
  float size;
  float speed;
  
  Player()
  {
    tab = "player";
    wetness = 10000;
    position = new PVector(width/2, height/2);
    sugar = 30;
    size = 50;

  }
  
  void update()
  {
    sugar = constrain(sugar, 0, 100);
    wetness -=0.01;
    
    if(sugar > 0)
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
    
    if(wetness < 0)gamestate = GAMEEND;

  }
  
  void render()
  {
    tint(easeOut(10, 60, sugar/100), 80, 80);
    //ellipse(position.x, position.y, size, size);
    image(player_leaves, position.x, position.y, size, size);
    image(player_body, position.x, position.y, size, size);
    
    if(wetness > 20 && wetness < 90)
    {
      image(player_faceHappy, position.x, position.y, size, size);
    } else
    {
      image(player_faceSick, position.x, position.y, size, size);
    }
    

  }
  
  void getsugar()
  {
    speed = 0;
    wetness -= 10;
    sugar += 10;
    fill(0);
    ellipse(position.x, position.y, 10, 10);
  }
 

}
