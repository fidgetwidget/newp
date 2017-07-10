package;

import openfl.display.Sprite;
import newp.Engine;
import samples.*;
import games.tennis.Tennis;

class Main extends Sprite {
  
  public function new () {
    super();
    var engine = new Engine(this);

    var betterCollisions = new BetterCollisions();
    var pong = new Pong();
    var simple = new Simple();
    var simpleCollisions = new SimpleCollisions();

    var tennis = new Tennis();
    
    engine.start(tennis);
  }
  
}