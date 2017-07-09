package samples.pong;

import openfl.display.Sprite;
import newp.collision.shapes.*;
import newp.utils.Draw;
import newp.Lib;

class PlayField {

  public var sprite:Sprite;
  public var scoreColliders:Array<Shape>;
  public var wallColliders:Array<Shape>;
  var height:Int;
  var width:Int;

  public function new () {
    this.sprite = new Sprite();
    this.scoreColliders = [];
    this.wallColliders = [];
    this.height = Lib.stage.stageHeight - 40;
    this.width = Lib.stage.stageWidth - 40;
    this.createScoreZones();
    this.createWalls();
    this.createDecorations();
  }


  function createScoreZones() {
    var lWall = new Sprite();
    lWall.x = 20;
    lWall.y = Lib.stage.stageHeight * 0.5;
    Draw.start(lWall.graphics)
      .lineStyle(1, 0xff0000)
      .moveTo(0, -height * 0.5)
      .lineTo(0, height * 0.5);

    var rWall = new Sprite();
    rWall.x = Lib.stage.stageWidth - 20;
    rWall.y = Lib.stage.stageHeight * 0.5;

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
    tWall.x = Lib.stage.stageWidth * 0.5;
    tWall.y = 20;

    Draw.start(tWall.graphics)
      .lineStyle(1, 0x333333)
      .moveTo(-width * 0.5, 0)
      .lineTo(width * 0.5, 0);

    var bWall = new Sprite();
    bWall.x = Lib.stage.stageWidth * 0.5;
    bWall.y = Lib.stage.stageHeight - 20;

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
    net.graphics.moveTo(Lib.stage.stageWidth * 0.5, 40);
    net.graphics.lineTo(Lib.stage.stageWidth * 0.5, Lib.stage.stageHeight - 40);

    this.sprite.addChild(net);
  }

}