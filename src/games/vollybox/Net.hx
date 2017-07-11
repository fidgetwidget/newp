package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Shape;
import newp.utils.Draw;
import newp.Entity;
import openfl.display.Sprite;


class Net {

  inline static var SHADOW_DEPTH:Float = 4;

  var field:PlayField;
  var baseline:Sprite;
  public var shadow:Sprite;
  public var net:Sprite;
  public var netBottom:Sprite;
  public var collider:Shape;

  public function new(field:PlayField) {
    this.field = field;
    
    this.baseline = new Sprite();

    this.shadow = new Sprite();
    this.shadow.x = field.centerX;
    this.shadow.y = 0;

    this.net = new Sprite();
    this.net.x = field.centerX;
    this.net.y = 0;

    this.netBottom = new Sprite();
    this.netBottom.x = field.centerX;
    this.netBottom.y = 0;

    this.drawBaseline(baseline.graphics);
    this.drawShadow(shadow.graphics);
    this.drawNet(net.graphics);
    this.drawNetBottom(netBottom.graphics);

    net.addChild(baseline);

    this.collider = new Shape(baseline);
  }

  function drawBaseline(g) {
    Draw.start(g)
      .lineStyle(2, 0x000000, 0)
      .drawRect(0, this.field.top+5, 1, PlayField.HEIGHT-10);
  }

  function drawShadow(g) {
    Draw.start(g)
      .clear()
      .beginFill(0x555555, 0.1)
      .drawLine([-SHADOW_DEPTH, SHADOW_DEPTH, 0, PlayField.HEIGHT-10, SHADOW_DEPTH, -SHADOW_DEPTH], 0, this.field.top+5)
      .endFill();
  }

  function drawNet(g) {
    Draw.start(g)
      .clear()
      .lineStyle(2, 0x333333)
      .drawLine([0, 15], 0, this.field.top-10)
      .lineStyle(1, 0x555555)
      .drawLine([0, PlayField.HEIGHT-30], 0, this.field.top-10);
  }

  function drawNetBottom(g) {
    Draw.start(g)
      .clear()
      .lineStyle(1, 0x555555)
      .drawLine([0, 20], 0, this.field.bottom-40)
      .lineStyle(2, 0x333333)
      .drawLine([0, 15], 0, this.field.bottom-20);
  }

}
