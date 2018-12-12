class Bullets extends GameObjects
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector mouse;
  float lifespan;
  float r;
  float mouseMag;
  
  Bullets(float tempX, float tempY)
  {
    position = new PVector(tempX, tempY);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);

    lifespan = 500;
    r = random(10,50);
  }

  void update()
  {
    lifespan -= 1;
    
    position.add(velocity);
    velocity.add(accelerationCalculator());
    velocity.limit(10);
  }
  
  void render()
  {
    // Particles fade as time passes
    // Particles change colour depending on their position on the screen
    float xPos = map(position.x, 0, width, 0, 100);
    float yPos = map(position.y, 0, height, 0, 100);
    float dying = map(lifespan, 0, 500, 0, 100);
    stroke(xPos, 50, 100, dying*0.3);
    strokeWeight(5);
    fill(xPos, yPos, 80, dying);
    ellipse(position.x, position.y, r, r);
  }
  
  void dealDamage()
  {
    for(int i = gameObjects.size() - 1; i > -1; i--)
    {
      GameObjects obj = gameObjects.get(i);
      if(obj.tab == "Enemy")
      {
        if(checkCollision(position, obj.position, size, obj.size) ) earth.health -= 10;
      }
    }
  }
  
  //*--------- Acceleration -------------*//
  //For the direction, get the vector pointing from particle to mouse
  //For the magnitude, artifically set it based on which key is pressed
  PVector accelerationCalculator()
  {
    //direction
    mouse = new PVector(mouseX, mouseY);
    mouse.sub(position);
    float dist = constrain(mouse.mag(), 0.01, 30);
    
    //magnitude
    keyPressed(dist); //magitude of vector = distance between points
    mouse.setMag(mouseMag);
    println(dist);
    
    return mouse;
  }
  
  //Particles react differently to the mouse depending on which Key is selected
  float keyPressed(float relativeDistance)
  {   
    switch(key)
    {
      case 's':
        //Stop
        mouseMag = 0; 
        return mouseMag;
      case 'd':
        //Disperse
        mouseMag = -2;
        return mouseMag;
      case 'f':
        //Flow away
        mouseMag = 200/(relativeDistance * relativeDistance) * -1;
        return mouseMag;
      default:
        mouseMag = 200/(relativeDistance * relativeDistance) * -1;
        return mouseMag;
    }
  }

  boolean isDead()
  {
    if(lifespan < 0) return true;
    else return false;
  }
  
  void bounceWall()
  {
    float border = 100;
    
    if(position.x > width - border || position.x < 0 + border)
    {
      velocity.x = velocity.x * -1;
    }
    if(position.y > height - border  || position.y < 0 + border)
    {
      velocity.y = velocity.y * -1;
    }
  }
}
