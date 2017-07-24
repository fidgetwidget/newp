package newp.math;


class MotionRange {

  var motionPropertiesMap:Map<String, MotionPropertyRange>;

  public function new(?properties:Array<String>) {
    this.motionPropertiesMap = new Map();
    if (properties != null) this.addProperty(properties);
  }

  // Methods
  // =======

  public function addProperty(prop:Dynamic):MotionRange {
    if (Std.is(prop, Array)) {
      var array:Array<String> = cast(prop);
      for (p in array) this.setProp(p, new MotionPropertyRange());
    } else if (Std.is(prop, String)) {
      var p:String = cast(prop);
      this.setProp(p, new MotionPropertyRange());
    } else {
      throw "Invalid prop. Must be either a String or an Array";
    }
    
    return this;
  }

  public function a(prop:String, ?min:Float, ?max:Float):Range {
    var m = this.getProp(prop);
    if (min != null) {
      max = max == null ? min : max;
      m.a.setup(min, max);
    }
    return m.a;
  }

  public function v(prop:String, ?min:Float, ?max:Float):Range {
    var m = this.getProp(prop);
    if (min != null) {
      max = max == null ? min : max;
      m.v.setup(min, max);
    }
    return m.v;
  }

  public function setDrag(min:Float, ?max:Float, ?prop:String):Void {
    var mp;
    max = max == null ? min : max;
    if (prop != null) {
      mp = this.motionPropertiesMap[prop];
      mp.drag.min = min;
      mp.drag.max = max;
    } else {
      for (p in this.motionPropertiesMap.keys()) {
        mp = this.motionPropertiesMap[p];
        mp.drag.min = min;
        mp.drag.max = max;
      }
    }
  }

  public function setMax(min:Float, ?max:Float, ?prop:String):Void {
    var mp;
    max = max == null ? min : max;
    if (prop != null) {
      mp = this.motionPropertiesMap[prop];
      mp.max.min = min;
      mp.max.max = max;
    } else {
      for (p in this.motionPropertiesMap.keys()) {
        mp = this.motionPropertiesMap[p];
        mp.max.min = min;
        mp.max.max = max;
      }
    }
  }

  public function copyFrom(motion:MotionRange):MotionRange {
    for (p in motion.motionPropertiesMap.keys()) {
      var mp:MotionPropertyRange;
      if (this.motionPropertiesMap.exists(p)) 
        mp = this.motionPropertiesMap.get(p);
      else 
        mp = new MotionPropertyRange();
      mp.copyFrom(motion.motionPropertiesMap.get(p));
      this.motionPropertiesMap.set(p, mp);
    }
    return this;
  }

  public function copyTo(motion:Motion):Void {
    for (p in this.motionPropertiesMap.keys()) {
      var mp = this.motionPropertiesMap[p]
      motion.addProperty(p);
      motion.a(p, mp.a.random());
      motion.v(p, mp.v.random());
      motion.drag(p, mp.drag.random());
      motion.max(p, mp.max.random());
    }
  }
 
  // Internal
  // ========

  inline function setProp(prop:String, val:MotionPropertyRange) {
    this.motionPropertiesMap.set(prop, val);
  }

  inline function getProp(prop:String):MotionPropertyRange {
    if (!this.motionPropertiesMap.exists(prop)) throw 'Invalid Property $prop';
    return this.motionPropertiesMap.get(prop);
  }

}