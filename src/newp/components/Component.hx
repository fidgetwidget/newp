package newp.components;

import newp.Entity;


interface Component {

  public var name(default, null):String;

  public var entity(default, null):Entity;

  public var type(default, null):String;

  public var updateable(default, null):Bool;

  public var renderable(default, null):Bool;

  public var collidable(default, null):Bool;

  public function addedToEntity(e:Entity):Void;

  public function removedFromEntity(e:Entity):Void;

}
