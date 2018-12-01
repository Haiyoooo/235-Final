class Puddle extends GameObject
{
  Puddle()
  {
    tab = "puddle";
    wetness = random(60, 100);
    position = new PVector(random(0, width), random(250, height));
    size = wetness;
  }
  
  void update()
  {
    // puddle gets smaller as time passes
    wetness -= 0.1;
    size = wetness;
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
      wetness-= 1;
      player.wetness += 1;
      tint(100, 40);
      image(add_water, player.position.x, player.position.y - 40);
    if(!slurpSound.isPlaying())
      {  //<>//
          slurpSound.play(1);
      }
    }
    else if (playerDistanceTo(position) > size/2)
    {
      slurpSound.pause();
    }
  }
}
