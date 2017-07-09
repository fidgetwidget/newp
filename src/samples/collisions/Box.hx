package samples.collisions;

import openfl.display.Sprite;
import newp.collision.shapes.Shape;
import newp.components.*;
import newp.utils.Draw;
import newp.scenes.Scene;
import newp.Entity;
import newp.Lib;


class Box extends Entity {

  public static function create(scene:Scene, x:Float, y:Float, width:Int, height:Int):Box {
    var b = new Box(scene, width, height);
    b.x = x;
    b.y = y;
    return b;
  }
  
  public var width:Int;
  public var height:Int;
  public var color(get, set):Int;

  public function new (scene:Scene, width:Int, height:Int) {
    super();
    this.width = width;
    this.height = height;
    this._color = 0x555555;
    this.addComponent(new SpriteComponent());
    this.addComponent(new ShapeComponent());
    this.redrawSprite();
  }

  function redrawSprite() {
    Draw.start(this.sprite.graphics)
      .clear()
      .lineStyle(1, this.color)
      .drawRect(0, 0, this.width, this.height);
  }

  inline function get_color():Int { return this._color; }
  function set_color(val:Int):Int {
    this._color = val;
    this.redrawSprite();
    return this._color;
  }
  var _color:Int;
  
}