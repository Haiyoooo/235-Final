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
      earth.health -= 1;
      health = 0;
    }
  }
  
  void render()
  {   
    noStroke();
    image(enemy1img, position.x, position.y, size, size);
  }
    
  boolean isDead()
  {
    if(health<1)
    {
      ding.play(60);
      score += 100;
      for(int i = 0; i < 10; i++) gameObjects.add(new Particles(position.x, position.y, 100) );
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
    size = 50;
    orbitSpeed = tempOrbit;
    health = 1;
  }
  
  void update()
  {
    //moves across screen
    position.add(orbitSpeed,0);
  }
  
  void render()
  {   
    noStroke();
    image(enemy2img, position.x, position.y, size, size);
  }
      
  boolean isDead()
  {
    if(health<1)
    {
      ding.play(60);
      score += 5000;
      for(int i = 0; i < 10; i++) gameObjects.add(new Particles(position.x, position.y, 90) );
      return true;
    }
    return false;
  }

}
