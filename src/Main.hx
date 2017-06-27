package;

import openfl.display.Sprite;
import newp.Lib;
import newp.Engine;

class Main extends Sprite {
  
  public function new () {
    
    super ();
    Lib.main = this;
    Lib.engine = new Engine(this, new newp.samples.Simple());
  }
  
}