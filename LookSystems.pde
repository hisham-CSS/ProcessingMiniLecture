//Covers the creation of the player, bullets and enemies. 
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
    }    
}

//responsible for creating and managing the explosions.
class ExplosionSystem extends SystemBase
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

//responsible for creating and managing the parallax scrolling system
class ParallaxScrollingSystem {
  ParallaxLayerComponent[] layerArray;
  
  //inject the appropriate dependancies into the parallax system - this includes the array of parrallax components and the player transform
  ParallaxScrollingSystem(ParallaxLayerComponent[] layerArray)
  {
    this.layerArray = layerArray;
  }
  
   void update() {
     for (ParallaxLayerComponent layer : layerArray) {
        //println("scrolling layer");
        layer.offsetY += layer.speed;
        
        if (layer.offsetY > layer.image.height) {
            layer.offsetY -= layer.image.height;
        }
        
        image(layer.image, 0, layer.offsetY);
        image(layer.image, 0, layer.offsetY - layer.image.height);
      }
    }
}
