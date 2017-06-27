package newp.inputs;

import openfl.ui.Keyboard;


class KeyboardKeys {

  public static function initKeyStates(keys:Map<Int, KeyState>):Void {
    
    addKey(Keyboard.LEFT, keys);                // 37
    addKey(Keyboard.UP, keys);                  // 38
    addKey(Keyboard.RIGHT, keys);               // 39
    addKey(Keyboard.DOWN, keys);                // 40

    addKey(Keyboard.NUMBER_0, keys);            // 48
    addKey(Keyboard.NUMBER_1, keys);            // 49
    addKey(Keyboard.NUMBER_2, keys);            // 50
    addKey(Keyboard.NUMBER_3, keys);            // 51
    addKey(Keyboard.NUMBER_4, keys);            // 52
    addKey(Keyboard.NUMBER_5, keys);            // 53
    addKey(Keyboard.NUMBER_6, keys);            // 54
    addKey(Keyboard.NUMBER_7, keys);            // 55
    addKey(Keyboard.NUMBER_8, keys);            // 56
    addKey(Keyboard.NUMBER_9, keys);            // 57

    addKey(Keyboard.A, keys);                   // 65
    addKey(Keyboard.B, keys);                   // 66
    addKey(Keyboard.C, keys);                   // 67
    addKey(Keyboard.D, keys);                   // 68
    addKey(Keyboard.E, keys);                   // 69
    addKey(Keyboard.F, keys);                   // 70
    addKey(Keyboard.G, keys);                   // 71
    addKey(Keyboard.H, keys);                   // 72
    addKey(Keyboard.I, keys);                   // 73
    addKey(Keyboard.J, keys);                   // 74
    addKey(Keyboard.K, keys);                   // 75
    addKey(Keyboard.L, keys);                   // 76
    addKey(Keyboard.M, keys);                   // 77
    addKey(Keyboard.N, keys);                   // 78
    addKey(Keyboard.O, keys);                   // 79
    addKey(Keyboard.P, keys);                   // 80
    addKey(Keyboard.Q, keys);                   // 81
    addKey(Keyboard.R, keys);                   // 82
    addKey(Keyboard.S, keys);                   // 83
    addKey(Keyboard.T, keys);                   // 84
    addKey(Keyboard.U, keys);                   // 85
    addKey(Keyboard.V, keys);                   // 86
    addKey(Keyboard.W, keys);                   // 87
    addKey(Keyboard.X, keys);                   // 88
    addKey(Keyboard.Y, keys);                   // 89
    addKey(Keyboard.Z, keys);                   // 90
    
    addKey(Keyboard.ENTER, keys);               // 13
    addKey(Keyboard.COMMAND, keys);             // 15
    addKey(Keyboard.CONTROL, keys);             // 17
    addKey(Keyboard.ALTERNATE, keys);           // 18
    addKey(Keyboard.SPACE, keys);               // 32
    addKey(Keyboard.SHIFT, keys);               // 16 
    addKey(Keyboard.BACKSPACE, keys);           // 8
    addKey(Keyboard.CAPS_LOCK, keys);           // 20  
    addKey(Keyboard.DELETE, keys);              // 46
    addKey(Keyboard.END, keys);                 // 35
    addKey(Keyboard.ESCAPE, keys);              // 27 
    addKey(Keyboard.HOME, keys);                // 36
    addKey(Keyboard.INSERT, keys);              // 45
    addKey(Keyboard.TAB, keys);                 // 9
    addKey(Keyboard.PAGE_DOWN, keys);           // 34
    addKey(Keyboard.PAGE_UP, keys);             // 33  
    addKey(Keyboard.LEFTBRACKET, keys);         // 219
    addKey(Keyboard.RIGHTBRACKET, keys);        // 221
    addKey(Keyboard.BACKQUOTE, keys);           // 192
    addKey(Keyboard.EQUAL, keys);               // 187
    addKey(Keyboard.MINUS, keys);               // 189
    addKey(Keyboard.BACKSLASH, keys);           // 220
    addKey(Keyboard.COMMA, keys);               // 188
    addKey(Keyboard.SEMICOLON, keys);           // 186
    addKey(Keyboard.PERIOD, keys);              // 190
    addKey(Keyboard.QUOTE, keys);               // 222
    addKey(Keyboard.SLASH, keys);               // 191  
  }

  static inline function addKey(key:Int, keyStates:Map<Int, KeyState>):Void {
    keyStates.set(key, { current:0, last:0 });
  }

}