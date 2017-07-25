package newp.components;

import openfl.display.DisplayObject;
import openfl.display.Sprite;


// NOTE: I want to rely on the transform rather than displayObject 
//  so that it can be applied to a displayObject, but for now this
//  was easier
class TransformComponent implements Component {

  public static function make(e:Entity, ?name:String, ?body:DisplayObject):TransformComponent {
    var t = new TransformComponent(body, name);
    e.addComponent(t);
    return t;
  }


  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = false;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = false;
  public var body(default, null):DisplayObject;
  
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var z(get, set):Float;
  public var rotation(get, set):Float;
  public var scaleX(get, set):Float;
  public var scaleY(get, set):Float;
  var _z:Float = 0;


  public function new(?body:DisplayObject, ?name:String) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++TransformComponent.uid}' : name;
    this.body = body == null ? new Sprite() : body; 
  }

  // Component
  // =========

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }


  // Properties
  // ==========

  inline function get_x():Float { return this.body.x; }
  inline function set_x(val:Float):Float { return this.body.x = val; }

  inline function get_y():Float { return this.body.y; }
  inline function set_y(val:Float):Float { return this.body.y = val; }

  inline function get_z():Float { return this._z; }
  inline function set_z(val:Float):Float { return this._z = val; }

  inline function get_rotation():Float { return this.body.rotation; }
  inline function set_rotation(val:Float):Float { return this.body.rotation = val; }

  inline function get_scaleX():Float { return this.body.scaleX; }
  inline function set_scaleX(val:Float):Float { return this.body.scaleX = val; }

  inline function get_scaleY():Float { return this.body.scaleY; }
  inline function set_scaleY(val:Float):Float { return this.body.scaleY = val; }

}
