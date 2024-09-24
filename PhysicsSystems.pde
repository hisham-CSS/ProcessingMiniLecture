//COLLISION SYSTEM THAT DEALS WITH CIRCLE COLLISIONS AND RAISING COLLISION COMPONENT EVENTS
class CollisionSystem extends SystemBase
{
  void update()
  {
    CollisionComponent[] colliders = getComponents(CollisionComponent.class);
   
     for (int i = 0; i < colliders.length; i++) {
        if (!colliders[i].look.isActive) continue;

        for (int j = i + 1; j < colliders.length; j++) {
            if (!colliders[j].look.isActive) continue;

            // Check if the collision flags match
            if (colliders[i].collisionFlags.contains(colliders[j].collisionID) &&
                colliders[j].collisionFlags.contains(colliders[i].collisionID)) {
                
                if (isColliding(colliders[i], colliders[j])) {
                    handleCollision(colliders[i], colliders[j]);
                }
            }
        }
    }
  }
  
  // Check if two LookComponents (circles) are colliding
  boolean isColliding(CollisionComponent a, CollisionComponent b) {
      // Calculate the distance between the two circle centers
      float distance = a.look.transform.position.dist(b.look.transform.position);
      
      // Sum of the radii
      float radiusSum = a.look.size + b.look.size;

      // Return true if the distance is less than or equal to the sum of the radii
      return distance <= radiusSum;
  }
  
    // Handle the collision between two LookComponents
    void handleCollision(CollisionComponent a, CollisionComponent b) {
        // Example: Deactivate both objects on collision (you can replace this with any other logic)
        a.onCollision(a, b);
        b.onCollision(b, a);
        
        //a.isActive = false;
        //b.isActive = false;
        //CreateExplosion(b.look.transform.position);
    }
}

//INTERFACE THAT IS USED TO CREATE COLLISION EVENTS - COMPONENT RAISES THE EVENT FOR OTHERS TO LISTEN TO
interface CollisionEvent
{
  void onCollision(CollisionComponent myCollider, CollisionComponent collidedObject);
}
//COLLISION FLAGS FOR THE GAME, A COLLISION COMPONENT HAS FLAGS IN WHICH IT CHECKS COLLISIONS AGAINST AS WELL AS ONE SET AS IT'S ID
//EXAMPLE - PLAYER HAS A COLLISION ID OF PLAYER, AND COLLISION FLAGS SET TO ENEMY AND ENEMYBULLET
public enum CollisionFlags {
  PLAYER, PLAYERBULLET, ENEMY, ENEMYBULLET, NONE
}

class CollisionComponent extends Component {
  LookComponent look;
  CollisionFlags collisionID;
  EnumSet<CollisionFlags> collisionFlags;
  ArrayList<CollisionEvent> collisionListeners = new ArrayList<CollisionEvent>();
  
  CollisionComponent(LookComponent look, EnumSet<CollisionFlags> collisionFlags, CollisionFlags collisionID)
  {
    this.look = look;
    this.collisionFlags = collisionFlags;
    this.collisionID = collisionID;
  }
  
  public void addListener(CollisionEvent evt)
  {
    collisionListeners.add(evt);
  }
  
  public void onCollision(CollisionComponent myCollider, CollisionComponent collidedObject)
  {
    if (collisionListeners == null || collisionListeners.size() <= 0) return;
    for (CollisionEvent e : collisionListeners)
      e.onCollision(myCollider, collidedObject);
  }
}

class PlayerBulletCollision implements CollisionEvent
{
  void onCollision(CollisionComponent myCollider, CollisionComponent collidedObject)
  {
    myCollider.look.isActive = false;
    collidedObject.look.isActive = false;
    createExplosion(collidedObject.look.transform.position);
  }
}
