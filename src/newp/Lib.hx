package newp;

import newp.scenes.Manager as SceneManager;
import newp.inputs.Manager as InputManager;
import newp.Engine;
import openfl.display.Sprite;
import openfl.display.Stage;

class Lib {
  
  public static var debug(default, null):Bool = false;

  @:allow(newp.Engine)
  public static var engine (default, null) :Engine;

  public static var main (get, never) :Sprite;
  public static var stage (get, never) :Stage;
  public static var sceneLayer (get, never) :Sprite;
  public static var debugLayer (get, never) :Sprite;
  public static var scenes (get, never) :SceneManager;
  public static var inputs (get, never) :InputManager;
  public static var delta (get, never) :Float;

  // Properties
  static inline function get_main () :Sprite { return Lib.engine != null ? Lib.engine.main : null; }
  static inline function get_stage () :Stage { return Lib.engine != null ? Lib.engine.stage : null; }
  static inline function get_sceneLayer () :Sprite { return Lib.engine != null ? Lib.engine.sceneLayer : null; }
  static inline function get_debugLayer () :Sprite { return Lib.engine != null ? Lib.engine.debugLayer : null; }
  static inline function get_scenes () :SceneManager { return Lib.engine != null ? Lib.engine.scenes : null; }
  static inline function get_inputs () :InputManager { return Lib.engine != null ? Lib.engine.inputs : null; }
  static inline function get_delta() :Float { return Lib.engine != null ? Lib.engine.clock.delta : 0; }
}