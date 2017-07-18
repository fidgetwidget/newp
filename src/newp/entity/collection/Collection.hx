package newp.entity.collection;

interface Collection {

  public var length(get, never):Int;

  // Entity Methods
  // ==============

  public function addEntity(entity:Entity, ?name:String):Void;

  public function getEntity(name:String):Entity;

  // target can be either String or Entity
  public function removeEntity(target:Dynamic):Void;

  // target can be either String or Entity
  public function hasEntity(target:Dynamic):Bool;


  public function iterator():Iterator<Entity>;

}