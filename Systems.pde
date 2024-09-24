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
  int waveNumber = 0;
  void start()
  {
    gamePlaying = true;
    waveNumber++;
  }
  
  void createWave()
  {
  }
}
