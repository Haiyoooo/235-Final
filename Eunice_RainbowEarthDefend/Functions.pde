boolean checkCollision(PVector position, PVector other, float size, float otherSize)
{
  // distance = radius1 + radius2 = sq root ( A^2 + O^2 )
  // square both sides
  //(radius1 + radius2)^2 = A^2 + O^2
  // use squaring instead of square rooting so the code is more efficient
  float distance = pow(position.y - other.y, 2) + pow(position.x - other.x, 2);
  float sumRadiusSq = pow(size/2 + otherSize/2, 2);
  
  if(distance < sumRadiusSq) return true;
  else return false;
}

void renderWall()
{
  if(borderActive)
  {
    float xPos = map(mouseX, 0, width, 0, 100);
    stroke(xPos, 50, 100, 50);
    strokeWeight(5);
    noFill();
    rectMode(CENTER);
    rect(width/2, height/2, width - border * 2, height - border * 2);
  }
}

void showScore()
{
  fill(100);
  textSize(30);
  text(score, width/2, 50);
}
