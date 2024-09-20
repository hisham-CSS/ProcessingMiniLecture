abstract class Component {
  // You can define common methods for all components here if needed
  protected String name;
  UUID linkedEntity;
  boolean isActive = true;
}

class TransformComponent extends Component
{
  PVector position;
  PVector velocity;

  TransformComponent(PVector position, PVector velocity)
  {
    name = "Transform";
    this.position = position;
    this.velocity = velocity;
  }
}

class LookComponent extends Component {
  int colour;
  float size;
  TransformComponent transform;
  
  LookComponent(int colour, float size, TransformComponent transform) {
    name = "Look";
    this.colour = colour;
    this.size = size;
    this.transform = transform;
  }
}


class ParallaxLayerComponent extends Component {
    PImage image;
    float speed;
    float offsetY;

    ParallaxLayerComponent(PImage image, float speed) {
        name = "Parallax";
        this.image = image;
        this.speed = speed;
        this.offsetY = 0;
    }
}



class ParticleComponent extends Component {
  TransformComponent transform;
  LookComponent look;
}

class CollisionComponent extends Component {
  LookComponent look;
  CollisionFlags collisionID;
  EnumSet<CollisionFlags> collisionFlags;
  
  CollisionComponent(LookComponent look, EnumSet<CollisionFlags> collisionFlags, CollisionFlags collisionID)
  {
    this.look = look;
    this.collisionFlags = collisionFlags;
    this.collisionID = collisionID;
  }
}

public enum CollisionFlags {
  PLAYER, PLAYERBULLET, ENEMY, ENEMYBULLET, NONE
}
