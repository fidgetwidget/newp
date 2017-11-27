package newp.display;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

// A collection of sprites in groups
class GroupCollection implements ICollection {

  // Internal Properties
  var groups:Map<String, Group>;
  var groupMap:Map<DisplayObject, Group>;
  var count:Int = 0;

  // Properties
  public var name(default, null):String;
  public var length(get, never):Int;
  public var groupNames(default, null):Array<String>;

  public function new(name:String, ?spriteGroups:Map<String, Array<DisplayObject>>) {
    this.name = name;
    this.groups = new Map();
    this.groupMap = new Map();
    this.groupNames = [];
    if (spriteGroups == null) return;

    for (groupName in spriteGroups.keys()) {
      this.makeGroup(groupName);
      var group:Array<DisplayObject> = spriteGroups[groupName];
      for (sprite in group) {
        this.add(sprite, groupName);
      }
    }
  }

  // Iterator
  // eg. for (obj:DisplayObject in myGroup)
  public function iterator():Iterator<DisplayObject> {
    // TODO: make this work
    return null;
  }

  // Methods
  // =======

  public function merge(collection:ICollection):Void {
    if (Std.is(collection, GroupCollection)) {
      var groupCollection:GroupCollection = cast(collection, GroupCollection);
      for (name in groupCollection.groupNames) {
        var group:Group = groupCollection.getGroup(name);
        for (sprite in group) {
          this.groups[name].add(sprite);
        }
      }
    }
    else if (Std.is(collection, LayerCollection)) {
      var layerCollection:LayerCollection = cast(collection, LayerCollection);
      for (name in layerCollection.layerNames) {
        var layer:Layer = layerCollection.getLayer(name);
        this.groups[name].merge(layer);
      }
    } 
    else {
      for (sprite in collection) {
        collection.remove(sprite);
        this.add(sprite);
      }
    }
  }

  public function makeGroup(name:String):Group {
    var group:Group;
    if (this.groups.exists(name)) {
      group = this.groups.get(name);
      // Reorder the names so that this one is on the top
      var i:Int = this.groupNames.indexOf(name);
      this.groupNames.splice(i, 1);
      this.groupNames.push(name);
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