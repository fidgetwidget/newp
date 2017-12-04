package samples;

import openfl.display.Bitmap;
import openfl.ui.Keyboard;
import newp.scenes.BasicScene;
import newp.display.frames.*;
import newp.display.animation.*;
import newp.Lib;
import samples.character.*;

class CharacterExample extends BasicScene {

  var character:Character;

  override function init() {
    super.init();
    this.initCharacter();
  }

  // Methods

  function initCharacter() :Void {
    this.character = new Character();
    this.addEntity(this.character);
    this.character.x = Lib.stage.stageWidth / 2;
    this.character.y = Lib.stage.stageHeight / 2;
  }

  // Update Loop

  public override function update():Void {
    this.update_controllerInput();
    this.character.update();
  } 

  function update_controllerInput() :Void {
    if (Lib.inputs.keyboard.pressed(Keyboard.A)) {
      this.character.moveLeft();
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.S)) {
      
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.D)) {
      this.character.moveRight();
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.W)) {
      this.character.jump();
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.J)) {
      this.character.punch();
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.K)) {
      this.character.kick();
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.L)) {
      this.character.jump();
    }
  }

}