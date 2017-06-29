package newp.inputs;

import openfl.ui.Keyboard;


class KeyStateMap {

  var map:Map<Int, KeyState>;
  
  public function new () { this.map = new Map(); }

  public function add(key:Int, state:KeyState=null) :Void {
    if (state == null) state = { current:0, last:0 };
    this.map.set(key, state);
  }

  public function get (key:Int) :KeyState { 
    if (!this.has(key)) { return null; }
    return this.map.get(key); 
  }

  public function has (key:Int) :Bool { 
    return this.map.exists(key); 
  }

  public function keys() {
    return this.map.keys();
  }

  public static function make() :KeyStateMap {
    var map = new KeyStateMap();

    // 1-7
    map.add(Keyboard.BACKSPACE);           // 8
    map.add(Keyboard.TAB);                 // 9
    // 10-12
    map.add(Keyboard.ENTER);               // 13
    // 14
    map.add(Keyboard.COMMAND);             // 15
    map.add(Keyboard.SHIFT);               // 16 
    map.add(Keyboard.CONTROL);             // 17
    map.add(Keyboard.ALTERNATE);           // 18
    // 19
    map.add(Keyboard.CAPS_LOCK);           // 20 
    // 21-26
    map.add(Keyboard.ESCAPE);              // 27 
    // 28-31
    map.add(Keyboard.SPACE);               // 32
    map.add(Keyboard.PAGE_UP);             // 33
    map.add(Keyboard.PAGE_DOWN);           // 34
    map.add(Keyboard.END);                 // 35
    map.add(Keyboard.HOME);                // 36
    map.add(Keyboard.LEFT);                // 37
    map.add(Keyboard.UP);                  // 38
    map.add(Keyboard.RIGHT);               // 39
    map.add(Keyboard.DOWN);                // 40
    // 41-44
    map.add(Keyboard.INSERT);              // 45
    map.add(Keyboard.DELETE);              // 46
    // 47
    map.add(Keyboard.NUMBER_0);            // 48
    map.add(Keyboard.NUMBER_1);            // 49
    map.add(Keyboard.NUMBER_2);            // 50
    map.add(Keyboard.NUMBER_3);            // 51
    map.add(Keyboard.NUMBER_4);            // 52
    map.add(Keyboard.NUMBER_5);            // 53
    map.add(Keyboard.NUMBER_6);            // 54
    map.add(Keyboard.NUMBER_7);            // 55
    map.add(Keyboard.NUMBER_8);            // 56
    map.add(Keyboard.NUMBER_9);            // 57
    // 58-64
    map.add(Keyboard.A);                   // 65
    map.add(Keyboard.B);                   // 66
    map.add(Keyboard.C);                   // 67
    map.add(Keyboard.D);                   // 68
    map.add(Keyboard.E);                   // 69
    map.add(Keyboard.F);                   // 70
    map.add(Keyboard.G);                   // 71
    map.add(Keyboard.H);                   // 72
    map.add(Keyboard.I);                   // 73
    map.add(Keyboard.J);                   // 74
    map.add(Keyboard.K);                   // 75
    map.add(Keyboard.L);                   // 76
    map.add(Keyboard.M);                   // 77
    map.add(Keyboard.N);                   // 78
    map.add(Keyboard.O);                   // 79
    map.add(Keyboard.P);                   // 80
    map.add(Keyboard.Q);                   // 81
    map.add(Keyboard.R);                   // 82
    map.add(Keyboard.S);                   // 83
    map.add(Keyboard.T);                   // 84
    map.add(Keyboard.U);                   // 85
    map.add(Keyboard.V);                   // 86
    map.add(Keyboard.W);                   // 87
    map.add(Keyboard.X);                   // 88
    map.add(Keyboard.Y);                   // 89
    map.add(Keyboard.Z);                   // 90
    // 91-185
    map.add(Keyboard.SEMICOLON);           // 186
    map.add(Keyboard.EQUAL);               // 187
    map.add(Keyboard.COMMA);               // 188
    map.add(Keyboard.MINUS);               // 189
    map.add(Keyboard.PERIOD);              // 190
    map.add(Keyboard.SLASH);               // 191  
    map.add(Keyboard.BACKQUOTE);           // 192
    // 193-218
    map.add(Keyboard.LEFTBRACKET);         // 219
    map.add(Keyboard.BACKSLASH);           // 220
    map.add(Keyboard.RIGHTBRACKET);        // 221
    map.add(Keyboard.QUOTE);               // 222
    
    return map;
  }

}