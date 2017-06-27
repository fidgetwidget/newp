package newp;

import newp.scenes.Manager as SceneManager;
// import newp.input.Manager as InputManager;
import newp.Engine;
import openfl.display.Sprite;
import openfl.display.Stage;

class Lib {
  
  @:allow(Main)
  public static var main (default, null) :Sprite;
  @:allow(Main)
  public static var engine (default, null) :Engine;

  public static var stage (get, never) :Stage;
  public static var scenes (get, never) :SceneManager;
  // public static var inputs (get, never) :InputManager;
  public static var delta (get, never) :Float;

  // Properties
  static inline function get_stage () :Stage { return Lib.main != null ? Lib.main.stage : null; }
  static inline function get_scenes () :SceneManager { return Lib.engine != null ? Lib.engine.scenes : null; }
  // static inline function get_inputs () :InputManater { return Lib.engine.inputs; }
  static inline function get_delta() :Float { return Lib.engine != null ? Lib.engine.clock.delta : 0; }
}