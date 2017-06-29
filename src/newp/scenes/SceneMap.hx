package newp.scenes;

import newp.scenes.Scene;

class SceneMap {
  
  var map:Map<String, Scene>;
  
  public function new () { this.map = new Map(); }

  public function add (scene:Scene, name:String = null):Void {
    if (name == null) { name = scene.name; }
    this.map.set(name, scene);
  }

  public function get (name:String) :Scene { 
    if (!this.has(name)) { return null; }
    return this.map.get(name); 
  }

  // Check for scene by either name, or reference
  public function has (args:Dynamic) :Bool { 
    var name:String;
    if (Std.is(args, String)) { name = cast args; } 
    else if (Std.is(args, Scene)) {
      var scene:Scene = cast args;
      name = scene.name;
    } else {
      throw "Value is not valid for adding to the List.";
    }
    return this.map.exists(name); 
  }
  
}