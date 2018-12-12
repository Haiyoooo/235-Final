class Enemy extends GameObjects
{
  float orbitSpeed;
  float angle;
  float approachSpeed;
  float distToEarth;

  Enemy()
  {
    tab = "Enemy";
    health = 100;
    size = 50;
    angle = random(0, PI); //start position on the circumference
    
    position = new PVector(0,0);
    
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
    fill(0);
    text(health, position.x, position.y);
  }
    
  boolean isDead()
  {
    if(health<1) return true;
    return false;
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
