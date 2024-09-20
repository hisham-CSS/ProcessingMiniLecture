import processing.sound.*;
import java.util.EnumSet;
import java.lang.reflect.Array;

//Systems that are required to build our engine
RenderSystem renderSystem;
MovementSystem movementSystem;
PlayerControlSystem playerControlSystem;
CollisionSystem collisionSystem;

AIMoveSystem aiMoveSystem;
ExplosionSystem explosionSystem;


//Parallax Scrolling which is pretty much it's own system of backgrounds overlayed on each other to create a scrolling effect
ParallaxScrollingSystem parallaxScrollingSystem;
ParallaxLayerComponent[] parallaxLayers;

//soundfile that is playing the background music
SoundFile music;
SoundFile explosionSound;

void setup() {
    size(800, 800, P2D);
    ellipseMode(RADIUS);
    //load audio
    music = new SoundFile(this, "music.mp3");
    explosionSound = new SoundFile(this, "explosion.wav");
    
    Thread loadingThread = new Thread(new LoadingThread());
    loadingThread.start();
    //thread("loadGame");
}

void draw() {   
  if (!gameLoaded)
  {  
    drawLoadingAnimation();
  }
  else {
    //load background music and play
    parallaxScrollingSystem.update();
    // Update player control system first
    playerControlSystem.update();
    aiMoveSystem.update();
    
    explosionSystem.update();
    // Update systems
    movementSystem.update();
    renderSystem.update();
    collisionSystem.update();
  }
}

void keyPressed() {
    playerControlSystem.keyPressed(key);
}

void keyReleased() {
    playerControlSystem.keyReleased(key);
}
