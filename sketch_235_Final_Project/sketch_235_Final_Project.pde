ArrayList <GameObject> gameObject = new ArrayList<GameObject>();
Player player;

boolean DEBUG = true;
float ease;

boolean night;
int timer; // for spawning puddles
float gameTimer; // for total game time
float step;

int gamestate;
final int RUNNING = 1;
final int GAMEEND = 2;


void setup()
{
  size(800, 800);
  colorMode(HSB, 100);
  noStroke();
  gamestate = 1;
  night = false;
  timer = 0;
  gameTimer = 0;
  step = PI;
  ease = 0.5;
  
  frameRate(60);
  
  //enemySpawner();
  gameObject.add( new Enemy(width * .5, height * .5) );
  gameObject.add( new Enemy(width * .1, height * .4) );
  gameObject.add( new Enemy(width * .7, height * .9) );
  
  player = new Player();
  gameObject.add( player );
}

void draw()
{ 

  
  switch(gamestate)
  {
    case RUNNING:
      gameTimer += 1;
      dayTime();
      
      //floor
      fill(15, 30, 80);
      rect(0, 200, width, height);
      
      //spawner
      puddleSpawner();
      
      for(int i = gameObject.size() - 1; i >= 0; i--)
      {
        GameObject obj = gameObject.get(i);
        obj.update();
        obj.render();
        
        if(obj.tab == "puddle" && (obj.wetness < 0 || gamestate == GAMEEND) )
        {
          gameObject.remove(i);
        }
        
      }

      
      if(night)
      {
        //enemyUpdater();
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
    if(player.sugar > 0)player.sugar--;
    if(key == ' ')player.getsugar();
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
