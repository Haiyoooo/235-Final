class Earth extends GameObjects
{
  Earth()
  {
    tab = "Earth";
    health = 100;
    size = 100;
    position = new PVector (width/2, height/2);
  }
  
  void update()
  {
  }
  
  void render()
  {
    noFill();
    stroke(2);
    ellipse(position.x, position.y, size, size);
    fill(50, 50);
    ellipse(position.x, position.y, health, health);
  } 
  
  boolean isDead()
  {
    if(health>0) return false;
    return true;
  }
}
