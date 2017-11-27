package newp.display.animation;

class AnimationQueue {

  public var behaviourAnimationsMap:Map<String, Animation>;
  public var current(get, never):Animation;
  public var behaviour(get, never):String;

  var queue:Array<String>;
  var _currentBehaviour:String;
  var _currentAnimation:Animation;

  public function new(behaviourAnimationsMap:Map<String, Animation> = null, defaultBehaviour:String = null) {
    this.behaviourAnimationsMap = behaviourAnimationsMap;
    this.defaultBehaviour = defaultBehaviour;
    
    this.queue = [];
    this._currentBehaviour = null;
    this._currentAnimation = null;
  }

  // for setting up the next behaviour
  public function enqueue(behaviour:String, force:Bool = false) {
    if (force) {
      this.clearQueue();
    }
    this.queue.push(behaviour);
  }

  function currentAnimationComplete(anim:Animation):Void {
    anim.onComplete = null; // remove our listener
    this.queue.shift();
    this.setCurrent();
  }

  inline function clearQueue():Void {
    while (this.queue.length > 0) { this.queue.pop(); }
  }

  inline function setCurrent():Void {
    this._currentBehaviour = this.behaviour();
    this._currentAnimation = this.animations(this._currentBehaviour);
    this._currentAnimation.onComplete = this.currentAnimationComplete;
  }

  // Properties

  inline function get_current():Animation {
    if (this._currentBehaviour != this.behaviour) { this.setCurrent(); }
    return this._currentAnimation;
  }

  inline function get_behaviour():String {
    return this.queue.length == 0 ? this.defaultBehaviour : this.queue[0];
  }

}
