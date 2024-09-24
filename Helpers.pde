Entity createEnemy(PVector spawnLocation)
{
  Entity enemy = new Entity();
  TransformComponent enemyTransform = new TransformComponent(spawnLocation, new PVector(0,0));
  LookComponent enemyLook = new LookComponent(color(255,0,0),20,enemyTransform);
  
  CollisionComponent collision = new CollisionComponent(enemyLook, EnumSet.of(CollisionFlags.PLAYER, CollisionFlags.PLAYERBULLET), CollisionFlags.ENEMY);
  
  enemy.addComponent(enemyTransform).addComponent(enemyLook).addComponent(collision);
  
  // Add AI entities with initial positions and velocities
  aiMoveSystem.registerComponent(TransformComponent.class, enemyTransform);
  renderSystem.registerComponent(LookComponent.class, enemyLook);
  collisionSystem.registerComponent(CollisionComponent.class, collision);
  
  return enemy;
}

Entity createExplosion(PVector spawnPoint)
{
  Entity explosion = new Entity();
  
  TransformComponent particleTransform[] = new TransformComponent[8];
  LookComponent particleLook[] = new LookComponent[8];
  
  particleTransform[0] = new TransformComponent(spawnPoint, UpLeft());
  particleTransform[1] = new TransformComponent(spawnPoint, UpRight()); 
  particleTransform[2] = new TransformComponent(spawnPoint, DownLeft()); 
  particleTransform[3] = new TransformComponent(spawnPoint, DownRight());
  particleTransform[4] = new TransformComponent(spawnPoint, Up());
  particleTransform[5] = new TransformComponent(spawnPoint, Right()); 
  particleTransform[6] = new TransformComponent(spawnPoint, Left()); 
  particleTransform[7] = new TransformComponent(spawnPoint, Down());
  
  for (int i = 0; i < particleTransform.length; i++)
  {
    particleLook[i] = new LookComponent(color(random(0,255), 0, 0), 20, particleTransform[i]);
    
    explosion.addComponent(particleTransform[i])
             .addComponent(particleLook[i]);
    
    explosionSystem.registerComponent(TransformComponent.class, particleTransform[i]);
    explosionSystem.registerComponent(LookComponent.class, particleLook[i]);
  }
  
  explosionSound.play();
  return explosion;
}

PVector Up()
{
  return new PVector(0, -1);
}
PVector Down()
{
  return new PVector(0, 1);
}
PVector Left()
{
  return new PVector(-1, 0);
}
PVector Right()
{
  return new PVector(1, 0);
}
PVector DownLeft()
{
  return new PVector(-1, 1).normalize();
}
PVector DownRight()
{
  return new PVector(1, 1).normalize();
}
PVector UpLeft()
{
  return new PVector(-1, -1).normalize();
}
PVector UpRight()
{
  return new PVector(1, -1).normalize();
}
