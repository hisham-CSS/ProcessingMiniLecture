class SystemBase {
     private HashMap<Class<?>, Component[]> componentMap = new HashMap<>();

    // Registers a component of a specific type
    public <T extends Component> void registerComponent(Class<T> componentType, T component) {
        Component[] components = componentMap.get(componentType);

        if (components == null) {
            // No array exists for this component type, create a new one
            components = (T[]) Array.newInstance(componentType, 1);
            components[0] = component;
            componentMap.put(componentType, components);
            return;
        }

        // Look for an inactive component to reuse
        for (int i = 0; i < components.length; i++) {
            if (!components[i].isActive) {
                components[i] = component;
                component.isActive = true;
                return;
            }
        }

        // If no inactive component is found, resize the array
        Component[] newArray = (T[]) Array.newInstance(componentType, components.length + 1);
        System.arraycopy(components, 0, newArray, 0, components.length);
        newArray[newArray.length - 1] = component;

        // Update the map with the new array
        componentMap.put(componentType, newArray);
    }

    // Retrieves all components of a specific type
    public <T extends Component> T[] getComponents(Class<T> componentType) {
        return (T[]) componentMap.get(componentType);
    }
}

class CollisionSystem extends SystemBase
{
  void update()
  {
    CollisionComponent[] colliders = getComponents(CollisionComponent.class);
   
    for (int i = (colliders.length - 1); i > 0; i--)
    {
      if (colliders[i].collisionFlags.contains(colliders[i-1].collisionID))
      {
        println(isColliding(colliders[i].look, colliders[i-1].look));
      }
    }
    
  }
  
  // Check if two LookComponents (circles) are colliding
  boolean isColliding(LookComponent a, LookComponent b) {
      // Calculate the distance between the two circle centers
      float distance = a.transform.position.dist(b.transform.position);
      
      // Sum of the radii
      float radiusSum = a.size + b.size;

      // Return true if the distance is less than or equal to the sum of the radii
      return distance <= radiusSum;
  }
}


class PlayerControlSystem {
    MovementSystem movementSystem;
    RenderSystem renderSystem;
    TransformComponent playerTransform;
    float speed = 2.0;

    boolean upPressed = false;
    boolean downPressed = false;
    boolean leftPressed = false;
    boolean rightPressed = false;
    
    SoundFile shootSound;
    
    //Dependancy Injection
    PlayerControlSystem(TransformComponent playerTransform, MovementSystem movementSystem, RenderSystem renderSystem, SoundFile shootSound) {
        this.playerTransform = playerTransform;
        this.movementSystem = movementSystem;
        this.renderSystem = renderSystem;
        this.shootSound = shootSound;
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
      EnumSet<CollisionFlags> flags = EnumSet.noneOf(CollisionFlags.class);
      flags.add(CollisionFlags.ENEMY);
      createBullet(new PVector(playerTransform.position.x, playerTransform.position.y - 30), new PVector(0, -5), flags);
        
      shootSound.play();
    }

    void update() {
      if (playerTransform != null) {
        playerTransform.position = new PVector(constrain(playerTransform.position.x, 0, width), constrain(playerTransform.position.y, 0, height));    
      }
    }
}
