package newp.scenes;


import newp.scenes.Scene;


class Example extends Scene {
  
  
  public function new () {
    
    super ();
    
    var shape = new openfl.display.Sprite();
    var g = shape.graphics;
    g.lineStyle(1, 0xff0000);
    g.moveTo(10, 10);
    g.lineTo(100, 10);
    g.lineTo(100, 100);
    g.lineTo(90, 110);
    g.lineTo(10, 100);
    g.lineTo(10, 10);
    this.addChild(shape);
    
  }
  
  
}