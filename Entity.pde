import java.util.UUID;
class Entity {
    UUID id;
    HashMap<Class<?>, Component> myComponents = new HashMap<Class<?>, Component>();

    Entity() {
        
        id = UUID.randomUUID(); 
    }
    
    // Component Management
    public Entity addComponent(Component component) 
    {
      component.linkedEntity = id;
      if (myComponents.get(component.getClass()) == null) myComponents.put(component.getClass(), component);
      return this;
    }
    
    public <T extends Component> T getComponent(Class<?> componentClass)
    {
      if (!myComponents.containsKey(componentClass)) return null;
      return (T) myComponents.get(componentClass);
    }
    // Component Management
}
