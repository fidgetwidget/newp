package newp.samples;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.events.MouseEvent;
import newp.scenes.Scene;
import newp.Lib;
import newp.utils.Dice;


class Simple extends Scene {
  
  var mouseIsDown:Bool = false;
  var mouseX:Float = 0;
  var mouseY:Float = 0;
  var spriteCounter:TextField;

  public function new () {
    
    super ();

    this.addSpriteCounter();

    this.addMessage();

    this.createSomeRandomBoxes();

    Lib.stage.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
    Lib.stage.addEventListener (MouseEvent.MOUSE_UP, onMouseUp);  
    Lib.stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
  }

  // Methods

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

  function addSpriteCounter() {
    var format = new TextFormat("Verdana", 24, 0xbbbbbb, true);
    this.spriteCounter = new TextField();
    this.spriteCounter.x = 10;
    this.spriteCounter.y = 10;
    this.spriteCounter.defaultTextFormat = format;
    this.spriteCounter.selectable = false;

    this.addChild(this.spriteCounter);
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

    this.addChild(textField);
  }

  function addBoxSprite(x:Float, y:Float, w:Float, h:Float) {
    var sprite = new openfl.display.Sprite();
    var g = sprite.graphics;
    
    g.lineStyle(1, 0xff0000);
    g.drawRect(x - w/2, y - h/2, w, h);
    this.addSprite(sprite);

    this.spriteCounter.text = Std.string(this.sprites.length);
  }

  // Event Handlers

  function onMouseDown(e: MouseEvent) { this.mouseIsDown = true; }

  function onMouseUp(e:MouseEvent) { this.mouseIsDown = false; }

  function onMouseMove(e:MouseEvent) {
    this.mouseX = e.stageX;
    this.mouseY = e.stageY;
  }

  // Update Loop

  public override function update():Void {

    if (this.mouseIsDown) {
      var w = Dice.roll() * 10, h = Dice.roll() * 10;
      this.addBoxSprite(this.mouseX, this.mouseY, w, h);
    }
  } 
  
  
}