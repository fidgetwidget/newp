package newp.components;

import openfl.display.Sprite;

class SpriteComponent implements Component implements Renderable implements Updatable {

  public var entity:Entity;
  public var type:String;
  public var updatable:Bool = true;
  public var renderable:Bool = true;
  public var collidable:Bool = false;
  public var sprite:Sprite;
  public var layer:String;

  public function new(?sprite:Sprite, ?layer:String) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.sprite = sprite == null ? new Sprite() : sprite;
    this.layer = layer;
  }

  public function update():Void {
    if (this.entity != null) this.adjustPosition();
  }

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    this.adjustPosition();
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

  inline function adjustPosition():Void {
    this.x = this.entity.x;
    this.y = this.entity.y;
  }

}
