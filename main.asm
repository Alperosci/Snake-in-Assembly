pos: res u16t 2, 0
velocity: res i16t 2, 0

tick: res u8t 1, 0

def LEFT_BTN   128          # values for bitmasking
def RIGHT_BTN  64
def UP_BTN     32
def DOWN_BTN   16

bodyX: res u16t 65535, 500     # body init400
bodyY: res u16t 65535, 500

lenght: res u16t 1, 3       # lenght init

applepos: res u16t 2, 50

#
#   TO-DO list at l-90
#

_start:
    str i16t, pos,     160              # starting values
    str i16t, pos + 2, 120

    str i16t, velocity,     -10
    str i16t, velocity + 2, 0

    rnd s0, 0, 31
    rnd s1, 0, 23

    mul s0, s0, 10
    mul s1, s1, 10

    str u16t, applepos, s0
    str u16t, applepos + 2, s1

    exit


_update:
    lod u8t, s0, tick   #   |
    inc s0              #   |
    str u8t, tick, s0   #   |
                        #   |   Making the game 2 tps
    cmp eq, 30, s0      #   |
    jfs @end+           #   |
                        #   |
    str u8t, tick, 0    #   |

    lod u16t, s0, pos           #   |
    lod i16t, s1, velocity      #   |
                                #   |   updating x position
    add s0, s0, s1              #   |
                                #   |
    str u16t, pos, s0           #   |

    lod u16t, s0, pos +2        #   |
    lod i16t, s1, velocity +2   #   |
                                #   |   updating y position
    add s0, s0, s1              #   |
                                #   |
    str u16t, pos +2, s0        #   |

    lod u16t, s0, pos           # apple detection
    lod u16t, s1, pos + 2
    lod u16t, s2, applepos
    lod u16t, s3, applepos + 2

    cmp eq, s0, s2
    jfs @notd+
    cmp eq, s1, s3
    jfs @notd+

    lod u16t, s0, lenght
    inc s0                      # inc lenght
    str u16t, lenght, s0

    rnd s0, 0, 31               #new position for apple
    rnd s1, 0, 23

    mul s0, s0, 10
    mul s1, s1, 10

    str u16t, applepos, s0
    str u16t, applepos + 2, s1

    @notd:

    # to do, body detection
    # to do, edge detection

    lod u16t, s0, pos           # getting values for addition to body
    lod u16t, s1, pos + 2
    lod u16t, s2, lenght

    mov s3, bodyX
    mov s4, bodyY

    mul s2, s2, 2

    add s3, s3, s2
    add s4, s4, s2

    str u16t, s3, s0         # adding position to body array
    str u16t, s4, s1

    mov s0, 0                #shift loop init
    lod u16t, s1, lenght
    mul s1, s1, 2

    .shiftloop:

    cmp lt, s0, s1
    jfs @done+

    mov s2, bodyX
    add s2, s2, s0

    mov s3, bodyY
    add s3, s3, s0

    add s4, s2, 2
    add s5, s3, 2

    lod u16t, s4, s4
    lod u16t, s5, s5

    str u16t, s2, s4
    str u16t, s3, s5

    add s0, s0, 2
    jmp .shiftloop

    @done:

    #lod u16t, s2, lenght
    #inc s2                   # inc lenght - Debug
    #str u16t, lenght, s2

    @end:
    exit

_draw:
    mov s0, 0
    lod u16t, s1, lenght     # render loop init
    mul s1, s1, 2

    .renderloop:

    cmp lt, s0, s1
    jfs @done+

    mov s2, bodyX
    add s2, s2, s0

    mov s3, bodyY
    add s3, s3, s0

    lod u16t, a0, s2               # rendering the body part
    lod u16t, a1, s3

    inc a0
    inc a1

    mov a2, 8
    mov a3, 8
    mov a4, 70

    syscall SYS_DRAW_RECT

    add s0, s0, 2
    jmp .renderloop

    @done:

    lod u16t, a0, applepos          #  rendering the apple
    lod u16t, a1, applepos + 2

    inc a0
    inc a1

    mov a2, 8
    mov a3, 8

    mov a4, 255

    syscall SYS_DRAW_RECT

    exit


_input:
    syscall SYS_GET_INPUT

    and s0, a0, RIGHT_BTN           # right button bitmask
    cmp eq, s0, 0x0
    jtr @equal+

    str i16t, velocity,     10
    str i16t, velocity + 2, 0

    @equal:

    and s0, a0, LEFT_BTN            # left button bitmask
    cmp eq, s0, 0x0
    jtr @equal+

    str i16t, velocity,     -10
    str i16t, velocity + 2, 0

    @equal:

    and s0, a0, UP_BTN              # up button bitmask
    cmp eq, s0, 0x0
    jtr @equal+

    str i16t, velocity,     0
    str i16t, velocity + 2, -10

    @equal:

    and s0, a0, DOWN_BTN            # down button bitmask
    cmp eq, s0, 0x0
    jtr @equal+

    str i16t, velocity,     0
    str i16t, velocity + 2, 10

    @equal:
    exit
