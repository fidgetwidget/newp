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
    this.character.ground = (Lib.stage.stageHeight / 2) - this.character.height;
  }

  // Update Loop

  public override function update():Void {
    this.update_controllerInput();
    this.character.update();
  } 

  function update_controllerInput() :Void {

    if (
      Lib.inputs.keyboard.down(Keyboard.A) || 
      Lib.inputs.keyboard.down(Keyboard.LEFT)) {
      this.character.moveLeft();
    } else if (
      Lib.inputs.keyboard.down(Keyboard.D) || 
      Lib.inputs.keyboard.down(Keyboard.RIGHT)) {
      this.character.moveRight();
    } else {
      this.character.notMoving();
    }

    if (
      Lib.inputs.keyboard.down(Keyboard.W) || 
      Lib.inputs.keyboard.down(Keyboard.L) ||
      Lib.inputs.keyboard.down(Keyboard.UP)) {
      this.character.jump();
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.J)) {
      this.character.punch();
    }

    if (Lib.inputs.keyboard.pressed(Keyboard.K)) {
      this.character.kick();
    }
  }

}