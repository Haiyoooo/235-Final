ArrayList <GameObjects> gameObjects = new ArrayList<GameObjects>();
ArrayList <Bullets> bullets = new ArrayList<Bullets>();
Earth earth;
Enemy enemy1;

int gamestate;
final int START = 0;
final int RUNNING = 1;
final int GAMEOVER = 2;

boolean borderActive;
float border;
float bulletCount;
float bulletMax;
float timer;
float levelTimer;
boolean DEBUG = true;
int score;

void setup()
{
  size(800, 600);
  colorMode(HSB, 100);
  imageMode(CENTER);
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER);
  
  gamestate = 1;
  border = 100;
  levelTimer = 0;
  timer = 0;
  score = 0;
  bulletMax = 10;
  
  gameObjects.add(earth = new Earth());     

}

void draw()
{
  background(0);
  
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
  
  if(DEBUG)
  {
    fill(0);
    text("Bullets " + bulletCount, 20, 20);
  }
}

void gameStart()
{
  if(mousePressed)gamestate++;
}

void gameRunning()
{
  timer++;
  levelTimer++;
  renderWall();
  showScore();
  
  //spawn bullets
  if(mousePressed && bulletCount < bulletMax && timer - 10 > 0)
  {
    timer = 0;
    gameObjects.add( new Bullets(earth.position.x, earth.position.y) );
    bulletCount++;
  }
  
  //out of bullets msg
  if(mousePressed && bulletCount == bulletMax)
  {
    fill(100);
    textSize(15);
    text("Still regenerating!", earth.position.x, earth.position.y);
  }
  
  //spawn enemies
  fill(100);
  text(levelTimer, 100, 100);
  if(frameCount % 180 == 0) gameObjects.add(new Enemy(0.001));
  if(levelTimer > 1000 && frameCount % 180 == 0) gameObjects.add(new Enemy(0.0015));
  if(levelTimer > 8000 && frameCount % 150 == 0) gameObjects.add(new Enemy(0.0025));
  
  if(levelTimer == random(1000, 2000)) gameObjects.add(new SpecialEnemy(1));
  if(levelTimer == random(1000, 2000)) gameObjects.add(new SpecialEnemy(1));
  if(levelTimer == random(2000, 3000)) gameObjects.add(new SpecialEnemy(3));
  if(levelTimer == random(2000, 3000)) gameObjects.add(new SpecialEnemy(3));
  if(levelTimer > 5000 && frameCount % 200 == 0) gameObjects.add(new SpecialEnemy(5));
  
  //game object manager
  for(int i = gameObjects.size() - 1; i > -1; i--)
  {
    GameObjects obj = gameObjects.get(i);
    obj.update();
    obj.render();
    
    if(obj.isDead()) gameObjects.remove(i);
  }
}

void gameOver()
{
  if(mousePressed)gamestate--;
}
