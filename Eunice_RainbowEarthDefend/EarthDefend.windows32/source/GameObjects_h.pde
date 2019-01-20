abstract class GameObjects
{
  PVector position;
  int size;
  String tab;
  int health;
  
  abstract void update();
  abstract void render();
  abstract boolean isDead();
}
