package newp.utils;

import openfl.geom.Point;
import newp.math.Bit;

class Directions {

  public static inline var NONE:Int  = 0;

  public static inline var N:Int  = 1 << 0;
  public static inline var E:Int  = 1 << 1;
  public static inline var S:Int  = 1 << 2;
  public static inline var W:Int  = 1 << 3;

  public static inline var CARDINAL:Int = N | E | S | W;

  public static inline var NW:Int = 1 << 4;
  public static inline var NE:Int = 1 << 5;
  public static inline var SE:Int = 1 << 6;
  public static inline var SW:Int = 1 << 7;

  public static inline var ANY:Int = NW | N | NE | E | SE | S | SW | W;

  public static inline var UP:Int    = N;
  public static inline var RIGHT:Int = E;
  public static inline var DOWN:Int  = S;
  public static inline var LEFT:Int  = W;

  public static inline var HORIZONTAL:Int = LEFT | RIGHT;
  public static inline var VERTICAL:Int = UP | DOWN;

  public static function isValid(direction:Int):Bool {
    return direction >= UP && direction <= UP | RIGHT | DOWN | LEFT;
  }

  public static function vectorFrom(direction:Int):Point {
    switch (direction) {
      case NW:  return _nw.clone();
      case N:   return _n.clone();
      case NE:  return _ne.clone();
      case E:   return _e.clone();
      case SE:  return _se.clone();
      case S:   return _s.clone();
      case SW:  return _sw.clone();
      case W:   return _w.clone();
      default:  return new Point(0,0); // a conflicting mixture
    }
  }

  public static function limitTo(point:Point, direction:Int) :Void {
    // has no north, but points north
    if (!Bit.has(direction, NW) && 
        !Bit.has(direction, N) && 
        !Bit.has(direction, NE) && 
        point.y < 0) point.y = 0;

    // has no east but points east
    if (!Bit.has(direction, E) &&
        !Bit.has(direction, NE) && 
        !Bit.has(direction, SE) &&
        point.x > 0) point.x = 0;

    // has no south but points south
    if (!Bit.has(direction, SW) && 
        !Bit.has(direction, S) && 
        !Bit.has(direction, SE) &&  
        point.y > 0) point.y = 0;

    // has no west but points west
    if (!Bit.has(direction, W) &&
        !Bit.has(direction, NW) && 
        !Bit.has(direction, SW) && 
        point.x < 0) point.x = 0;
  }

  static var _nw:Point = new Point(-1, -1);
  static var _n:Point  = new Point( 0, -1);
  static var _ne:Point = new Point( 1, -1);
  static var _e:Point  = new Point( 1,  0);
  static var _se:Point = new Point( 1,  1);
  static var _s:Point  = new Point( 0,  1);
  static var _sw:Point = new Point(-1,  1);
  static var _w:Point  = new Point(-1,  0);

}