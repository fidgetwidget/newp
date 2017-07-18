package newp.components;

import openfl.display.Sprite;

class SpriteComponent implements Component implements Renderable implements Updateable {

  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity:Entity;
  public var type:String;
  public var updateable:Bool = true;
  public var renderable:Bool = true;
  public var collidable:Bool = false;
  public var sprite:Sprite;
  public var layer:String;
  var sync:Bool;

  public function new(?sprite:Sprite, ?layer:String, syncPosition:Bool = true, ?name:String) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++SpriteComponent.uid}' : name;
    this.sprite = sprite == null ? new Sprite() : sprite;
    this.layer = layer;
    this.sync = syncPosition;
  }

  public function update():Void {
    if (this.sync) this.syncPosition(this.entity);
  }

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    if (this.sync) this.syncPosition(e);
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

  inline function syncPosition(entity:Entity):Void {
    if (entity == null) return;
    this.sprite.x = entity.x;
    this.sprite.y = entity.y;
  }

}
