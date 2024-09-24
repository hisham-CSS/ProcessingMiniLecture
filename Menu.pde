import java.util.Stack;

boolean gamePlaying = false;

//Stores entities as groups which make up our menus
class Menu {
    ArrayList<Entity> entities = new ArrayList<>();
    MenuTypes menuType;
    
    Menu(MenuTypes menuType)
    {
      this.menuType = menuType;
    }

    public Menu addEntity(Entity entity) {
        entities.add(entity);
        return this;
    }

    public ArrayList<Entity> getEntities() {
        return entities;
    }
}

public enum MenuTypes
{
  MAINMENU, INGAME, PAUSE, GAMEOVER, DIALOG
}

//***************************
//COMPONENTS
//***************************
class ButtonComponent extends Component {
    String label;
    float x, y, w, h;
    int textSize;
    boolean isHovered = false;
    Runnable onClick;

    ButtonComponent(String label, float x, float y, float w, float h, int textSize, Runnable onClick) {
        this.label = label;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.textSize = textSize;
        this.onClick = onClick;
    }

    // Adjust hover check for rectMode(CENTER)
    public boolean checkHover(float mouseX, float mouseY) {
        float halfWidth = w / 2;
        float halfHeight = h / 2;
        
        // Check if mouse is within the button's bounds, considering center mode
        return mouseX > x - halfWidth && mouseX < x + halfWidth &&
               mouseY > y - halfHeight && mouseY < y + halfHeight;
    }
}

//TEXT COMPONENT FOR DISPLAYING STANDARD TEXT
class TextComponent extends Component {
    String text;
    float x, y;

    TextComponent(String text, float x, float y) {
        this.text = text;
        this.x = x;
        this.y = y;
    }
}

//ANIMATED TEXT COMPONENT THAT ANIMATES THE TEXT FROM THE TOP OF THE SCREEN
class AnimatedTextComponent extends Component {
    String text;
    int textSize;
    float x, y, targetY;
    float speed = 2;  // Speed of the animation

    AnimatedTextComponent(String text, int textSize, float x, float startY, float targetY) {
        this.text = text;
        this.textSize = textSize;
        this.x = x;
        this.y = startY;
        this.targetY = targetY;
    }

    // Update the position of the text to move it towards targetY
    public void update() {
        if (y < targetY) {
            y += speed;  // Move down by speed
            if (y > targetY) y = targetY;  // Ensure it doesn't overshoot
        }
    }
}
//***************************
//COMPONENTS
//***************************

//MENU SYSTEM CLASS THAT IS UNIQUE SO IT DOES NOT EXTEND FROM SYSTEM BASE - IT IS A STACK BASED MENU
class MenuSystem {
    private Stack<Menu> menuStack = new Stack<>();
    HashMap<MenuTypes, Menu> menuObjects = new HashMap<MenuTypes, Menu>();
    
    public void addMenuObject(Menu menuToAdd)
    {
      if (menuObjects.get(menuToAdd.menuType) != null) return;
      menuObjects.put(menuToAdd.menuType, menuToAdd);
    }
    
    // Add a new menu to the system (i.e., push it onto the stack)
    public void pushMenu(Menu menu) {
        menuStack.push(menu);
    }

    // Remove the top menu from the stack
    public void popMenu() {
        if (!menuStack.isEmpty()) {
            menuStack.pop();
        }
    }
    
    public void update() {
        if (!menuStack.isEmpty()) {
            Menu currentMenu = menuStack.peek();

            for (Entity entity : currentMenu.getEntities()) {
                // Check for AnimatedTextComponent and update it
                AnimatedTextComponent animatedText = entity.getComponent(AnimatedTextComponent.class);
                if (animatedText != null) {
                    animatedText.update();  // Update position
                }
            }
        }
    }

