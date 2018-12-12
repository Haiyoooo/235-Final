class Enemy extends GameObjects
{
  float orbitSpeed;
  float angle;
  float approachSpeed;
  float distToEarth;

  Enemy(float tempOrbit)
  {
    tab = "Enemy";
    health = 1;
    size = 50;
    angle = random(0, PI); //start position on the circumference
    
    position = new PVector(0,0);
    
    distToEarth = random(250, 300);
    orbitSpeed = tempOrbit;
    approachSpeed = 10;

  }
  
  void update()
  {
    //rotates closer to earth
    position.x = distToEarth * cos(angle += orbitSpeed) + width/2;
    position.y = distToEarth * sin(angle += orbitSpeed) + height/2;
    if(frameCount % 120 == 0)
    {
      distToEarth -= approachSpeed;
      orbitSpeed += 0.001; //approach in sudden jumps
    }
    
    //attack earth, deal damage
    if(checkCollision(position, earth.position, size, earth.size) ) 
    {
      earth.health -= 10;
      health = 0;
    }
  }
  
  void render()
  {   
    noStroke();
    fill(100, 80, 100);
    ellipse(position.x, position.y, size, size);
  }
    
  boolean isDead()
  {
    if(health<1)
    {
      score += 100;
      return true;
    }
    return false;
  }
}

class SpecialEnemy extends Enemy
{
  SpecialEnemy(float tempOrbit)
  {
    super(tempOrbit);
    position = new PVector(0, height/2);
    size = 25;
    orbitSpeed = tempOrbit;
    health = 1;
  }
  
  void update()
  {
    //moves across the top of the screen
    position.add(orbitSpeed,0);
  }
  
      
  boolean isDead()
  {
    if(health<1)
    {
      score += 1000;
      return true;
    }
    return false;
  }

}
