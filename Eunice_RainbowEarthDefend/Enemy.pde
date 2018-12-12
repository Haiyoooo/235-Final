class Enemy extends GameObjects
{
  float health;
  float orbitSpeed;
  float angle;
  float approachSpeed;
  float distToEarth;

  Enemy()
  {
    tab = "Enemy";
    health = 100;
    size = 50;
    angle = 0; //start position on the circumference
    
    position = new PVector(250, 0);
    
    distToEarth = 250;
    orbitSpeed = 0.01;
    approachSpeed = 10;
  }
  
  void update()
  {
    //rotates closer to earth
    position.x = distToEarth * cos(angle += orbitSpeed) + width/2;
    position.y = distToEarth * sin(angle += orbitSpeed) + height/2;
    if(frameCount % 120 == 0) distToEarth -= approachSpeed; //approach in sudden jumps
    
    //check collision, deal damage
    if(checkCollision(position, earth.position, size, earth.size) ) earth.health -= 10;
  }
  
  void render()
  {   
    fill(10, 80, 100);
    ellipse(position.x, position.y, size, size);
  }
}

class SpecialEnemy extends Enemy
{
  SpecialEnemy()
  {
    position = new PVector(0, 100);
    size = 25;
    orbitSpeed = 5;
  }
  
  void update()
  {
    //moves across the top of the screen
    position.add(orbitSpeed,0);
  }
}
