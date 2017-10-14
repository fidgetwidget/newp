package newp.display;

import openfl.display.DisplayObject;

// A sprite list, grouped by layer
class SpriteList {

  var sprites:Map<String, Array<DisplayObject>>;

  public function new(?spriteList:Map<String, Array<DisplayObject>>) {
    this.sprites = spriteList == null ? new Map() : spriteList;
  }

  inline public function get(layer:String):Array<DisplayObject> {
    return this.sprites.exists(layer) ? this.sprites[layer] : null;
  }

  inline public function add(layer:String, sprite:DisplayObject):Void {
    if (!this.sprites.exists(layer)) this.sprites.set(layer, []);
    this.sprites[layer].push(sprite);
  }

}
