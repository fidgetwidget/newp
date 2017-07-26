package newp;

import newp.scenes.Manager as SceneManager;
import newp.scenes.Scene;
import newp.inputs.Manager as InputManager;
import newp.utils.Clock;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

class Engine {

  public var debug (get, set) :Bool;
  public var gamespeed :Float = 1;
  public var clock (default, null) :Clock;
  public var main (default, null) :Sprite;
  public var stage (get, never) :Stage;
  public var sceneLayer (default, null) :Sprite;
  public var debugLayer (default, null) :Sprite;
  public var scenes (default, null) :SceneManager;
  public var inputs (default, null) :InputManager;

  public function new( main:Sprite ) {
    newp.Lib.engine = this;
    this.main = main;
    this.sceneLayer = new Sprite();
    this.debugLayer = new Sprite();
    this.scenes = new SceneManager();
    this.inputs = new InputManager();
    this.clock = new Clock();
  }

  public function start(scene:Scene = null):Void {
    this.stage.addEventListener (Event.ENTER_FRAME, this.update);

    this.main.addChild(sceneLayer);
    this.main.addChild(debugLayer);

    if (scene == null) { return; }
    this.scenes.setScene(scene);
  }

  function update(e:Event):Void {
    this.clock.tick();
    if (Lib.debug) {
      this.debugLayer.graphics.clear();
      this.debugLayer.graphics.lineStyle(1, 0xff0000, 0.5);  
    }
    this.inputs.update();
    this.scenes.update();
  }

  // Properties
  inline function get_stage():Stage { return this.main.stage; }

  inline function get_debug():Bool { return this._debug; }
  inline function set_debug(val:Bool):Bool {
    if (!val) this.debugLayer.graphics.clear();
    return this._debug = val;
  }
  

  var _debug:Bool = false;



}
