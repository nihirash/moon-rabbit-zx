TAB = 9
CR = 13
LF = 10
NULL = 0
SPACE = ' '
ESC = 27

MIME_DOWNLOAD = '+'
MIME_LINK = '>'
MIME_TEXT = '@'
MIME_IMAGE = '*'
MIME_MUSIC = '!'
MIME_INPUT = '_'

BORDER_TOP    = 7
BORDER_BOTTOM = 8

sepparators db CR, LF, TAB, NULL, SPACE
sepparators_len = $ - sepparators