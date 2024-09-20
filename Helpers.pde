Entity createPlayer()
{
    Entity playerEntity = new Entity();
    
    //create components and associate to entity
    TransformComponent playerTransform = new TransformComponent(new PVector(width / 2, height / 2), new PVector(0, 0));
    LookComponent playerLook = new LookComponent(color(0, 255, 0), 20, playerTransform);
    
    CollisionComponent collision = new CollisionComponent(playerLook, EnumSet.of(CollisionFlags.ENEMY, CollisionFlags.ENEMYBULLET), CollisionFlags.PLAYER);
    
    playerEntity.addComponent(playerTransform);
    playerEntity.addComponent(playerLook);
    playerEntity.addComponent(collision);


    //register component to system
    movementSystem.registerComponent(TransformComponent.class, playerTransform);
    renderSystem.registerComponent(LookComponent.class, playerLook);
    collisionSystem.registerComponent(CollisionComponent.class, collision);
    
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
  LookComponent enemyLook = new LookComponent(color(255,0,0),20,enemyTransform);
  
  CollisionComponent collision = new CollisionComponent(enemyLook, EnumSet.of(CollisionFlags.PLAYER, CollisionFlags.PLAYERBULLET), CollisionFlags.ENEMY);
  
  enemy.addComponent(enemyTransform);
  enemy.addComponent(enemyLook);
  enemy.addComponent(collision);
  // Add AI entities with initial positions and velocities
  aiMoveSystem.registerComponent(TransformComponent.class, enemyTransform);
  renderSystem.registerComponent(LookComponent.class, enemyLook);
  collisionSystem.registerComponent(CollisionComponent.class, collision);
  
  return enemy;
}

Entity createBullet(PVector spawnLocation, PVector velocity, EnumSet<CollisionFlags> collisionFlags)
{
  Entity bullet = new Entity();
  TransformComponent transform = new TransformComponent(spawnLocation, velocity);
  LookComponent look = new LookComponent(color(255, 255, 255), 5, transform);
  CollisionComponent collision = new CollisionComponent(look, collisionFlags, CollisionFlags.PLAYERBULLET);
  
  bullet.addComponent(transform);
  bullet.addComponent(look);
  bullet.addComponent(collision);
  
  movementSystem.registerComponent(TransformComponent.class, transform);
  renderSystem.registerComponent(LookComponent.class, look);
  collisionSystem.registerComponent(CollisionComponent.class, collision);
  
  return bullet;
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
    particleLook[i] = new LookComponent(color(random(0,255), 0, 0), 20, particleTransform[i]);
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
