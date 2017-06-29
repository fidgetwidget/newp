package newp.inputs;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class KeyboardInput {

  var keyStates:KeyStateMap;

  public function new() {
    this.initStates();
    this.addEventHandlers();
  }

  public function down(key:Int):Bool {
    if (!this.keyStates.has(key)) return false;
    return this.keyStates.get(key).current > 0;
  }

  public function up(key:Int):Bool {
    if (!this.keyStates.has(key)) return false;
    return this.keyStates.get(key).current <= 0; 
  }

  public function pressed(key:Int):Bool {
    if (!this.keyStates.has(key)) return false;
    return this.keyStates.get(key).current == 2;
  }

  public function released(key:Int):Bool {
    if (!this.keyStates.has(key)) return false;
    return this.keyStates.get(key).current == -1;
  }

  public function update():Void {
    for (k in keyStates.keys()) {
      var state = keyStates.get(k);
      if (state.last == -1 && state.current == -1) state.current = 0;
      if (state.last == 2 && state.current == 2) state.current = 1;
      state.last = state.current;
    }
  }

  // +-------------------------
  // | Initializers
  // +-------------------------

  function initStates():Void {
    this.keyStates = KeyStateMap.make();
  }

  function addEventHandlers():Void {
    Lib.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    Lib.stage.addEventListener( KeyboardEvent.KEY_UP,   onKeyUp );
  }

  // +-------------------------
  // | Event Handlers
  // +-------------------------

  function onKeyDown(e:KeyboardEvent):Void {
    var key = e.keyCode;
    if (!keyStates.has(key)) return;
    var state = keyStates.get(key);
    if (state.current > 0) state.current = 1;
    else state.current = 2;
  }

  function onKeyUp(e:KeyboardEvent):Void {
    var key = e.keyCode;
    if (!keyStates.has(key)) return;
    var state = keyStates.get(key);
    if (state.current > 0) state.current = -1;
    else state.current = 0;
  }

}