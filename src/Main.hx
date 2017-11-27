package;

import openfl.display.Sprite;
import newp.Engine;
import samples.*;
import games.vollybox.VollyBox;

class Main extends Sprite {
  
  public function new () {
    super();
    var engine = new Engine(this);

    var betterCollisions = new BetterCollisions();
    var pong = new Pong();
    var simple = new Simple();
    var simpleCollisions = new SimpleCollisions();
    var animation = new AnimationTest();

    var vollybox = new VollyBox();
    
    engine.start(animation);
  }
  
}