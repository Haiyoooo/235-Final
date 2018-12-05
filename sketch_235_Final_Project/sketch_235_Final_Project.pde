ArrayList <GameObject> gameObject = new ArrayList<GameObject>();
Player player;
Enemy enemy1, enemy2, enemy3;


boolean DEBUG = false;
BufferedReader reader; //(C) https://github.com/michael-mj-john/LoaderExample/blob/master/dataLoader.pde
String line;
int lastLoad;

boolean night;
boolean photosynthesis;
boolean screenshake;
int timer; // for spawning puddles
int gameTimer; // divide by 60 to get seconds
float step;
float x, y, x1, y1;
float ease;

int gamestate;
final int START = 0;
final int RUNNING = 1;
final int GAMEEND = 2;


void setup()
{
  size(800, 800);
  colorMode(HSB, 100);
  imageMode(CENTER);
  noStroke();
  gamestate = 0;
  night = false;
  screenshake = false;
  timer = 0;
  gameTimer = 0;
  step = PI;
  ease = 0.006;
  frameRate(60);
  
  loadImages();
  loadSounds();
  
  gameObject.add( enemy1 = new Enemy(width * .5, height * .5) );
  gameObject.add( enemy2 = new Enemy(width * .1, height * .4) );
  gameObject.add( enemy3 = new Enemy(width * .7, height * .9) );
  gameObject.add( player = new Player() );
  
  readFromFile(); //I'll load the parameters first, even when not in debug mode  
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
      
      //spawner
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
      player.getCarbondioxide();
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
  }
 
}

void mousePressed()
{
  if(gamestate == START)
  {
    gamestate++;
    roosterSound.play(1);
  }
  else if(gamestate == GAMEEND) setup();  
}

/*---------------------KEYBOARD-------------------------------*/
// (c) https://forum.processing.org/two/discussion/16594/#Comment_68096
boolean isUp, isDown, isLeft, isRight;

void keyPressed()
{
  if(gamestate == RUNNING)
  {
    setMove(keyCode, true);
    if(key == ' ') player.getSugar();
  }
}
 
void keyReleased()
{
  setMove(keyCode, false);
  photosynthesis = false;
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

/*This function loads gameplay parameters from a file called "data.txt"
"data.txt" must be in the same directory as the .pde file
Error handling could be better. 
Note that data.txt format is name/value pairs, tab separated
*/
void readFromFile() {
  reader = createReader("data.txt"); 
  if( reader == null ) { 
    println( "open failure" ); 
    return;
  }
  //must re-size this array depending on how many parameters you are using (an ArrayList would be better)
  float parameterArray[] = new float[2]; 
  int i=0;

 // this is one of the rare places where a "do" loop is called for
 do {
   //'try/catch' is Java's exception handling. I am not an expert in this, 
   //this is based on example code. When you hit the end of the file,
   //it throws an exception, which is "caught" and the program moves on.
   //(it seems like there should be a more elegant way to do this)
   try {
      line = reader.readLine(); // this is a "buffered read", a Processing feature
    } 
    catch (IOException e) {
      e.printStackTrace(); //not really a necessary line
      line = null;
    }
    if( line != null ) {
      String[] params = split( line, TAB ); //"split" is a common String function. note that this means your data file must be TAB separated fields
      println( params[0], params[1] ); //just a debug feature
      parameterArray[i++] = Float.valueOf(params[1]);//inserting file values into my parameters array
    }
  }
  while (line != null); // end of "do-while" loop
  
  // assign loaded parameters to gameplay variables 
  ease = parameterArray[0];
  step = parameterArray[1];
  
  lastLoad = millis();
  
}
