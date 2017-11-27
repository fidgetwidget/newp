package newp.entity;

import newp.Entity;


class EntityCollection implements ICollection {

  var map:Map<String, Entity>;


  public var length(get, never):Int;

  public function new() {
    this.map = new Map();
  }

  // Entity Methods
  // ==============

  public function addEntity(entity:Entity, ?name:String):Void {
    var n = name == null ? entity.name : name;
    if (this.hasEntity(n)) return; // we don't need to add it again
    this.map.set(n, entity);
    this.count++;
  }

  public function getEntity(name:String):Entity {
    if (!this.hasEntity(name)) return null;
    return this.map.get(name);
  }

  // target can be either String or Entity
  public function removeEntity(target:Dynamic):Void {
    var name = this.getNameFromTarget(target);
    this.map.remove(target);
    this.count--;
  }

  // target can be either String or Entity
  public function hasEntity(target:Dynamic):Bool {
    var name = this.getNameFromTarget(target);
    return this.map.exists(name);
  }

  public function iterator():Iterator<Entity> {
    return this.map.iterator();
  }

  inline function get_length():Int { return this.count; }
  var count:Int = 0;


  inline function getNameFromTarget(target:Dynamic) {
    var n:String = '';
    if (Std.is(target, String)) {
      n = target;
    } else if (Std.is(target, Entity)) {
      n = cast(target, Entity).name;
    } else {
      throw "Unknown target type: Must be either a String, or an Entity.";
    }
    return n;
  }

}