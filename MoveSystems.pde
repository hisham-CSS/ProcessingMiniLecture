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
