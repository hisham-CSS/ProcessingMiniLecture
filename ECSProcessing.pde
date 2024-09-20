import processing.sound.*;
import java.lang.reflect.Array;

//Systems that are required to build our engine
RenderSystem renderSystem;
MovementSystem movementSystem;
PlayerControlSystem playerControlSystem;


AIMoveSystem aiMoveSystem;
ParticleSystem particleSystem;


//Parallax Scrolling which is pretty much it's own system of backgrounds overlayed on each other to create a scrolling effect
ParallaxScrollingSystem parallaxScrollingSystem;
ParallaxLayerComponent[] parallaxLayers;

//soundfile that is playing the background music
SoundFile music;
SoundFile explosionSound;

void setup() {
    size(800, 800, P2D);
    ellipseMode(RADIUS);
    thread("loadGame");
    
    
    
}

void draw() {   
  if (gameLoaded)
  {
    
    // Update player control system first
    playerControlSystem.update();
    aiMoveSystem.update();
    parallaxScrollingSystem.update();
    particleSystem.update();
    // Update systems
    movementSystem.update();
    renderSystem.update();
  }
  else {
    drawLoadingAnimation();
  }
}

void keyPressed() {
    playerControlSystem.keyPressed(key);
}

void keyReleased() {
    playerControlSystem.keyReleased(key);
}
