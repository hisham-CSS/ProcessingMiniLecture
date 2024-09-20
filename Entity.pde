import java.util.UUID;
class Entity {
    UUID id;
    HashMap<String, Component> myComponents = new HashMap<String, Component>();

    Entity() {
        
        id = UUID.randomUUID(); 
    }
    
    // Component Management
    public void addComponent(Component component) 
    {
      component.linkedEntity = id;
      if (myComponents.get(component.name) == null) myComponents.put(component.name, component);       
    }
    
    public <T extends Component> T getComponent(String name)
    {
      if (!myComponents.containsKey(name)) return null;
      return (T) myComponents.get(name);
    }
    // Component Management
}
