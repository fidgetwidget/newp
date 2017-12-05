package;

import openfl.display.Sprite;
import newp.Engine;
import samples.*;
import games.vollybox.VollyBox;

class Main extends Sprite {
  
  public function new () {
    super();

    var engine = new Engine(this);

    // Base Example
    var simple = new Simple();

    // Collision Examples
    var simpleCollisions = new SimpleCollisions();
    var betterCollisions = new BetterCollisions();

    // Animation Examples
    var animationExample = new AnimationExample();
    var texturePacker = new TexturePackerExample();
    var characterExample = new CharacterExample();

    // Game Examples
    var pong = new Pong();
    var vollybox = new VollyBox();
    
    engine.start(characterExample);
  }
  
}