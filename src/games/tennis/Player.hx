package games.tennis;

import newp.components.*;
import newp.collision.shapes.Polygon;
import newp.math.Motion;
import newp.math.Utils as MathUtils;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;


class Player extends Entity {

  inline static var BASE_MOVE_SPEED:Int = 300;
  inline static var MAX_MOVE_SPEED:Int = 200;
  inline static var DRAG:Int = 300;

  var field:PlayField;
  var playerNo:Int;
  var width:Float;
  var height:Float;


  public function new(player:Int, field:PlayField) {
    super();
    this.playerNo = player;
    this.field = field;
    this.width = 20;
    this.height = 20;

    var sprite = new Sprite();
    var collider = Polygon.rectangle(sprite, this.width, this.height);
    var motion = new Motion();

    motion.drag = DRAG;
    motion.max_velocity = MAX_MOVE_SPEED;

    this.addComponent(new SpriteComponent(sprite));
    this.addComponent(new ShapeComponent(collider));
    this.addComponent(new MotionComponent(motion));

    this.y = field.centerY;
    switch(this.playerNo) {
      case 1:
        this.x = field.left + 50;
      case 2:
        this.x = field.right - 50;
    }

    this.redrawPlayer();
  }

  override public function update() {
    var k = Lib.inputs.keyboard;
    var up:Int=0, down:Int=0, left:Int=0, right:Int=0;
    switch (this.playerNo) {
      case 1:
        up = 87;
        down = 83;
        left = 65;
        right = 68;
      case 2:
        left = 37;
        up = 38;
        right = 39;
        down = 40;
    }

    var speed = BASE_MOVE_SPEED;

    if (k.down(up)) {
      this.ay = -speed;
      if (this.vy != 0 && MathUtils.sign(this.ay) != MathUtils.sign(this.vy)) this.vy *= 0.25;
    } else if (k.down(down)) {
      this.ay = speed;
      if (this.vy != 0 && MathUtils.sign(this.ay) != MathUtils.sign(this.vy)) this.vy *= 0.25;
    } else {
      this.ay = 0;
    }

    if (k.down(left)) {
      this.motion.ax = -speed;
      if (this.vx != 0 && MathUtils.sign(this.ax) != MathUtils.sign(this.vx)) this.vx *= 0.25;
    } else if (k.down(right)) {
      this.motion.ax = speed;
      if (this.vx != 0 && MathUtils.sign(this.ax) != MathUtils.sign(this.vx)) this.vx *= 0.25;
    } else {
      this.motion.ax = 0;
    }

    super.update();
  }

  function redrawPlayer() {
    var g = this.sprite.graphics;
    var halfWidth = width*0.5;
    var halfHeight = height*0.5;
    Draw.start(g)
      .beginFill(0x555555, 0.1)
      .drawEllipse(-halfWidth, halfHeight - 5, width, 10)
      .beginFill(0xf5deb3)
      .lineStyle(3, 0xf5deb3, 0.2)
      .drawRect(-halfWidth, -halfHeight, width, height)
      .endFill();
  }

}
