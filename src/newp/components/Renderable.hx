package newp.components;

import newp.scenes.Scene;
import openfl.display.Sprite;


// NOTE: perhaps it should be aware of it's container, rather than the scene?
interface Renderable {

  public var sprite(default, null):Sprite;
  public var layer(get, set):String;
  public var scene(default, null):Scene;

  public function addedToScene(scene:Scene):Void;
  public function removedFromScene():Void;

}
