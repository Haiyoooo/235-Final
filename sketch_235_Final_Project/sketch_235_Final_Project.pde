Player player;
ArrayList <Puddle> puddle = new ArrayList<Puddle>();
ArrayList <Enemy> enemy = new ArrayList<Enemy>();
ArrayList <GameObject> gameObject = new ArrayList<GameObject>();
boolean DEBUG = true;
boolean night;
int timer; // for spawning puddles
float gameTimer; // for total game time
float step;
final int RUNNING = 1;
final int GAMEEND = 2;
int gamestate;
float ease;


void setup()
{
  size(800, 800);
  colorMode(HSB, 100);
  player = new Player();
  noStroke();
  gamestate = 1;
  night = false;
  timer = 0;
  gameTimer = 0;
  step = PI;
  ease = 0.5;

  enemySpawner();
}

void draw()
{ 

  
  switch(gamestate)
  {
    case RUNNING:
      gameTimer += 1;
      dayTime();
      fill(15, 30, 80);
      rect(0, 200, width, height);
      player.update();
      player.render();
      
      puddleSpawner();
      puddleUpdater();
      
      if(night)
      {
        enemyUpdater();
      }
      break;
      
    case GAMEEND:
      displayHighscore();
  }


  if(DEBUG)
  {
    debugger();
  }
}

void mousePressed()
{
  if(gamestate == GAMEEND)
  {
    setup();
  }
  
  if(mouseButton == LEFT) ease -= 0.001 ;
  if(mouseButton == RIGHT) ease += 0.001 ;
}

/*--------------------------------------------------
                       KEYBOARD
--------------------------------------------------*/
// (c) https://forum.processing.org/two/discussion/16594/#Comment_68096
boolean isUp, isDown, isLeft, isRight;

void keyPressed()
{
  if(gamestate == RUNNING)
  {
    setMove(keyCode, true);
    if(player.selfEsteem > 0)player.selfEsteem--;
    if(key == ' ')player.getSelfEsteem();
  }
}
 
void keyReleased()
{
  if(gamestate == RUNNING)
  {
    setMove(keyCode, false);
  }
}

boolean setMove(int k, boolean b)
{
  switch (k)
  {
    case UP:
      return isUp = b;
   
    case DOWN:
      return isDown = b;
   
    case LEFT:
      return isLeft = b;
   
    case RIGHT:
      return isRight = b;
   
    default:
      return b;
  }
}
