class Puddle extends GameObject
{
  Puddle()
  {
    tab = "puddle";
    wetness = random(50, 80);
    position = new PVector(random(0, width), random(250, height));
    size = wetness * 1.5;
  }
  
  void update()
  {
    // puddle gets smaller as time passes
    wetness -= 0.5;
    size = wetness * 1.5;
  }
  
  void render()
  {
    fill(60, 80, 70);
    ellipse(position.x, position.y, size, size);
  }
  
  void checkCollision()
  {
    //if the player is touching the puddle, the player absorbs the puddle
    if(playerDistanceTo(position) < size/2)
    {
      wetness-= 0.5;
      player.wetness += 0.5;
      tint(100, 40);
      image(add_water, player.position.x, player.position.y - 70);
      
      if(!slurpSound.isPlaying())
      {  //<>//
          slurpSound.play(1);
      }
    }
  }
}
