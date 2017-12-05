package samples.character;

import openfl.display.Bitmap;
import newp.collision.shapes.Shape;
import newp.collision.shapes.Circle;
import newp.components.*;
import newp.display.animation.*;
import newp.display.frames.*;
import newp.math.Dice;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;


class Character extends Entity {

  public var ground:Float;
  public var width(default, null):Int = 56;
  public var height(default, null):Int = 80;

  var FALL_SPEED:Float = 30.18 * 30;
  var JUMP_POWER:Float = -500;
  var MOVE_SPEED:Float = 350;
  var LEFT:Int = 1;
  var RIGHT:Int = -1;
  var PUNCH_DELAY:Float = 1/6;
  var KICK_DELAY:Float = 1/6;
  var GROUND_DRAG:Float = 500;
  var AIR_DRAG:Float = 50;

  var bitmap:Bitmap;
  var sprite:SpriteComponent;
  var animation:AnimationComponent;

  var offsetX:Float;
  var facing(get, set):Int;
  
  var jumping:Bool;
  var airdelay:Float;
  var moving(get, never):Bool;
  var jumpingOrFalling(get, never):Bool;

  public function new() {
    super();
    this.initMotion();
    this.initAnimation();
    this.initSprite();
    
    this.offsetX = (width / 2) + 3;
    this.jumping = false;
    this.airdelay = 0;
    this.facing = RIGHT;
  }

  function initMotion() :Void {
    this.motion = MotionComponent.make(this);
    this.motion.drag = 0;
    this.motion.xMax = 220;
  }

  function initAnimation() :Void {
    var asset = openfl.Assets.getBitmapData('assets/animationTest/kit.png');
    var frameSet = FrameFactory.makeFrameSet('fox', asset, width, height);
    var behaviours = new BehaviourMap<FrameAnimation>();
    // Default
    behaviours.add( new FrameAnimation("idle",        [0, 1, 2],      true,  true,  3) );

    // actions
    behaviours.add( new FrameAnimation("walk",        [3, 4, 5],      false, false, 16) );
    behaviours.add( new FrameAnimation("punch",       [12, 13, 14],   false, false, 10) );
    behaviours.add( new FrameAnimation("kick",        [15, 16, 17],   false, false, 10) );
    behaviours.add( new FrameAnimation("airpunch",    [18, 19, 20],   false, false, 10) );
    behaviours.add( new FrameAnimation("airkick",     [21, 22, 23],   false, false, 10) );

    // response
    behaviours.add( new FrameAnimation("hit",         [9, 10, 11],    false, false, 10) );
    behaviours.add( new FrameAnimation("ko",          [24, 25, 26],   true,  true,  8) );

    // static frames
    behaviours.add( new FrameAnimation("jump_start",  [6],            false, false, 5) );
    behaviours.add( new FrameAnimation("jumping",     [7],            true,  false, 1) ); 
    behaviours.add( new FrameAnimation("falling",     [8],            true,  false, 1) );
    var animationQueue = new AnimationQueue(behaviours.behaviourAnimationMap, "idle");
    this.animation = AnimationComponent.make(this, frameSet, animationQueue);
  }

  function initSprite() :Void {
    this.sprite = SpriteComponent.make(this);
    this.bitmap = new Bitmap();
    this.bitmap.x = -this.offsetX;
    this.sprite.addChild(this.bitmap);
  }

  override function preUpdate() :Void {
    if (this.animation == null) return;

    if (this.vy < 0) {
      this.animation.defaultBehaviour = 'jumping';
    } else if (this.vy > 0) {
      this.animation.defaultBehaviour = 'falling';
    } else {
      this.animation.defaultBehaviour = this.moving ? 'walk' : 'idle';
    }

    if (this.jumpingOrFalling) {
      this.motion.xDrag = AIR_DRAG;
      if (this.airdelay > 0) {
        this.airdelay -= Lib.delta;
      } else {
        this.vy += FALL_SPEED * Lib.delta;
        trace(this.vy);
      }
    } else {
      this.motion.xDrag = GROUND_DRAG;
    }
  }

  override function postUpdate() :Void {
    if (this.bitmap.bitmapData != this.animation.bitmapData) {
      this.bitmap.bitmapData = this.animation.bitmapData;
    }

    if (!this.jumpingOrFalling) {
      this.y = this.ground;
      this.vy = 0;
      this.jumping = false;
    }
  }


  public function moveLeft() :Void {
    if (this.motion.vx > 0) {
      // if we are in the air, we slow down more quickly
      // if we are on the ground, we start moving in the other direction right away
      this.vx = !this.jumpingOrFalling ? 0 : this.vx * 0.05;
    }
    this.facing = LEFT;
    this.motion.ax = -MOVE_SPEED;
  }

  public function moveRight() :Void {
    if (this.motion.vx < 0) {
      // if we are in the air, we slow down more quickly
      // if we are on the ground, we start moving in the other direction right away
      this.vx = !this.jumpingOrFalling ? 0 : this.vx * 0.05;
    }
    this.facing = RIGHT;
    this.motion.ax = MOVE_SPEED;
  }

  public function notMoving() :Void {
    this.motion.ax = 0;

    if (!this.jumpingOrFalling) {
      this.motion.vx = 0;
    }
  }

  public function jump() :Void {
    if (!this.jumpingOrFalling) {
      this.startJump();
    }
  }

  public function punch() :Void {
    if (this.jumping) {
      this.animation.enqueue('airpunch');
      this.airdelay += PUNCH_DELAY;
    } else {
      this.animation.enqueue('punch');
    }
  }

  public function kick() :Void {
    if (this.jumping) {
      this.animation.enqueue('airkick');
      this.airdelay += KICK_DELAY;
    } else {
      this.animation.enqueue('kick');
    }
  }


  function startJump() :Void {
    this.jumping = true;
    this.vy = JUMP_POWER;
    trace(this.vy);
    this.animation.enqueue('jump_start');
    this.animation.defaultBehaviour = 'jumping';
  }

  inline function get_jumpingOrFalling():Bool {
    return this.y < this.ground;
  }

  inline function get_moving():Bool {
    return this.vx != 0;
  }

  inline function get_facing():Int {
    return this._facing;
  }

  inline function set_facing(val:Int):Int {
    this.bitmap.x = this.offsetX * val;
    this.bitmap.scaleX = -val;
    return this._facing = val;
  }
  var _facing:Int = 0;

}