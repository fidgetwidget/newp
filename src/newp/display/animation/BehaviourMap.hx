package newp.display.animation;

class BehaviourMap<T:Animation> {

  public var behaviourAnimationMap:Map<String, T>;

  public function new() {
    this.behaviourAnimationMap = new Map<String, T>();
  }

  public function add(anim:T){
    this.behaviourAnimationMap.set(anim.name, anim);
  }

  // TODO: add support for other animation types

}
