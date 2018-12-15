class Particles extends GameObjects
{
  PVector position;
  PVector velocity;
  float lifespan;
  float hue;
  String string;
  
  Particles(float posX, float posY, float tempHue)
  {
    tab = "Particles";
    lifespan = 30;
    position = new PVector(posX, posY);
    velocity = new PVector( random(-10, 10), random(-10, 10) );
    hue = tempHue;
    string = "";
  }
  
  void update()
  {
    lifespan--;
    position.add(velocity);
  }
  
  void render()
  {
    fill(hue, 80, 80, 5);
    ellipse(position.x, position.y, 5, 5);
  }
  
  boolean isDead()
  {
    if(lifespan<0) return true;
    return false;
  }
}
