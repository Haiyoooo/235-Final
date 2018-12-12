ArrayList <GameObjects> gameObjects = new ArrayList<GameObjects>();
ArrayList <Bullets> bullets = new ArrayList<Bullets>();
Earth earth;
Enemy enemy1;

int gamestate;
final int START = 0;
final int RUNNING = 1;
final int GAMEOVER = 2;

float bulletCount;

void setup()
{
  size(800, 600);
  colorMode(HSB, 100);
  imageMode(CENTER);
  noStroke();
  
  gamestate = 1;
  
  gameObjects.add(earth = new Earth());
  gameObjects.add(new Enemy());
  gameObjects.add(new SpecialEnemy());
}

void draw()
{
  background(100);
  
  switch(gamestate)
  {
    case START:
      gameStart();
      break;
    case RUNNING:
      gameRunning();
      break;
    case GAMEOVER:
      gameOver();
      break;
  }
}

void gameStart()
{
  
  if(mousePressed)gamestate++;
}

void gameRunning()
{
  addParticles();
  for(int i = gameObjects.size() - 1; i > -1; i--)
  {
    GameObjects obj = gameObjects.get(i);
    obj.update();
    obj.render();
  }
}

void gameOver()
{
  if(mousePressed)gamestate++;
}
