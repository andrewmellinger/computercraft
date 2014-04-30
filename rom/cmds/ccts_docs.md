## Movement
f - forward
b - back
l - left
r - right
u - up
d - down

## Digging
* - dig forward until nothing
/ - dig up until nothing
\ - dig down nothing will fall, so it is ok

## Block Placement
1-9 - place down block from this slot of that number
0 - place down block from this slot 10
~1-9 - place forward block from this slot of that number
~0 - place forward block from slot 10

## Miscellaneous
. - NoOp
# Comment to end of line

## Repeats
@####[] repeat expression in group
E.g. @20[*f/2]
Above digs a tunnel 20 long 2 high and places blocks from 2 below (fill in)

## TurtleSim diagnostic printing
Print only symbols for turtle shim - subject to change - don't build code based on that.
x - dig forward - individual
_ - dig down - individual
^ - dig up - individual
!f - detect forward
!/ - detect up
!\ - detect down

-----

If ever wanted to do conditional:
?f#:y. - if forward is same as # do y

FUTURE:
&foo() - function
$foo - execute function

-----

Modify ftunnel to just dig lots up
Modify stairs down to have landings
Modify stairs down to actually place torches
Update compile-tschema to use updated symbols


----------------------------
===========================


============

-- Sample house wood house in turtle script

## TODO: Make a version where it moves backwards
## and does two layers at once

# First layer
u
1
@3[@4[f1]r]
f1ff1f1r

# Second layer
u
1
@3[@3[f3]f1r]
f2ff2fr

# Roof layer
4@4[f4]rfr
4@4[f4]lfl
4@4[f4]rfr
4@4[f4]lfl
4@4[f4]

# Put in door
rfr
@5[f]
ddd
rffr
~5




=========
Optimized backward house in turtle script


# We are going to do this backwards
# 1 = wood block, 2 = glass pane, 3 = glass block, 4 = slab, 5 = door
full      # up to starting position
1^4b      # 1,1
1^4~1b    # 2,1
1^4~2b    # 3,1
1^4~2b    # 4,1
1^4~2rb   # 5,1
1^4~1b    # 5,2
1^4~2b    # 5,3
1^4~2b    # 5,4
1^4~2rb   # 5,5
1^4~1b    # 4,5
1^4~2b    # 3,5
1^4~2b    # 2,5
1^4~2rb   # 1,5
1^4~1b    # 1,4
^4~3b     # 1,3
1^4rb     # 1,2
^4~3b     # 2,2
^4b       # 3,2
^4rb      # 4,2
^4b       # 4,3
^4rb      # 4,4
^4b       # 3,4
^4rblf    # 2,4
^4b       # 3,3      
^4bb      # 2,3
~5        # Door


=====================

# Scout Platform Commands
# slot 1 - Cobblestone
# slot 2 - Ladder
# slot 16 - coal
@6[u1]
@2[f1]
rf1
r@4[f1]
r@4[f1]
r@4[f1]
r@2[f1]
r@3[f1]
rf1
r@2[f1]
rff
lbb
@6[d]


