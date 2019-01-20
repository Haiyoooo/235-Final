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
    image(earthimg, position.x, position.y);
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
