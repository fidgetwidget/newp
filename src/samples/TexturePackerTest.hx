package samples;

import openfl.display.Bitmap;
import openfl.ui.Keyboard;
import newp.scenes.SimpleScene;
import newp.display.frames.*;
import newp.display.imports.TexturePackerImporter;
import newp.display.animation.*;
import newp.Lib;

class TexturePackerTest extends SimpleScene {

  var animationQueue:AnimationQueue<FrameAnimation>;
  var frameGroups:FrameGroups;
  var frameSet(get, never):FrameSet;
  var bitmap:Bitmap;
  var frameId:Int = -1;
  var frame:Frame = null;

  public function new () {
    super();
    this.initGroups();
    this.initSprite();
  }

  // Methods

  function initGroups():Void {
    var importer = new TexturePackerImporter();
    var exp:EReg = ~/.+(?=\/)/;
    this.frameGroups = importer.praseIntoGroups('kit', 'assets/animationTest/texturePacker/kit', exp);
    var behaviours = new BehaviourMap<FrameAnimation>();
    
    //                                            name        loop     reverse    fps
    behaviours.add(frameGroups.makeFrameAnimation("airkick",  false,   false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("airpunch", false,   false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("block",    false,   false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("hit",      false,   false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("idle",     true,    true,      3));
    behaviours.add(frameGroups.makeFrameAnimation("jump",     false,   false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("kick",     false,   false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("ko",       true,    false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("punch",    false,   false,     10));
    behaviours.add(frameGroups.makeFrameAnimation("walk",     false,   false,     5));

    this.animationQueue = new AnimationQueue(behaviours.behaviourAnimationMap, "idle");
  }

  function initSprite():Void {
    this.bitmap = new Bitmap();
    this.container.addChild(this.bitmap);
  }

  // Update Loop

  public override function update():Void {
    this.input_update(); // check for user input on what animation should be default/queued

    this.animationQueue.update();
    if (this.animationQueue.current.frameId != this.frameId) {
      this.setFrame();
    }
  } 

  inline function input_update():Void {
    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_1)) {
      this.animationQueue.defaultBehaviour = "walk";
      this.animationQueue.enqueue(null, true);
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
      this.animationQueue.defaultBehaviour = "ko";
      this.animationQueue.enqueue(null, true);
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_9)) {
      this.animationQueue.enqueue("block");
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.NUMBER_0)) {
      this.animationQueue.defaultBehaviour = "idle";
      this.animationQueue.enqueue(null, true);
    }
  }

  inline function setFrame() :Void {
    this.frameId = this.animationQueue.current.frameId;
    this.frame = this.frameSet.getFrame(this.frameId);
    this.bitmap.bitmapData = this.frame.bmp;
  }

  inline function get_frameSet():FrameSet { return this.frameGroups == null ? null : this.frameGroups.frameSet; }

}