package games.tennis;

import newp.Entity;
import newp.components.*;


class Ball extends Entity {

  var field:PlayField;

  public function new(field:PlayField) {
    super();
    this.field = field;
  }

}
