package;

import openfl.display.Sprite;
import newp.Engine;

class Main extends Sprite {
  
  public function new () {
    super();
    var engine = new Engine(this);
    var scene = new samples.BetterCollisions();
    engine.start(scene);
  }
  
}