package newp.inputs;


class Manager {
  
  public var keyboard(default, null):KeyboardInput;
  public var mouse(default, null):MouseInput;
  // TODO: add gamepads

  public function new () {  
    this.keyboard = new KeyboardInput();
    this.mouse = new MouseInput();
  }

  public function update () :Void {
    this.keyboard.update();
    this.mouse.update();
  }

}
