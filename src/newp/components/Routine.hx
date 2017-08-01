package newp.components;

import newp.Entity;


class Routine implements Component implements Updateable {

  static var uid:Int = 0;


  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = true;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = false;

  public function new(?name:String) {
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++Routine.uid}' : name;
  }

  // Updateable
  // ==========

  public function update():Void { 
    // Put your logic here
  }

  // Component
  // =========

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

}
