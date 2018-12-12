class Player extends GameObject
{
  float sugar;
  float speed;
  float wetness_wither;
  float wetness_drown;
  float wetness_death;
  float rate;
  color bodycolor;

  final int MOVABLE = 0;
  final int PHOTOSYNTHESIZING = 1;
  color c1;
  color c2;

  
  //design variables
  float high, medium, low; //speed
  float minSpeed, maxSpeed, minSize, maxSize;
  float maxSugar;
  
  Player()
  {
    tab = "player";
    wetness = 150;
    position = new PVector(width/2, height/2);
    sugar = 30;
    size = 100;
    speed = 0;
    rate = 0;
    state = MOVABLE;
    
    wetness_wither = 50;
    wetness_drown = 250;
    wetness_death = 300;
    
    bodycolor = color(30, 80, 80);
    
    minSpeed = 5;
    maxSpeed = 10;
    minSize = 30;
    maxSize = 250;
    maxSugar = 100;
    
    c1 = color(10, 50, 80);
    c2 = color(55, 80, 60);
    

  }
  
  void update()
  {
    if(!night) wetness -= 0.3;
    //if(wetness < 0 || wetness > wetness_death || sugar <= 0) gamestate = GAMEEND;
    sugar = constrain(sugar, 0, maxSugar);
    size = easeOut(minSize, maxSize, wetness/wetness_death); //wetter = bigger

    //moving uses up sugar
    //if(isLeft || isRight || isDown || isUp && sugar > 0) player.sugar-= 0.1;
    
    switch(state)
      {
        case MOVABLE:
          movingUpdate();
          break;
        case PHOTOSYNTHESIZING:
          getSugar();
          break;
      }
  }
  
  void movingUpdate()
  {
    speed = easeOut(maxSpeed, minSpeed, wetness/wetness_death);
    if(isLeft  && position.x > 0     )position.add(-speed,0);
    if(isRight && position.x < width )position.add(speed,0);
    if(isDown  && position.y < height)position.add(0,speed);
    if(isUp    && position.y > 230   )position.add(0,-speed);
    
    if( keyPressed & key == ' ') state = PHOTOSYNTHESIZING;
  }
  
  void render()
  {
    tint(100);
    switch(state)
      {
        case MOVABLE:
          image(player_leavesClosed, position.x, position.y, size, size);
          break;
        case PHOTOSYNTHESIZING:
          image(player_leaves, position.x, position.y, size, size);
          break;
      }
    
    //body
    tint(lerpColor(c1, c2, wetness/wetness_death));
    image(player_body, position.x, position.y, size, size);
    
    //face
    if(night && (enemy1.isAggro() || enemy2.isAggro() || enemy3.isAggro())) image(player_faceScared, position.x, position.y, size, size);
    else if (wetness > wetness_drown) image(player_faceSick, position.x, position.y, size, size);
    else if (wetness > wetness_wither) image(player_faceHappy, position.x, position.y, size, size); 
    else if (wetness < wetness_wither) image(player_faceSick, position.x, position.y, size, size);
    tint(100); //remove tint
  }
  
  void getSugar()
  {
    if( keyPressed & key == ' ') state = PHOTOSYNTHESIZING;
    else state = MOVABLE;
    
    if(!night)
    {  
      rate = photoRateDay;  
    }
    else
    {
      rate = photoRateNight; //photosynthesis is slower at night
    }
    
    // 6CO2 + 6H2O + light energy = C6H12O6 + 6O2.
    speed = 0;
    
    if(wetness > 0)
    {
      wetness -= 1 * rate;
      sugar += 1 * rate;
      image(add_sugar, position.x, position.y - random(40, 50), 50 * rate, 50 * rate);
    }
    fill(0);
    ellipse(position.x, position.y, 10, 10);
  }
}
