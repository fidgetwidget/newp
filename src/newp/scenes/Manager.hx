package newp.scenes;

import newp.Lib;

class Manager {
  
  var scenes :SceneMap;
  var activeScenes :Array<Scene>;
  var sceneInFocus (get, never) :Scene;
  
  public function new () {
    
    this.scenes = new SceneMap();
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
    Lib.sceneLayer.addChild(scene.container);
    scene.begin();
    if (this.active(scene)) { return; }
    this.activeScenes.insert(0, scene);
  }

  // drop the scene from the active set
  public function dropScene (scene:Scene) :Void {
    scene.end();
    Lib.sceneLayer.removeChild(scene.container);
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