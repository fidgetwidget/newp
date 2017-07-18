package newp.components;

import openfl.display.DisplayObject;
import openfl.display.Sprite;


class TransformComponent implements Component {

  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity:Entity;
  public var type:String;
  public var updateable:Bool = false;
  public var renderable:Bool = false;
  public var collidable:Bool = false;
  public var body:DisplayObject;

  public function new(?body:DisplayObject, ?name:String) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++TransformComponent.uid}' : name;
    this.body = body == null ? new Sprite() : body; 
  }

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

}
