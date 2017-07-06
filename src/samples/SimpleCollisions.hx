package samples;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.FPS;
import openfl.display.Sprite;
import newp.scenes.Scene;
import newp.collision.shapes.Shape;
import newp.collision.ShapeCollision;
import newp.math.Dice;
import newp.Lib;


class SimpleCollisions extends Scene {
  
  var hudLayer:Sprite;
  var spriteCounter:TextField;
  var fps:FPS;

  var spriteLayer:Sprite;
  var colliders:Array<Shape>;
  var shapeCollision:ShapeCollision = new ShapeCollision();
  
  public function new () {
    super();
    this.colliders = [];
    this.initLayers();
    this.initHud();
  }

  // Adjust it to add them to a different layer
  public override function addSprite(sprite:Sprite):Int {
    this.spriteLayer.addChild(sprite);
    this.sprites.push(sprite);
    return this.sprites.length;
  }

  // Update Loop

  public override function update():Void {
    if (Lib.inputs.mouse.down()) {
      var w = Dice.roll() * 10, h = Dice.roll() * 10;
      this.addCollider(Lib.inputs.mouse.x, Lib.inputs.mouse.y, w, h);
    }

    this.collisionPass();
  } 

  // Methods

  function initLayers() {
    this.hudLayer = new Sprite();
    this.spriteLayer = new Sprite();
    this.addChild(this.spriteLayer);
    this.addChild(this.hudLayer);
  }

  function initHud() {
    this.fps = new FPS(10, 40, 0x555555);
    this.hudLayer.addChild(this.fps);
    
    var spriteCounterFormat = new TextFormat("Verdana", 24, 0x777777, true);
    this.spriteCounter = new TextField();
    this.spriteCounter.x = 10;
    this.spriteCounter.y = 10;
    this.spriteCounter.defaultTextFormat = spriteCounterFormat;
    this.spriteCounter.selectable = false;
    this.hudLayer.addChild(this.spriteCounter);

    var textField = new TextField();
    var textFieldFormat = new TextFormat("Verdana", 24, 0xbbbbbb, true);
    textFieldFormat.align = TextFormatAlign.CENTER;
    
    textField.defaultTextFormat = textFieldFormat;
    textField.x = 0;
    textField.y = Lib.stage.stageHeight - 30;
    textField.width = Lib.stage.stageWidth;
    textField.selectable = false;
    textField.text = "Click to add colliders to the stage";

    this.hudLayer.addChild(textField);
  }

  function addCollider(x:Float, y:Float, w:Float, h:Float) {
    var sprite = new openfl.display.Sprite();
    var g = sprite.graphics;
    
    g.lineStyle(1, 0xff0000);
    g.drawRect(x - w/2, y - h/2, w, h);
    this.addSprite(sprite);

    var shape = new Shape(sprite);
    this.colliders.push(shape);

    // only update the text when we update the count
    this.spriteCounter.text = Std.string(this.sprites.length);
  }

  function collisionPass():Void {
    for (i in 0...colliders.length) {
      var shape:Shape = colliders[i];
      this.collisionTest(shape, i);
    }
  }

  function collisionTest(shape:Shape, index:Int):Void {
    for (i in 0...colliders.length) {
      if (i == index) continue;

      var other:Shape = colliders[i];

      if (shape.test(other, shapeCollision) != null) {
        shape.x -= shapeCollision.separationX;
        shape.y -= shapeCollision.separationY;
      }
    }
  }
  
}