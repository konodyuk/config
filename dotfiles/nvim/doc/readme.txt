*readme*

Setup description.

================================================================================
CONTENTS                                                       *readme-contents*

Keymaps.......................................................: |readme-keymaps|
Text Objects..............................................: |readme-textobjects|
Plugins.......................................................: |readme-plugins|
Features.....................................................: |readme-features|

================================================================================
KEYMAPS                                                         *readme-keymaps*

--------------------------------------------------------------------------------
REPL                                                                  *LEADER-r*

    *LEADER-r*{motion}  Run selected object in |iron.nvim|

    *LEADER-rt*         Toggle Iron

    *LEADER-rR*         Restart Iron

    *LEADER-rq*         Interrupt Iron


================================================================================
TEXT OBJECTS                                                *readme-textobjects*

    *af*                a function: signature + body
    *if*                inside function: body

    *ac*                a class: definition + body
    *ic*                inside class: body

    *aa*                an argument: argument + comma + whitespace
    *ia*                inner argument

    *aC*                a comment: multiline comment block

    *il*                inside line: trim whitespace
    *al*                a line: with whitespace

    *aF*                a file
    *iF*                inside file: same as above

    *aP*                a backward paragraph: `[count]aP` selects `count`
                      paragraphs backward including the current


--------------------------------------------------------------------------------
MOTIONS                                                         *readme-motions*

    *[a*                Previous argument
    *]a*                Next argument

    *[f*                Previous function
    *]f*                Next function

    *[c*                Previous class
    *]c*                Next class

    *[C*                Previous comment
    *]C*                Next comment


================================================================================
PLUGINS                                                         *readme-plugins*


================================================================================
FEATURES                                                       *readme-features*


vim:tw=80:sw=4:ft=help:norl:conceallevel=1
