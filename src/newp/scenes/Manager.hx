package newp.scenes;

import newp.Lib;
import newp.scenes.Scene;
import newp.scenes.List;

class Manager {
  
  var scenes :List;
  var activeScenes :Array<Scene>;
  var sceneInFocus (get, never) :Scene;
  
  public function new () {
    
    this.scenes = new List();
    this.activeScenes = [];
    
  }

  public function update () :Void {
    var i, l, s;
    l = this.activeScenes.length;
    i = l;
    while (i >= 0) {
        s = this.activeScenes[i];
        if (s != null) { s.update(); }
        i--;
    }
  }
  
  // make the scene the active scene
  public function setScene (scene:Scene) :Void {
    if (!this.contains(scene)) { this.addScene(scene); }
    scene.begin();
    if (this.active(scene)) { return; }
    this.activeScenes.insert(0, scene);
  }

  // drop the scene from the active set
  public function dropScene (scene:Scene) :Void {
    scene.end();
    if (!this.active(scene)) { return; }
    this.activeScenes.remove(scene);
  }

  public function addScene (scene:Scene) :Void {
    this.scenes.add(scene);
  }

  public function active (scene:Scene) :Bool {
    return this.activeScenes.indexOf(scene) >= 0;
  }

  public function contains (scene:Scene) :Bool {
    return this.scenes.has(scene);
  }
  
  // Properties

  function get_sceneInFocus () :Scene {
    return this.activeScenes.length > 0 ? this.activeScenes[0] : null;
  }

}