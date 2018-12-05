class Player extends GameObject
{
  float co2;
  float sugar;
  float speed;
  float wetness_wither;
  float wetness_drown;
  float wetness_death;
  float rate;
  color bodycolor;
  
  Player()
  {
    tab = "player";
    wetness = 200;
    position = new PVector(width/2, height/2);
    sugar = 30;
    size = 100;
    co2 = 50;
    speed = 0;
    rate = 0;
    
    wetness_wither = 50; //TODO: Show death limits on HUD
    wetness_drown = 250;
    wetness_death = 300;
    
    bodycolor = color(30, 80, 80);

  }
  
  void update()
  {
    if(!night) wetness -= 0.3;
    if(wetness < 0 || wetness > wetness_death || sugar <= 0) gamestate = GAMEEND;
    
    sugar = constrain(sugar, 0, 100);
    
    //more sugar, more speed
    speed = easeOut(5, 10, sugar/100);
    if(isLeft  && position.x > 0     )position.add(-speed,0);
    if(isRight && position.x < width )position.add(speed,0);
    if(isDown  && position.y < height)position.add(0,speed);
    if(isUp    && position.y > 230   )position.add(0,-speed);

    //moving uses up sugar
    //if(isLeft || isRight || isDown || isUp && sugar > 0) player.sugar-= 0.1;
  }
  
  void render()
  {
    
    
    //check photosynthesis
    if(photosynthesis == true)
    {
      image(player_leaves, position.x, position.y, size, size);
    } else
    {
      image(player_leavesClosed, position.x, position.y, size, size);
    }
    
    tint(bodycolor);
    image(player_body, position.x, position.y, size, size);
    //check wetness
    if(night && (enemy1.isAggro() || enemy2.isAggro() || enemy3.isAggro()))
    {   
      image(player_faceScared, position.x, position.y, size, size);
    }
    else if (wetness > wetness_drown)
    {
      //too wet
      bodycolor = color(60, 80, 80);
      image(player_faceSick, position.x, position.y, size, size);
    } else if (wetness > wetness_wither)
    {
       //healthy
      bodycolor = color(30, 80, 80);
      image(player_faceHappy, position.x, position.y, size, size); 
    }
    else if (wetness < wetness_wither)
    {
      //too dry
      bodycolor = color(10, 80, 80);
      image(player_faceSick, position.x, position.y, size, size);
    }
    
    tint(100); //remove tint

  }
  
  void getSugar()
  {
    if(!night)
    {  
      rate = 1;  
    }
    else
    {
      rate = 0.5; //photosynthesis is slower at night
    }
    
    // 6CO2 + 6H2O + light energy = C6H12O6 + 6O2.
    speed = 0;
    
    if(wetness > 0 && co2 > 0)
    {
      wetness -= 3 * rate;
      co2 -= 3 * rate;
      sugar += 0.5 * rate;
      image(add_sugar, position.x, position.y - random(40, 50), 50 * rate, 50 * rate);
      
    }
    photosynthesis = true;
    fill(0);
    ellipse(position.x, position.y, 10, 10);
  }

  void getCarbondioxide()
  {
      if(co2 < 500)
      {
      // scream into the mic to create more carbon dioxide
      in.start();
      co2 += amp.analyze() * 20;
      }
  }
}