    // Check hover state continuously based on current mouse position
    public void updateHoverState(float mouseX, float mouseY) {
        if (!menuStack.isEmpty()) {
            Menu currentMenu = menuStack.peek();

            for (Entity entity : currentMenu.getEntities()) {
                ButtonComponent button = entity.getComponent(ButtonComponent.class);

                if (button != null && button.isActive) {
                    // Check if the mouse is hovering over the button
                    button.isHovered = button.checkHover(mouseX, mouseY);
                }
            }
        }
    }

    public void renderMenu() {
        if (!menuStack.isEmpty()) {
            Menu currentMenu = menuStack.peek();

            for (Entity entity : currentMenu.getEntities()) {
                ButtonComponent button = entity.getComponent(ButtonComponent.class);
                AnimatedTextComponent animatedText = entity.getComponent(AnimatedTextComponent.class);
                TextComponent text = entity.getComponent(TextComponent.class);
                
                if (button != null && button.isActive) {
                    drawButton(button);
                }

                if (animatedText != null) {
                    drawText(animatedText);
                }
                
                if (text != null) {
                  drawText(text);
                }
            }
        }
    }
    
    private void drawText(AnimatedTextComponent text) {
        fill(0);
        textAlign(CENTER, CENTER);  // Align text to center
        textSize(text.textSize);
        int baseColour = color(50, 100, 255);
        
        //Add drop shadow
        for (int i = 5; i > 0; i--)
        {
          int layerShade = baseColour - (i * color(50,100,255));
          fill(layerShade);
          text(text.text, text.x + i + 3, text.y + 3 + i, width, 200);
        }
        
        fill(baseColour);
        
        text(text.text, text.x, text.y, width, 200);  // Draw at current position
    }

    // Handle input for the top menu
    public void handleInput(boolean mousePressed) {
        if (!menuStack.isEmpty()) {
            Menu currentMenu = menuStack.peek();

            for (Entity entity : currentMenu.getEntities()) {
                ButtonComponent button = entity.getComponent(ButtonComponent.class);

                if (button != null && button.isActive && button.isHovered) {
                    // Perform button action when clicked
                    if (mousePressed && button.onClick != null) {
                        button.onClick.run();  // Execute the button action
                    }
                }
            }
        }
    }

    private void drawButton(ButtonComponent button) {
        if (button.isHovered) {
            fill(200, 200, 200);  // Hover color
        } else {
            fill(255);  // Normal color
        }
        rect(button.x, button.y, button.w, button.h);
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(button.textSize);
        text(button.label, button.x, button.y, button.w - 20, button.h);
    }

    private void drawText(TextComponent text) {
        fill(0);
        text(text.text, text.x, text.y);
    }
}

//HELPER FUNCTIONS
void createMainMenu()
{
   // Create a menu
    Menu mainMenu = new Menu(MenuTypes.MAINMENU);
    
    // Create buttons and text as entities
    Entity startButtonEntity = new Entity();
    rectMode(CENTER);
    ButtonComponent startButton = new ButtonComponent("Start Game", width/2, height/2, 200, 100, 20, 
    () -> { gameSystem.start(); });

    Entity exitButtonEntity = new Entity();
    ButtonComponent exitButton = new ButtonComponent("Exit", width - 120, height - 70, 200, 100, 20, () -> exit());
    
    Entity animatedTextEntity = new Entity();
    AnimatedTextComponent animatedText = new AnimatedTextComponent("Processing Space Shooter", 40, width / 2, -50, startButton.y - 150);
    animatedTextEntity.addComponent(animatedText);

    // Add components to entities
    startButtonEntity.addComponent(startButton);
    exitButtonEntity.addComponent(exitButton);

    // Add entities to the menu
    mainMenu.addEntity(startButtonEntity)
            .addEntity(exitButtonEntity)
            .addEntity(animatedTextEntity);

    menuSystem.addMenuObject(mainMenu);
}

void createGameOverMenu()
{
  Menu gameOverMenu = new Menu(MenuTypes.GAMEOVER); 
}

void createInGameMenu()
{
  Menu inGameMenu = new Menu(MenuTypes.INGAME);
}

void createDialogueMenu()
{
  Menu dialogueMenu = new Menu(MenuTypes.DIALOG);
}
