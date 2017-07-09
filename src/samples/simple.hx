package samples;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.FPS;
import newp.scenes.SimpleScene;
import newp.math.Dice;
import newp.Lib;


class Simple extends SimpleScene {
  
  var spriteCounter:TextField;

  public function new () {
    super();
    this.addFPS();
    this.addSpriteCounter();
    this.addMessage();
    this.createSomeRandomBoxes();
  }

  // Methods

  function addFPS() {
    var fps = new FPS(10, 40, 0x555555);
    this.container.addChild(fps);
  }  

  function addSpriteCounter() {
    var format = new TextFormat("Verdana", 24, 0x777777, true);
    this.spriteCounter = new TextField();
    this.spriteCounter.x = 10;
    this.spriteCounter.y = 10;
    this.spriteCounter.defaultTextFormat = format;
    this.spriteCounter.selectable = false;

    this.container.addChild(this.spriteCounter);
  }

  function addMessage() {
    var textField = new TextField();
    var format = new TextFormat("Verdana", 24, 0xbbbbbb, true);
    format.align = TextFormatAlign.CENTER;
    textField.defaultTextFormat = format;
    textField.x = 0;
    textField.y = Lib.stage.stageHeight - 30;
    textField.width = Lib.stage.stageWidth;
    textField.selectable = false;
    textField.text = "Click to add some random squares!";

    this.container.addChild(textField);
  }

  function createSomeRandomBoxes() {
    var x, y, w, h;
    for (i in 0...30) {
      x = Dice.parse("3d100 10d6");
      y = Dice.parse("3d100 10d6");

      w = Dice.roll() * 10;
      h = Dice.roll() * 10;
      this.addBoxSprite(x, y, w, h);
    }
  }

  function addBoxSprite(x:Float, y:Float, w:Float, h:Float) {
    var sprite = new openfl.display.Sprite();
    var g = sprite.graphics;
    
    g.lineStyle(1, 0xff0000);
    g.drawRect(x - w/2, y - h/2, w, h);
    this.addSprite(sprite);

    this.spriteCounter.text = Std.string(this.sprites.length);
  }

  // Update Loop

  public override function update():Void {

    if (Lib.inputs.mouse.down()) {
      var w = Dice.roll() * 10, h = Dice.roll() * 10;
      this.addBoxSprite(Lib.inputs.mouse.x, Lib.inputs.mouse.y, w, h);
    }
  } 
  
  
}