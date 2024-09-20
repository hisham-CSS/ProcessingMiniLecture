int totalSteps = 8;  // Total number of loading steps - call one more updateProgress (9 instead of 8) so that 100% shows up on the screen
int currentStep = 0;  // Current progress through the loading steps

boolean gameLoaded = false;
float loadingProgress = 0;

void loadGame()
{
  updateProgress(); 
  // Initialize systems
  movementSystem = new MovementSystem();
  updateProgress(); 
  renderSystem = new RenderSystem();
  updateProgress(); 
  particleSystem = new ParticleSystem();
  
  updateProgress(); 
  
  //Create player
  Entity player = createPlayer();
  aiMoveSystem = new AIMoveSystem(player.getComponent("Transform"));
  updateProgress(); 
  
  //PARALLAX SECTION
  // Load images for each parallax layer
  PImage layer1 = loadImage("background_far.png");  // Furthest layer
  PImage layer2 = loadImage("background_mid.png");  // Middle layer
  PImage layer3 = loadImage("background_mid-2.png"); // Middle Layer
  PImage layer4 = loadImage("background_near.png"); // Nearest layer
  updateProgress(); 
  // Create parallax layers with different speeds
  parallaxLayers = new ParallaxLayerComponent[] {
      new ParallaxLayerComponent(layer1, 1.5),
      new ParallaxLayerComponent(layer2, 2.0),
      new ParallaxLayerComponent(layer3, 3.0),
      new ParallaxLayerComponent(layer4, 4.0)
  };
  updateProgress(); 
  parallaxScrollingSystem = new ParallaxScrollingSystem(parallaxLayers, player.getComponent("Transform"));
  
  //PARALLAX SECTION
  updateProgress();
  
  //create inital wave of enemies
  createEnemy(new PVector(100, 100));
  createEnemy(new PVector(200, 100));
  createEnemy(new PVector(300, 100));
  createEnemy(new PVector(400, 100));
  createEnemy(new PVector(500, 100));
  
  //load background music and play
  music = new SoundFile(this, "music.mp3");
  explosionSound = new SoundFile(this, "explosion.wav");
  music.loop();
  
  //Global sound class with a static variable for all sound in the sketch
  Sound.volume(0.1f);
  updateProgress(); 
  gameLoaded = true;
}

//load the game with a circle that fills up
void drawLoadingAnimation() {
    background(0);

    // Draw a "filling" circle animation based on loading progress
    fill(50);
    ellipse(width / 2, height / 2, 200, 200);  // Circle background

    // Draw the filling arc based on the loading progress
    float angle = TWO_PI * loadingProgress;  // Circular progression based on progress
    fill(0, 102, 153);
    arc(width / 2, height / 2, 200, 200, -HALF_PI, -HALF_PI + angle, PIE);

    // Draw text indicating progress
    fill(255);
    textAlign(CENTER);
    textSize(20);
    text("Loading... " + (int)(loadingProgress * 100) + "%", width / 2, height - 100);
}

//update the progress  bar
void updateProgress() {
    currentStep++;  // Increment the step count
    loadingProgress = currentStep / (float) totalSteps;  // Calculate progress as a percentage
}
