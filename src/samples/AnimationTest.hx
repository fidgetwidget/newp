package samples;

import openfl.display.Bitmap;
import newp.scenes.SimpleScene;
import newp.display.frames.Frame;
import newp.display.frames.FrameSet;
import newp.display.frames.FrameFactory;
import newp.display.animation.Animation;
import newp.display.animation.AnimationQueue;
import newp.display.animation.BehaviourMap;
import newp.display.animation.FrameAnimation;

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
    behaviours.add(new FrameAnimation("stand",     [0, 1, 2],    true,   true,  3));
    behaviours.add(new FrameAnimation("down",      [3, 4, 5],    false,  false, 10));
    behaviours.add(new FrameAnimation("jump",      [6, 7, 8],    false,  false, 10));
    behaviours.add(new FrameAnimation("hit",       [9, 10, 11],  false,  false, 10));
    behaviours.add(new FrameAnimation("punch",     [12, 13, 14], false,  false, 10));
    behaviours.add(new FrameAnimation("kick",      [15, 16, 17], false,  false, 10));
    behaviours.add(new FrameAnimation("flypunch",  [18, 19, 20], false,  false, 10));
    behaviours.add(new FrameAnimation("flykick",   [21, 22, 23], false,  false, 10));
    behaviours.add(new FrameAnimation("dizzy",     [24, 25, 26], true,   false, 6));
    this.animationQueue = new AnimationQueue(behaviours.behaviourAnimationMap, "stand");
    var asset = openfl.Assets.getBitmapData('assets/private/fox/kit_from_firefox.png');
    this.frameSet = FrameFactory.makeFrameSet('fox', asset, 56, 80);
  }

  function initSprite():Void {
    this.bitmap = new Bitmap();
    this.container.addChild(this.bitmap);
  }

  // Update Loop

  public override function update():Void {
    this.animationQueue.update();
    if (this.animationQueue.current.frameId != this.frameId) {
      this.setFrame();
    }
    // trace(this.animationQueue.current.current);
  } 

  inline function setFrame() :Void {
    this.frameId = this.animationQueue.current.frameId;
    this.frame = this.frameSet.getFrame(this.frameId);
    this.bitmap.bitmapData = this.frame.bmp;
  }

}