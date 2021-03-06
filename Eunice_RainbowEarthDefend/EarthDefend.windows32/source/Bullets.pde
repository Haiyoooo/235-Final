class Bullets extends GameObjects
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector mouse;
  PVector force;
  float lifespan;
  float r;
  float mouseMag;


  Bullets(float tempX, float tempY)
  {
    position = new PVector(tempX, tempY);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    lifespan = 500;
    r = 30;
  }

  void update()
  {
    lifespan -= 1;
    
    velocity.add(accelerationCalculator());
    position.add(velocity);
    velocity.mult(0.9); //air resistance
    velocity.limit(2);
    
    dealDamage();

  }
  
  void render()
  {
    // Particles fade as time passes
    // Particles change colour depending on their position on the screen
    float xPos = map(position.x, 0, width, 0, 100);
    float yPos = map(position.y, 0, height, 0, 100);
    float dying = map(lifespan, 0, 500, 10, 40);
    stroke(xPos, 50, 100, dying);
    strokeWeight(5);
    fill(xPos, yPos, 80, dying);
    ellipse(position.x, position.y, r, r);
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
    
    return mouse;
  }
  
  //Particles react differently to the mouse depending on which Key is selected
  float keyPressed(float relativeDistance)
  {   
    switch(key)
    {
      case '2': //fast
        mouseMag = -2;
        return mouseMag;
      case '1': //slower
        mouseMag = 200/(relativeDistance * relativeDistance) * -1;
        return mouseMag;
      default:
        mouseMag = 200/(relativeDistance * relativeDistance) * -1;
        return mouseMag;
    }
  }
  
  void dealDamage()
  {
    for(int i = gameObjects.size() - 1; i > -1; i--)
    {
      GameObjects obj = gameObjects.get(i);
      if(obj.tab == "Enemy" && checkCollision(position, obj.position, size, obj.size) ) obj.health -= 10;
    }
  }

  boolean isDead()
  {
    if(lifespan < 0)
    {
      bulletCount--;
      return true;
    }
    else return false;
  }
}
