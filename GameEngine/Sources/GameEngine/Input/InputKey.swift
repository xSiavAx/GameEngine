extension InputProcessor {
    enum Key: Int32, CaseIterable {
        case SPACE = 32 //                GLFW_KEY_SPACE  
        case APOSTROPHE = 39 //           GLFW_KEY_APOSTROPHE /* ' */
        case COMMA = 44 //                GLFW_KEY_COMMA /* , */
        case MINUS = 45 //                GLFW_KEY_MINUS /* - */
        case PERIOD = 46 //               GLFW_KEY_PERIOD /* . */
        case SLASH = 47 //                GLFW_KEY_SLASH /* / */
        case k0 = 48 //                   GLFW_KEY_0  
        case k1 = 49 //                   GLFW_KEY_1  
        case k2 = 50 //                   GLFW_KEY_2  
        case k3 = 51 //                   GLFW_KEY_3  
        case k4 = 52 //                   GLFW_KEY_4  
        case k5 = 53 //                   GLFW_KEY_5  
        case k6 = 54 //                   GLFW_KEY_6  
        case k7 = 55 //                   GLFW_KEY_7  
        case k8 = 56 //                   GLFW_KEY_8  
        case k9 = 57 //                   GLFW_KEY_9  
        case SEMICOLON = 59 //            GLFW_KEY_SEMICOLON/* ; */
        case EQUAL = 61 //                GLFW_KEY_EQUAL/* = */
        case A = 65 //                    GLFW_KEY_A  
        case B = 66 //                    GLFW_KEY_B  
        case C = 67 //                    GLFW_KEY_C  
        case D = 68 //                    GLFW_KEY_D  
        case E = 69 //                    GLFW_KEY_E  
        case F = 70 //                    GLFW_KEY_F  
        case G = 71 //                    GLFW_KEY_G  
        case H = 72 //                    GLFW_KEY_H  
        case I = 73 //                    GLFW_KEY_I  
        case J = 74 //                    GLFW_KEY_J  
        case K = 75 //                    GLFW_KEY_K  
        case L = 76 //                    GLFW_KEY_L  
        case M = 77 //                    GLFW_KEY_M  
        case N = 78 //                    GLFW_KEY_N  
        case O = 79 //                    GLFW_KEY_O  
        case P = 80 //                    GLFW_KEY_P  
        case Q = 81 //                    GLFW_KEY_Q  
        case R = 82 //                    GLFW_KEY_R  
        case S = 83 //                    GLFW_KEY_S  
        case T = 84 //                    GLFW_KEY_T  
        case U = 85 //                    GLFW_KEY_U  
        case V = 86 //                    GLFW_KEY_V  
        case W = 87 //                    GLFW_KEY_W  
        case X = 88 //                    GLFW_KEY_X  
        case Y = 89 //                    GLFW_KEY_Y  
        case Z = 90 //                    GLFW_KEY_Z  
        case LEFT_BRACKET = 91 //         GLFW_KEY_LEFT_BRACKET /* [ */
        case BACKSLASH = 92 //            GLFW_KEY_BACKSLASH /* \ */
        case RIGHT_BRACKET = 93 //        GLFW_KEY_RIGHT_BRACKET /* ] */
        case GRAVE_ACCENT = 96 //         GLFW_KEY_GRAVE_ACCENT /* ` */
        case WORLD_1 = 161 //             GLFW_KEY_WORLD_1 /* non-US #1 */
        case WORLD_2 = 162 //             GLFW_KEY_WORLD_2 /* non-US #2 */

        case ESCAPE = 256 //              GLFW_KEY_ESCAPE
        case ENTER = 257 //               GLFW_KEY_ENTER
        case TAB = 258 //                 GLFW_KEY_TAB
        case BACKSPACE = 259 //           GLFW_KEY_BACKSPACE
        case INSERT = 260 //              GLFW_KEY_INSERT
        case DELETE = 261 //              GLFW_KEY_DELETE
        case RIGHT = 262 //               GLFW_KEY_RIGHT
        case LEFT = 263 //                GLFW_KEY_LEFT
        case DOWN = 264 //                GLFW_KEY_DOWN
        case UP = 265 //                  GLFW_KEY_UP
        case PAGE_UP = 266 //             GLFW_KEY_PAGE_UP
        case PAGE_DOWN = 267 //           GLFW_KEY_PAGE_DOWN
        case HOME = 268 //                GLFW_KEY_HOME
        case END = 269 //                 GLFW_KEY_END
        case CAPS_LOCK = 280 //           GLFW_KEY_CAPS_LOCK
        case SCROLL_LOCK = 281 //         GLFW_KEY_SCROLL_LOCK
        case NUM_LOCK = 282 //            GLFW_KEY_NUM_LOCK
        case PRINT_SCREEN = 283 //        GLFW_KEY_PRINT_SCREEN
        case PAUSE = 284 //               GLFW_KEY_PAUSE
        case F1 = 290 //                  GLFW_KEY_F1
        case F2 = 291 //                  GLFW_KEY_F2
        case F3 = 292 //                  GLFW_KEY_F3
        case F4 = 293 //                  GLFW_KEY_F4
        case F5 = 294 //                  GLFW_KEY_F5
        case F6 = 295 //                  GLFW_KEY_F6
        case F7 = 296 //                  GLFW_KEY_F7
        case F8 = 297 //                  GLFW_KEY_F8
        case F9 = 298 //                  GLFW_KEY_F9
        case F10 = 299 //                 GLFW_KEY_F10
        case F11 = 300 //                 GLFW_KEY_F11
        case F12 = 301 //                 GLFW_KEY_F12
        case F13 = 302 //                 GLFW_KEY_F13
        case F14 = 303 //                 GLFW_KEY_F14
        case F15 = 304 //                 GLFW_KEY_F15
        case F16 = 305 //                 GLFW_KEY_F16
        case F17 = 306 //                 GLFW_KEY_F17
        case F18 = 307 //                 GLFW_KEY_F18
        case F19 = 308 //                 GLFW_KEY_F19
        case F20 = 309 //                 GLFW_KEY_F20
        case F21 = 310 //                 GLFW_KEY_F21
        case F22 = 311 //                 GLFW_KEY_F22
        case F23 = 312 //                 GLFW_KEY_F23
        case F24 = 313 //                 GLFW_KEY_F24
        case F25 = 314 //                 GLFW_KEY_F25
        case KP_0 = 320 //                GLFW_KEY_KP_0
        case KP_1 = 321 //                GLFW_KEY_KP_1
        case KP_2 = 322 //                GLFW_KEY_KP_2
        case KP_3 = 323 //                GLFW_KEY_KP_3
        case KP_4 = 324 //                GLFW_KEY_KP_4
        case KP_5 = 325 //                GLFW_KEY_KP_5
        case KP_6 = 326 //                GLFW_KEY_KP_6
        case KP_7 = 327 //                GLFW_KEY_KP_7
        case KP_8 = 328 //                GLFW_KEY_KP_8
        case KP_9 = 329 //                GLFW_KEY_KP_9
        case KP_DECIMAL = 330 //          GLFW_KEY_KP_DECIMAL
        case KP_DIVIDE = 331 //           GLFW_KEY_KP_DIVIDE
        case KP_MULTIPLY = 332 //         GLFW_KEY_KP_MULTIPLY
        case KP_SUBTRACT = 333 //         GLFW_KEY_KP_SUBTRACT
        case KP_ADD = 334 //              GLFW_KEY_KP_ADD
        case KP_ENTER = 335 //            GLFW_KEY_KP_ENTER
        case KP_EQUAL = 336 //            GLFW_KEY_KP_EQUAL
        case LEFT_SHIFT = 340 //          GLFW_KEY_LEFT_SHIFT
        case LEFT_CONTROL = 341 //        GLFW_KEY_LEFT_CONTROL
        case LEFT_ALT = 342 //            GLFW_KEY_LEFT_ALT
        case LEFT_SUPER = 343 //          GLFW_KEY_LEFT_SUPER
        case RIGHT_SHIFT = 344 //         GLFW_KEY_RIGHT_SHIFT
        case RIGHT_CONTROL = 345 //       GLFW_KEY_RIGHT_CONTROL
        case RIGHT_ALT = 346 //           GLFW_KEY_RIGHT_ALT
        case RIGHT_SUPER = 347 //         GLFW_KEY_RIGHT_SUPER
        case MENU = 348 //                GLFW_KEY_MENU

        static let LAST = MENU
    }
}
