Entity createPlayer()
{
    Entity playerEntity = new Entity();
    
    //create components and associate to entity
    TransformComponent playerTransform = new TransformComponent(new PVector(width / 2, height / 2), new PVector(0, 0));
    LookComponent playerLook = new LookComponent(color(0, 255, 0), 20, playerTransform, true);
    playerEntity.addComponent(playerTransform);
    playerEntity.addComponent(playerLook);

    //register component to system
    movementSystem.registerComponent(TransformComponent.class, playerTransform);
    renderSystem.registerComponent(LookComponent.class, playerLook);
    
    //load player sound files
    SoundFile shootSound = new SoundFile(this, "shoot.wav");

    //create the input control system and the AI Move System that requires the playerTransform component
    playerControlSystem = new PlayerControlSystem(playerTransform, movementSystem, renderSystem, shootSound);
    aiMoveSystem = new AIMoveSystem(playerTransform);
    return playerEntity;
}

Entity createEnemy(PVector spawnLocation)
{
  Entity enemy = new Entity();
  TransformComponent enemyTransform = new TransformComponent(spawnLocation, new PVector(0,0));
  LookComponent enemyLook = new LookComponent(color(255,0,0),20,enemyTransform, true);
  enemy.addComponent(enemyTransform);
  enemy.addComponent(enemyLook);
  // Add AI entities with initial positions and velocities
  aiMoveSystem.registerComponent(TransformComponent.class, enemyTransform);
  renderSystem.registerComponent(LookComponent.class, enemyLook);
  
  return enemy;
}

Entity CreateExplosion(PVector spawnPoint)
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
    particleLook[i] = new LookComponent(color(random(0,255), 0, 0), 20, particleTransform[i], false);
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
