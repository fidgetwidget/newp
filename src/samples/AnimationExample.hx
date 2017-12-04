package samples;

import openfl.display.Bitmap;
import openfl.ui.Keyboard;
import newp.scenes.SimpleScene;
import newp.display.frames.*;
import newp.display.animation.*;
import newp.Lib;

class AnimationExample extends SimpleScene {

  var animationQueue:AnimationQueue<FrameAnimation>;
  var frameSet:FrameSet;
  var bitmap:Bitmap;
  var frameId:Int = -1;
  var frame:Frame = null;

  public function new () {
    super();
    this.initFrameData();
    this.initAnimations();
    this.initSprite();
  }

  // Methods

  function initFrameData() :Void {
    var asset = openfl.Assets.getBitmapData('assets/animationTest/kit.png');
    this.frameSet = FrameFactory.makeFrameSet('fox', asset, 56, 80);
  }

  function initAnimations() :Void {
    var behaviours = new BehaviourMap<FrameAnimation>();

    behaviours.add( new FrameAnimation("idle",      [0, 1, 2],      true,  true,  3) );
    behaviours.add( new FrameAnimation("walk",      [3, 4, 5],      false, false, 5) );
    behaviours.add( new FrameAnimation("jump",      [6, 7, 8],      false, false, 10) );
    behaviours.add( new FrameAnimation("hit",       [9, 10, 11],    false, false, 10) );
    behaviours.add( new FrameAnimation("punch",     [12, 13, 14],   false, false, 10) );
    behaviours.add( new FrameAnimation("kick",      [15, 16, 17],   false, false, 10) );
    behaviours.add( new FrameAnimation("airpunch",  [18, 19, 20],   false, false, 10) );
    behaviours.add( new FrameAnimation("airkick",   [21, 22, 23],   false, false, 10) );
    behaviours.add( new FrameAnimation("ko",        [24, 25, 26],   true,  true,  8) );

    this.animationQueue = new AnimationQueue(behaviours.behaviourAnimationMap, "idle");
  }
 
  /* 
  // Alternatively, you could use a FrameGroup to define the name => frameIndexes
  // This would be useful if, for example, you wanted to use the walk frames for a run, only at a faster speed. 
  function initAnimations() :Void {
    var frameGroups = new FrameGroups(this.frameSet, [
        "idle" =>      [0, 1, 2],
        "walk" =>      [3, 4, 5],
        "jump" =>      [6, 7, 8],
        "hit" =>       [9, 10, 11],
        "punch" =>     [12, 13, 14],
        "kick" =>      [15, 16, 17],
        "airpunch" =>  [18, 19, 20],
        "airkick" =>   [21, 22, 23],
        "ko" =>        [24, 25, 26],
      ]);
    var behaviours = new BehaviourMap<FrameAnimation>();
    behaviours.add( frameGroups.makeFrameAnimation("airkick",  false,   false,     10) );
    behaviours.add( frameGroups.makeFrameAnimation("airpunch", false,   false,     10) );
    behaviours.add( frameGroups.makeFrameAnimation("hit",      false,   false,     10) );
    behaviours.add( frameGroups.makeFrameAnimation("idle",     true,    true,      3)  );
    behaviours.add( frameGroups.makeFrameAnimation("jump",     false,   false,     10) );
    behaviours.add( frameGroups.makeFrameAnimation("kick",     false,   false,     10) );
    behaviours.add( frameGroups.makeFrameAnimation("ko",       true,    true,      8) );
    behaviours.add( frameGroups.makeFrameAnimation("punch",    false,   false,     10) );
    behaviours.add( frameGroups.makeFrameAnimation("walk",     false,   false,     5)  );

    this.animationQueue = new AnimationQueue(behaviours.behaviourAnimationMap, "idle");
  }
   */

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
      this.animationQueue.enqueue("airpunch");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_7)) {
      this.animationQueue.enqueue("airkick");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_8)) {
      this.animationQueue.enqueue("ko", false, 5);
    }

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