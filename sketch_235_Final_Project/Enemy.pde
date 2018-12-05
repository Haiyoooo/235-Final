class Enemy extends GameObject
{
  PVector zonePos;
  float zone;
  float sugar;
  float sugar_full;
  float attackDelay;
  
  final int FULL = 0;
  final int SEARCHING = 1;
  final int CHASING = 2;
  final int ATTACK = 3;

  Enemy(float posX, float posY)
  {
    tab = "enemy";
    wetness = 50;
    position = new PVector(posX, posY);
    size = 100;
    state = FULL;
    
    sugar = enemyStartSugar;
    sugar_full = enemyFullSugar;
    attackDelay = 60;
    
    zonePos = new PVector(posX, posY);
    zone = 400;
  }
  
  void update()
  {
    println("Enemy sugar " + enemy1.sugar + " " + enemy1.state);
    
    //teleport offscreen enemies to random position
    if (zonePos.x < 0 || zonePos.x > width || zonePos.y > height || zonePos.y < 230 )
    {
      zonePos.set(random(0, width), random(230, height));
    }
    
    isAggro();
    
    if(night)
    {
      switch(state)
      {
        case FULL:
          fullUpdate();
          break;
        case SEARCHING:
          searchingUpdate();
          break;
        case CHASING:
          chasingUpdate();
          break;
        case ATTACK:
          attackUpdate();
          break;
      } 
    }

  }
  
  void fullUpdate()
  {
    zonePos.add( random(-1, 0), random(-3, 3) );
    sugar -= enemyBurnSugarRate;
    position.x = easeOut(position.x, zonePos.x, 0.002);
    position.y = easeOut(position.y, zonePos.y, 0.002);
    if(sugar <= 0) state = SEARCHING;
  }
  
  void searchingUpdate()
  {
     zonePos.add( random(-1, 0), random(-5, 5) );
    position.x = easeOut(position.x, zonePos.x, 0.002);
    position.y = easeOut(position.y, zonePos.y, 0.002);
     if(isAggro()) state = CHASING;
  }
  
  void chasingUpdate()
  {
    position.x = easeOut(position.x, player.position.x, ease);
    position.y = easeOut(position.y, player.position.y, ease);
    if(inAttackRange()) state = ATTACK;
  }
  
  void attackUpdate()
  {
    textSize(40);
    text("Moo-moo's eating your sugar!!!", 10, 600);
    
    if(gameTimer - attackDelay > atkTimer)
    {
      player.sugar -= enemyEatRate;
      sugar += enemyEatRate;
      textSize(40);
      text("ATTACK", 10, 600);
      atkTimer = gameTimer;
    }

    screenshake = true;
    
    if(sugar > sugar_full) state = FULL;
    else if(!inAttackRange() && gameTimer - atkTimer > 10) state = CHASING; //delay
  }
  

  
  void render()
  {
    if(night)
    {    
    if(night)
    {
      switch(state)
      {
        case FULL:
          size = 100;
          fullUpdate();
          break;
        case SEARCHING:
          size = 50;
          fill(50, 50, 50, 10);
          ellipse(zonePos.x, zonePos.y, zone, zone);
          searchingUpdate();
          break;
        case CHASING:
          size = 50;
          fill(100, 80, 80, 20);
          ellipse(zonePos.x, zonePos.y, zone, zone);
          chasingUpdate();
          break;
        case ATTACK:
          size = 50;
          tint(100, 80, 80);
          attackUpdate();
          break;
      } 
    }
      image(enemy_cow, position.x, position.y, size, 100);
    }
  }
  
  
  boolean inAttackRange()
  {
    if(playerDistanceTo(position) < size/2 && night)
    {
      return true;
    }
    else
    {
      screenshake = false;
      return false;
    }
  }
  
  boolean isAggro()
  {
     if(playerDistanceTo(zonePos) < zone/2) return true;
     else return false;
  }
  
}
