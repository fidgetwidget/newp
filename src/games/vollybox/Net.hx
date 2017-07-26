package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Shape;
import newp.utils.Draw;
import newp.Entity;
import openfl.display.Sprite;


class Net extends Entity {

  inline static var SHADOW_DEPTH:Float = 4;
  inline static var HEIGHT:Float = 290; //PlayField.HEIGHT-10;

  var game:VollyBox;
  var field(get, never):PlayField;

  var shadow:SpriteComponent;
  var net:SpriteComponent;
  var netBottom:SpriteComponent;

  var netMask:Sprite;
  var collider:Shape;

  public function new(game:VollyBox) {
    super();
    this.name = 'net';
    this.game = game;

    this.makeSprites();
    this.makeColliders();
    
    this.x = field.centerX;
    this.y = field.centerY;

    
  }

  function makeSprites() {
    shadow = SpriteComponent.make(this, 'background');
    this.drawShadow(shadow.graphics);

    net = SpriteComponent.make(this, 'foreground');
    this.drawNet(net.graphics);

    netBottom = SpriteComponent.make(this);
    this.drawNetBottom(netBottom.graphics);
  }

  inline function drawShadow(g) {
    Draw.start(g)
      .clear()
      .beginFill(0x555555, 0.1)
      .drawRect(-SHADOW_DEPTH/2, -HEIGHT/2, SHADOW_DEPTH, HEIGHT)
      // .drawLine([-SHADOW_DEPTH, SHADOW_DEPTH, 0, PlayField.HEIGHT-10, SHADOW_DEPTH, -SHADOW_DEPTH], 0, this.field.top+5)
      .endFill();
  }

  inline function drawNet(g) {
    Draw.start(g)
      .clear()
      .lineStyle(2, 0x333333)
      .drawLine([0, 15], 0, -HEIGHT/2 - 15)
      .lineStyle(1, 0x555555)
      .drawLine([0, HEIGHT-30], 0, -HEIGHT/2 - 15);
  }

  inline function drawNetBottom(g) {
    Draw.start(g)
      .clear()
      .lineStyle(1, 0x555555)
      .drawLine([0, 40], 0, HEIGHT/2 - 45)
      .lineStyle(2, 0x333333)
      .drawLine([0, 15], 0, HEIGHT/2 - 15);
  }


  function makeColliders() {
    netMask = new Sprite();
    drawNetMask(netMask.graphics);
    net.addChild(netMask);
    collider = new Shape(netMask);
    ShapeComponent.make(this, collider, ['net']);
  }

  inline function drawNetMask(g) {
    Draw.start(g)
      .lineStyle(2, 0x000000, 0)
      .drawRect(0, -HEIGHT/2, 1, HEIGHT);
  }

  inline function get_field():PlayField { return this.game.playField; }

}
