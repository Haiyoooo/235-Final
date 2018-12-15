class Earth extends GameObjects
{
  Earth()
  {
    tab = "Earth";
    health = 1;
    size = 100;
    position = new PVector (width/2, height/2);
  }
  
  void update()
  {
  }
  
  void render()
  {
    stroke(2);
    stroke(mouseX, 50, 100, 50);
    rectMode(CENTER);
    fill(100, 50);
    ellipse(position.x, position.y, size, size);
    
    //current bullets
    float currentBullets = map(bulletMax - bulletCount, 0, bulletMax, 0, size);
    fill(50, 80, 100, 80);
    ellipse(position.x, position.y, currentBullets, currentBullets);
  } 
  
  boolean isDead()
  {
    if(health<1)
    { 
      explosion.play(1);
      for(int i = 0; i < 10; i++) gameObjects.add(new Particles(earth.position.x, earth.position.y, 60) );
      return true;
    }
    return false;
  }
}
