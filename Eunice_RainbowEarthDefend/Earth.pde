class Earth extends GameObjects
{
  float health;
  
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
    fill(50, 50);
    ellipse(position.x, position.y, health, health);
    ellipse(position.x, position.y, size, size);
  }
  
  
}
