package newp.inputs;

import openfl.geom.Point;
import openfl.events.MouseEvent;

class MouseInput {

  var mouseStates:Map<Int,Int>;
  var mousePos:Point;

  public var x(get, never):Float;
  public var y(get, never):Float;

  public function new() {
    this.initStates();
    this.initPosition();
    this.addEventHandlers();
  }

  public function update():Void {
    for (i in 0...MouseButtons.COUNT) {
      if (this.mouseStates.get(i) == 2) this.mouseStates.set(i, 1);
      if (this.mouseStates.get(i) == -1) this.mouseStates.set(i, 0);
    }
  }

  public function down(button:Int = 0):Bool {
    if (!this.mouseStates.exists(button)) return false;
    return this.mouseStates.get(button) > 0;
  }

  public function up(button:Int = 0):Bool {
    if (!this.mouseStates.exists(button)) return false;
    return this.mouseStates.get(button) <= 0;
  }

  public function pressed(button:Int = 0):Bool {
    if (!this.mouseStates.exists(button)) return false;
    return this.mouseStates.get(button) == 2;
  }

  public function released(button:Int = 0):Bool {
    if (!this.mouseStates.exists(button)) return false;
    return this.mouseStates.get(button) == -1;
  }

  // +-------------------------
  // | Initializers
  // +-------------------------

  inline function initStates():Void {
    this.mouseStates = new Map();
    this.mouseStates.set(MouseButtons.LEFT_MOUSE,   0);
    this.mouseStates.set(MouseButtons.MIDDLE_MOUSE, 0);
    this.mouseStates.set(MouseButtons.RIGHT_MOUSE,  0);
  }

  inline function initPosition():Void {
    this.mousePos = new Point();
  }

  inline function addEventHandlers():Void {
    
    Lib.stage.addEventListener(MouseEvent.MOUSE_MOVE,         onMouseMove);

    Lib.stage.addEventListener(MouseEvent.MOUSE_DOWN,         onLeftMouseDown);
    Lib.stage.addEventListener(MouseEvent.MOUSE_UP,           onLeftMouseUp);

    Lib.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,  onMiddleMouseDown);
    Lib.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,    onMiddleMouseUp);

    Lib.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,   onRightMouseDown);
    Lib.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,     onRightMouseUp);
    
  }

  // +-------------------------
  // | Event Handlers
  // +-------------------------

  function onMouseMove(e:MouseEvent):Void {
    this.mousePos.x = e.stageX;
    this.mousePos.y = e.stageY;
  }

  function onLeftMouseDown(e:MouseEvent):Void   { this.mouseStates.set(MouseButtons.LEFT_MOUSE, 2); }
  function onLeftMouseUp(e:MouseEvent):Void     { this.mouseStates.set(MouseButtons.LEFT_MOUSE, -1); }

  function onMiddleMouseDown(e:MouseEvent):Void { this.mouseStates.set(MouseButtons.MIDDLE_MOUSE, 2); }
  function onMiddleMouseUp(e:MouseEvent):Void   { this.mouseStates.set(MouseButtons.MIDDLE_MOUSE, -1); }

  function onRightMouseDown(e:MouseEvent):Void  { this.mouseStates.set(MouseButtons.RIGHT_MOUSE, 2); }
  function onRightMouseUp(e:MouseEvent):Void    { this.mouseStates.set(MouseButtons.RIGHT_MOUSE, -1); }


  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_x():Float { return this.mousePos.x; }

  inline function get_y():Float { return this.mousePos.y; }

}