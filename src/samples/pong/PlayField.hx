package samples.pong;

import openfl.display.Sprite;
import newp.collision.shapes.*;
import newp.utils.Draw;
import newp.Lib;

class PlayField {

  public var sprite:Sprite;
  public var scoreColliders:Array<Shape>;
  public var wallColliders:Array<Shape>;
  public var centerX(get, never):Float;
  public var centerY(get, never):Float;
  public var top(get, never):Float;
  public var right(get, never):Float;
  public var bottom(get, never):Float;
  public var left(get, never):Float;

  var height:Int;
  var width:Int;

  public function new () {
    this.sprite = new Sprite();
    this.scoreColliders = [];
    this.wallColliders = [];
    this.height = 480;
    this.width = 640;
    this.createScoreZones();
    this.createWalls();
    this.createDecorations();
  }


  function createScoreZones() {
    var lWall = new Sprite();
    lWall.x = this.left;
    lWall.y = this.centerY;
    
    Draw.start(lWall.graphics)
      .lineStyle(1, 0xff0000)
      .moveTo(0, -height * 0.5)
      .lineTo(0, height * 0.5);

    var rWall = new Sprite();
    rWall.x = this.right;
    rWall.y = this.centerY;

    Draw.start(rWall.graphics)
      .lineStyle(1, 0xff0000)
      .moveTo(0, -height * 0.5)
      .lineTo(0, height * 0.5);

    this.sprite.addChild(lWall);
    this.sprite.addChild(rWall);

    // Colliders

    var lWallCollider = Polygon.rectangle(lWall, 1, height);
    var rWallCollider = Polygon.rectangle(rWall, 1, height);

    this.scoreColliders.push(lWallCollider);
    this.scoreColliders.push(rWallCollider);
  }

  function createWalls() {
    var tWall = new Sprite();
    tWall.x = this.centerX;
    tWall.y = this.top;

    Draw.start(tWall.graphics)
      .lineStyle(1, 0x333333)
      .moveTo(-width * 0.5, 0)
      .lineTo(width * 0.5, 0);

    var bWall = new Sprite();
    bWall.x = this.centerX;
    bWall.y = this.bottom;

    Draw.start(bWall.graphics)
      .lineStyle(1, 0x333333)
      .moveTo(-width * 0.5, 0)
      .lineTo(width * 0.5, 0);

    this.sprite.addChild(tWall);
    this.sprite.addChild(bWall);

    var tWallCollider = Polygon.rectangle(tWall, width, 1);
    var bWallCollider = Polygon.rectangle(bWall, width, 1);

    this.wallColliders.push(tWallCollider);
    this.wallColliders.push(bWallCollider);
  }

  function createDecorations() {
    var net = new Sprite();
    net.graphics.lineStyle(8, 0x999999, 0.5);
    net.graphics.moveTo(this.centerX, this.top + 20);
    net.graphics.lineTo(this.centerX, this.bottom - 20);

    this.sprite.addChild(net);
  }

  inline function get_centerX():Float { return Lib.stage.stageWidth * 0.5; }
  inline function get_centerY():Float { return Lib.stage.stageHeight * 0.5; }

  inline function get_top():Float     { return this.centerY - this.height * 0.5; }
  inline function get_right():Float   { return this.centerX + this.width * 0.5; }
  inline function get_bottom():Float  { return this.centerY + this.height * 0.5; }
  inline function get_left():Float    { return this.centerX - this.width * 0.5; }

}