package newp;

import newp.scenes.Manager as SceneManager;
import newp.scenes.Scene;
import newp.inputs.Manager as InputManager;
import newp.utils.Clock;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

class Engine {

  public var clock (default, null) :Clock;
  public var main (default, null) :Sprite;
  public var stage (get, never) :Stage;
  public var scenes (default, null) :SceneManager;
  public var inputs (default, null) :InputManager;

  public function new( main:Sprite, scene:Scene = null ) {
    this.main = main;
    this.scenes = new SceneManager();
    this.inputs = new InputManager();
    
    this.clock = new Clock();
    this.stage.addEventListener (Event.ENTER_FRAME, this.update);

    if (scene == null) { return; }
    this.scenes.setScene(scene);
  }

  function update(e:Event):Void {
    this.clock.tick();
    this.inputs.update();
    this.scenes.update();
  }

  // Properties
  inline function get_stage():Stage { return this.main.stage; }

}
