package newp.motion;


class Motion {

  var motionPropertiesMap:Map<String, MotionProp>;

  public function new(?properties:Array<String>) {
    this.motionPropertiesMap = new Map();
    if (properties != null) this.addProperty(properties);
  }

  // Methods
  // =======

  public function update(target:Dynamic):Void {
    for (p in this.motionPropertiesMap.keys()) this.updateMotionProp(p, target);
  }

  public function addProperty(prop:Dynamic):Motion {
    if (Std.is(prop, Array)) {
      var array:Array<String> = cast(prop);
      for (p in array) this.setProp(p, new MotionProp());
    } else if (Std.is(prop, String)) {
      var p:String = cast(prop);
      this.setProp(p, new MotionProp());
    } else {
      throw "Invalid prop. Must be either a String or an Array";
    }
    
    return this;
  }

  public function a(prop:String, ?val:Float):Float {
    var m = this.getProp(prop);
    if (val != null) m.a = val;
    return m.a;
  }

  public function v(prop:String, ?val:Float):Float {
    var m = this.getProp(prop);
    if (val != null) m.v = val;
    return m.v;
  }

  public function drag(prop:String, ?val:Float):Float {
    var m = this.getProp(prop);
    if (val != null) m.drag = val;
    return m.drag;
  }

  public function max(prop:String, ?val:Float):Float {
    var m = this.getProp(prop);
    if (val != null) m.max = val;
    return m.max;
  }

  public function setDrag(val:Float, ?prop:String) {
    if (prop != null) {
      this.motionPropertiesMap[prop].drag = val;
    } else {
      for (p in this.motionPropertiesMap.keys()) this.motionPropertiesMap[p].drag = val;
    }
    return val;
  }

  public function setMax(val:Float, ?prop:String) {
    if (prop != null) {
      this.motionPropertiesMap[prop].max = val;
    } else {
      for (p in this.motionPropertiesMap.keys()) this.motionPropertiesMap[p].max = val;
    }
    return val;
  }

  public function copyFrom(motion:Motion):Motion {
    for (p in motion.motionPropertiesMap.keys()) {
      var prop:MotionProp;
      if (this.motionPropertiesMap.exists(p)) 
        prop = this.motionPropertiesMap.get(p);
      else 
        prop = new MotionProp();
      
      prop.copyFrom(motion.motionPropertiesMap.get(p));
      this.motionPropertiesMap.set(p, prop);
    }
    return this;
  }
 
  // Internal
  // ========

  inline function setProp(prop:String, val:MotionProp) {
    this.motionPropertiesMap.set(prop, val);
  }

  inline function getProp(prop:String):MotionProp {
    if (!this.motionPropertiesMap.exists(prop)) throw 'Invalid Property $prop';
    return this.motionPropertiesMap.get(prop);
  }

  inline function updateMotionProp(prop:String, target:Dynamic) {
    this.motionPropertiesMap[prop]
        .update()
        .apply(prop, target);
  }

}