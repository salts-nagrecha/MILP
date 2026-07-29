############################################################
# Production Planning
############################################################
suffix objpriority;
set PRODUCTS;
set WEEKS ordered;

############################################################
# Parameters
############################################################

param demand{PRODUCTS,WEEKS} >= 0 default 0;

param isl{PRODUCTS} >= 0;
param current_stock{PRODUCTS} >= 0;

param pouch_size := 200;

param min_batches := 1;
param max_batches := 30;

param max_weekly_pouches := 5616;

############################################################
# Decision variables
############################################################

var batches{PRODUCTS,WEEKS} integer >=0;

var inventory{PRODUCTS,WEEKS} >=0;

var back_order{PRODUCTS,WEEKS} >=0;

var produce{PRODUCTS,WEEKS} binary;

var dev_pos{PRODUCTS,WEEKS} >=0;

var dev_neg{PRODUCTS,WEEKS} >=0;

############################################################
# Expressions
############################################################



############################################################
# Constraints
############################################################


subject to RunMin{p in PRODUCTS,w in WEEKS}:

    batches[p,w] >= min_batches*produce[p,w];


subject to RunMax{p in PRODUCTS,w in WEEKS}:

    batches[p,w] <= max_batches*produce[p,w];

subject to WeeklyCapacity{w in WEEKS}:

    sum{p in PRODUCTS}
        pouch_size * batches[p,w]

    <= max_weekly_pouches;

subject to InventoryBalance{p in PRODUCTS,w in WEEKS}:
    inventory[p,w]
    -
    back_order[p,w]

    =

    (if ord(w)=1 then current_stock[p]
    else inventory[p,prev(w)]
        - back_order[p,prev(w)])

    +

    pouch_size * batches[p,w]

    -

    demand[p,w];


subject to ISLDeviation{p in PRODUCTS,w in WEEKS}:

inventory[p,w]
-
isl[p]

=

dev_pos[p,w]
-
dev_neg[p,w];

############################################################
# Objectives
############################################################

minimize BackOrderObjective:
    sum {p in PRODUCTS, w in WEEKS}
        back_order[p,w];


minimize ChangeoverObjective:
    sum {p in PRODUCTS, w in WEEKS}
        produce[p,w];


minimize ISLObjective:
    sum {p in PRODUCTS, w in WEEKS}
        (dev_pos[p,w] + dev_neg[p,w]);