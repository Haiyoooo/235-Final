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
    stroke(2);
    stroke(mouseX, 50, 100, 50);
    rectMode(CENTER);
    noFill();
    //fill(100, 50);
    ellipse(position.x, position.y, size, size);
    
    //current bullets
    float currentBullets = map(bulletMax - bulletCount, 0, 20, 0, size);
    fill(50, 80, 100, 80);
    ellipse(position.x, position.y, currentBullets, currentBullets);
    
    //hp bar
    stroke(1);
    fill(100, 100, 100);
    rect(position.x, position.y - 60, health, 10);
  } 
  
  boolean isDead()
  {
    if(health>0) return false;
    return true;
  }
}
