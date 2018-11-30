class Puddle extends GameObject
{
  Puddle()
  {
    tab = "puddle";
    wetness = random(60, 100);
    position = new PVector(random(0, width), random(250, height));
  }
  
  void update()
  {
    // puddle gets smaller as time passes
    wetness -= 0.1;
    
    checkPlayer();
  }
  
  void render()
  {
    fill(60, 80, 70);
    ellipse(position.x, position.y, wetness, wetness);
  }
  
  void checkPlayer()
  {
    //if the player is touching the puddle, the player absorbs the puddle
    if(playerDistanceTo(position) < wetness/2)
    {
      wetness-= 1;
      player.wetness += 1;
        if(!slurpSound.isPlaying())
        { 
          slurpSound.play(1);
        }
    //} else if (slurpSound.isPlaying())
    //{
    //  slurpSound.pause();
    }
  }
}
