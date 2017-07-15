package samples;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.FPS;
import openfl.display.Sprite;
import newp.scenes.BasicScene;
import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.math.Dice;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import samples.collisions.Box;

class BetterCollisions extends BasicScene {
  
  var spriteCounter:TextField;
  var shapeEntityMap:Map<Shape, Entity>;
  var fps:FPS;  

  override function init() {
    super.init();
    this.shapeEntityMap = new Map();

    var hudLayer = this.sprites.getLayer('hud').container;

    this.fps = new FPS(10, 40, 0x555555);
    hudLayer.addChild(this.fps);
    
    var spriteCounterFormat = new TextFormat("Verdana", 24, 0x777777, true);
    this.spriteCounter = new TextField();
    this.spriteCounter.x = 10;
    this.spriteCounter.y = 10;
    this.spriteCounter.defaultTextFormat = spriteCounterFormat;
    this.spriteCounter.selectable = false;
    hudLayer.addChild(this.spriteCounter);

    var textField = new TextField();
    var textFieldFormat = new TextFormat("Verdana", 24, 0xbbbbbb, true);
    textFieldFormat.align = TextFormatAlign.CENTER;
    
    textField.defaultTextFormat = textFieldFormat;
    textField.x = 0;
    textField.y = Lib.stage.stageHeight - 30;
    textField.width = Lib.stage.stageWidth;
    textField.selectable = false;
    textField.text = "Click to add colliders to the stage";

    hudLayer.addChild(textField);
  }

  // Entity
  // ======
  
  override public function addEntity (entity:Entity) :Void {
    super.addEntity(entity);
    if (entity.collidable) {
      for (collider in entity.colliders) this.shapeEntityMap.set(collider, entity);
    }
  }

  override public function removeEntity (entity:Entity) :Void {
    super.removeEntity(entity);
    if (entity.collidable) {
      for (collider in entity.colliders) this.shapeEntityMap.remove(collider);
    }
  }

  // Update Loop

  public override function update():Void {
    if (Lib.inputs.mouse.down()) {
      var w:Int = Math.floor( Dice.roll() * 10 ), h:Int = Math.floor( Dice.roll() * 10 );
      this.createShape(Lib.inputs.mouse.x, Lib.inputs.mouse.y, w, h);
    }

    if (Lib.inputs.keyboard.pressed(32)) {
      var w:Int = Math.floor( Dice.roll() * 10 ), h:Int = Math.floor( Dice.roll() * 10 );
      this.createShape(Lib.inputs.mouse.x, Lib.inputs.mouse.y, w, h);
    }

    for (shape in colliders.shapes) {
      colliders.update(shape);

      var bounds = shape.bounds;
      if (bounds.minX > Lib.stage.stageWidth || 
          bounds.minY > Lib.stage.stageHeight ||
          bounds.maxX < 0 || bounds.maxY < 0) {
        colliders.remove(shape);
      }
    }

    for (e in this.entities) {
      if (!Std.is(e, Box)) continue;
      var box = cast(e, Box);
      if (box.color != 0x555555) box.color = 0x555555;
    }

    colliders.collisionTestAll(this.collisionResolver);
  } 

  inline function collisionResolver(shape:Shape, collision:ShapeCollision):Void {
    shape.x -= collision.separationX;
    shape.y -= collision.separationY;
    var e = this.shapeEntityMap.get(shape);
    if (Std.is(e, Box)) {
      cast(e, Box).color = 0xff5555;
    }
  }

  // Methods
  
  function createShape(x:Float, y:Float, w:Int, h:Int) {
    var box = Box.create(this, x, y, w, h);
    this.addEntity(box);
    this.spriteCounter.text = Std.string(this.entities.length);
  }
  
}