package games.omf;

import newp.scenes.BasicScene;
import newp.utils.Draw;
import newp.Lib;
import openfl.display.Sprite;
import openfl.Assets;


class OneMoreFloor extends BasicScene {

  public function new() {
    super();
  }

  override function init() {
    super.init(); // init_entities, init_sprites, and init_colliders
    // add any other inits we need
  }

  // default: this.entities = new EntityCollection();
  override function init_entities() {
    // add the entity manager

  }

  // default: this.sprites = new DisplayCollection(['camera', 'hud', 'debug']);
  override function init_sprites() {
    // add the sprite layers to the scene
    
  }

  // default: this.colliders = new ShapeBins();
  override function init_colliders() {
    // add the collision containers to the scene
    
  }

  override public function update() {
    // update loop
    
  }

  // called when the scene is made the active scene
  override public function begin() { }

  // called when the scene is droped from the active list
  override public function end() { }

}
