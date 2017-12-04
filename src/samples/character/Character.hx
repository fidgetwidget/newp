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

  var START_JUMP_TIME:Float = 1;
  var MAX_AIRTIME:Float = 1.5;
  var LEFT:Int = 1;
  var RIGHT:Int = 0;
  var PUNCH_AIRTIME:Float = 1/6;
  var KICK_AIRTIME:Float = 1/6;

  var bitmap:Bitmap;
  var sprite:SpriteComponent;
  var animation:AnimationComponent;
  var facing:Int = 0; // 0: right, 1:left
  var jumping:Bool = false;
  var airtime:Float = 0;
  var offsetX:Float = 56 / 2;

  public function new() {
    super();
    this.initAnimation();
    this.initSprite();
  }

  function initAnimation() :Void {
    var asset = openfl.Assets.getBitmapData('assets/animationTest/kit.png');
    var frameSet = FrameFactory.makeFrameSet('fox', asset, 56, 80);
    var behaviours = new BehaviourMap<FrameAnimation>();
    behaviours.add( new FrameAnimation("idle",      [0, 1, 2],      true,  true,  3) );
    behaviours.add( new FrameAnimation("walk",      [3, 4, 5],      false, false, 5) );
    behaviours.add( new FrameAnimation("jump",      [6, 7],         false, false, 5) );
    behaviours.add( new FrameAnimation("fall",      [8],            true, false,  1) );
    behaviours.add( new FrameAnimation("hit",       [9, 10, 11],    false, false, 10) );
    behaviours.add( new FrameAnimation("punch",     [12, 13, 14],   false, false, 10) );
    behaviours.add( new FrameAnimation("kick",      [15, 16, 17],   false, false, 10) );
    behaviours.add( new FrameAnimation("airpunch",  [18, 19, 20],   false, false, 10) );
    behaviours.add( new FrameAnimation("airkick",   [21, 22, 23],   false, false, 10) );
    behaviours.add( new FrameAnimation("ko",        [24, 25, 26],   true,  true,  8) );
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
    if (this.airtime > 0) {
      this.animation.defaultBehaviour = 'jump';
      this.airtime -= Lib.delta;
    } else {
      this.animation.defaultBehaviour = 'idle';
      this.jumping = false;
    }
  }

  override function postUpdate() :Void {
    if (this.bitmap.bitmapData != this.animation.bitmapData) {
      this.bitmap.bitmapData = this.animation.bitmapData;
    }
  }


  public function moveLeft() :Void {
    this.facing = LEFT;
    this.bitmap.scaleX = -1;
    this.bitmap.x = this.offsetX;
  }

  public function moveRight() :Void {
    this.facing = RIGHT;
    this.bitmap.scaleX = 1;
    this.bitmap.x = -this.offsetX;
  }

  public function jump() :Void {
    if (this.jumping) {
      if (this.airtime < MAX_AIRTIME) {
        this.airtime++;
      }
    } else {
      this.startJump();
    }
  }

  public function punch() :Void {
    if (this.jumping) {
      this.animation.enqueue('airpunch');
      this.airtime += PUNCH_AIRTIME;
    } else {
      this.animation.enqueue('punch');
    }
  }

  public function kick() :Void {
    if (this.jumping) {
      this.animation.enqueue('airkick');
      this.airtime += KICK_AIRTIME;
    } else {
      this.animation.enqueue('kick');
    }
  }


  function startJump() :Void {
    this.jumping = true;
    this.airtime = START_JUMP_TIME;
    this.animation.enqueue('jump');
  }

}