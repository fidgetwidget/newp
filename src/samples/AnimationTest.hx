package samples;

import openfl.display.Bitmap;
import openfl.ui.Keyboard;
import newp.scenes.SimpleScene;
import newp.display.frames.Frame;
import newp.display.frames.FrameSet;
import newp.display.frames.FrameFactory;
import newp.display.animation.Animation;
import newp.display.animation.AnimationQueue;
import newp.display.animation.BehaviourMap;
import newp.display.animation.FrameAnimation;
import newp.Lib;

class AnimationTest extends SimpleScene {

  var animationQueue:AnimationQueue<FrameAnimation>;
  var frameSet:FrameSet;
  var bitmap:Bitmap;
  var frameId:Int = -1;
  var frame:Frame = null;

  public function new () {
    super();
    this.initAnimations();
    this.initSprite();
  }

  // Methods

  function initAnimations():Void {
    var behaviours = new BehaviourMap<FrameAnimation>();
    behaviours.add(new FrameAnimation("idle",      [0, 1, 2],    true,   true,  3));
    behaviours.add(new FrameAnimation("walk",      [3, 4, 5],    false,  false, 10));
    behaviours.add(new FrameAnimation("jump",      [6, 7, 8],    false,  false, 10));
    behaviours.add(new FrameAnimation("hit",       [9, 10, 11],  false,  false, 10));
    behaviours.add(new FrameAnimation("punch",     [12, 13, 14], false,  false, 10));
    behaviours.add(new FrameAnimation("kick",      [15, 16, 17], false,  false, 10));
    behaviours.add(new FrameAnimation("flypunch",  [18, 19, 20], false,  false, 10));
    behaviours.add(new FrameAnimation("flykick",   [21, 22, 23], false,  false, 10));
    behaviours.add(new FrameAnimation("ko",        [24, 25, 26], true,   false, 6));
    this.animationQueue = new AnimationQueue(behaviours.behaviourAnimationMap, "idle");
    var asset = openfl.Assets.getBitmapData('assets/private/fox/kit_from_firefox.png');
    this.frameSet = FrameFactory.makeFrameSet('fox', asset, 56, 80);
  }

  function initSprite():Void {
    this.bitmap = new Bitmap();
    this.container.addChild(this.bitmap);
  }

  // Update Loop

  public override function update():Void {
    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_1)) {
      this.animationQueue.enqueue("walk");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_2)) {
      this.animationQueue.enqueue("jump");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_3)) {
      this.animationQueue.enqueue("hit");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_4)) {
      this.animationQueue.enqueue("punch");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_5)) {
      this.animationQueue.enqueue("kick");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_6)) {
      this.animationQueue.enqueue("flypunch");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_7)) {
      this.animationQueue.enqueue("flykick");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_8)) {
      this.animationQueue.enqueue("ko");
    }

    // if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_9)) {
    //   this.animationQueue.enqueue("block");
    // }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_0)) {
      this.animationQueue.enqueue(null, true);
    }

    this.animationQueue.update();
    if (this.animationQueue.current.frameId != this.frameId) {
      this.setFrame();
    }
  } 

  inline function setFrame() :Void {
    this.frameId = this.animationQueue.current.frameId;
    this.frame = this.frameSet.getFrame(this.frameId);
    this.bitmap.bitmapData = this.frame.bmp;
  }

}