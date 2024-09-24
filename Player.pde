Entity createPlayer()
{
    Entity playerEntity = new Entity();
    
    //create components and associate to entity
    TransformComponent playerTransform = new TransformComponent(new PVector(width / 2, height / 2), 
                                                                new PVector(0, 0));
    
    //Green player - radius of 20
    LookComponent playerLook = new LookComponent(color(0, 255, 0), 
                                                 20, 
                                                 playerTransform);
    
    
    //CollisionFlags of Enemy and EnemyBullet with CollisionID set as Player
    CollisionComponent collision = new CollisionComponent(playerLook, 
                                                          EnumSet.of(CollisionFlags.ENEMY, CollisionFlags.ENEMYBULLET), 
                                                          CollisionFlags.PLAYER);
                                                          
    
    
    //entity stores components in a hashmap - supports method chaining
    playerEntity.addComponent(playerTransform)
                .addComponent(playerLook)
                .addComponent(collision);

    //register component to system
    movementSystem.registerComponent(TransformComponent.class, playerTransform);
    renderSystem.registerComponent(LookComponent.class, playerLook);
    collisionSystem.registerComponent(CollisionComponent.class, collision);

    //create the input control system and the AI Move System that requires the playerTransform component
    playerControlSystem = new PlayerControlSystem(playerTransform, movementSystem, renderSystem);
    aiMoveSystem = new AIMoveSystem(playerTransform);
    
    collision.addListener(playerControlSystem);
    return playerEntity;
}

Entity createBullet(PVector spawnLocation, PVector velocity, EnumSet<CollisionFlags> collisionFlags)
{
  Entity bullet = new Entity();
  TransformComponent transform = new TransformComponent(spawnLocation, velocity);
  LookComponent look = new LookComponent(color(255, 255, 255), 5, transform);
  CollisionComponent collision = new CollisionComponent(look, collisionFlags, CollisionFlags.PLAYERBULLET);
  collision.addListener(playerBulletCollision);
  
  bullet.addComponent(transform)
        .addComponent(look)
        .addComponent(collision);
  
  movementSystem.registerComponent(TransformComponent.class, transform);
  renderSystem.registerComponent(LookComponent.class, look);
  collisionSystem.registerComponent(CollisionComponent.class, collision);
  
  return bullet;
}

class PlayerControlSystem implements CollisionEvent {
    MovementSystem movementSystem;
    RenderSystem renderSystem;
    TransformComponent playerTransform;
    float speed = 5.0;

    boolean upPressed = false;
    boolean downPressed = false;
    boolean leftPressed = false;
    boolean rightPressed = false;
    
    
    
    //Dependancy Injection
    PlayerControlSystem(TransformComponent playerTransform, MovementSystem movementSystem, RenderSystem renderSystem) {
        this.playerTransform = playerTransform;
        this.movementSystem = movementSystem;
        this.renderSystem = renderSystem;
    }

    void keyPressed(char key) {
        if (key == 'w' || key == 'W') {
            upPressed = true;
        } else if (key == 's' || key == 'S') {
            downPressed = true;
        } else if (key == 'a' || key == 'A') {
            leftPressed = true;
        } else if (key == 'd' || key == 'D') {
            rightPressed = true;
        } else if (key == ' ') {
            shoot();
        }

        updateDirection();
    }

    void keyReleased(char key) {
        if (key == 'w' || key == 'W') {
            upPressed = false;
        } else if (key == 's' || key == 'S') {
            downPressed = false;
        } else if (key == 'a' || key == 'A') {
            leftPressed = false;
        } else if (key == 'd' || key == 'D') {
            rightPressed = false;
        }

        updateDirection();
    }

    private void updateDirection() {
        float dx = 0;
        float dy = 0;

        if (upPressed) {
            dy -= 1;
        }
        if (downPressed) {
            dy += 1;
        }
        if (leftPressed) {
            dx -= 1;
        }
        if (rightPressed) {
            dx += 1;
        }

        setDirection(dx, dy);
    }

    void setDirection(float dx, float dy) {
      if (playerTransform != null) {
        PVector newVel = new PVector(dx, dy);
        newVel.normalize();
        PVector.mult(newVel, speed, playerTransform.velocity);
      }
    }

    void shoot() {
      EnumSet<CollisionFlags> flags = EnumSet.of(CollisionFlags.ENEMY);
      createBullet(new PVector(playerTransform.position.x, playerTransform.position.y - 30), new PVector(0, -5), flags);
        
      shootSound.play();
    }

    void update() {
      if (playerTransform != null) {
        playerTransform.position = new PVector(constrain(playerTransform.position.x, 0, width), constrain(playerTransform.position.y, 0, height));    
      }
    }
    
    void onCollision(CollisionComponent myCollider, CollisionComponent collidedObject)
    {
      //println("player collisions");
    }
}
