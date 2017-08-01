package games.vollybox;

import newp.components.Routine;
import newp.math.Utils as MathUtil;
import newp.Entity;


class CPUInput extends Routine {

  public var player(get, never):Player;
  public var game:VollyBox;
  var speed:Float;
  var inputs:Map<String, Int>;

  public function new(game:VollyBox) {
    super('playerInput');
    this.game = game;
  }

  override public function update():Void { 
    var dx = player.x - game.ball.x;
    var dy = player.y - game.ball.y;
    var l = MathUtil.vec_length(dx, dy);
    var ballOnPlayerSide = player.playerNo == 1 ? game.ball.x < game.field.centerX : game.ball.x > game.field.centerX;
    var ballApproachingPlayerSide = player.playerNo == 1 ? game.ball.vx < 0 : game.ball.vx > 0;
    var fx = game.ball.x;
    var fy = game.ball.y;

    if (game.ball.z + game.ball.vz > 5) {
      fx += game.ball.vx;
      fy += game.ball.vy;
    }

    if ((ballOnPlayerSide || ballApproachingPlayerSide) && l < 140) {
      var prevX = player.motion.ax;
      var prevY = player.motion.ay;
      player.motion.accelerateTowards(Player.BASE_MOVE_SPEED, fx, fy);
      if (   (prevX == 0 && player.motion.ax != 0)
          || (prevY == 0 && player.motion.ay != 0)) {
        game.array_random(game.sounds['move']).play();
      }
      // if the ball is in hit range, and moving twards the ground, and we haven't already tried to hit it
      if (ballOnPlayerSide && player.hitType == HitTypes.NONE && game.ball.z < 1.75 && game.ball.vz < 0) {
        player.actionDelayed = true;
        //  if it seems 
        if (l > Player.MAX_HIT_SIZE && l < Player.MAX_HIT_SIZE + Player.MAX_MOVE_SPEED) {
          player._bump();
        } else if (l < Player.MAX_HIT_SIZE) {
          player._hit();
        }
      }
    } else {
      var prevY = player.motion.ay;
      player.ax = 0;
      player.motion.accelerateTowards(Player.BASE_MOVE_SPEED/3, player.x, fy);
      if (prevY == 0) {
        this.game.array_random(this.game.sounds['move']).play();
      }
    }

    if (player.vx != 0 && MathUtil.sign(player.ax) != MathUtil.sign(player.vx)) player.vx *= 0.25;
    if (player.vy != 0 && MathUtil.sign(player.ay) != MathUtil.sign(player.vy)) player.vy *= 0.25;
  }


  inline function get_player():Player { return this.entity != null ? cast(this.entity, Player) : null; }

}
