package newp.display.animation;

@:generic
class AnimationQueue<T:Animation> {

  public var behaviourAnimationsMap:Map<String, T>;
  public var current(get, never):T;
  public var behaviour(get, never):String;
  public var defaultBehaviour:String;

  var queue:Array<String>;
  var _currentBehaviour:String;
  var _loopLimit:Null<Int>;
  var _currentAnimation:T;

  public function new(behaviourAnimationsMap:Map<String, T> = null, defaultBehaviour:String = null) {
    this.behaviourAnimationsMap = behaviourAnimationsMap;
    this.defaultBehaviour = defaultBehaviour;
    
    this.queue = [];
    this._currentBehaviour = null;
    this._currentAnimation = null;
  }

  public function update():Void {
    if (this.current == null) return;
    this.current.update();
  }

  // for setting up the next behaviour
  public function enqueue(behaviour:String, force:Bool = false, loopCount:Null<Int> = null ) {
    if (force) {
      if (this._currentAnimation != null) {
        this._currentAnimation.onComplete = null;
        this._currentAnimation.onLoop = null;
      }
      this.clearQueue();
    }

    if (behaviour != null && this.behaviourAnimationsMap.exists(behaviour)) {
      this.queue.push(behaviour);
      this._loopLimit = loopCount;
    }

    if (force) { this.setCurrent(); }
  }

  function currentAnimationComplete(anim:Animation):Void {
    anim.onComplete = null; // remove our listener
    this.queue.shift();
    this.setCurrent();
  }

  function currentAnimationLoop(anim:Animation, count:Int):Void {
    if (this._loopLimit != null && this._loopLimit <= count) {
      anim.stop();
      anim.onLoop = null;
      this._loopLimit = null;
      this.currentAnimationComplete(anim);
    }
  }

  inline function clearQueue():Void {
    while (this.queue.length > 0) { this.queue.pop(); }
  }

  inline function setCurrent():Void {
    this._currentBehaviour = this.behaviour;
    this._currentAnimation = this.behaviourAnimationsMap[this._currentBehaviour];
    this._currentAnimation.onComplete = this.currentAnimationComplete;
    this._currentAnimation.onLoop = this.currentAnimationLoop;
    this._currentAnimation.play();
  }

  // Properties

  inline function get_current():T {
    if (this._currentBehaviour != this.behaviour) { this.setCurrent(); }
    return this._currentAnimation;
  }

  inline function get_behaviour():String {
    return this.queue.length == 0 ? this.defaultBehaviour : this.queue[0];
  }

}
