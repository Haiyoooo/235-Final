ArrayList <GameObject> gameObject = new ArrayList<GameObject>();
Player player;
Enemy enemy1, enemy2, enemy3;


boolean DEBUG = false;
BufferedReader reader; //(C) https://github.com/michael-mj-john/LoaderExample/blob/master/dataLoader.pde
String line;
int lastLoad;

boolean night;
boolean screenshake;
int timer; // for spawning puddles
int gameTimer; // divide by 60 to get seconds
int atkTimer;
float step;
float x, y, x1, y1;

int gamestate;
final int START = 0;
final int RUNNING = 1;
final int GAMEEND = 2;

float sunSpeed;
float ease;
float puddleAbsorbRate, puddleEvaporateRate, puddleSpawnDelay;
float enemyEatRate;
float waterY; //413 = whole ground flooded
float adjust;
float enemyBurnSugarRate, enemyStartSugar, enemyFullSugar;
float photoRateDay, photoRateNight;

void setup()
{
  size(800, 800);
  colorMode(HSB, 100);
  imageMode(CENTER);
  noStroke();

  loadImages();
  loadSounds();
  
  initialize();
  readFromFile(); //I'll load the parameters first, even when not in debug mode  
}

void initialize()
{
  gamestate = 0;
  night = false;
  screenshake = false;
  timer = 0;
  gameTimer = 0;
  atkTimer = 0;
  step = PI;
  frameRate(60);
  
  gameObject.add( enemy1 = new Enemy(width, height * .5) );
  gameObject.add( enemy2 = new Enemy(0, height * .4) );
  gameObject.add( enemy3 = new Enemy(width, height * .9) );
  gameObject.add( player = new Player() );
}

void draw()
{ 
  
  
  switch(gamestate)
  {
    case START:
      image(instructions, width/2, height/2);
      break;
    case RUNNING:
      gameTimer += 1;
      skyBox();
      ground();
      
      if(screenshake) shake = random(-5,5);
      else shake = 0;
      
      puddleSpawner();
      
      //updater
      for(int i = gameObject.size() - 1; i >= 0; i--)
      {
        GameObject obj = gameObject.get(i);
        obj.update();
        obj.render();
        obj.checkCollision();
        
        //puddle despawner
        if(obj.tab == "puddle" && ( obj.wetness < 0 || gamestate == GAMEEND) ) gameObject.remove(i);
      }
      if(night) fogOfWar();
      hud();
      break;
      
    case GAMEEND:
      displayHighscore();
      setMove(keyCode, false);
      for(int i = gameObject.size() - 1; i >= 0; i--) gameObject.remove(i);
      break;
  }


  if(DEBUG)
  {
    debugger();
    if( gameTimer % 300 == 0 )readFromFile(); //five second load interval
    //image(screen_waves, width/2, waterY);
  }
 
}

void mousePressed()
{
  if(gamestate == START)
  {
    gamestate++;
    roosterSound.play(1);
  }
  else if(gamestate == GAMEEND) initialize();  
}

/*---------------------KEYBOARD-------------------------------*/
// (c) https://forum.processing.org/two/discussion/16594/#Comment_68096
boolean isUp, isDown, isLeft, isRight;

void keyPressed()
{
  if(gamestate == RUNNING)
  {
    
    if(key == ' ') player.getSugar();
    else setMove(keyCode, true);
  }
}
 
void keyReleased()
{
  setMove(keyCode, false);
  player.speed = 0;
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

void readFromFile() {
  
  final int SIZE = 21;
  
  reader = createReader("data.txt"); 
  if( reader == null ) { 
    println( "open failure" ); 
    return;
  }
  //must re-size this array depending on how many parameters you are using (an ArrayList would be better)
  float parameterArray[] = new float[SIZE]; 
  int i=0;

 // this is one of the rare places where a "do" loop is called for
 do {
   try {
      line = reader.readLine(); // this is a "buffered read", a Processing feature
    } 
    catch (IOException e) {
      e.printStackTrace(); //not really a necessary line
      line = null;
    }
    if( line != null ) {
      String[] params = split( line, TAB ); //"split" is a common String function. note that this means your data file must be TAB separated fields
      println(params[0], params[1]);
      parameterArray[i++] = Float.valueOf(params[1]);//inserting file values into my parameters array
    }
  }
  while (line != null); // end of "do-while" loop
  
  // assign loaded parameters to gameplay variables 
  ease = parameterArray[0];
  sunSpeed = parameterArray[1];
  player.maxSugar = parameterArray[2];
  player.minSpeed = parameterArray[3];
  player.maxSpeed = parameterArray[4];
  player.minSize = parameterArray[5];
  player.maxSize = parameterArray[6];
  puddleAbsorbRate = parameterArray[7];
  puddleSpawnDelay = parameterArray[8];
  puddleEvaporateRate = parameterArray[9];
  adjust = parameterArray[10];
  player.wetness_drown = parameterArray[11];
  player.wetness_wither = parameterArray[12];
  waterY = parameterArray[13];
  enemyEatRate = parameterArray[14];
  enemyBurnSugarRate = parameterArray[15];
  enemyStartSugar = parameterArray[16];
  enemyFullSugar = parameterArray[17];
  photoRateDay = parameterArray[18];
  photoRateNight = parameterArray[19];
}
