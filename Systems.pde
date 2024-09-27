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

class GameSystem
{
  private int waveNumber = 0;
  private int lives = 5;
  ArrayList<ValueChangedEvent> lifeValueListeners = new ArrayList<ValueChangedEvent>();
  ArrayList<ValueChangedEvent> waveValueListeners = new ArrayList<ValueChangedEvent>();
  
  void start()
  {
    gamePlaying = true;
    createWave();
   
  }
  
  void AddListener(ChangeEvent eventType, ValueChangedEvent listener)
  {
    if (eventType == ChangeEvent.LIVES) 
    {
      lifeValueListeners.add(listener);
      return;
    }
    waveValueListeners.add(listener);
  }
  
  void createWave()
  {
    //update the wave number and create the wave
    waveNumber++;
    
    if (waveValueListeners == null || waveValueListeners.size() <= 0) return;
    
    for (ValueChangedEvent evt : waveValueListeners)
    {
      evt.ValueChanged(waveNumber);
    }
  }
  
  void setLives(int value)
  {
    lives = value;
    
    if (lifeValueListeners == null || lifeValueListeners.size() <= 0) return;
    
    for (ValueChangedEvent evt : lifeValueListeners)
    {
      evt.ValueChanged(lives);
    }
  }
}

enum ChangeEvent
{
  LIVES, WAVES
}

interface ValueChangedEvent
{
  void ValueChanged(int changedValue);
}
