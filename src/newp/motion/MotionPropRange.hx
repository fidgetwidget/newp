package newp.motion;

import newp.math.Range;


class MotionPropRange {

  public var a:Range;
  public var v:Range;
  public var drag:Range;
  public var max:Range;

  public function new() {
    this.a = new Range();
    this.v = new Range();
    this.drag = new Range();
    this.max = new Range();
  }

}
