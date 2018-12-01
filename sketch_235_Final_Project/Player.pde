class Player extends GameObject
{
  float sugar;
  float speed;
  float wetness_wither;
  float wetness_drown;
  
  Player()
  {
    tab = "player";
    wetness = 400;
    position = new PVector(width/2, height/2);
    sugar = 30;
    size = 100;
    
    wetness_wither = 100; //TODO: Show death limits on HUD
    wetness_drown = 500;

  }
  
  void update()
  {
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

    sugar = constrain(sugar, 0, 100);
  }
  
  void render()
  {
    tint(easeOut(10, 60, wetness/100), 80, 80);
    
    //check photosynthesis
    if(photosynthesis == true)
    {
      image(player_leaves, position.x, position.y, size, size);
    } else
    {
      image(player_leavesClosed, position.x, position.y, size, size);
    }
    
    image(player_body, position.x, position.y, size, size);
    
    //check wetness
    if(night && (enemy1.isAggro() || enemy2.isAggro() || enemy3.isAggro()))
    {
      image(player_faceScared, position.x, position.y, size, size);
    }
    else if (wetness > wetness_wither && wetness < wetness_drown)
    {
      //healthy
      image(player_faceHappy, position.x, position.y, size, size); 
    }
    else if (wetness < 200)
    {
      //too dry
      image(player_faceSick, position.x, position.y, size, size);
      
      tint(100); //TODO: LERP IT. Border gets clearer as the plant is getting drier.
      image(screen_brown, width/2, height/2);
    }
    else if (wetness > 500)
    {
      //too wet
      image(player_faceSick, position.x, position.y, size, size);
      tint(100, 50);  //TODO: LERP THE TRANSFORM. Higher waves as the plant drowns.
      image(screen_waves, width/2, height/2); 
    }
    
    tint(100); //remove tint

  }
  
  void getSugar()
  {
    speed = 0;
    wetness -= 6;
    sugar += 3;
    fill(0);
    ellipse(position.x, position.y, 10, 10);
    photosynthesis = true;
    image(add_sugar, position.x, position.y - random(40, 50));
  }

}
