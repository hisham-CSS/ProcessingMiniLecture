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

//Responsible for updating all object positions by applying this cycles velocity
class MovementSystem extends SystemBase {
    void update() {
      TransformComponent[] transforms = getComponents(TransformComponent.class);
      
      //no transform components to update
      if (transforms.length <= 0) return;
      
      //update all transform components
      for (TransformComponent transform : transforms)
      {
        //if the current component isn't active - do not do anything and continue to the next element in the loop
        if (transform.isActive == false) continue;
        
        //apply velocity to the position for this draw cycle
        transform.position = new PVector(transform.position.x + transform.velocity.x, transform.position.y + transform.velocity.y);
        
        //if the element leaves the screen - we no longer update it by changing the transform component's activation to false
        if (transform.position.x < -5 || transform.position.y < -5 || transform.position.x > width + 5 || transform.position.y > height + 5)
            transform.isActive = false;
      }
    }
}

class AIMoveSystem extends SystemBase
{
    TransformComponent playerTransform;
    float maxSpeed = 2.0;        // Maximum speed the AI can move at
    float slowingRadius = 50;    // Radius for slowing down as AI approaches the player

    // Constructor: Pass in the player's transform so the AI knows the player's position
    AIMoveSystem(TransformComponent playerTransform) {
        this.playerTransform = playerTransform;
    }

    // Update method to control the AI movement
    void update() {
      TransformComponent[] transforms = getComponents(TransformComponent.class);
        // Iterate over all AI entities (transform components) in the system
        for (TransformComponent aiTransform : transforms) {
            if (!aiTransform.isActive) continue;  // Skip inactive AI entities

            // Calculate the steering force to seek the player
            PVector steering = seek(aiTransform, playerTransform.position);
            
            // Update the AI's velocity with the calculated steering force
            aiTransform.velocity.add(steering);
            aiTransform.velocity.limit(maxSpeed);  // Limit AI's velocity to prevent overspeeding

            // Update the AI's position by adding its velocity
            aiTransform.position.add(aiTransform.velocity);
        }
    }

    // Seek behavior: Calculate steering force to move AI toward the player
    PVector seek(TransformComponent aiTransform, PVector targetPosition) {
        // Calculate the desired velocity: direction toward the player
        PVector desiredVelocity = PVector.sub(targetPosition, aiTransform.position);

        // Get the distance to the target (player)
        float distance = desiredVelocity.mag();

        // If AI is within the slowing radius, slow it down as it approaches the player
        if (distance < slowingRadius) {
            desiredVelocity.setMag(map(distance, 0, slowingRadius, 0, maxSpeed));
        } else {
            // Otherwise, move at full speed toward the target
            desiredVelocity.setMag(maxSpeed);
        }

        // Calculate the steering force: desired velocity minus the current velocity
        return PVector.sub(desiredVelocity, aiTransform.velocity);
    }
}
class RenderSystem extends SystemBase {
    void update() {
        LookComponent[] lookComponents = getComponents(LookComponent.class);
        if (lookComponents.length <= 0) return;
        
        // First, render the objects
        for (LookComponent look : lookComponents) {
            if (!look.isActive) continue;
            
            // Draw the circle
            fill(look.colour);
            ellipse(look.transform.position.x, look.transform.position.y, look.size, look.size);

            // Check if the object moves off-screen and deactivate it
            if (look.transform.position.x < -5 || look.transform.position.y < -5 ||
                look.transform.position.x > width + 5 || look.transform.position.y > height + 5) {
                look.isActive = false;
            }
        }

        // Then, perform collision detection between collidable objects
        for (int i = 0; i < lookComponents.length; i++) {
            LookComponent look1 = lookComponents[i];
            if (!look1.collidable || !look1.isActive) continue;

            for (int j = i + 1; j < lookComponents.length; j++) {
                LookComponent look2 = lookComponents[j];
                if (!look2.collidable || !look2.isActive) continue;

                // Check for collisions between look1 and look2
                if (isColliding(look1, look2)) {
                    handleCollision(look1, look2);
                }
            }
        }
    }

