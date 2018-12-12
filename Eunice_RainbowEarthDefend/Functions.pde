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

void addParticles() //Can i put this under the mover class?
{
   if (mousePressed && (mouseButton == RIGHT) && bulletCount < 20 )
  {
     gameObjects.add( new Bullets(earth.position.x, earth.position.y) );
  }
}
