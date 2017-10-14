package games.vollybox.components;

import games.vollybox.entities.Player;

import newp.components.Routine;
import newp.math.Utils as MathUtil;
import newp.Entity;
import newp.Lib;
import openfl.ui.Keyboard as Key;


class PlayerInput extends Routine {

  public var player(get, never):Player;
  var speed:Float;
  var inputs:Map<String, Int>;

  public function new() {
    super('playerInput');
  }

  override public function addedToEntity(e:Entity):Void {
    super.addedToEntity(e);
    this.initInputs();
  }

  override public function update():Void { 
    speed = player.hasBall ? Player.SERVICE_MOVE_SPEED : Player.BASE_MOVE_SPEED;

    var k = Lib.inputs.keyboard;
    var dx = 0;
    var dy = 0;
    if (!player.charging) {

      if (k.down(this.inputs['up'])) {
        dy = -1;
      } else if (k.down(this.inputs['down'])) {
        dy = 1;
      } else {
        dy = 0;
      }

      if (k.down(this.inputs['left'])) {
        dx = -1;
      } else if (k.down(this.inputs['right'])) {
        dx = 1;
      } else {
        dx = 0;
      }

      player.motion.ax = speed * dx;
      player.motion.ay = speed * dy;

      // Slow down faster on change of direction
      if (dy != 0 && MathUtil.sign(player.ay) != MathUtil.sign(player.vy)) {
        player.vy *= 0.25;
      }
      if (dx != 0 && MathUtil.sign(player.ax) != MathUtil.sign(player.vx)) {
        player.vx *= 0.25;
      }
    } else {
      if (!k.down(this.inputs['hit'])) {
        player.charging = false;
      }
    }

    if (!player.actionDelayed) {
      if (k.down(this.inputs['bump'])) {
        player.actionDelayed = true;
      }
    }
    if (k.released(this.inputs['bump']))  {
      player._bump();
    }

    if (k.pressed(this.inputs['hit'])) {
      player._chargeHit(dx, dy);
    } else if (k.released(this.inputs['hit'])) {
      player._hit();
    }
  }

  inline function initInputs() {
    switch (player.playerNo) {
      case 1:
        this.inputs = [
          'left'  => Key.A, // A
          'up'    => Key.W, // W
          'right' => Key.D, // D
          'down'  => Key.S, // S
          'bump'  => Key.K, 
          'hit'   => Key.L, 
        ];
      case 2:
        this.inputs = [
          'left'  => 37, // ARROW_LEFT
          'up'    => 38, // ARROW_UP
          'right' => 39, // ARROW_RIGHT
          'down'  => 40, // ARROW_DOWN
          'bump'  => 191, // /
          'hit'   => 190, // .
        ];
    }
  }


  inline function get_player():Player { return this.entity != null ? cast(this.entity, Player) : null; }

}
