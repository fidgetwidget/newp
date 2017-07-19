package newp.components;

import newp.scenes.Scene;
import openfl.display.Sprite;


interface Renderable {

  public var sprite:Sprite;
  public var layer(get, set):String;
  public var scene(default, null):Scene;

  public function addedToScene(scene:Scene):Void;
  public function removedFromScene():Void;

}
