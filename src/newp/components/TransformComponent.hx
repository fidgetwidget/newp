package newp.components;

import openfl.display.DisplayObject;
import openfl.display.Sprite;


// NOTE: I think I want to change it from a displayObject to a transform
//  but I need to be more familiar with how the transform is attached to a 
//  display object before I go ahead with that change.
class TransformComponent implements Component {

  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = false;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = false;
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
