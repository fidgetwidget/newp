package newp.components;

import openfl.display.BitmapData;
import newp.Entity;
import newp.display.frames.Frame;
import newp.display.frames.FrameSet;
import newp.display.animation.AnimationQueue;
import newp.display.animation.FrameAnimation;

class AnimationComponent implements IComponent implements IUpdateable {

  public static function make(e:Entity, frameSet:FrameSet, queue:AnimationQueue<FrameAnimation>) :AnimationComponent {
    var fac = new AnimationComponent(frameSet, queue);
    e.addComponent(fac);
    return fac;
  }

  static var uid:Int = 0;

  // Instance
  // ========

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = true;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = false;

  public var queue:AnimationQueue<FrameAnimation>;
  public var frameSet:FrameSet;
  public var bitmapData(get, never):BitmapData;
  public var defaultBehaviour(get, set):String;
  var behaviour:String;
  var animation:FrameAnimation;
  var bmp:BitmapData;
  var frame:Frame;
  var frameId:Int;

  public function new(frameSet:FrameSet, queue:AnimationQueue<FrameAnimation>, ?name:String) {
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++AnimationComponent.uid}' : name;
    this.frameSet = frameSet;
    this.queue = queue;
    this.behaviour = this.queue.defaultBehaviour;
    this.animation = this.queue.current;
    this.frame = null;
    this.frameId = -1;
  }

  // Updateable
  // ==========

  public function enqueue(behaviour:String, force:Bool = false):Void {
    this.queue.enqueue(behaviour, force);
  }

  public function update():Void {
    if (this.entity == null) return;
    this.queue.update();
    // check for changes
    if (this.behaviour != this.queue.behaviour) {
      this.setAnimation();
    } else if (this.animation.frameId != this.frameId) {
      this.setFrame();
    }
  }

  // Component
  // =========

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

  // Methods
  // =======

  inline function setAnimation():Void {
    this.behaviour = this.queue.behaviour;
    this.animation = this.queue.current;
  }

  inline function setFrame():Void {
    this.frameId = this.animation.frameId;
    this.frame = this.frameSet.getFrame(this.frameId);
    this.bmp = this.frame.bmp;
  }

  // Properites
  // ==========

  inline function get_defaultBehaviour():String {
    return this.queue.defaultBehaviour;
  }
  inline function set_defaultBehaviour(val:String):String {
    return this.queue.defaultBehaviour = val;
  }

  inline function get_bitmapData():BitmapData {
    if (this.frameId != this.animation.frameId) {
      this.setFrame();
    }
    return this.bmp;
  }

}
