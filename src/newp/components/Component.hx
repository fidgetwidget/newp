package newp.components;

import newp.Entity;

interface Component {

  public var entity:Entity;

  public var type:String;

  public var updateable:Bool;

  public var renderable:Bool;

  public var collidable:Bool;

  public function addedToEntity(e:Entity):Void;

  public function removedFromEntity(e:Entity):Void;

}
