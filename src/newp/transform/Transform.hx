package newp.display;

import newp.Lib;


class Transform {

  var map:Map<String, FloatTransform>;
  
  public function new(?props:Array<String>) {
    for (prop in props) {
      this.map.set(prop, {from:null, to:null});
    }
  }

  public function set(prop:String, ?from:Float, ?to:Float):Transform {
    this.map.set(prop, { from: from, to: to });
    return this;
  }

  public function has(prop:String):Bool {
    return this.map.exists(prop);
  }

  public function get(prop:String):FloatTransform {
    return this.map[prop];
  }

}