    // Check if two LookComponents (circles) are colliding
    boolean isColliding(LookComponent a, LookComponent b) {
        // Calculate the distance between the two circle centers
        float dx = a.transform.position.x - b.transform.position.x;
        float dy = a.transform.position.y - b.transform.position.y;
        float distance = sqrt(dx * dx + dy * dy);

        // Sum of the radii
        float radiusA = a.size / 2;
        float radiusB = b.size / 2;
        float radiusSum = radiusA + radiusB;

        // Return true if the distance is less than or equal to the sum of the radii
        return distance <= radiusSum;
    }

    // Handle the collision between two LookComponents
    void handleCollision(LookComponent a, LookComponent b) {
        // Example: Deactivate both objects on collision (you can replace this with any other logic)
        a.isActive = false;
        b.isActive = false;
        CreateExplosion(a.transform.position);
    }
}

class ParticleSystem extends SystemBase
{
  void update()
  {
    TransformComponent transformComponents[] = getComponents(TransformComponent.class);
    LookComponent lookComponents[] = getComponents(LookComponent.class);
    if (transformComponents == null) return;
    for(int i = 0; i < transformComponents.length; i++)
    {
      //if the current component isn't active - do not do anything and continue to the next element in the loop
         if (transformComponents[i].isActive == false) continue;
         if (lookComponents[i].isActive == false) continue;
         
         fill(lookComponents[i].colour);
         ellipse(lookComponents[i].transform.position.x, lookComponents[i].transform.position.y, lookComponents[i].size, lookComponents[i].size);
         lookComponents[i].size -= 0.6;
         
         //apply velocity to the position for this draw cycle
         transformComponents[i].position = new PVector(transformComponents[i].position.x + transformComponents[i].velocity.x, transformComponents[i].position.y + transformComponents[i].velocity.y);
          
          
          //if the element leaves the screen - we no longer update it by changing the transform component's activation to false
        if (lookComponents[i].size <= 0 || transformComponents[i].position.x < -5 || transformComponents[i].position.y < -5 || transformComponents[i].position.x > width + 5 || transformComponents[i].position.y > height + 5)
        {
            transformComponents[i].isActive = false;
            lookComponents[i].isActive = false;
        }
   }
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
        Entity bullet = new Entity();
        TransformComponent transform = new TransformComponent(new PVector(playerTransform.position.x, playerTransform.position.y - 20), new PVector(0, -5));
        LookComponent look = new LookComponent(color(255, 255, 255), 5, transform, true);
        bullet.addComponent(transform);
        bullet.addComponent(look);
        movementSystem.registerComponent(TransformComponent.class, transform);
        renderSystem.registerComponent(LookComponent.class, look);
        
        shootSound.play();
    }

    void update() {
      if (playerTransform != null) {
        playerTransform.position = new PVector(constrain(playerTransform.position.x, 0, width), constrain(playerTransform.position.y, 0, height));    
      }
    }
}

class ParallaxScrollingSystem {
  ParallaxLayerComponent[] layerArray;
  TransformComponent playerTransform;
  
  //inject the appropriate dependancies into the parallax system - this includes the array of parrallax components and the player transform
  ParallaxScrollingSystem(ParallaxLayerComponent[] layerArray, TransformComponent playerTransform)
  {
    this.layerArray = layerArray;
    this.playerTransform = playerTransform;
  }
  
   void update() {
     for (ParallaxLayerComponent layer : layerArray) {
        
        layer.offsetY += layer.speed - (playerTransform.velocity.y / 2);
        
        if (layer.offsetY > layer.image.height) {
            layer.offsetY -= layer.image.height;
        }
        
        image(layer.image, 0, layer.offsetY);
        image(layer.image, 0, layer.offsetY - layer.image.height);
      }
    }
  
}
