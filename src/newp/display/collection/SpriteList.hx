package newp.display.collection;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

// A collection of sprites in groups
class SpriteList implements Collection {

  var groups:Map<String, Group>;
  var count:Int = 0;

  public var length(get, never):Int;

  public var groupNames(default, null):Array<String>;

  // public var container(default, null):DisplayObjectContainer;

  public function new(?spriteGroups:Map<String, Array<DisplayObject>>) {
    this.container = null;
    this.groups = new Map();
    this.groupNames = [];
    if (spriteGroups == null) return;

    for (groupName in spriteGroups) {
      this.makeGroup(groupName);
      var group = spriteGroups[groupName];
      for (sprite in group) {
        this.add(sprite, groupName);
      }
    }
  }

  public function merge(collection:Collection):Void {
    // TODO: describe how to merge with other collections
  }

  // Group Methods
  // =============

  public function makeGroup(name:String):Collection {
    var group;
    if (this.groups.exists(name)) {
      group = this.groups.get(name);
      // TODO: reorder things to have this group be the last one instead
      return group;
    }

    group = new Group(name);
    this.groupNames.push(name);
    this.groups.set(name, group);
    return group;
  }

  public function getGroup(name:String):Group {
    if (!this.groups.exists(name)) throw 'Group[${name}] doesn\'t Exist';

    return this.groups[name];
  }

  // Sprite Methods
  // ==============

  // add new, or adjust the group of a graphic
  public function add(graphic:DisplayObject, ?group:String):Void {
    if (group == null) {
      var i = this.groupNames.length - 1;
      if (i < 0) throw "There must be a group before we can add a Sprite to it";
      group = this.groupNames[i]; // default to the top group
    }

    if (!this.groups.exists(group)) throw 'Group[${group}] doesn\'t Exist';

    if (this.groupMap.exists(graphic)) {
      this.groupMap[graphic].remove(graphic);
    } else {
      count++;
    }

    this.groupMap.set(graphic, this.groups[group]);
    this.groups[group].add(graphic);
  }

  public function remove(graphic:DisplayObject):Void {
    if (!this.groupMap.exists(graphic)) return;

    this.groupMap[graphic].remove(graphic);
    this.groupMap.remove(graphic);
    count--;
  }


  // 

  inline function get_length():Int { return count; }
}