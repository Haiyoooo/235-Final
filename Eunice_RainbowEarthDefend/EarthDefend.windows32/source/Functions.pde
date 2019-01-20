boolean checkCollision(PVector position, PVector other, float size, float otherSize)
{
  float distance = pow(position.y - other.y, 2) + pow(position.x - other.x, 2);
  float sumRadiusSq = pow(size/2 + otherSize/2, 2);
  
  if(distance < sumRadiusSq) return true;
  else return false;
}

void renderWall()
{
    float xPos = map(mouseX, 0, width, 0, 100);
    stroke(xPos, 50, 100, 50);
    strokeWeight(5);
    noFill();
    rectMode(CENTER);
    rect(width/2, height/2, width* .8, height * .8);
}

void showScore()
{
  fill(100);
  textSize(30);
  text(score, width/2, 50);
}
