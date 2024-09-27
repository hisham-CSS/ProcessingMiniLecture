import processing.sound.*;
import java.util.EnumSet;
import java.lang.reflect.Array;

//Systems that are required to build our engine
RenderSystem renderSystem;
MovementSystem movementSystem;
PlayerControlSystem playerControlSystem;
CollisionSystem collisionSystem;
MenuSystem menuSystem;
AIMoveSystem aiMoveSystem;
GameSystem gameSystem = new GameSystem();


//system that spawns 8 items that slowly scale down over time
ExplosionSystem explosionSystem;


//Parallax Scrolling which is pretty much it's own system of backgrounds overlayed on each other to create a scrolling effect
ParallaxScrollingSystem parallaxScrollingSystem;
ParallaxLayerComponent[] parallaxLayers;

//soundfile that is playing the background music and the explosion sound
SoundFile music;
SoundFile explosionSound;
SoundFile shootSound;

void setup() {
    size(800, 800, P2D);
    //fullScreen(P2D);
    textFont(createFont("SPACE.ttf", 64));
    
    ellipseMode(RADIUS);
    
    //load on a seperate thread so that we don't hang the application when initally loading
    Thread loadingThread = new Thread(new LoadingThread(this));
    loadingThread.start();
}

void draw() {   
  if (!gameLoaded) drawLoadingAnimation();
  else 
  {
    if (!gamePlaying)
    {
      //load background music and play
      parallaxScrollingSystem.update();
      menuSystem.updateHoverState(mouseX, mouseY);
      menuSystem.update();
      menuSystem.renderMenu();
    }
    else
    {
      parallaxScrollingSystem.update();
      //update player input and AI input for the frame
      playerControlSystem.update();
      aiMoveSystem.update();
      
      //update any explosions that may be active
      explosionSystem.update();
      
      //Update all entity positions, render entities then check for collisions
      movementSystem.update();
      renderSystem.update();
      collisionSystem.update();
    }
  }
}

void mousePressed() {
    menuSystem.handleInput(true);
}

void keyPressed() {
    playerControlSystem.keyPressed(key);
}

void keyReleased() {
    playerControlSystem.keyReleased(key);
}
