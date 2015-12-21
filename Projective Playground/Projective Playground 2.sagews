︠a43dc702-5257-4ea4-a6e4-39f060c68364︠
#
#  This will soon be a suite of utilities which counts the realizations
#  (whether strong or weak) of a linear space in the projective plane F_p.
#
#   A projective point (a:b:c) is represented in the program as [a,b,c].
#
#   Capabilities:
#    test if 2 points are distinct in P2Fp
#    test if 3 points are collinear in P2Fp
#    test if a set of points in P2Fp forms an arc
#    output the set of points on a given conic
#    output the set of points on a given cubic
#    visualize a set of points

import timeit

# Tests if the points are distinct in the projective plane over F_p.
def distinct (point1, point2, p):
    for i in range(1,p):
        if [(x*i)%p for x in point1] == [y%p for y in point2]:
            return False
    return True

# Tests for collinearity
def collinear (p0,p1,p2,p):
    return ((p0[0] * (p1[1] * p2[2] - p1[2] * p2[1]) - p0[1] * (p1[0] * p2[2] - p2[0] * p1[2] ) + p0[2] * (p1[0] * p2[1] - p1[1] * p2[0])) % p == 0)

def ff_det (p0, p1, p2):
    return (p0[0] * (p1[1] * p2[2] - p1[2] * p2[1]) - p0[1] * (p1[0] * p2[2] - p2[0] * p1[2] ) + p0[2] * (p1[0] * p2[1] - p1[1] * p2[0]))

# Tests if the points form an n-arc in the projective plane over F_p.
def arctest (points, n, p):
    for a in range(n):
        for b in range(a+1,n):
            for c in range(b+1,n):
                p1 = points[a]
                p2 = points[b]
                p3 = points[c]
                if matrix(3,3, p1 + p2 + p3).det() % p == 0:
                    print p1, p2, p3
                    return False
    return True

# Returns all points in plane.
def points_in_plane (p):
    if is_prime (p):
        return [[0,0,1]] + [[0,1,x] for x in range(0,p)] + [[1,x,y] for x in range(0,p) for y in range(0,p)]
    if is_prime_power (p):
        return [[0,0,1]] + [[0,1,x] for x in list(GF(p,'a'))] + [[1,x,y] for x in list(GF(p,'a')) for y in list(GF(p,'a'))]
    else:
        print "Not a prime power"


def visualize(points, p):
    plane = points_in_plane(p)
    if plane[0] in points:
        sys.stdout.write('X')
    else:
        sys.stdout.write('.')
    sys.stdout.flush()
    print
    print
    for i in range(0,p):
        if plane[1+i] in points:
            sys.stdout.write('X')
        else:
            sys.stdout.write('.')
    sys.stdout.flush()
    print
    print
    for i in range(0,p):
        for j in range(0,p):
            if plane[1+p+i*p+j] in points:
                sys.stdout.write('X')
            else:
                sys.stdout.write('.')
        sys.stdout.flush()
        print
︡ee7142da-79ae-4a2b-866d-fa0399d14ab3︡
︠992409f5-5f0d-4b46-9598-dd5c64abd5d5︠


def tripping (p):
    pp = points_in_plane(p)
    num = len(pp)
    epic_data = [[[False for i in xrange(num)] for j in xrange(num)] for k in xrange(num)]
    if is_prime(p):
        for i in xrange(num):
            if (i % 10) == 0:
                print i
            for j in xrange(i, num):
                for k in xrange(j, num):
                    ijk = collinear(pp[i],pp[j],pp[k],p)
                    epic_data[i][j][k] = ijk
                    epic_data[j][i][k] = ijk
                    epic_data[i][k][j] = ijk
                    epic_data[j][k][i] = ijk
                    epic_data[k][i][j] = ijk
                    epic_data[k][j][i] = ijk
    elif is_prime_power(p):
        for i in xrange(num):
            print i
            for j in xrange(i,num):
                for k in xrange(j,num):
                    ijk = (ff_det(pp[i],pp[j],pp[k]) == 0)
                    epic_data[i][j][k] = ijk
                    epic_data[j][i][k] = ijk
                    epic_data[i][k][j] = ijk
                    epic_data[j][k][i] = ijk
                    epic_data[k][i][j] = ijk
                    epic_data[k][j][i] = ijk
    return epic_data

#t3 = tripping(3)
#t5 = tripping(5)
#t7 = tripping(7)
#t11 = tripping(11)
#t13 = tripping(13)
#t16 = tripping(16)
#t17 = tripping(17)
#t19 = tripping(19)
t23 = tripping(23)

#save(t3,'t3')
#save(t5,'t5')
#save(t7,'t7')
#save(t11,'t11')
#save(t13, 't13')
#save(t16, 't16')
#save(t17, 't17')
#save(t19, 't19')

#t4 = tripping(4)
#t8 = tripping(8)
#t9 = tripping(9)

#save(t4, 't4')
#save(t8, 't8')
#save(t9, 't9')

print "done"

def bad_trip(p):
    pp = points_in_plane(p)
    num = len(pp)
    for i in xrange(num):
        for j in xrange(i, num):
            for k in xrange(j, num):
                if (ff_det(pp[i],pp[j],pp[k]) == 0) != collinear(pp[i],pp[j],pp[k],p):
                    print i, j, k
                    print pp[i], pp[j], pp[k]
                    print ff_det(pp[i],pp[j],pp[k])
                    return False

︡17b87665-7ced-4fff-bcf4-88f02ec68ddb︡
︠71f87744-ff9e-4d5a-bf0d-6027b6ba2bc6︠

# COMBINATORIAL:

# Get good points to assign to be (1:0:0), etc.

def grab_start_points (levi):
    v0 = list(levi.left)[0]
    e1 = levi.neighbors(v0)[0]
    e2 = levi.neighbors(v0)[1]
    for v in levi.neighbors(e1):
        if v != v0:
            v1 = v
    for v in levi.neighbors(e1):
        if v != v0 and v != v1:
            v2 = v
    for v in levi.neighbors(e2):
        if v != v0:
            v3 = v
    for v in levi.neighbors(e2):
        if v != v0 and v != v3:
            v4 = v
    return (v0, v1, v2, v3, v4)

# Get another point to determine.

def next_point (levi, detted):
    for p in levi.left:
        if p not in detted:
            return p
    print "No Next Point"
    return False

# Find out whether a set of points are collinear as points in the Levi graph.

def combinatorially_collinear (levi, points):
    for line in levi.neighbors(points[0]):
        flag = True
        for point in points:
            if flag and not levi.has_edge(point, line):
                flag = False
        if flag:
            return True
    return False

# Create the database of all the combinatorial collinearities.

def combinatorially_tripping (levi):
    num = len(levi.left)
    epic_data = [[[False for i in xrange(num)] for j in xrange(num)] for k in xrange(num)]
    l = len(levi.left)
    for p1 in levi.left:
        for p2 in levi.left:
            for p3 in levi.left:
                epic_data[p1 - 1][p2 - 1][p3 - 1] = combinatorially_collinear (levi, [p1,p2,p3])
    return epic_data

# Get up to 2 constraints for a given point which has yet to be determined.

def find_constraints (levi, detted, newpoint ):
    global printinfo
    goodLines = 0
    output = []
    for line in levi.neighbors(newpoint):
        S = set(levi.neighbors(line)).intersection(detted)
        if goodLines < 2 and len(S) >=2:
            goodLines += 1
            others = list(S)
            output += [others[0],others[1]]
    return output


# GEOMETRIC:

# consult the geometric collinearity database.

def line_thru_using_db (pi1, pi2, t, pp, p):
    line = t[pi1][pi2]
    return [pp[i] for i in xrange(p^2 + p + 1) if line[i]]

def line_thru_direct (pi1, pi2, t, pp, p):
    p1 = pp[pi1]
    p2 = pp[pi2]
    return [p3 for p3 in pp if collinear(pp[pi1],pp[pi2],p3,p)]

# Given a partial realization and a set of constraints, determine what points satisfy those
# constraints.

def checkset( constraints, realization, pointindices, t, pp, p ):
    global printinfo
    if printinfo:
        print "rlzn: ", realization
        print "cstr: ", constraints
        for c in constraints:
            print "locs: ", realization.get(c)
    op = []
    if len(constraints) == 0:
        op = pp
    elif len(constraints) == 2:
        #op = line_thru_using_db (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p)
        op = line_thru_direct (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p)
    elif len(constraints) == 4:
        #for x in line_thru_using_db (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p):
        for x in line_thru_direct (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p):
            #if x in line_thru_using_db (pointindices[constraints[2]], pointindices[constraints[3]], t, pp, p):
            if x in line_thru_direct (pointindices[constraints[2]], pointindices[constraints[3]], t, pp, p):
                op += [x]
    v = realization.values()
    output = []
    for ostensible in op:
        if ostensible not in v:
            output += [ostensible]
    if printinfo:
        print "op: ", op
        print "tosearch: ", output
        print

    return output


# check that a partial realization is consistent with what the levi graph demands so far.

def is_it_good_so_far (detted, newpoint, realization, pointindices, t, c, pp, p):
    p1 = newpoint
    for p2 in detted:
        loc2 = realization.get(p2)
        for p3 in detted:
            loc3 = realization.get(p3)
            if p1 != p2 and p2 != p3 and p3 != p1:
                loci1 = pointindices[p1]
                loci2 = pointindices[p2]
                loci3 = pointindices[p3]
                #if t[loci1][loci2][loci3] != c[p1 - 1][p2 - 1][p3 -1]:
                if collinear(pp[loci1],pp[loci2],pp[loci3],p) != c[p1 - 1][p2 - 1][p3 - 1]:
                    return False
    return True

# MAIN METHOD:
# This algorithm imitates the Peilen process over a known projective plane.

def strong (levi, t, prime):

    global printinfo

    c = combinatorially_tripping(levi)

    pp = points_in_plane(prime)
    st = grab_start_points (levi)

    p = [False for x in xrange(10)]
    loc = [False for x in xrange(10)]
    constraints = [False for x in xrange(10)]
    pointindices = [False for x in xrange(11)]

    p[0] = st[0]                       # "combinatorial points"
    p[1] = st[1]
    p[2] = st[2]
    p[3] = st[3]
    p[4] = st[4]
    detted = set([p[0],p[1],p[2],p[3],p[4]])
    realization = {p[0]:[1,1,0],
                   p[1]:[1,0,0],
                   p[2]:[0,1,0],
                   p[3]:[0,0,1],
                   p[4]:[1,1,1]}
    for N in xrange(5):
        pointindices[p[N]] = pplookup( pp, realization.get(p[N]) )

    constraints = [False for x in xrange(10)]

    for N in xrange(5,10):
        p[N] = next_point (levi, detted)
        constraints[N] = find_constraints(levi, detted, p[N])
        detted.add(p[N])

    if printinfo:
        print "Before realize_...: we have p = ", p
    detted = detted.difference(set([p[5], p[6], p[7], p[8], p[9]]))

    i = 0
    j = 0

    return realize_what_remains (5, pp, p, loc, detted, realization, pointindices, constraints, t, c, prime)


def realize_what_remains( N, pp, p, loc, detted, realization, pointindices, constraints, t, c, prime ):
    global printinfo
    if N == 10:
        # print realization
        # visualize(list(realization.values()),prime)
        return 1
    else:
        j = 0
        for loc[N] in checkset( constraints[N], realization, pointindices, t, pp, prime ) :
            detted.add(p[N])
            realization.update({p[N]:loc[N]})
            pointindices[p[N]] = pplookup( pp, loc[N] )
            if printinfo:
                print "Detted::: ", detted
            if is_it_good_so_far (detted, p[N], realization, pointindices, t, c, pp, prime):
                j += realize_what_remains( N + 1, pp, p, loc, detted, realization, pointindices, constraints, t, c, prime )
            del realization[p[N]]
            detted.remove(p[N])
            pointindices[p[N]] = False
        return j

def pplookup ( pp, point ):
    for i in xrange(len(pp)):
        if point == pp[i]:
            return i

︡b31bf7d8-74ad-4b73-a733-f1d3ee9a86ec︡
︠47d52515-8267-4e91-b674-0d24119567bei︠
 #7 Points
Fano_Data = Graph({11:[1,2,3], 12: [3,6,4], 13:[1,5,4], 14: [1,7,6], 15:[2,7,4], 16:[3,7,5], 17: [2,5,6]})
Fano_Part = (range(1,8),range(11,18))
Fano_Graph = BipartiteGraph(Fano_Data, Fano_Part)
Fano_Graph.name('Fano')

#8 Points
Eight_Data = Graph({11:[1,2,3],12:[3,4,5],13:[5,6,7],14:[3,7,8],15:[1,5,8],16:[2,6,8],17:[1,6,4],18:[2,7,4]})
Eight_Part = (range(1,9),range(11,19))
Eight_Graph = BipartiteGraph(Eight_Data, Eight_Part)
Eight_Graph.name('EightThree')

#9 Points

Con_9_1_Data = Graph({11:[1,2,3],12:[1,5,9],13:[1,4,8],14:[2,4,7],15:[2,6,9],16:[3,5,7],17:[3,6,8],18:[4,5,6],19:[7,8,9]})
Con_9_1_Part = (range(1,10),range(11,20))
Con_9_1_Graph = BipartiteGraph(Con_9_1_Data, Con_9_1_Part)
Con_9_1_Graph.name('Con-9-1')

Con_9_2_Data = Graph({11:[1,2,3], 12:[3,4,5], 13:[1,5,6], 14:[1,7,8], 15:[3,8,9],
                     16:[5,9,7],  17:[2,7,6], 18:[2,8,4], 19:[4,9,6]})
Con_9_2_Part = (range(1,10),range(11,20))
Con_9_2_Graph = BipartiteGraph(Con_9_2_Data, Con_9_2_Part)
Con_9_2_Graph.name('Con-9-2')

Con_9_3_Data = Graph({11:[1,2,3],12:[3,4,5],13:[5,6,1],14:[1,8,4],15:[2,7,5],
                      16:[2,8,9],17:[3,9,6],18:[4,9,7],19:[6,7,8]})
Con_9_3_Part = (range(1,10),range(11,20))
Con_9_3_Graph = BipartiteGraph(Con_9_3_Data, Con_9_3_Part)
Con_9_3_Graph.name('Con-9-3')

Con_9_4_Data = Graph({11:[1,2,3],12:[3,4,5],13:[5,6,1],14:[1,8,4],15:[2,7,5],
                      16:[2,8,9],17:[3,9,6],18:[4,2,6],19:[4,9,7],20:[6,7,8]})
Con_9_4_Part = (range(1,10),range(11,21))
Con_9_4_Graph = BipartiteGraph(Con_9_4_Data, Con_9_4_Part)
Con_9_4_Graph.name('Con-9-4')

Con_9_5_Data = Graph({11:[1,2,3],12:[3,4,5],13:[5,6,1],14:[1,7,4],15:[2,7,6],
                      16:[2,8,4],17:[3,8,6],18:[4,9,6],19:[2,9,5],20:[7,8,9]})
Con_9_5_Part = (range(1,10),range(11,21))
Con_9_5_Graph = BipartiteGraph(Con_9_5_Data, Con_9_5_Part)
Con_9_5_Graph.name('Con-9-5')

Con_9_6_Data = Graph({11:[1,2,3],12:[4,5,6],13:[7,8,9],14:[1,4,8],15:[1,5,9],
                      16:[2,4,7],17:[2,5,8],18:[2,6,9],19:[3,5,7],20:[3,6,8]})
Con_9_6_Part = (range(1,10),range(11,21))
Con_9_6_Graph = BipartiteGraph(Con_9_6_Data, Con_9_6_Part)
Con_9_6_Graph.name('Con-9-6')

Con_9_7_Data = Graph({11:[1,2,3], 12:[4,5,6], 13:[7,8,9], 14:[1,4,8], 15:[1,5,9],
                      16:[2,4,7], 17:[2,5,8], 18:[2,6,9], 19:[3,5,7], 20:[3,6,8],
                      21:[1,7,6]})
Con_9_7_Part = (range(1,10), range(11,22))
Con_9_7_Graph = BipartiteGraph(Con_9_7_Data,Con_9_7_Part)
Con_9_7_Graph.name('Con-9-7')

Con_9_8_Data = Graph({11:[1,2,3], 12:[4,5,6], 13:[7,8,9], 14:[1,4,8], 15:[1,5,9],
                      16:[2,4,7], 17:[2,5,8], 18:[2,6,9], 19:[3,5,7], 20:[3,6,8],
                      21:[1,7,6], 22:[3,9,4]})
Con_9_8_Part = (range(1,10), range(11,23))
Con_9_8_Graph = BipartiteGraph(Con_9_8_Data, Con_9_8_Part)
Con_9_8_Graph.name('Con-9-8')

Con_9_9_Data = Graph({11:[1,2,3],12:[3,4,5],13:[1,5,6,7],14:[1,4,8],15:[2,6,8],
                      16:[2,5,9],17:[3,7,8],18:[3,6,9],19:[4,7,9]})
Con_9_9_Part = (range(1,10),range(11,20))
Con_9_9_Graph = BipartiteGraph(Con_9_9_Data, Con_9_9_Part)
Con_9_9_Graph.name('Con-9-9')

Con_9_10_Data = Graph({11:[1,2,3,4],12:[4,5,6,7],13:[3,7,9],14:[2,7,8],15:[1,6,8],
                      16:[1,5,9],17:[2,6,9],18:[3,5,8],19:[4,8,9]})
Con_9_10_Part = (range(1,10),range(11,20))
Con_9_10_Graph = BipartiteGraph(Con_9_10_Data, Con_9_10_Part)
Con_9_10_Graph.name('Con-9-10')


Con_9_List = [Con_9_1_Graph, Con_9_2_Graph, Con_9_3_Graph, Con_9_4_Graph, Con_9_5_Graph,
         Con_9_6_Graph, Con_9_7_Graph, Con_9_8_Graph, Con_9_9_Graph, Con_9_10_Graph]

# [10_3,9_3] superconfigurations - the duals of the [9_3,10_3] superconfigurations

ConfigDual_9_4_Data = Graph({11:[1,3,4],12:[1,2,7],13:[1,5,6,8],14:[2,3,5],15:[5,9,10],
                             16:[4,6,10],17:[6,7,9],18:[3,7,8,10],19:[2,4,8,9]})
ConfigDual_9_4_Part = (range(1,11),range(11,20))
ConfigDual_9_4_Graph = BipartiteGraph(ConfigDual_9_4_Data, ConfigDual_9_4_Part)
ConfigDual_9_4_Graph.name('ConfigDual-9-4')

ConfigDual_9_5_Data = Graph({11:[1,2,3,4],12:[4,5,6,7],13:[1,7,8,9],14:[1,6,10],15:[2,6,8],
                             16:[2,5,9],17:[3,7,10],18:[3,5,8],19:[4,9,10]})
ConfigDual_9_5_Part = (range(1,11),range(11,20))
ConfigDual_9_5_Graph = BipartiteGraph(ConfigDual_9_5_Data, ConfigDual_9_5_Part)
ConfigDual_9_5_Graph.name('ConfigDual-9-5')

ConfigDual_9_6_Data = Graph({11:[1,6,7,8],12:[3,4,7,10],13:[2,8,10],14:[2,5,7,9],15:[1,4,5],
                             16:[3,6,9],17:[2,4,6],18:[3,5,8],19:[1,9,10]})
ConfigDual_9_6_Part = (range(1,11),range(11,20))
ConfigDual_9_6_Graph = BipartiteGraph(ConfigDual_9_6_Data, ConfigDual_9_6_Part)
ConfigDual_9_6_Graph.name('ConfigDual-9-6')

ConfigDual_10s = [ConfigDual_9_4_Graph, ConfigDual_9_5_Graph, ConfigDual_9_6_Graph]



#----- COLUMN 10 -------------------------------

# 10_0 CONFIGURATIONS


Con_10_0_1_Data = Graph ({11:[1,2,3], 12:[1,4,5], 13:[1,6,7], 14:[8,9,10], 15:[2,4,8], 16:[3,5,8], 17:[2,6,9],
                          18:[3,7,9], 19:[4,6,10], 20:[5,7,10]})
Con_10_0_1_Part = (range(1,11), range(11,21))
Con_10_0_1_Graph = BipartiteGraph(Con_10_0_1_Data, Con_10_0_1_Part)
Con_10_0_1_Graph.name('Con-10-0 #1 (Desargues)')

Con_10_0_2_Data = Graph({11:[1,2,3],
                           12:[1,4,5],
                           13:[1,6,7],
                           14:[8,9,10],
                           15:[2,4,8],
                           16:[3,7,8],
                          17:[2,6,9],
                          18:[3,5,9],
                          19:[4,6,10],
                          20:[5,7,10]})
Con_10_0_2_Part = (range(1,11), range(11,21))
Con_10_0_2_Graph = BipartiteGraph(Con_10_0_2_Data, Con_10_0_2_Part)
Con_10_0_2_Graph.name('Con-10-0 #2')

Con_10_0_3_Data = Graph({11:[1,2,3],
                         12:[1,4,5],
                         13:[1,6,7],
                         14:[8,9,10],
                         15:[2,4,8],
                         16:[3,6,8],
                         17:[2,7,9],
                         18:[3,5,9],
                         19:[4,6,10],
                         20:[5,7,10]})
Con_10_0_3_Part = (range(1,11),range(11,21))
Con_10_0_3_Graph = BipartiteGraph(Con_10_0_3_Data, Con_10_0_3_Part)
Con_10_0_3_Graph.name('Con-10-0 #3')

Con_10_0_4_Data = Graph({11:[1,2,3],
                      12:[1,4,5],
                      13:[1,6,7],
                      14:[8,9,10],
                      15:[2,4,8],
                      16:[3,6,8],
                      17:[2,5,9],
                      18:[3,7,9],
                      19:[4,6,10],
                      20:[5,7,10]})
Con_10_0_4_Part = (range(1,11),range(11,21))
Con_10_0_4_Graph = BipartiteGraph(Con_10_0_4_Data, Con_10_0_4_Part)
Con_10_0_4_Graph.name('Con-10-0 #4')

Con_10_0_5_Data = Graph({11:[1,2,3],
                          12:[1,4,5],
                          13:[1,6,7],
                          14:[8,9,10],
                          15:[2,4,8],
                          16:[3,7,8],
                          17:[2,5,9],
                          18:[4,6,9],
                          19:[3,6,10],
                          20:[5,7,10]})
Con_10_0_5_Part = (range(1,11),range(11,21))
Con_10_0_5_Graph = BipartiteGraph(Con_10_0_5_Data, Con_10_0_5_Part)
Con_10_0_5_Graph.name('Con-10-0 #5')

Con_10_0_6_Data = Graph({11:[1,2,3],
                          12:[1,4,5],
                          13:[1,6,7],
                          14:[8,9,10],
                          15:[2,4,8],
                          16:[3,7,8],
                          17:[2,6,9],
                          18:[5,7,9],
                          19:[3,5,10],
                          20:[4,6,10]})
Con_10_0_6_Part = (range(1,11),range(11,21))
Con_10_0_6_Graph = BipartiteGraph(Con_10_0_6_Data, Con_10_0_6_Part)
Con_10_0_6_Graph.name('Con-10-0 #6')

Con_10_0_7_Data = Graph({11:[1,2,3],
                          12:[1,4,5],
                          13:[1,6,7],
                          14:[2,8,9],
                          15:[4,8,10],
                          16:[6,9,10],
                          17:[5,7,8],
                          18:[3,5,9],
                          19:[7,3,10],
                          20:[2,4,6]})
Con_10_0_7_Part = (range(1,11),range(11,21))
Con_10_0_7_Graph = BipartiteGraph(Con_10_0_7_Data, Con_10_0_7_Part)
Con_10_0_7_Graph.name('Con-10-0 #7')

Con_10_0_8_Data = Graph({11:[1,2,3],
                          12:[1,4,5],
                          13:[1,6,7],
                          14:[3,8,9],
                          15:[5,8,10],
                          16:[7,9,10],
                          17:[2,7,8],
                          18:[6,5,9],
                          19:[4,3,10],
                          20:[2,4,6]})
Con_10_0_8_Part = (range(1,11),range(11,21))
Con_10_0_8_Graph = BipartiteGraph(Con_10_0_8_Data, Con_10_0_8_Part)
Con_10_0_8_Graph.name('Con-10-0 #8')

Con_10_0_9_Data = Graph({11:[1,2,3],
                          12:[1,4,5],
                          13:[1,6,7],
                          14:[2,8,9],
                          15:[4,8,10],
                          16:[6,9,10],
                          17:[5,7,8],
                          18:[3,5,9],
                          19:[2,7,10],
                          20:[3,4,6]})
Con_10_0_9_Part = (range(1,11),range(11,21))
Con_10_0_9_Graph = BipartiteGraph(Con_10_0_9_Data, Con_10_0_9_Part)
Con_10_0_9_Graph.name('Con-10-0 #9')

Con_10_0_10_Data = Graph({11:[1,2,3],
                           12:[1,4,5],
                           13:[1,6,7],
                           14:[3,8,9],
                           15:[2,8,10],
                           16:[7,9,10],
                           17:[5,7,8],
                           18:[6,5,9],
                           19:[4,3,10],
                           20:[2,4,6]})
Con_10_0_10_Part = (range(1,11),range(11,21))
Con_10_0_10_Graph = BipartiteGraph(Con_10_0_10_Data, Con_10_0_10_Part)
Con_10_0_10_Graph.name('Con-10-0 #10')

Con_10_0_List = [Con_10_0_1_Graph, Con_10_0_2_Graph, Con_10_0_3_Graph, Con_10_0_4_Graph,
            Con_10_0_5_Graph, Con_10_0_6_Graph, Con_10_0_7_Graph, Con_10_0_8_Graph,
            Con_10_0_9_Graph, Con_10_0_10_Graph]

# The following are the six basic configurations in "Box D" of the Basic Configurations chart.
# Namely, all basic configurations such that there are 10-11 lines, and 2 are of degree 4.

# The 2 degree-4 lines don't intersect:

BoxD311Data = Graph({1:[11,12,13],
                     2:[11,14,17], 3:[11,16,18], 4:[11,19,20],
                     5:[12,15,16], 6:[12,17,20], 7:[12,18,19],
                     8:[13,14,16,19], 9:[13,15,17,18],
                     10: [14,15,20]})
BoxD311Part = (range(1,11),range(11,21))
BoxD311Graph = BipartiteGraph (BoxD311Data, BoxD311Part)
BoxD311Graph.name('Con-10-2 Un. #1')

BoxD312Data = Graph({1:[11,12,13],
                     2:[11,14,17], 3:[11,16,18], 4:[11,19,20],
                     5:[12,15,16], 6:[12,17,20], 7:[12,18,19],
                     8:[13,14,16,20], 9:[13,15,17,18],
                     10: [14,15,19]})
BoxD312Part = (range(1,11),range(11,21))
BoxD312Graph = BipartiteGraph (BoxD312Data, BoxD312Part)
BoxD312Graph.name('Con-10-2 Un. #2')

BoxD321Data = Graph({1:[11,12,13],
                     2:[11,14,17],
                     3:[11,16,18],
                     4:[11,19,20],
                     5:[12,15,16],
                     6:[12,17,20],
                     7:[12,18,19],
                     8:[13,14,16,19],
                     9:[13,15,17],
                     10:[14,15,18,20]})
BoxD321Part = (range(1,11),range(11,21))
BoxD321Graph = BipartiteGraph (BoxD321Data, BoxD321Part)
BoxD321Graph.name('Con-10-2 Un. #3')

# The 2 degree-4 lines don't intersect:

DreidelData = Graph({1:[11,13,20], 2:[11,14,17], 3:[11,15,18], 4:[11,16,19],
                 5:[12,13,17], 6:[12,14,18], 7:[12,15,19], 8:[12,16,20],
                 9:[13,14,15,16], 10:[17,18,19,20]})
DreidelPart = (range(1,11),range(11,21))
DreidelGraph = BipartiteGraph(DreidelData, DreidelPart)
DreidelGraph.name('Con-10-2 Un. #4: Dreidel')

RobotData = Graph({1:[11,13,17], 2:[11,14,18], 3:[11,15,19], 4:[11,16,20],
                   5:[12,13,18], 6:[12,14,17], 7:[12,15,20], 8:[12,16,19],
                   9:[13,14,15,16], 10:[17,18,19,20]})
RobotPart = (range(1,11),range(11,21))
RobotGraph = BipartiteGraph(RobotData, RobotPart)
RobotGraph.name('Con-10-2 Un. #5: Robot')


Con_10_2_U_List = [BoxD311Graph, BoxD312Graph, BoxD321Graph, DreidelGraph, RobotGraph]


#Box 10,1 in the Chart, the "unreachable" 1D4 subset

Con_10_1_U_1 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [18, 15, 20], 7: [13, 16, 20], 8: [12, 19, 15], 9: [13, 14, 17], 10: [18, 12, 14, 16], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 8], 13: [9, 1, 0, 7], 14: [9, 10, 2, 0], 15: [2, 0, 6, 8], 16: [10, 0, 3, 7], 17: [9, 0, 3, 5], 18: [10, 0, 4, 6], 19: [0, 4, 5, 8], 20: [0, 5, 6, 7]}
Con_10_1_U_2 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [18, 15, 20], 7: [13, 16, 20], 8: [19, 13, 14], 9: [12, 15, 17], 10: [18, 12, 14, 16], 11: [1, 2, 0, 3, 4], 12: [9, 1, 10, 0], 13: [1, 0, 7, 8], 14: [10, 2, 0, 8], 15: [9, 2, 0, 6], 16: [10, 0, 3, 7], 17: [9, 0, 3, 5], 18: [10, 0, 4, 6], 19: [0, 4, 5, 8], 20: [0, 5, 6, 7]}
Con_10_1_U_3 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [18, 15, 20], 7: [13, 14, 20], 8: [19, 13, 16], 9: [12, 15, 17], 10: [18, 12, 14, 16], 11: [1, 2, 0, 3, 4], 12: [9, 1, 10, 0], 13: [1, 0, 7, 8], 14: [10, 2, 0, 7], 15: [9, 2, 0, 6], 16: [10, 0, 3, 8], 17: [9, 0, 3, 5], 18: [10, 0, 4, 6], 19: [0, 4, 5, 8], 20: [0, 5, 6, 7]}
Con_10_1_U_4 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 14, 20], 6: [18, 17, 20], 7: [12, 15, 20], 8: [19, 13, 17], 9: [13, 15, 16], 10: [18, 12, 14, 16], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 7], 13: [9, 1, 0, 8], 14: [10, 2, 0, 5], 15: [9, 2, 0, 7], 16: [9, 10, 0, 3], 17: [0, 3, 6, 8], 18: [10, 0, 4, 6], 19: [0, 4, 5, 8], 20: [0, 5, 6, 7]}
Con_10_1_U_5 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 16, 20], 6: [18, 17, 20], 7: [13, 15, 20], 8: [12, 19, 15], 9: [13, 14, 17], 10: [18, 12, 14, 16], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 8], 13: [9, 1, 0, 7], 14: [9, 10, 2, 0], 15: [2, 0, 7, 8], 16: [10, 0, 3, 5], 17: [9, 0, 3, 6], 18: [10, 0, 4, 6], 19: [0, 4, 5, 8], 20: [0, 5, 6, 7]}
Con_10_1_U_6 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 16, 20], 6: [18, 17, 20], 7: [12, 15, 20], 8: [19, 13, 15], 9: [13, 14, 17], 10: [18, 12, 14, 16], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 7], 13: [9, 1, 0, 8], 14: [9, 10, 2, 0], 15: [2, 0, 7, 8], 16: [10, 0, 3, 5], 17: [9, 0, 3, 6], 18: [10, 0, 4, 6], 19: [0, 4, 5, 8], 20: [0, 5, 6, 7]}
Con_10_1_U_7 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [12, 19, 20], 6: [18, 17, 20], 7: [15, 16, 20], 8: [19, 13, 15], 9: [13, 14, 17], 10: [18, 12, 14, 16], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 5], 13: [9, 1, 0, 8], 14: [9, 10, 2, 0], 15: [2, 0, 7, 8], 16: [10, 0, 3, 7], 17: [9, 0, 3, 6], 18: [10, 0, 4, 6], 19: [0, 4, 5, 8], 20: [0, 5, 6, 7]}
Con_10_1_U_8 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [18, 15, 20], 7: [19, 13, 14], 8: [18, 12, 17], 9: [13, 15, 16], 10: [12, 14, 16, 20], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 8], 13: [9, 1, 0, 7], 14: [10, 2, 0, 7], 15: [9, 2, 0, 6], 16: [9, 10, 0, 3], 17: [0, 3, 5, 8], 18: [0, 4, 6, 8], 19: [0, 4, 5, 7], 20: [10, 0, 5, 6]}
Con_10_1_U_9 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [18, 15, 20], 7: [19, 13, 16], 8: [18, 13, 14], 9: [12, 15, 17], 10: [12, 14, 16, 20], 11: [1, 2, 0, 3, 4], 12: [9, 1, 10, 0], 13: [1, 0, 7, 8], 14: [10, 2, 0, 8], 15: [9, 2, 0, 6], 16: [10, 0, 3, 7], 17: [9, 0, 3, 5], 18: [0, 4, 6, 8], 19: [0, 4, 5, 7], 20: [10, 0, 5, 6]}
Con_10_1_U_10 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [18, 15, 20], 7: [19, 13, 14], 8: [18, 13, 16], 9: [12, 15, 17], 10: [12, 14, 16, 20], 11: [1, 2, 0, 3, 4], 12: [9, 1, 10, 0], 13: [1, 0, 7, 8], 14: [10, 2, 0, 7], 15: [9, 2, 0, 6], 16: [10, 0, 3, 8], 17: [9, 0, 3, 5], 18: [0, 4, 6, 8], 19: [0, 4, 5, 7], 20: [10, 0, 5, 6]}
Con_10_1_U_11 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [13, 15, 20], 7: [19, 15, 16], 8: [18, 12, 17], 9: [18, 13, 14], 10: [12, 14, 16, 20], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 8], 13: [9, 1, 0, 6], 14: [9, 10, 2, 0], 15: [2, 0, 6, 7], 16: [10, 0, 3, 7], 17: [0, 3, 5, 8], 18: [9, 0, 4, 8], 19: [0, 4, 5, 7], 20: [10, 0, 5, 6]}
Con_10_1_U_12 = {1: [11, 12, 13], 2: [11, 14, 15], 3: [11, 16, 17], 4: [11, 18, 19], 5: [19, 17, 20], 6: [13, 15, 20], 7: [12, 19, 15], 8: [18, 14, 17], 9: [18, 13, 16], 10: [12, 14, 16, 20], 11: [1, 2, 0, 3, 4], 12: [1, 10, 0, 7], 13: [9, 1, 0, 6], 14: [10, 2, 0, 8], 15: [2, 0, 6, 7], 16: [9, 10, 0, 3], 17: [0, 3, 5, 8], 18: [9, 0, 4, 8], 19: [0, 4, 5, 7], 20: [10, 0, 5, 6]}

Con_10_1_U_1_Graph = BipartiteGraph(Graph(Con_10_1_U_1), (range(1,11), range(11,21)))
Con_10_1_U_2_Graph = BipartiteGraph(Graph(Con_10_1_U_2), (range(1,11), range(11,21)))
Con_10_1_U_3_Graph = BipartiteGraph(Graph(Con_10_1_U_3), (range(1,11), range(11,21)))
Con_10_1_U_4_Graph = BipartiteGraph(Graph(Con_10_1_U_4), (range(1,11), range(11,21)))
Con_10_1_U_5_Graph = BipartiteGraph(Graph(Con_10_1_U_5), (range(1,11), range(11,21)))
Con_10_1_U_6_Graph = BipartiteGraph(Graph(Con_10_1_U_6), (range(1,11), range(11,21)))
Con_10_1_U_7_Graph = BipartiteGraph(Graph(Con_10_1_U_7), (range(1,11), range(11,21)))
Con_10_1_U_8_Graph = BipartiteGraph(Graph(Con_10_1_U_8), (range(1,11), range(11,21)))
Con_10_1_U_9_Graph = BipartiteGraph(Graph(Con_10_1_U_9), (range(1,11), range(11,21)))
Con_10_1_U_10_Graph = BipartiteGraph(Graph(Con_10_1_U_10), (range(1,11), range(11,21)))
Con_10_1_U_11_Graph = BipartiteGraph(Graph(Con_10_1_U_11), (range(1,11), range(11,21)))
Con_10_1_U_12_Graph = BipartiteGraph(Graph(Con_10_1_U_12), (range(1,11), range(11,21)))

Con_10_1_U_1_Graph.name("Con-10-1 Un. #1")
Con_10_1_U_2_Graph.name("Con-10-1 Un. #2")
Con_10_1_U_3_Graph.name("Con-10-1 Un. #3")
Con_10_1_U_4_Graph.name("Con-10-1 Un. #4")
Con_10_1_U_5_Graph.name("Con-10-1 Un. #5")
Con_10_1_U_6_Graph.name("Con-10-1 Un. #6")
Con_10_1_U_7_Graph.name("Con-10-1 Un. #7")
Con_10_1_U_8_Graph.name("Con-10-1 Un. #8")
Con_10_1_U_9_Graph.name("Con-10-1 Un. #9")
Con_10_1_U_10_Graph.name("Con-10-1 Un. #10")
Con_10_1_U_11_Graph.name("Con-10-1 Un. #11")
Con_10_1_U_12_Graph.name("Con-10-1 Un. #12")

Con_10_1_U_List = [Con_10_1_U_1_Graph, Con_10_1_U_2_Graph, Con_10_1_U_3_Graph, Con_10_1_U_4_Graph, Con_10_1_U_5_Graph, Con_10_1_U_6_Graph, Con_10_1_U_7_Graph, Con_10_1_U_8_Graph, Con_10_1_U_9_Graph, Con_10_1_U_10_Graph, Con_10_1_U_11_Graph, Con_10_1_U_12_Graph]



Con_10_1_R_1 = {1: [11, 12, 13], 2: [11, 17, 15], 3: [11, 16, 18], 4: [12, 19, 15], 5: [12, 16, 20], 6: [19, 13, 17], 7: [13, 18, 20], 8: [14, 15, 16], 9: [14, 17, 18], 10: [11, 14, 19, 20], 11: [1, 10, 2, 0, 3], 12: [1, 0, 4, 5], 13: [1, 0, 6, 7], 14: [9, 10, 0, 8], 15: [2, 0, 4, 8], 16: [0, 3, 5, 8], 17: [9, 2, 0, 6], 18: [9, 0, 3, 7], 19: [10, 0, 4, 6], 20: [10, 0, 5, 7]}
Con_10_1_R_2 ={1: [11, 12, 13], 2: [11, 17, 15], 3: [11, 16, 18], 4: [12, 19, 15], 5: [12, 18, 20], 6: [19, 13, 17], 7: [13, 16, 20], 8: [14, 15, 16], 9: [14, 17, 18], 10: [11, 14, 19, 20], 11: [1, 10, 2, 0, 3], 12: [1, 0, 4, 5], 13: [1, 0, 6, 7], 14: [9, 10, 0, 8], 15: [2, 0, 4, 8], 16: [0, 3, 7, 8], 17: [9, 2, 0, 6], 18: [9, 0, 3, 5], 19: [10, 0, 4, 6], 20: [10, 0, 5, 7]}
Con_10_1_R_3 ={1: [11, 12, 13, 14], 2: [11, 17, 15], 3: [11, 18, 16], 4: [12, 19, 15], 5: [18, 12, 20], 6: [19, 13, 17], 7: [13, 16, 20], 8: [14, 15, 16], 9: [18, 14, 17], 10: [19, 14, 20], 11: [1, 0, 2, 3], 12: [1, 0, 4, 5], 13: [1, 0, 6, 7], 14: [9, 1, 10, 0, 8], 15: [0, 2, 4, 8], 16: [0, 3, 7, 8], 17: [9, 0, 2, 6], 18: [9, 0, 3, 5], 19: [10, 0, 4, 6], 20: [10, 0, 5, 7]}
Con_10_1_R_4 ={1: [11, 12, 13], 2: [11, 17, 15], 3: [11, 16, 18], 4: [12, 19, 15], 5: [12, 18, 20], 6: [19, 13, 16], 7: [13, 17, 20], 8: [14, 15, 16], 9: [14, 17, 18], 10: [11, 14, 19, 20], 11: [1, 10, 2, 0, 3], 12: [1, 0, 4, 5], 13: [1, 0, 6, 7], 14: [9, 10, 0, 8], 15: [2, 0, 4, 8], 16: [0, 3, 6, 8], 17: [9, 2, 0, 7], 18: [9, 0, 3, 5], 19: [10, 0, 4, 6], 20: [10, 0, 5, 7]}
#Con_10_1_R_5 ={1: [12, 11, 13, 100], 2: [11, 17, 100, 15], 3: [11, 100, 16, 18], 4: [12, 19, 100, 15], 5: [12, 100, 18, 20], 6: [13, 19, 100, 16], 7: [13, 17, 100, 20], 8: [100, 15, 16, 14], 9: [17, 100, 18, 14], 10: [11, 19, 100, 20, 14], 11: [1, 2, 3, 10], 12: [1, 4, 5], 13: [1, 7, 6], 14: [9, 8, 10], 15: [2, 4, 8], 16: [3, 6, 8], 17: [7, 9, 2], 18: [9, 3, 5], 19: [4, 6, 10], 20: [7, 5, 10]}
Con_10_1_R_6 ={1: [11, 12, 13], 2: [11, 17, 15], 3: [11, 16, 18], 4: [12, 19, 15], 5: [12, 17, 20], 6: [19, 13, 16], 7: [13, 18, 20], 8: [14, 15, 16], 9: [14, 17, 18], 10: [11, 14, 19, 20], 11: [1, 10, 2, 0, 3], 12: [1, 0, 4, 5], 13: [1, 0, 6, 7], 14: [9, 10, 0, 8], 15: [2, 0, 4, 8], 16: [0, 3, 6, 8], 17: [9, 2, 0, 5], 18: [9, 0, 3, 7], 19: [10, 0, 4, 6], 20: [10, 0, 5, 7]}
Con_10_1_R_7 ={1: [11, 12, 13, 14], 2: [11, 17, 15], 3: [11, 19, 16], 4: [18, 12, 15], 5: [12, 17, 20], 6: [18, 19, 13], 7: [13, 16, 20], 8: [14, 15, 16], 9: [18, 14, 17], 10: [19, 14, 20], 11: [1, 0, 2, 3], 12: [1, 0, 4, 5], 13: [1, 0, 6, 7], 14: [9, 1, 10, 0, 8], 15: [0, 2, 4, 8], 16: [0, 3, 7, 8], 17: [9, 0, 2, 5], 18: [9, 0, 4, 6], 19: [10, 0, 3, 6], 20: [10, 0, 5, 7]}
Con_10_1_R_8 ={1: [11, 12, 13, 14], 2: [11, 17, 15], 3: [11, 19, 16], 4: [12, 15, 20], 5: [18, 12, 19], 6: [13, 17, 20], 7: [18, 13, 16], 8: [14, 15, 16], 9: [18, 14, 17], 10: [19, 14, 20], 11: [1, 0, 2, 3], 12: [1, 0, 4, 5], 13: [1, 0, 6, 7], 14: [9, 1, 10, 0, 8], 15: [0, 2, 4, 8], 16: [0, 3, 7, 8], 17: [9, 0, 2, 6], 18: [9, 0, 5, 7], 19: [10, 0, 3, 5], 20: [10, 0, 4, 6]}

Con_10_1_R_1Graph = BipartiteGraph(Graph(Con_10_1_R_1), (range(1,11), range(11,21)))
Con_10_1_R_2Graph = BipartiteGraph(Graph(Con_10_1_R_2), (range(1,11), range(11,21)))
Con_10_1_R_3Graph = BipartiteGraph(Graph(Con_10_1_R_3), (range(1,11), range(11,21)))
Con_10_1_R_4Graph = BipartiteGraph(Graph(Con_10_1_R_4), (range(1,11), range(11,21)))
#Con_10_1_R_5Graph = BipartiteGraph(Graph(Con_10_1_R_5), (range(1,11), range(11,21)))
Con_10_1_R_6Graph = BipartiteGraph(Graph(Con_10_1_R_6), (range(1,11), range(11,21)))
Con_10_1_R_7Graph = BipartiteGraph(Graph(Con_10_1_R_7), (range(1,11), range(11,21)))
Con_10_1_R_8Graph = BipartiteGraph(Graph(Con_10_1_R_8), (range(1,11), range(11,21)))

Con_10_1_R_1Graph.name('Con-10-1-R #1')
Con_10_1_R_2Graph.name('Con-10-1-R #2')
Con_10_1_R_3Graph.name('Con-10-1-R #3')
Con_10_1_R_4Graph.name('Con-10-1-R #4')
#Con_10_1_R_5Graph.name('Con-10-1-R #5')
Con_10_1_R_6Graph.name('Con-10-1-R #6 (Anti-Desargues No. 1)')
Con_10_1_R_7Graph.name('Con-10-1-R #7')
Con_10_1_R_8Graph.name('Con-10-1-R #8')

Con_10_1_R_List = [Con_10_1_R_1Graph,
Con_10_1_R_2Graph,
Con_10_1_R_3Graph,
Con_10_1_R_4Graph,
#Con_10_1_R_5Graph,
Con_10_1_R_6Graph,
Con_10_1_R_7Graph,
Con_10_1_R_8Graph]


Con_10_1_List = Con_10_1_R_List + Con_10_1_U_List



Con_10_2_R_1 = {1: [11, 12, 13],
                2: [17, 11, 15], 3: [16, 18, 11], 4: [19, 12, 15], 5: [16, 20, 12], 6: [17, 19, 13], 7: [18, 20, 13], 8: [16, 14, 15], 9: [17, 18, 12, 14], 10: [19, 20, 11, 14], 11: [10, 1, 2, 3], 12: [1, 4, 5, 9], 13: [1, 6, 7], 14: [10, 8, 9], 15: [2, 4, 8], 16: [3, 5, 8], 17: [2, 6, 9], 18: [3, 7, 9], 19: [10, 4, 6], 20: [10, 5, 7]}
Con_10_2_R_2 = {1: [11, 12, 13, 14],
                2: [17, 11, 15], 3: [16, 18, 19, 11], 4: [19, 12, 15], 5: [18, 20, 12], 6: [17, 19, 13], 7: [16, 20, 13], 8: [16, 14, 15], 9: [17, 18, 14], 10: [19, 20, 14], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [10, 1, 8, 9], 15: [2, 4, 8], 16: [3, 7, 8], 17: [2, 6, 9], 18: [3, 5, 9], 19: [10, 3, 4, 6], 20: [10, 5, 7]}
Con_10_2_R_3 = {1: [11, 12, 13],
 2: [17, 11, 15], 3: [16, 18, 11], 4: [19, 12, 15], 5: [17, 20, 12], 6: [16, 19, 13], 7: [18, 20, 13, 15], 8: [16, 14, 15], 9: [17, 18, 14], 10: [19, 20, 11, 14], 11: [10, 1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [10, 8, 9], 15: [2, 4, 7, 8], 16: [3, 6, 8], 17: [2, 5, 9], 18: [3, 7, 9], 19: [10, 4, 6], 20: [10, 5, 7]}
Con_10_2_R_4 = {1: [11, 12, 13],
 2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [17, 19, 20], 6: [18, 20, 15], 7: [20, 13, 14], 8: [16, 19, 13, 15], 9: [17, 12, 15], 10: [16, 18, 12, 14], 11: [1, 2, 3, 4], 12: [10, 1, 9], 13: [1, 7, 8], 14: [10, 2, 7], 15: [2, 6, 8, 9], 16: [10, 3, 8], 17: [3, 5, 9], 18: [10, 4, 6], 19: [4, 5, 8], 20: [5, 6, 7]}
Con_10_2_R_5 = {1: [11, 12, 13],
 2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [16, 19, 20], 6: [17, 18, 20], 7: [20, 13, 15], 8: [17, 19, 12, 15], 9: [17, 13, 14], 10: [16, 18, 12, 14], 11: [1, 2, 3, 4], 12: [10, 1, 8], 13: [1, 7, 9], 14: [10, 2, 9], 15: [2, 7, 8], 16: [10, 3, 5], 17: [3, 6, 8, 9], 18: [10, 4, 6], 19: [4, 5, 8], 20: [5, 6, 7]}
Con_10_2_R_6 = {1: [11, 12, 13],
 2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [17, 19, 20], 6: [18, 20, 15], 7: [16, 19, 13, 15], 8: [18, 13, 14], 9: [17, 12, 15], 10: [16, 20, 12, 14], 11: [1, 2, 3, 4], 12: [10, 1, 9], 13: [1, 7, 8], 14: [10, 2, 8], 15: [2, 6, 7, 9], 16: [10, 3, 7], 17: [3, 5, 9], 18: [4, 6, 8], 19: [4, 5, 7], 20: [10, 5, 6]}
Con_10_2_R_7 = {1: [11, 12, 13],
 2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [17, 19, 20], 6: [20, 13, 15], 7: [16, 19, 15], 8: [17, 18, 12, 15], 9: [18, 13, 14], 10: [16, 20, 12, 14], 11: [1, 2, 3, 4], 12: [10, 1, 8], 13: [1, 6, 9], 14: [10, 2, 9], 15: [2, 6, 7, 8], 16: [10, 3, 7], 17: [3, 5, 8], 18: [4, 8, 9], 19: [4, 5, 7], 20: [10, 5, 6]}

Con_10_2_R_1_Graph = BipartiteGraph(Graph(Con_10_2_R_1), (range(1,11),range(11,21)))
Con_10_2_R_2_Graph = BipartiteGraph(Graph(Con_10_2_R_2), (range(1,11),range(11,21)))
Con_10_2_R_3_Graph = BipartiteGraph(Graph(Con_10_2_R_3), (range(1,11),range(11,21)))
Con_10_2_R_4_Graph = BipartiteGraph(Graph(Con_10_2_R_4), (range(1,11),range(11,21)))
Con_10_2_R_5_Graph = BipartiteGraph(Graph(Con_10_2_R_5), (range(1,11),range(11,21)))
Con_10_2_R_6_Graph = BipartiteGraph(Graph(Con_10_2_R_6), (range(1,11),range(11,21)))
Con_10_2_R_7_Graph = BipartiteGraph(Graph(Con_10_2_R_7), (range(1,11),range(11,21)))

Con_10_2_R_1_Graph.name('Con-10-2 R #1')
Con_10_2_R_2_Graph.name('Con-10-2 R #2')
Con_10_2_R_3_Graph.name('Con-10-2 R #3 (Anti-Desargues No. 2)')
Con_10_2_R_4_Graph.name('Con-10-2 R #4')
Con_10_2_R_5_Graph.name('Con-10-2 R #5')
Con_10_2_R_6_Graph.name('Con-10-2 R #6')
Con_10_2_R_7_Graph.name('Con-10-2 R #7')

Con_10_2_R_List = [Con_10_2_R_1_Graph, Con_10_2_R_2_Graph, Con_10_2_R_3_Graph, Con_10_2_R_4_Graph, Con_10_2_R_5_Graph, Con_10_2_R_6_Graph, Con_10_2_R_7_Graph]

Con_10_2_List = Con_10_2_U_List + Con_10_2_R_List





Con_10_3_1 = {1: [11, 12, 13],
              2: [17, 11, 15], 3: [16, 18, 11], 4: [19, 12, 15], 5: [16, 20, 12], 6: [17, 19, 13], 7: [18, 20, 13], 8: [16, 13, 14, 15], 9: [17, 18, 12, 14], 10: [19, 20, 11, 14], 11: [10, 1, 2, 3], 12: [1, 4, 5, 9], 13: [1, 6, 7, 8], 14: [10, 8, 9], 15: [2, 4, 8], 16: [3, 5, 8], 17: [2, 6, 9], 18: [3, 7, 9], 19: [10, 4, 6], 20: [10, 5, 7]}
Con_10_3_2 = {1: [11, 12, 13],
              2: [17, 11, 15], 3: [16, 18, 11], 4: [19, 12, 15], 5: [16, 20, 12], 6: [17, 19, 13], 7: [18, 20, 13, 15], 8: [16, 14, 15], 9: [17, 18, 12, 14], 10: [19, 20, 11, 14], 11: [10, 1, 2, 3], 12: [1, 4, 5, 9], 13: [1, 6, 7], 14: [10, 8, 9], 15: [2, 4, 7, 8], 16: [3, 5, 8], 17: [2, 6, 9], 18: [3, 7, 9], 19: [10, 4, 6], 20: [10, 5, 7]}
Con_10_3_3 = {1: [11, 12, 13, 14],
              2: [17, 20, 11, 15], 3: [16, 18, 19, 11], 4: [19, 12, 15], 5: [18, 20, 12], 6: [17, 19, 13], 7: [16, 20, 13], 8: [16, 14, 15], 9: [17, 18, 14], 10: [19, 20, 14], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [10, 1, 8, 9], 15: [2, 4, 8], 16: [3, 7, 8], 17: [2, 6, 9], 18: [3, 5, 9], 19: [10, 3, 4, 6], 20: [10, 2, 5, 7]}
Con_10_3_4 = {1: [11, 12, 13],
              2: [17, 11, 15], 3: [16, 18, 11], 4: [19, 12, 15], 5: [16, 17, 20, 12], 6: [16, 19, 13], 7: [18, 20, 13, 15], 8: [16, 14, 15], 9: [17, 18, 14], 10: [19, 20, 11, 14], 11: [10, 1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [10, 8, 9], 15: [2, 4, 7, 8], 16: [3, 5, 6, 8], 17: [2, 5, 9], 18: [3, 7, 9], 19: [10, 4, 6], 20: [10, 5, 7]}
Con_10_3_5 = {1: [11, 12, 13],
              2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [17, 19, 20], 6: [18, 20, 15], 7: [16, 19, 13, 15], 8: [17, 18, 13, 14], 9: [17, 12, 15], 10: [16, 20, 12, 14], 11: [1, 2, 3, 4], 12: [10, 1, 9], 13: [1, 7, 8], 14: [10, 2, 8], 15: [2, 6, 7, 9], 16: [10, 3, 7], 17: [3, 5, 8, 9], 18: [4, 6, 8], 19: [4, 5, 7], 20: [10, 5, 6]}

Con_10_3_1_Graph = BipartiteGraph(Graph(Con_10_3_1), (range(1,11), range(11,21)))
Con_10_3_2_Graph = BipartiteGraph(Graph(Con_10_3_2), (range(1,11), range(11,21)))
Con_10_3_3_Graph = BipartiteGraph(Graph(Con_10_3_3), (range(1,11), range(11,21)))
Con_10_3_4_Graph = BipartiteGraph(Graph(Con_10_3_4), (range(1,11), range(11,21)))
Con_10_3_5_Graph = BipartiteGraph(Graph(Con_10_3_5), (range(1,11), range(11,21)))

Con_10_3_1_Graph.name('Con-10-3 #1')
Con_10_3_2_Graph.name('Con-10-3 #2')
Con_10_3_3_Graph.name('Con-10-3 #3')
Con_10_3_4_Graph.name('Con-10-3 #4 (UberFano / Anti-Desargues No. 3)')
Con_10_3_5_Graph.name('Con-10-3 #5')

Con_10_3_List = [Con_10_3_1_Graph, Con_10_3_2_Graph, Con_10_3_3_Graph, Con_10_3_4_Graph, Con_10_3_5_Graph]



# Box 11_0 (a.k.a. "Box C") ------------------------------


#Box C Configuration A Graphs
#7 of them

Con_11_0_1 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11],
              4: [16, 18, 12], 5: [17, 19, 12], 6: [16, 20, 13],
              7: [17, 21, 13], 8: [19, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15]}
Con_11_0_2 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11],
              4: [16, 18, 12], 5: [17, 19, 12], 6: [16, 21, 13], 7: [17, 20, 13],
              8: [19, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15]}
Con_11_0_3 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11],
              4: [16, 18, 12], 5: [17, 19, 12], 6: [16, 20, 13], 7: [17, 21, 13],
              8: [20, 14, 15], 9: [19, 21, 14], 10: [18, 21, 15]}
Con_11_0_4 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11],
 4: [16, 18, 12], 5: [17, 21, 12], 6: [16, 19, 13], 7: [17, 20, 13],
 8: [19, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15]}
Con_11_0_5 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11],
 4: [16, 18, 12], 5: [17, 19, 12], 6: [16, 19, 13], 7: [21, 20, 13],
 8: [20, 14, 15], 9: [17, 21, 14], 10: [18, 21, 15]}
Con_11_0_6 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11],
 4: [16, 19, 12], 5: [17, 18, 12], 6: [16, 20, 13], 7: [19, 21, 13],
 8: [20, 14, 15], 9: [17, 21, 14], 10: [18, 21, 15]}
Con_11_0_7 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11],
 4: [16, 19, 12], 5: [17, 20, 12], 6: [16, 18, 13], 7: [19, 21, 13],
 8: [20, 14, 15], 9: [17, 21, 14], 10: [18, 21, 15]}


# Box C configuration B graphs
#There are 4 total
Con_11_0_8 = {1: [11, 12, 13, 14], 
                          2: [16, 17, 18, 15], 
                          3: [19, 20, 11, 15], 
                          4: [21, 12, 15], 
                          5: [17, 21, 11], 
                          6: [17, 19, 12], 
                          7: [18, 19, 13], 
                          8: [16, 20, 13], 
                          9: [18, 20, 14], 
                          10: [16, 21, 14]}
Con_11_0_9 = {1: [11, 12, 13, 14], 
                          2: [16, 17, 18, 15], 
                          3: [19, 20, 11, 15], 
                          4: [21, 12, 15], 
                          5: [17, 21, 11], 
                          6: [18, 19, 12], 
                          7: [17, 19, 13], 
                          8: [16, 20, 13], 
                          9: [18, 20, 14], 
                          10: [16, 21, 14]}
Con_11_0_10 = {1: [11, 12, 13, 14], 
                          2: [16, 17, 18, 15], 
                          3: [19, 20, 11, 15], 
                          4: [21, 12, 15],
                          5: [17, 21, 11],
                          6: [18, 19, 12], 
                          7: [17, 20, 13],
                          8: [16, 19, 13],
                          9: [18, 20, 14],
                          10: [16, 21, 14]}
Con_11_0_11 = {1: [11, 12, 13, 14], 
                          2: [16, 17, 18, 15], 
                          3: [19, 20, 11, 15], 
                          4: [21, 12, 15], 
                          5: [17, 21, 11],
                          6: [18, 19, 12],
                          7: [17, 20, 13], 
                          8: [16, 19, 13], 
                          9: [18, 21, 14], 
                          10: [16, 20, 14]}


#Box C Configuration C
#9 of them

Con_11_0_12 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 21, 13],
               8: [17, 19, 13], 9: [16, 19, 14], 10: [18, 20, 14], 11: [1, 3, 5],
               12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9],
               17: [2, 5, 8], 18: [10, 3, 6], 19: [3, 8, 9], 20: [10, 4, 5], 21: [4, 6, 7]}
Con_11_0_13 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 21, 13], 8: [17, 19, 13], 9: [16, 18, 14], 10: [19, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 9], 19: [10, 3, 8], 20: [10, 4, 5], 21: [4, 6, 7]}
Con_11_0_14 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 19, 13], 8: [17, 18, 13], 9: [16, 21, 14], 10: [19, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 8], 19: [10, 3, 7], 20: [10, 4, 5], 21: [4, 6, 9]}
Con_11_0_15 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 18, 13], 8: [17, 19, 13], 9: [16, 21, 14], 10: [19, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 7], 19: [10, 3, 8], 20: [10, 4, 5], 21: [4, 6, 9]}
Con_11_0_16 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 20, 13], 8: [17, 19, 13], 9: [16, 18, 14], 10: [19, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 9], 19: [10, 3, 8], 20: [4, 5, 7], 21: [10, 4, 6]}
Con_11_0_17 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 19, 13], 8: [17, 18, 13], 9: [16, 20, 14], 10: [19, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 8], 19: [10, 3, 7], 20: [4, 5, 9], 21: [10, 4, 6]}
Con_11_0_18 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 18, 13], 8: [17, 19, 13], 9: [16, 20, 14], 10: [19, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 7], 19: [10, 3, 8], 20: [4, 5, 9], 21: [10, 4, 6]}
Con_11_0_19 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 20, 12], 7: [16, 21, 13], 8: [17, 19, 13], 9: [16, 19, 14], 10: [18, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [10, 3, 6], 19: [3, 8, 9], 20: [4, 5, 6], 21: [10, 4, 7]}
Con_11_0_20 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15],
               4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 20, 12], 7: [16, 21, 13], 8: [17, 19, 13], 9: [16, 18, 14], 10: [19, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 9], 19: [10, 3, 8], 20: [4, 5, 6], 21: [10, 4, 7]}


#Box C, Configuration D
#23 of them (generated by program only, not checked by hand)

Con_11_0_21 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 12, 15],
               4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 21, 11], 7: [16, 19, 13], 8: [17, 18, 14], 9: [19, 21, 14], 10: [17, 21, 20]}
Con_11_0_22 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 12, 15],
               4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 20, 11], 7: [16, 19, 13], 8: [17, 18, 14], 9: [19, 21, 14], 10: [17, 21, 20]}
Con_11_0_23 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 11], 7: [16, 19, 13], 8: [17, 18, 14], 9: [19, 20, 14], 10: [17, 21, 20]}
Con_11_0_24 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 21, 11], 7: [16, 21, 13], 8: [17, 18, 14], 9: [19, 20, 14], 10: [17, 19, 21]}
Con_11_0_25 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 20, 11], 7: [16, 19, 13], 8: [17, 19, 14], 9: [18, 21, 14], 10: [17, 21, 20]}
Con_11_0_26 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 11], 7: [16, 19, 13], 8: [17, 19, 14], 9: [18, 20, 14], 10: [17, 21, 20]}
Con_11_0_27 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 20, 11], 7: [16, 19, 13], 8: [17, 20, 14], 9: [18, 21, 14], 10: [17, 19, 21]}
Con_11_0_28 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 11], 7: [16, 19, 13], 8: [17, 21, 14], 9: [18, 20, 14], 10: [17, 19, 20]}
Con_11_0_29 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [21, 20, 11], 7: [16, 18, 13], 8: [17, 18, 14], 9: [19, 20, 14], 10: [17, 19, 21]}
Con_11_0_30 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [21, 20, 11], 7: [16, 18, 13], 8: [17, 18, 14], 9: [19, 21, 14], 10: [17, 19, 20]}
Con_11_0_31 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 21, 11], 7: [17, 19, 13], 8: [16, 21, 14], 9: [17, 18, 14], 10: [19, 21, 20]}
Con_11_0_32 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 11], 7: [17, 19, 13], 8: [16, 20, 14], 9: [17, 18, 14], 10: [19, 21, 20]}
Con_11_0_33 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 20, 11], 7: [17, 21, 13], 8: [16, 19, 14], 9: [18, 21, 14], 10: [17, 19, 20]}
Con_11_0_34 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 11], 7: [17, 21, 13], 8: [16, 19, 14], 9: [18, 20, 14], 10: [17, 19, 20]}
Con_11_0_35 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [21, 20, 11], 7: [17, 18, 13], 8: [16, 18, 14], 9: [19, 20, 14], 10: [17, 19, 21]}
Con_11_0_36 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [21, 20, 11], 7: [17, 18, 13], 8: [16, 18, 14], 9: [19, 21, 14], 10: [17, 19, 20]}
Con_11_0_37 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [21, 20, 11], 7: [17, 18, 13], 8: [16, 19, 14], 9: [18, 21, 14], 10: [17, 19, 21]}
Con_11_0_38 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [21, 20, 11], 7: [17, 18, 13], 8: [16, 19, 14], 9: [18, 20, 14], 10: [17, 19, 21]}
Con_11_0_39 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [21, 20, 11], 7: [17, 18, 13], 8: [16, 19, 14], 9: [18, 21, 14], 10: [17, 19, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 7], 18: [3, 7, 9], 19: [10, 3, 8], 20: [10, 4, 6], 21: [5, 6, 9]}
Con_11_0_40 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 20, 11], 7: [19, 21, 13], 8: [16, 21, 14], 9: [17, 19, 14], 10: [17, 18, 21], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 9], 18: [10, 3, 6], 19: [3, 7, 9], 20: [4, 5, 6], 21: [10, 7, 8]}
Con_11_0_41 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 21, 11], 7: [19, 21, 13], 8: [16, 21, 14], 9: [17, 19, 14], 10: [17, 18, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 9], 18: [10, 3, 6], 19: [3, 7, 9], 20: [10, 4, 5], 21: [6, 7, 8]}
Con_11_0_42 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [21, 20, 11], 7: [18, 21, 13], 8: [16, 19, 14], 9: [17, 18, 14], 10: [17, 19, 21], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 9], 18: [3, 7, 9], 19: [10, 3, 8], 20: [4, 5, 6], 21: [10, 6, 7]}
Con_11_0_43 = {1: [11, 12, 13, 14],
               2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [21, 20, 11], 7: [18, 21, 13], 8: [16, 19, 14], 9: [17, 18, 14], 10: [17, 19, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 9], 18: [3, 7, 9], 19: [10, 3, 8], 20: [10, 4, 6], 21: [5, 6, 7]}


#Box 11,1 in the Chart, the "unreachable" 1D4 subset
#finds 5 configs

Con_11_1_U_1 = {1: [11, 12, 13],
                2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [19, 21, 20], 6: [17, 18, 20, 15], 7: [16, 20, 13, 14], 8: [18, 21, 12, 14], 9: [17, 21, 13], 10: [16, 19, 12, 15], 11: [1, 2, 3, 4], 12: [10, 1, 8], 13: [1, 7, 9], 14: [2, 7, 8], 15: [10, 2, 6], 16: [10, 3, 7], 17: [3, 6, 9], 18: [4, 6, 8], 19: [10, 4, 5], 20: [5, 6, 7], 21: [5, 8, 9]}
Con_11_1_U_2 = {1: [11, 12, 13],
                2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [19, 21, 20], 6: [17, 18, 20, 15], 7: [16, 20, 13, 14], 8: [18, 21, 13], 9: [17, 21, 12, 14], 10: [16, 19, 12, 15], 11: [1, 2, 3, 4], 12: [10, 1, 9], 13: [1, 7, 8], 14: [2, 7, 9], 15: [10, 2, 6], 16: [10, 3, 7], 17: [3, 6, 9], 18: [4, 6, 8], 19: [10, 4, 5], 20: [5, 6, 7], 21: [5, 8, 9]}
Con_11_1_U_3 = {1: [11, 12, 13],
                2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [17, 19, 20, 15], 6: [16, 18, 20, 13], 7: [20, 12, 14], 8: [16, 19, 21, 14], 9: [17, 18, 21, 12], 10: [21, 13, 15], 11: [1, 2, 3, 4], 12: [1, 7, 9], 13: [10, 1, 6], 14: [2, 7, 8], 15: [10, 2, 5], 16: [3, 6, 8], 17: [3, 5, 9], 18: [4, 6, 9], 19: [4, 5, 8], 20: [5, 6, 7], 21: [10, 8, 9]}
Con_11_1_U_4 = {1: [11, 12, 13],
                2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [17, 19, 20, 15], 6: [16, 18, 20, 13], 7: [20, 12, 14], 8: [19, 21, 13, 14], 9: [17, 18, 21, 12], 10: [16, 21, 15], 11: [1, 2, 3, 4], 12: [1, 7, 9], 13: [1, 6, 8], 14: [2, 7, 8], 15: [10, 2, 5], 16: [10, 3, 6], 17: [3, 5, 9], 18: [4, 6, 9], 19: [4, 5, 8], 20: [5, 6, 7], 21: [10, 8, 9]}
Con_11_1_U_5 = {1: [11, 12, 13],
                2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 11], 5: [17, 19, 20, 15], 6: [16, 18, 20, 13], 7: [20, 12, 14], 8: [19, 21, 13, 14], 9: [17, 18, 21], 10: [16, 21, 12, 15], 11: [1, 2, 3, 4], 12: [10, 1, 7], 13: [1, 6, 8], 14: [2, 7, 8], 15: [10, 2, 5], 16: [10, 3, 6], 17: [3, 5, 9], 18: [4, 6, 9], 19: [4, 5, 8], 20: [5, 6, 7], 21: [10, 8, 9]}





#Box 12,0 "unreachables": only one config, found+checked by hand
Con_12_0_U_1_Data = Graph({11:[1,3,4], 12:[1,5,6], 13:[1,7,8], 14:[1,9,10],
                 15:[2,3,5], 16:[2,6,7], 17:[2,8,9], 18:[2,4,10],
                 19:[3,6,9], 20:[4,6,8], 21:[3,7,10], 22:[5,8,10]})
Con_12_0_U_1_Part = (range(1,11),range(11,23))
Con_12_0_U_1_Graph = BipartiteGraph(Con_12_0_U_1_Data, Con_12_0_U_1_Part)
Con_12_0_U_1_Graph.name('Con-12-0: Unreachable #1 (EvilGrid)')

Con_12_0_U_List = [Con_12_0_U_1_Graph]





Con_11_0_1_Data = Graph(Con_11_0_1)
Con_11_0_1_Part = (range(1,11), range(11,22))
Con_11_0_1_Graph = BipartiteGraph(Con_11_0_1_Data, Con_11_0_1_Part)

Con_11_0_2_Data = Graph(Con_11_0_2)
Con_11_0_2_Part = (range(1,11), range(11,22))
Con_11_0_2_Graph = BipartiteGraph(Con_11_0_2_Data, Con_11_0_2_Part)

Con_11_0_3_Data = Graph(Con_11_0_3)
Con_11_0_3_Part = (range(1,11), range(11,22))
Con_11_0_3_Graph = BipartiteGraph(Con_11_0_3_Data, Con_11_0_3_Part)

Con_11_0_4_Data = Graph(Con_11_0_4)
Con_11_0_4_Part = (range(1,11), range(11,22))
Con_11_0_4_Graph = BipartiteGraph(Con_11_0_4_Data, Con_11_0_4_Part)

Con_11_0_5_Data = Graph(Con_11_0_5)
Con_11_0_5_Part = (range(1,11), range(11,22))
Con_11_0_5_Graph = BipartiteGraph(Con_11_0_5_Data, Con_11_0_5_Part)

Con_11_0_6_Data = Graph(Con_11_0_6)
Con_11_0_6_Part = (range(1,11), range(11,22))
Con_11_0_6_Graph = BipartiteGraph(Con_11_0_6_Data, Con_11_0_6_Part)

Con_11_0_7_Data = Graph(Con_11_0_7)
Con_11_0_7_Part = (range(1,11), range(11,22))
Con_11_0_7_Graph = BipartiteGraph(Con_11_0_7_Data, Con_11_0_7_Part)

Con_11_0_8_Data = Graph(Con_11_0_8)
Con_11_0_8_Part = (range(1,11), range(11,22))
Con_11_0_8_Graph = BipartiteGraph(Con_11_0_8_Data, Con_11_0_8_Part)

Con_11_0_9_Data = Graph(Con_11_0_9)
Con_11_0_9_Part = (range(1,11), range(11,22))
Con_11_0_9_Graph = BipartiteGraph(Con_11_0_9_Data, Con_11_0_9_Part)

Con_11_0_10_Data = Graph(Con_11_0_10)
Con_11_0_10_Part = (range(1,11), range(11,22))
Con_11_0_10_Graph = BipartiteGraph(Con_11_0_10_Data, Con_11_0_10_Part)

Con_11_0_11_Data = Graph(Con_11_0_11)
Con_11_0_11_Part = (range(1,11), range(11,22))
Con_11_0_11_Graph = BipartiteGraph(Con_11_0_11_Data, Con_11_0_11_Part)

Con_11_0_12_Data = Graph(Con_11_0_12)
Con_11_0_12_Part = (range(1,11), range(11,22))
Con_11_0_12_Graph = BipartiteGraph(Con_11_0_12_Data, Con_11_0_12_Part)

Con_11_0_13_Data = Graph(Con_11_0_13)
Con_11_0_13_Part = (range(1,11), range(11,22))
Con_11_0_13_Graph = BipartiteGraph(Con_11_0_13_Data, Con_11_0_13_Part)

Con_11_0_14_Data = Graph(Con_11_0_14)
Con_11_0_14_Part = (range(1,11), range(11,22))
Con_11_0_14_Graph = BipartiteGraph(Con_11_0_14_Data, Con_11_0_14_Part)

Con_11_0_15_Data = Graph(Con_11_0_15)
Con_11_0_15_Part = (range(1,11), range(11,22))
Con_11_0_15_Graph = BipartiteGraph(Con_11_0_15_Data, Con_11_0_15_Part)

Con_11_0_16_Data = Graph(Con_11_0_16)
Con_11_0_16_Part = (range(1,11), range(11,22))
Con_11_0_16_Graph = BipartiteGraph(Con_11_0_16_Data, Con_11_0_16_Part)

Con_11_0_17_Data = Graph(Con_11_0_17)
Con_11_0_17_Part = (range(1,11), range(11,22))
Con_11_0_17_Graph = BipartiteGraph(Con_11_0_17_Data, Con_11_0_17_Part)

Con_11_0_18_Data = Graph(Con_11_0_18)
Con_11_0_18_Part = (range(1,11), range(11,22))
Con_11_0_18_Graph = BipartiteGraph(Con_11_0_18_Data, Con_11_0_18_Part)

Con_11_0_19_Data = Graph(Con_11_0_19)
Con_11_0_19_Part = (range(1,11), range(11,22))
Con_11_0_19_Graph = BipartiteGraph(Con_11_0_19_Data, Con_11_0_19_Part)

Con_11_0_20_Data = Graph(Con_11_0_20)
Con_11_0_20_Part = (range(1,11), range(11,22))
Con_11_0_20_Graph = BipartiteGraph(Con_11_0_20_Data, Con_11_0_20_Part)

Con_11_0_21_Data = Graph(Con_11_0_21)
Con_11_0_21_Part = (range(1,11), range(11,22))
Con_11_0_21_Graph = BipartiteGraph(Con_11_0_21_Data, Con_11_0_21_Part)

Con_11_0_22_Data = Graph(Con_11_0_22)
Con_11_0_22_Part = (range(1,11), range(11,22))
Con_11_0_22_Graph = BipartiteGraph(Con_11_0_22_Data, Con_11_0_22_Part)

Con_11_0_23_Data = Graph(Con_11_0_23)
Con_11_0_23_Part = (range(1,11), range(11,22))
Con_11_0_23_Graph = BipartiteGraph(Con_11_0_23_Data, Con_11_0_23_Part)

Con_11_0_24_Data = Graph(Con_11_0_24)
Con_11_0_24_Part = (range(1,11), range(11,22))
Con_11_0_24_Graph = BipartiteGraph(Con_11_0_24_Data, Con_11_0_24_Part)

Con_11_0_25_Data = Graph(Con_11_0_25)
Con_11_0_25_Part = (range(1,11), range(11,22))
Con_11_0_25_Graph = BipartiteGraph(Con_11_0_25_Data, Con_11_0_25_Part)

Con_11_0_26_Data = Graph(Con_11_0_26)
Con_11_0_26_Part = (range(1,11), range(11,22))
Con_11_0_26_Graph = BipartiteGraph(Con_11_0_26_Data, Con_11_0_26_Part)

Con_11_0_27_Data = Graph(Con_11_0_27)
Con_11_0_27_Part = (range(1,11), range(11,22))
Con_11_0_27_Graph = BipartiteGraph(Con_11_0_27_Data, Con_11_0_27_Part)

Con_11_0_28_Data = Graph(Con_11_0_28)
Con_11_0_28_Part = (range(1,11), range(11,22))
Con_11_0_28_Graph = BipartiteGraph(Con_11_0_28_Data, Con_11_0_28_Part)

#Con_11_0_29_Data = Graph(Con_11_0_29)
#Con_11_0_29_Part = (range(1,11), range(11,22))
#Con_11_0_29_Graph = BipartiteGraph(Con_11_0_29_Data, Con_11_0_29_Part)

#Con_11_0_30_Data = Graph(Con_11_0_30)
#Con_11_0_30_Part = (range(1,11), range(11,22))
#Con_11_0_30_Graph = BipartiteGraph(Con_11_0_30_Data, Con_11_0_30_Part)

Con_11_0_31_Data = Graph(Con_11_0_31)
Con_11_0_31_Part = (range(1,11), range(11,22))
Con_11_0_31_Graph = BipartiteGraph(Con_11_0_31_Data, Con_11_0_31_Part)

Con_11_0_32_Data = Graph(Con_11_0_32)
Con_11_0_32_Part = (range(1,11), range(11,22))
Con_11_0_32_Graph = BipartiteGraph(Con_11_0_32_Data, Con_11_0_32_Part)

Con_11_0_33_Data = Graph(Con_11_0_33)
Con_11_0_33_Part = (range(1,11), range(11,22))
Con_11_0_33_Graph = BipartiteGraph(Con_11_0_33_Data, Con_11_0_33_Part)

Con_11_0_34_Data = Graph(Con_11_0_34)
Con_11_0_34_Part = (range(1,11), range(11,22))
Con_11_0_34_Graph = BipartiteGraph(Con_11_0_34_Data, Con_11_0_34_Part)

#Con_11_0_35_Data = Graph(Con_11_0_35)
#Con_11_0_35_Part = (range(1,11), range(11,22))
#Con_11_0_35_Graph = BipartiteGraph(Con_11_0_35_Data, Con_11_0_35_Part)

#Con_11_0_36_Data = Graph(Con_11_0_36)
#Con_11_0_36_Part = (range(1,11), range(11,22))
#Con_11_0_36_Graph = BipartiteGraph(Con_11_0_36_Data, Con_11_0_36_Part)

#Con_11_0_37_Data = Graph(Con_11_0_37)
#Con_11_0_37_Part = (range(1,11), range(11,22))
#Con_11_0_37_Graph = BipartiteGraph(Con_11_0_37_Data, Con_11_0_37_Part)

#Con_11_0_38_Data = Graph(Con_11_0_38)
#Con_11_0_38_Part = (range(1,11), range(11,22))
#Con_11_0_38_Graph = BipartiteGraph(Con_11_0_38_Data, Con_11_0_38_Part)

#Con_11_0_39_Data = Graph(Con_11_0_39)
#Con_11_0_39_Part = (range(1,11), range(11,22))
#Con_11_0_39_Graph = BipartiteGraph(Con_11_0_39_Data, Con_11_0_39_Part)

Con_11_0_40_Data = Graph(Con_11_0_40)
Con_11_0_40_Part = (range(1,11), range(11,22))
Con_11_0_40_Graph = BipartiteGraph(Con_11_0_40_Data, Con_11_0_40_Part)

Con_11_0_41_Data = Graph(Con_11_0_41)
Con_11_0_41_Part = (range(1,11), range(11,22))
Con_11_0_41_Graph = BipartiteGraph(Con_11_0_41_Data, Con_11_0_41_Part)

#Con_11_0_42_Data = Graph(Con_11_0_42)
#Con_11_0_42_Part = (range(1,11), range(11,22))
#Con_11_0_42_Graph = BipartiteGraph(Con_11_0_42_Data, Con_11_0_42_Part)

#Con_11_0_43_Data = Graph(Con_11_0_43)
#Con_11_0_43_Part = (range(1,11), range(11,22))
#Con_11_0_43_Graph = BipartiteGraph(Con_11_0_43_Data, Con_11_0_43_Part)

Con_11_0_1_Graph.name("Con-11-0 #1")
Con_11_0_2_Graph.name("Con-11-0 #2")
Con_11_0_3_Graph.name("Con-11-0 #3")
Con_11_0_4_Graph.name("Con-11-0 #4")
Con_11_0_5_Graph.name("Con-11-0 #5")
Con_11_0_6_Graph.name("Con-11-0 #6")
Con_11_0_7_Graph.name("Con-11-0 #7")
Con_11_0_8_Graph.name("Con-11-0 #8")
Con_11_0_9_Graph.name("Con-11-0 #9")
Con_11_0_10_Graph.name("Con-11-0 #10")
Con_11_0_11_Graph.name("Con-11-0 #11")
Con_11_0_12_Graph.name("Con-11-0 #12")
Con_11_0_13_Graph.name("Con-11-0 #13")
Con_11_0_14_Graph.name("Con-11-0 #14")
Con_11_0_15_Graph.name("Con-11-0 #15")
Con_11_0_16_Graph.name("Con-11-0 #16")
Con_11_0_17_Graph.name("Con-11-0 #17")
Con_11_0_18_Graph.name("Con-11-0 #18")
Con_11_0_19_Graph.name("Con-11-0 #19")
Con_11_0_20_Graph.name("Con-11-0 #20")
Con_11_0_21_Graph.name("Con-11-0 #21")
Con_11_0_22_Graph.name("Con-11-0 #22")
Con_11_0_23_Graph.name("Con-11-0 #23")
Con_11_0_24_Graph.name("Con-11-0 #24")
Con_11_0_25_Graph.name("Con-11-0 #25")
Con_11_0_26_Graph.name("Con-11-0 #26")
Con_11_0_27_Graph.name("Con-11-0 #27")
Con_11_0_28_Graph.name("Con-11-0 #28")
#Con_11_0_29_Graph.name("Con-11-0 #29")
#Con_11_0_30_Graph.name("Con-11-0 #30")
Con_11_0_31_Graph.name("Con-11-0 #31")
Con_11_0_32_Graph.name("Con-11-0 #32")
Con_11_0_33_Graph.name("Con-11-0 #33")
Con_11_0_34_Graph.name("Con-11-0 #34")
#Con_11_0_35_Graph.name("Con-11-0 #35")
#Con_11_0_36_Graph.name("Con-11-0 #36")
#Con_11_0_37_Graph.name("Con-11-0 #37")
#Con_11_0_38_Graph.name("Con-11-0 #38")
#Con_11_0_39_Graph.name("Con-11-0 #39")
Con_11_0_40_Graph.name("Con-11-0 #40")
Con_11_0_41_Graph.name("Con-11-0 #41")
#Con_11_0_42_Graph.name("Con-11-0 #42")
#Con_11_0_43_Graph.name("Con-11-0 #43")

Con_11_0_List = [Con_11_0_1_Graph, Con_11_0_2_Graph,
 Con_11_0_3_Graph, Con_11_0_4_Graph, Con_11_0_5_Graph, Con_11_0_6_Graph, Con_11_0_7_Graph, Con_11_0_8_Graph, Con_11_0_9_Graph, Con_11_0_10_Graph, Con_11_0_11_Graph, Con_11_0_12_Graph, Con_11_0_13_Graph, Con_11_0_14_Graph, Con_11_0_15_Graph, Con_11_0_16_Graph, Con_11_0_17_Graph, Con_11_0_18_Graph, Con_11_0_19_Graph, Con_11_0_20_Graph, Con_11_0_21_Graph, Con_11_0_22_Graph, Con_11_0_23_Graph, Con_11_0_24_Graph, Con_11_0_25_Graph, Con_11_0_26_Graph, Con_11_0_27_Graph, Con_11_0_28_Graph, Con_11_0_31_Graph, Con_11_0_32_Graph, Con_11_0_33_Graph, Con_11_0_34_Graph, Con_11_0_40_Graph, Con_11_0_41_Graph]


Con_11_1_U_1_Graph = BipartiteGraph(Graph(Con_11_1_U_1),(range(1,11),range(11,22)))
Con_11_1_U_2_Graph = BipartiteGraph(Graph(Con_11_1_U_2),(range(1,11),range(11,22)))
Con_11_1_U_3_Graph = BipartiteGraph(Graph(Con_11_1_U_3),(range(1,11),range(11,22)))
Con_11_1_U_4_Graph = BipartiteGraph(Graph(Con_11_1_U_4),(range(1,11),range(11,22)))
Con_11_1_U_5_Graph = BipartiteGraph(Graph(Con_11_1_U_5),(range(1,11),range(11,22)))

Con_11_1_U_1_Graph.name('Con-11-1 Unreachable #1')
Con_11_1_U_2_Graph.name('Con-11-1 Unreachable #2')
Con_11_1_U_3_Graph.name('Con-11-1 Unreachable #3')
Con_11_1_U_4_Graph.name('Con-11-1 Unreachable #4')
Con_11_1_U_5_Graph.name('Con-11-1 Unreachable #5')


Con_11_1_U_List = [Con_11_1_U_1_Graph, Con_11_1_U_2_Graph,Con_11_1_U_3_Graph,Con_11_1_U_4_Graph,Con_11_1_U_5_Graph]


Con_12_0_R_1 = {1: [11, 12, 13, 14],
                2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 12], 6: [16, 20, 13], 7: [17, 21, 22, 13], 8: [19, 22, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 8], 20: [3, 6, 9], 21: [10, 7, 9], 22: [4, 7, 8]}
Con_12_0_R_2 = {1: [11, 12, 13, 14],
                2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 12], 6: [16, 21, 13], 7: [17, 22, 20, 13], 8: [19, 22, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 8], 20: [3, 7, 9], 21: [10, 6, 9], 22: [4, 7, 8]}
Con_12_0_R_3 = {1: [11, 12, 13, 14],
                2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 12], 6: [16, 20, 13], 7: [17, 21, 22, 13], 8: [22, 20, 14, 15], 9: [19, 21, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 9], 20: [3, 6, 8], 21: [10, 7, 9], 22: [4, 7, 8]}
Con_12_0_R_4 = {1: [11, 12, 13, 14],
                2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 21, 12], 6: [16, 19, 13], 7: [17, 22, 20, 13], 8: [19, 22, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 5, 9], 22: [4, 7, 8]}
Con_12_0_R_5 = {1: [11, 12, 13, 14],
                2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 19, 12], 5: [17, 18, 22, 12], 6: [16, 20, 13], 7: [19, 21, 22, 13], 8: [22, 20, 14, 15], 9: [17, 21, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 9], 18: [10, 3, 5], 19: [3, 4, 7], 20: [3, 6, 8], 21: [10, 7, 9], 22: [5, 7, 8]}
Con_12_0_R_6 = {1: [11, 12, 13, 14],
                2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 22, 12, 15], 5: [17, 21, 11], 6: [18, 19, 12], 7: [17, 19, 22, 13], 8: [16, 20, 13], 9: [18, 22, 20, 14], 10: [16, 21, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 7], 18: [2, 6, 9], 19: [3, 6, 7], 20: [3, 8, 9], 21: [10, 4, 5], 22: [4, 7, 9]}
Con_12_0_R_7 = {1: [11, 12, 13, 14],
                2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 22, 12, 15], 5: [17, 21, 11], 6: [18, 19, 12], 7: [17, 20, 13], 8: [16, 19, 22, 13], 9: [18, 22, 20, 14], 10: [16, 21, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 7], 18: [2, 6, 9], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 4, 5], 22: [4, 8, 9]}
Con_12_0_R_8 = {1: [11, 12, 13, 14],
                2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 12, 15], 5: [17, 21, 11], 6: [18, 19, 22, 12], 7: [17, 22, 20, 13], 8: [16, 19, 13], 9: [18, 20, 14], 10: [16, 21, 22, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 7], 18: [2, 6, 9], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 4, 5], 22: [10, 6, 7]}
Con_12_0_R_9 = {1: [11, 12, 13, 14],
                2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 12, 15], 5: [17, 21, 22, 11], 6: [18, 19, 22, 12], 7: [17, 20, 13], 8: [16, 19, 13], 9: [18, 21, 14], 10: [16, 22, 20, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 7], 18: [2, 6, 9], 19: [3, 6, 8], 20: [10, 3, 7], 21: [4, 5, 9], 22: [10, 5, 6]}
Con_12_0_R_10 = {1: [11, 12, 13, 14],
                 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 22, 20, 11], 6: [18, 21, 22, 12], 7: [16, 21, 13], 8: [17, 19, 13], 9: [16, 19, 22, 14], 10: [18, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [10, 3, 6], 19: [3, 8, 9], 20: [10, 4, 5], 21: [4, 6, 7], 22: [5, 6, 9]}
Con_12_0_R_11 = {1: [11, 12, 13, 14],
                 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 22, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 21, 13], 8: [17, 19, 22, 13], 9: [16, 18, 22, 14], 10: [19, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 9], 19: [10, 3, 8], 20: [10, 4, 5], 21: [4, 6, 7], 22: [4, 8, 9]}
Con_12_0_R_12 = {1: [11, 12, 13, 14],
                 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 22, 20, 11], 6: [18, 21, 22, 12], 7: [16, 19, 22, 13], 8: [17, 18, 13], 9: [16, 21, 14], 10: [19, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 8], 19: [10, 3, 7], 20: [10, 4, 5], 21: [4, 6, 9], 22: [5, 6, 7]}
Con_12_0_R_13 = {1: [11, 12, 13, 14],
                 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 22, 20, 11], 6: [18, 21, 22, 12], 7: [16, 19, 22, 13], 8: [17, 18, 13], 9: [16, 20, 14], 10: [19, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 8], 19: [10, 3, 7], 20: [4, 5, 9], 21: [10, 4, 6], 22: [5, 6, 7]}
Con_12_0_R_14 = {1: [11, 12, 13, 14],
                 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 22, 20, 15], 5: [17, 20, 11], 6: [18, 20, 12], 7: [16, 21, 13], 8: [17, 19, 22, 13], 9: [16, 18, 22, 14], 10: [19, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 9], 19: [10, 3, 8], 20: [4, 5, 6], 21: [10, 4, 7], 22: [4, 8, 9]}
Con_12_0_R_15 = {1: [11, 12, 13, 14],
                 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [22, 20, 13, 15], 5: [16, 21, 22, 12], 6: [18, 20, 11], 7: [16, 19, 13], 8: [17, 18, 22, 14], 9: [19, 21, 14], 10: [17, 21, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 8], 19: [3, 7, 9], 20: [10, 4, 6], 21: [10, 5, 9], 22: [4, 5, 8]}
Con_12_0_R_16 = {1: [11, 12, 13, 14],
                 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [22, 20, 13, 15], 5: [16, 21, 22, 12], 6: [18, 20, 11], 7: [16, 19, 13], 8: [17, 19, 22, 14], 9: [18, 21, 14], 10: [17, 21, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 9], 19: [3, 7, 8], 20: [10, 4, 6], 21: [10, 5, 9], 22: [4, 5, 8]}
Con_12_0_R_17 = {1: [11, 12, 13, 14],
                 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [22, 20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 22, 11], 7: [16, 19, 13], 8: [17, 19, 22, 14], 9: [18, 20, 14], 10: [17, 21, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 9], 19: [3, 7, 8], 20: [10, 4, 9], 21: [10, 5, 6], 22: [4, 6, 8]}
Con_12_0_R_18 = {1: [11, 12, 13, 14],
                 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [22, 20, 13, 15], 5: [16, 21, 22, 12], 6: [18, 21, 11], 7: [17, 19, 13], 8: [16, 20, 14], 9: [17, 18, 22, 14], 10: [19, 21, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [2, 7, 9], 18: [3, 6, 9], 19: [10, 3, 7], 20: [10, 4, 8], 21: [10, 5, 6], 22: [4, 5, 9]}

Con_12_0_R_1_Graph = BipartiteGraph(Graph(Con_12_0_R_1),(range(1,11),range(11,23)))
Con_12_0_R_2_Graph = BipartiteGraph(Graph(Con_12_0_R_2),(range(1,11),range(11,23)))
Con_12_0_R_3_Graph = BipartiteGraph(Graph(Con_12_0_R_3),(range(1,11),range(11,23)))
Con_12_0_R_4_Graph = BipartiteGraph(Graph(Con_12_0_R_4),(range(1,11),range(11,23)))
Con_12_0_R_5_Graph = BipartiteGraph(Graph(Con_12_0_R_5),(range(1,11),range(11,23)))
Con_12_0_R_6_Graph = BipartiteGraph(Graph(Con_12_0_R_6),(range(1,11),range(11,23)))
Con_12_0_R_7_Graph = BipartiteGraph(Graph(Con_12_0_R_7),(range(1,11),range(11,23)))
Con_12_0_R_8_Graph = BipartiteGraph(Graph(Con_12_0_R_8),(range(1,11),range(11,23)))
Con_12_0_R_9_Graph = BipartiteGraph(Graph(Con_12_0_R_9),(range(1,11),range(11,23)))
Con_12_0_R_10_Graph = BipartiteGraph(Graph(Con_12_0_R_10),(range(1,11),range(11,23)))
Con_12_0_R_11_Graph = BipartiteGraph(Graph(Con_12_0_R_11),(range(1,11),range(11,23)))
Con_12_0_R_12_Graph = BipartiteGraph(Graph(Con_12_0_R_12),(range(1,11),range(11,23)))
Con_12_0_R_13_Graph = BipartiteGraph(Graph(Con_12_0_R_13),(range(1,11),range(11,23)))
Con_12_0_R_14_Graph = BipartiteGraph(Graph(Con_12_0_R_14),(range(1,11),range(11,23)))
Con_12_0_R_15_Graph = BipartiteGraph(Graph(Con_12_0_R_15),(range(1,11),range(11,23)))
Con_12_0_R_16_Graph = BipartiteGraph(Graph(Con_12_0_R_16),(range(1,11),range(11,23)))
Con_12_0_R_17_Graph = BipartiteGraph(Graph(Con_12_0_R_17),(range(1,11),range(11,23)))
Con_12_0_R_18_Graph = BipartiteGraph(Graph(Con_12_0_R_18),(range(1,11),range(11,23)))


Con_12_0_R_1_Graph.name("Con-12-0 Reachable #1")
Con_12_0_R_2_Graph.name("Con-12-0 Reachable #2")
Con_12_0_R_3_Graph.name("Con-12-0 Reachable #3")
Con_12_0_R_4_Graph.name("Con-12-0 Reachable #4")
Con_12_0_R_5_Graph.name("Con-12-0 Reachable #5")
Con_12_0_R_6_Graph.name("Con-12-0 Reachable #6")
Con_12_0_R_7_Graph.name("Con-12-0 Reachable #7")
Con_12_0_R_8_Graph.name("Con-12-0 Reachable #8")
Con_12_0_R_9_Graph.name("Con-12-0 Reachable #9")
Con_12_0_R_10_Graph.name("Con-12-0 Reachable #10")
Con_12_0_R_11_Graph.name("Con-12-0 Reachable #11")
Con_12_0_R_12_Graph.name("Con-12-0 Reachable #12")
Con_12_0_R_13_Graph.name("Con-12-0 Reachable #13")
Con_12_0_R_14_Graph.name("Con-12-0 Reachable #14")
Con_12_0_R_15_Graph.name("Con-12-0 Reachable #15")
Con_12_0_R_16_Graph.name("Con-12-0 Reachable #16")
Con_12_0_R_17_Graph.name("Con-12-0 Reachable #17")
Con_12_0_R_18_Graph.name("Con-12-0 Reachable #18")


Con_12_0_R_List = [Con_12_0_R_1_Graph, Con_12_0_R_2_Graph, Con_12_0_R_3_Graph, Con_12_0_R_4_Graph, Con_12_0_R_5_Graph, Con_12_0_R_6_Graph, Con_12_0_R_7_Graph, Con_12_0_R_8_Graph, Con_12_0_R_9_Graph, Con_12_0_R_10_Graph, Con_12_0_R_11_Graph, Con_12_0_R_12_Graph, Con_12_0_R_13_Graph, Con_12_0_R_14_Graph, Con_12_0_R_15_Graph, Con_12_0_R_16_Graph, Con_12_0_R_17_Graph, Con_12_0_R_18_Graph]

Con_12_0_List= Con_12_0_R_List + Con_12_0_U_List


Con_13_0_1 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 23, 12], 6: [16, 23, 20, 13], 7: [17, 21, 22, 13], 8: [19, 22, 14, 15], 9: [21, 20, 14], 10: [18, 21, 23, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 8], 20: [3, 6, 9], 21: [10, 7, 9], 22: [4, 7, 8], 23: [10, 5, 6]}
Con_13_0_2 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 23, 12], 6: [16, 23, 20, 13], 7: [17, 21, 22, 13], 8: [22, 20, 14, 15], 9: [19, 21, 14], 10: [18, 21, 23, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 9], 20: [3, 6, 8], 21: [10, 7, 9], 22: [4, 7, 8], 23: [10, 5, 6]}




Con_13_0_1_Graph = BipartiteGraph(Graph(Con_13_0_1),(range(1,11),range(11,24)))
Con_13_0_2_Graph = BipartiteGraph(Graph(Con_13_0_2),(range(1,11),range(11,24)))

Con_13_0_1_Graph.name("Con-13-0 #1")
Con_13_0_2_Graph.name("Con-13-0 #2")

Con_13_0_List = [Con_13_0_1_Graph, Con_13_0_2_Graph]


Con_11_1_R_1 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 12], 5: [17, 19, 12], 6: [16, 19, 21, 13], 7: [17, 20, 13], 8: [19, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 6, 8], 20: [3, 7, 9], 21: [10, 6, 9]}
Con_11_1_R_2 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 12], 5: [17, 19, 21, 12], 6: [16, 21, 13], 7: [17, 20, 13], 8: [19, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 8], 20: [3, 7, 9], 21: [10, 5, 6, 9]}
Con_11_1_R_3 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 12], 5: [17, 19, 12], 6: [16, 20, 13], 7: [17, 21, 13], 8: [20, 14, 15], 9: [16, 19, 21, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6, 9], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 9], 20: [3, 6, 8], 21: [10, 7, 9]}
Con_11_1_R_4 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 12], 5: [17, 21, 12], 6: [16, 19, 13], 7: [17, 20, 13], 8: [19, 14, 15], 9: [21, 20, 14], 10: [18, 21, 13, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [10, 1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 5, 9]}
Con_11_1_R_5 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 12], 5: [17, 21, 12], 6: [16, 19, 21, 13], 7: [17, 20, 13], 8: [19, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 5, 6, 9]}
Con_11_1_R_6 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 19, 12], 5: [17, 20, 12], 6: [16, 18, 13], 7: [19, 21, 13], 8: [20, 14, 15], 9: [17, 21, 14], 10: [18, 21, 12, 15], 11: [1, 2, 3], 12: [10, 1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 9], 18: [10, 3, 6], 19: [3, 4, 7], 20: [3, 5, 8], 21: [10, 7, 9]}
Con_11_1_R_7 = {1: [11, 12, 13, 14],
 2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 12, 15], 5: [17, 21, 11], 6: [17, 19, 12], 7: [18, 19, 13], 8: [16, 20, 13], 9: [18, 20, 14], 10: [16, 19, 21, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 6], 18: [2, 7, 9], 19: [10, 3, 6, 7], 20: [3, 8, 9], 21: [10, 4, 5]}
Con_11_1_R_8 = {1: [11, 12, 13, 14],
 2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 12, 15], 5: [17, 21, 11], 6: [17, 19, 12], 7: [18, 19, 21, 13], 8: [16, 20, 13], 9: [18, 20, 14], 10: [16, 21, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 6], 18: [2, 7, 9], 19: [3, 6, 7], 20: [3, 8, 9], 21: [10, 4, 5, 7]}
Con_11_1_R_9 = {1: [11, 12, 13, 14],
 2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 12, 15], 5: [17, 21, 11], 6: [18, 19, 12], 7: [17, 19, 13], 8: [16, 20, 13], 9: [18, 20, 14], 10: [16, 19, 21, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 7], 18: [2, 6, 9], 19: [10, 3, 6, 7], 20: [3, 8, 9], 21: [10, 4, 5]}
Con_11_1_R_10 = {1: [11, 12, 13, 14],
 2: [16, 17, 18, 15], 3: [19, 20, 11, 15], 4: [21, 12, 15], 5: [17, 21, 11], 6: [18, 19, 12], 7: [17, 20, 13], 8: [16, 19, 21, 13], 9: [18, 21, 14], 10: [16, 20, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 7], 18: [2, 6, 9], 19: [3, 6, 8], 20: [10, 3, 7], 21: [4, 5, 8, 9]}
Con_11_1_R_11 = {1: [11, 12, 13, 14],
 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 18, 20, 13], 8: [17, 19, 13], 9: [16, 21, 14], 10: [19, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 7], 19: [10, 3, 8], 20: [10, 4, 5, 7], 21: [4, 6, 9]}
Con_11_1_R_12 = {1: [11, 12, 13, 14],
 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 19, 13], 8: [17, 18, 13], 9: [16, 20, 14], 10: [17, 19, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [10, 2, 5, 8], 18: [3, 6, 8], 19: [10, 3, 7], 20: [4, 5, 9], 21: [10, 4, 6]}
Con_11_1_R_13 = {1: [11, 12, 13, 14],
 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 20, 12], 7: [16, 21, 13], 8: [17, 19, 13], 9: [16, 19, 14], 10: [17, 18, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [10, 2, 5, 8], 18: [10, 3, 6], 19: [3, 8, 9], 20: [4, 5, 6], 21: [10, 4, 7]}
Con_11_1_R_14 = {1: [11, 12, 13, 14],
 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 20, 12], 7: [16, 21, 13], 8: [17, 19, 13], 9: [16, 19, 20, 14], 10: [18, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [10, 3, 6], 19: [3, 8, 9], 20: [4, 5, 6, 9], 21: [10, 4, 7]}
Con_11_1_R_15 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 21, 20, 11], 7: [16, 21, 13], 8: [17, 18, 14], 9: [19, 20, 14], 10: [17, 19, 21], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 8], 19: [10, 3, 9], 20: [4, 5, 6, 9], 21: [10, 6, 7]}
Con_11_1_R_16 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 11], 7: [16, 19, 13], 8: [17, 19, 14], 9: [16, 18, 20, 14], 10: [17, 21, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7, 9], 17: [10, 2, 8], 18: [3, 6, 9], 19: [3, 7, 8], 20: [10, 4, 9], 21: [10, 5, 6]}
Con_11_1_R_17 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 20, 12], 6: [18, 20, 11], 7: [16, 19, 13], 8: [17, 20, 14], 9: [18, 21, 14], 10: [17, 19, 21], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 9], 19: [10, 3, 7], 20: [4, 5, 6, 8], 21: [10, 5, 9]}
Con_11_1_R_18 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [21, 20, 13, 15], 5: [16, 21, 12], 6: [18, 20, 11], 7: [16, 19, 13], 8: [17, 20, 14], 9: [18, 21, 14], 10: [17, 19, 21], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 9], 19: [10, 3, 7], 20: [4, 6, 8], 21: [10, 4, 5, 9]}
Con_11_1_R_19 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 20, 12], 6: [18, 21, 11], 7: [16, 19, 13], 8: [17, 21, 14], 9: [18, 20, 14], 10: [17, 19, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 9], 19: [10, 3, 7], 20: [10, 4, 5, 9], 21: [5, 6, 8]}
Con_11_1_R_20 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [21, 20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 11], 7: [16, 19, 13], 8: [17, 21, 14], 9: [18, 20, 14], 10: [17, 19, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7], 17: [10, 2, 8], 18: [3, 6, 9], 19: [10, 3, 7], 20: [10, 4, 9], 21: [4, 5, 6, 8]}
Con_11_1_R_21 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 21, 11], 7: [17, 19, 13], 8: [16, 21, 14], 9: [17, 18, 20, 14], 10: [19, 21, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [2, 7, 9], 18: [3, 6, 9], 19: [10, 3, 7], 20: [10, 4, 5, 9], 21: [10, 6, 8]}
Con_11_1_R_22 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 20, 12], 6: [18, 20, 11], 7: [17, 21, 13], 8: [16, 19, 14], 9: [18, 21, 14], 10: [17, 19, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 7], 18: [3, 6, 9], 19: [10, 3, 8], 20: [10, 4, 5, 6], 21: [5, 7, 9]}
Con_11_1_R_23 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 21, 20, 12], 6: [18, 21, 11], 7: [17, 21, 13], 8: [16, 19, 14], 9: [18, 20, 14], 10: [17, 19, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 7], 18: [3, 6, 9], 19: [10, 3, 8], 20: [10, 4, 5, 9], 21: [5, 6, 7]}
Con_11_1_R_24 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [20, 13, 15], 5: [16, 20, 12], 6: [18, 20, 11], 7: [19, 21, 13], 8: [16, 21, 14], 9: [17, 19, 20, 14], 10: [17, 18, 21], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 8], 17: [10, 2, 9], 18: [10, 3, 6], 19: [3, 7, 9], 20: [4, 5, 6, 9], 21: [10, 7, 8]}

Con_11_1_R_1_Graph = BipartiteGraph(Graph(Con_11_1_R_1), (range(1,11), range(11,22)))
Con_11_1_R_2_Graph = BipartiteGraph(Graph(Con_11_1_R_2), (range(1,11), range(11,22)))
Con_11_1_R_3_Graph = BipartiteGraph(Graph(Con_11_1_R_3), (range(1,11), range(11,22)))
Con_11_1_R_4_Graph = BipartiteGraph(Graph(Con_11_1_R_4), (range(1,11), range(11,22)))
Con_11_1_R_5_Graph = BipartiteGraph(Graph(Con_11_1_R_5), (range(1,11), range(11,22)))
Con_11_1_R_6_Graph = BipartiteGraph(Graph(Con_11_1_R_6), (range(1,11), range(11,22)))
Con_11_1_R_7_Graph = BipartiteGraph(Graph(Con_11_1_R_7), (range(1,11), range(11,22)))
Con_11_1_R_8_Graph = BipartiteGraph(Graph(Con_11_1_R_8), (range(1,11), range(11,22)))
Con_11_1_R_9_Graph = BipartiteGraph(Graph(Con_11_1_R_9), (range(1,11), range(11,22)))
Con_11_1_R_10_Graph = BipartiteGraph(Graph(Con_11_1_R_10), (range(1,11), range(11,22)))
Con_11_1_R_11_Graph = BipartiteGraph(Graph(Con_11_1_R_11), (range(1,11), range(11,22)))
Con_11_1_R_12_Graph = BipartiteGraph(Graph(Con_11_1_R_12), (range(1,11), range(11,22)))
Con_11_1_R_13_Graph = BipartiteGraph(Graph(Con_11_1_R_13), (range(1,11), range(11,22)))
Con_11_1_R_14_Graph = BipartiteGraph(Graph(Con_11_1_R_14), (range(1,11), range(11,22)))
Con_11_1_R_15_Graph = BipartiteGraph(Graph(Con_11_1_R_15), (range(1,11), range(11,22)))
Con_11_1_R_16_Graph = BipartiteGraph(Graph(Con_11_1_R_16), (range(1,11), range(11,22)))
Con_11_1_R_17_Graph = BipartiteGraph(Graph(Con_11_1_R_17), (range(1,11), range(11,22)))
Con_11_1_R_18_Graph = BipartiteGraph(Graph(Con_11_1_R_18), (range(1,11), range(11,22)))
Con_11_1_R_19_Graph = BipartiteGraph(Graph(Con_11_1_R_19), (range(1,11), range(11,22)))
Con_11_1_R_20_Graph = BipartiteGraph(Graph(Con_11_1_R_20), (range(1,11), range(11,22)))
Con_11_1_R_21_Graph = BipartiteGraph(Graph(Con_11_1_R_21), (range(1,11), range(11,22)))
Con_11_1_R_22_Graph = BipartiteGraph(Graph(Con_11_1_R_22), (range(1,11), range(11,22)))
Con_11_1_R_23_Graph = BipartiteGraph(Graph(Con_11_1_R_23), (range(1,11), range(11,22)))
Con_11_1_R_24_Graph = BipartiteGraph(Graph(Con_11_1_R_24), (range(1,11), range(11,22)))

Con_11_1_R_1_Graph.name("Con-11-1 R. #1")
Con_11_1_R_2_Graph.name("Con-11-1 R. #2")
Con_11_1_R_3_Graph.name("Con-11-1 R. #3")
Con_11_1_R_4_Graph.name("Con-11-1 R. #4")
Con_11_1_R_5_Graph.name("Con-11-1 R. #5")
Con_11_1_R_6_Graph.name("Con-11-1 R. #6")
Con_11_1_R_7_Graph.name("Con-11-1 R. #7")
Con_11_1_R_8_Graph.name("Con-11-1 R. #8")
Con_11_1_R_9_Graph.name("Con-11-1 R. #9")
Con_11_1_R_10_Graph.name("Con-11-1 R. #10")
Con_11_1_R_11_Graph.name("Con-11-1 R. #11")
Con_11_1_R_12_Graph.name("Con-11-1 R. #12")
Con_11_1_R_13_Graph.name("Con-11-1 R. #13")
Con_11_1_R_14_Graph.name("Con-11-1 R. #14")
Con_11_1_R_15_Graph.name("Con-11-1 R. #15")
Con_11_1_R_16_Graph.name("Con-11-1 R. #16")
Con_11_1_R_17_Graph.name("Con-11-1 R. #17")
Con_11_1_R_18_Graph.name("Con-11-1 R. #18")
Con_11_1_R_19_Graph.name("Con-11-1 R. #19")
Con_11_1_R_20_Graph.name("Con-11-1 R. #20")
Con_11_1_R_21_Graph.name("Con-11-1 R. #21")
Con_11_1_R_22_Graph.name("Con-11-1 R. #22")
Con_11_1_R_23_Graph.name("Con-11-1 R. #23")
Con_11_1_R_24_Graph.name("Con-11-1 R. #24")

Con_11_1_R_List = [Con_11_1_R_1_Graph, Con_11_1_R_2_Graph, Con_11_1_R_3_Graph, Con_11_1_R_4_Graph, Con_11_1_R_5_Graph, Con_11_1_R_6_Graph, Con_11_1_R_7_Graph, Con_11_1_R_8_Graph, Con_11_1_R_9_Graph, Con_11_1_R_10_Graph, Con_11_1_R_11_Graph, Con_11_1_R_12_Graph, Con_11_1_R_13_Graph, Con_11_1_R_14_Graph, Con_11_1_R_15_Graph, Con_11_1_R_16_Graph, Con_11_1_R_17_Graph, Con_11_1_R_18_Graph, Con_11_1_R_19_Graph, Con_11_1_R_20_Graph, Con_11_1_R_21_Graph, Con_11_1_R_22_Graph, Con_11_1_R_23_Graph, Con_11_1_R_24_Graph]
Con_11_1_List = Con_11_1_U_List + Con_11_1_R_List


Con_11_2_1 = {1: [11, 12, 13, 14], 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 12], 5: [17, 21, 12], 6: [16, 19, 13], 7: [17, 20, 13], 8: [19, 14, 15], 9: [16, 21, 20, 14], 10: [18, 21, 13, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [10, 1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6, 9], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 5, 9]}
Con_11_2_2 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 21, 12], 7: [16, 18, 20, 13], 8: [17, 19, 21, 13], 9: [16, 21, 14], 10: [19, 20, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [2, 5, 8], 18: [3, 6, 7], 19: [10, 3, 8], 20: [10, 4, 5, 7], 21: [4, 6, 8, 9]}
Con_11_2_3 = {1: [11, 12, 13, 14], 2: [16, 17, 12, 15], 3: [18, 19, 11, 15], 4: [21, 20, 15], 5: [17, 20, 11], 6: [18, 20, 12], 7: [16, 21, 13], 8: [17, 19, 13], 9: [16, 19, 20, 14], 10: [17, 18, 21, 14], 11: [1, 3, 5], 12: [1, 2, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [2, 7, 9], 17: [10, 2, 5, 8], 18: [10, 3, 6], 19: [3, 8, 9], 20: [4, 5, 6, 9], 21: [10, 4, 7]}

Con_11_2_1_Graph = BipartiteGraph(Graph(Con_11_2_1), (range(1,11), range(11,22)))
Con_11_2_2_Graph = BipartiteGraph(Graph(Con_11_2_2), (range(1,11), range(11,22)))
Con_11_2_3_Graph = BipartiteGraph(Graph(Con_11_2_3), (range(1,11), range(11,22)))

Con_11_2_1_Graph.name("Con-11-2 #1")
Con_11_2_2_Graph.name("Con-11-2 #2")
Con_11_2_3_Graph.name("Con-11-2 #3")

Con_11_2_List = [Con_11_2_1_Graph, Con_11_2_2_Graph, Con_11_2_3_Graph]


Con_12_1_1 = {1: [11, 12, 13],
 2: [11, 14, 15], 3: [16, 17, 22, 11], 4: [18, 19, 11], 5: [17, 19, 20, 15], 6: [16, 18, 20, 13], 7: [22, 20, 12, 14], 8: [16, 19, 21, 14], 9: [17, 18, 21, 12], 10: [21, 22, 13, 15], 11: [1, 2, 3, 4], 12: [1, 7, 9], 13: [10, 1, 6], 14: [2, 7, 8], 15: [10, 2, 5], 16: [3, 6, 8], 17: [3, 5, 9], 18: [4, 6, 9], 19: [4, 5, 8], 20: [5, 6, 7], 21: [10, 8, 9], 22: [10, 3, 7]}
Con_12_1_2 = {1: [11, 12, 13],
 2: [11, 14, 15], 3: [16, 17, 11], 4: [18, 19, 22, 11], 5: [17, 19, 20, 15], 6: [16, 18, 20, 13], 7: [22, 20, 12, 14], 8: [16, 19, 21, 14], 9: [17, 18, 21, 12], 10: [21, 22, 13, 15], 11: [1, 2, 3, 4], 12: [1, 7, 9], 13: [10, 1, 6], 14: [2, 7, 8], 15: [10, 2, 5], 16: [3, 6, 8], 17: [3, 5, 9], 18: [4, 6, 9], 19: [4, 5, 8], 20: [5, 6, 7], 21: [10, 8, 9], 22: [10, 4, 7]}
Con_12_1_3 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 12], 6: [16, 19, 21, 13], 7: [17, 22, 20, 13], 8: [19, 22, 14, 15], 9: [21, 20, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 6, 8], 20: [3, 7, 9], 21: [10, 6, 9], 22: [4, 7, 8]}
Con_12_1_4 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 12], 6: [16, 20, 13], 7: [17, 21, 22, 13], 8: [22, 20, 14, 15], 9: [16, 19, 21, 14], 10: [18, 21, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6, 9], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 9], 20: [3, 6, 8], 21: [10, 7, 9], 22: [4, 7, 8]}
Con_12_1_5 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 21, 12], 6: [16, 19, 13], 7: [17, 22, 20, 13], 8: [19, 22, 14, 15], 9: [21, 20, 14], 10: [18, 21, 13, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [10, 1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 5, 9], 22: [4, 7, 8]}
Con_12_1_6 = {1: [11, 12, 13, 14],
 2: [16, 17, 18, 15],
 3: [19, 20, 11, 15], 4: [21, 12, 15], 5: [17, 21, 22, 11], 6: [18, 19, 22, 12], 7: [17, 20, 13], 8: [16, 19, 21, 13], 9: [18, 21, 14], 10: [16, 22, 20, 14], 11: [1, 3, 5], 12: [1, 4, 6], 13: [1, 7, 8], 14: [10, 1, 9], 15: [2, 3, 4], 16: [10, 2, 8], 17: [2, 5, 7], 18: [2, 6, 9], 19: [3, 6, 8], 20: [10, 3, 7], 21: [4, 5, 8, 9], 22: [10, 5, 6]}
Con_12_1_7 = {1: [11, 12, 13, 14],
 2: [16, 17, 11, 15], 3: [18, 19, 12, 15], 4: [22, 20, 13, 15], 5: [16, 21, 12], 6: [18, 21, 22, 11], 7: [16, 19, 13], 8: [17, 19, 22, 14], 9: [16, 18, 20, 14], 10: [17, 21, 20], 11: [1, 2, 6], 12: [1, 3, 5], 13: [1, 4, 7], 14: [1, 8, 9], 15: [2, 3, 4], 16: [2, 5, 7, 9], 17: [10, 2, 8], 18: [3, 6, 9], 19: [3, 7, 8], 20: [10, 4, 9], 21: [10, 5, 6], 22: [4, 6, 8]}

Con_12_1_1_Graph = BipartiteGraph(Graph(Con_12_1_1), (range(1,11),range(11,23)))
Con_12_1_2_Graph = BipartiteGraph(Graph(Con_12_1_2), (range(1,11),range(11,23)))
Con_12_1_3_Graph = BipartiteGraph(Graph(Con_12_1_3), (range(1,11),range(11,23)))
Con_12_1_4_Graph = BipartiteGraph(Graph(Con_12_1_4), (range(1,11),range(11,23)))
Con_12_1_5_Graph = BipartiteGraph(Graph(Con_12_1_5), (range(1,11),range(11,23)))
Con_12_1_6_Graph = BipartiteGraph(Graph(Con_12_1_6), (range(1,11),range(11,23)))
Con_12_1_7_Graph = BipartiteGraph(Graph(Con_12_1_7), (range(1,11),range(11,23)))

Con_12_1_1_Graph.name("Con-12-1 #1")
Con_12_1_2_Graph.name("Con-12-1 #2")
Con_12_1_3_Graph.name("Con-12-1 #3")
Con_12_1_4_Graph.name("Con-12-1 #4")
Con_12_1_5_Graph.name("Con-12-1 #5")
Con_12_1_6_Graph.name("Con-12-1 #6")
Con_12_1_7_Graph.name("Con-12-1 #7")

Con_12_1_List = [Con_12_1_1_Graph, Con_12_1_2_Graph, Con_12_1_3_Graph, Con_12_1_4_Graph, Con_12_1_5_Graph, Con_12_1_6_Graph, Con_12_1_7_Graph]


Con_13_1_1 = {1: [11, 12, 13, 14],
              2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 23, 12], 6: [16, 23, 20, 13], 7: [17, 21, 22, 13], 8: [22, 20, 14, 15], 9: [16, 19, 21, 14], 10: [18, 21, 23, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6, 9], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 9], 20: [3, 6, 8], 21: [10, 7, 9], 22: [4, 7, 8], 23: [10, 5, 6]}
Con_13_1_1_Graph = BipartiteGraph(Graph(Con_13_1_1), (range(1,11),range(11,24)))
Con_13_1_1_Graph.name("Con-13-1 #1: Maximal Incidence")
Con_13_1_List = [Con_13_1_1_Graph]


Con_11_3_1 = {1: [11, 12, 13, 14],
              2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 12], 5: [17, 19, 21, 12], 6: [16, 19, 13], 7: [17, 20, 13], 8: [19, 14, 15], 9: [16, 21, 20, 14], 10: [18, 21, 13, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [10, 1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6, 9], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 6, 8], 20: [3, 7, 9], 21: [10, 5, 9]}
Con_11_3_1_Graph = BipartiteGraph(Graph(Con_11_3_1), (range(1,11),range(11,22)))
Con_11_3_1_Graph.name("Con-11-3 #1: The Peilen Superconfiguration")
Con_11_3_List = [Con_11_3_1_Graph]


Con_12_2_1 = {1: [11, 12, 13, 14],
              2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 21, 12], 6: [16, 19, 13], 7: [17, 22, 20, 13], 8: [19, 22, 14, 15], 9: [16, 21, 20, 14], 10: [18, 21, 13, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [10, 1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6, 9], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 6, 8], 20: [3, 7, 9], 21: [10, 5, 9], 22: [4, 7, 8]}
Con_12_2_1_Graph = BipartiteGraph(Graph(Con_12_2_1), (range(1,11),range(11,23)))
Con_12_2_1_Graph.name("Con-12-2 #1: The Lawrence Superconfiguration")
Con_12_2_List = [Con_12_2_1_Graph]


Con_12_3_1 = {1: [11, 12, 13, 14],
              2: [16, 17, 11, 15], 3: [18, 19, 20, 11], 4: [16, 18, 22, 12], 5: [17, 19, 21, 12], 6: [16, 19, 13], 7: [17, 22, 20, 13], 8: [19, 22, 14, 15], 9: [16, 21, 20, 14], 10: [18, 21, 13, 15], 11: [1, 2, 3], 12: [1, 4, 5], 13: [10, 1, 6, 7], 14: [1, 8, 9], 15: [10, 2, 8], 16: [2, 4, 6, 9], 17: [2, 5, 7], 18: [10, 3, 4], 19: [3, 5, 6, 8], 20: [3, 7, 9], 21: [10, 5, 9], 22: [4, 7, 8]}
Con_12_3_1_Graph = BipartiteGraph(Graph(Con_12_3_1), (range(1,11),range(11,23)))
Con_12_3_1_Graph.name("Con-12-3 #1: Woop!")
Con_12_3_List = [Con_12_3_1_Graph]


Con_13_2_List = []
Con_13_3_List = []

Con_10_4_1 = {10: [14, 12, 13], 1: [19, 15, 12], 2: [17, 16, 12], 3: [19, 18, 13], 4: [17, 20, 13], 11: [8, 9, 5], 14: [10, 6, 7], 15: [1, 9, 6], 16: [2, 9, 7], 18: [8, 3, 6], 20: [8, 4, 7], 5: [17, 19, 11], 12: [10, 8, 1, 2], 13: [10, 9, 3, 4], 6: [17, 14, 15, 18], 7: [19, 14, 16, 20], 8: [11, 18, 20, 12], 17: [2, 4, 5, 6], 9: [11, 15, 16, 13], 19: [1, 3, 5, 7]}
Con_10_4_1_Graph = BipartiteGraph(Graph(Con_10_4_1), (range(1,11), range(11,21)))
Con_10_4_1_Graph.name("Con-10-4 #1: MindFuck")
Con_10_4_List = [Con_10_4_1_Graph]

ListOfAllConfigurations = (deepcopy(ConfigDual_10s) + 
                           deepcopy(Con_10_0_List) + 
                           deepcopy(Con_10_1_List) + 
                           deepcopy(Con_10_2_List) + 
                           deepcopy(Con_10_3_List) + 
                           deepcopy(Con_11_0_List) + 
                           deepcopy(Con_11_1_List) +
                           deepcopy(Con_11_2_List) +
                           deepcopy(Con_11_3_List) +
                           deepcopy(Con_12_0_List) +
                           deepcopy(Con_12_1_List) +
                           deepcopy(Con_12_2_List) +
                           deepcopy(Con_12_3_List) +
                           deepcopy(Con_13_0_List) +
                           deepcopy(Con_13_1_List) +
                           deepcopy(Con_13_2_List) +
                           deepcopy(Con_13_3_List) +
                           deepcopy(Con_10_4_List))
︡769a6b45-c6fe-4559-8631-094124ad7435︡
︠7640e767-744b-4cb8-8cc6-834c3571824d︠
print "hi"
start = timeit.default_timer()
printinfo = False
#t3 = load('t3.sobj')
#t4 = load('t4.sobj')
#t5 = load('t5.sobj')
#t7 = load('t7.sobj')
#t8 = load('t8.sobj')
#t9 = load('t9.sobj')
#t11 = load('t11.sobj')
#t13 = load('t13.sobj')
#t16 = load('t16.sobj')
#t17 = load('t17.sobj')
#t19 = load('t19.sobj')

k = 0
for g in ListOfAllConfigurations:
    k += 1
    if k >= 109:
        print g
        #print "3...  ", strong (g, t3, 3)
        #print "4...  ", strong (g, t4, 4)
        #print "5...  ", strong (g, t5, 5)
        #print "7...  ", strong (g, t7, 7)
        #print "8...  ", strong (g, t8, 8)
        #print "9...  ", strong (g, t9, 9)
        #print "11... ", strong (g, t11, 11)
        #print "13... ", strong (g, t13, 13)
        #print "16... ", strong (g, t16, 16)
        #print "17... ", strong (g, t17, 17)
        print "23... ", strong (g, False, 23)
        print

stop = timeit.default_timer()
print "time ", stop - start
︡3e8d7a95-bcea-4932-aef7-2cc81c7886bc︡{"stdout":"hi\n"}︡{"stdout":"Con-11-1 R. #21\n23...  "}︡{"stdout":"2\n\nCon-11-1 R. #22\n23...  "}︡{"stdout":"1\n\nCon-11-1 R. #23\n23...  "}︡{"stdout":"0\n\nCon-11-1 R. #24\n23...  "}︡{"stdout":"0\n\nCon-11-2 #1\n23...  "}︡{"stdout":"0\n\nCon-11-2 #2\n23...  "}︡{"stdout":"0\n\nCon-11-2 #3\n23...  "}︡{"stdout":"0\n\nCon-11-3 #1: The Peilen Superconfiguration\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #1\n23...  "}︡{"stdout":"2\n\nCon-12-0 Reachable #2\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #3\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #4\n23...  "}︡{"stdout":"18\n\nCon-12-0 Reachable #5\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #6\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #7\n23...  "}︡{"stdout":"1\n\nCon-12-0 Reachable #8\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #9\n23...  "}︡{"stdout":"2\n\nCon-12-0 Reachable #10\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #11\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #12\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #13\n23...  "}︡{"stdout":"18\n\nCon-12-0 Reachable #14\n23...  "}︡{"stdout":"20\n\nCon-12-0 Reachable #15\n23...  "}︡{"stdout":"2\n\nCon-12-0 Reachable #16\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #17\n23...  "}︡{"stdout":"0\n\nCon-12-0 Reachable #18\n23...  "}︡{"stdout":"2\n\nCon-12-0: Unreachable #1 (EvilGrid)\n23...  "}︡{"stdout":"0\n\nCon-12-1 #1\n23... "}︡{"stderr":"Error in lines 16-31\n"}︡{"stderr":"Traceback (most recent call last):\n  File \"/projects/e16f4599-d2d3-4f68-be40-cb85ebb0091c/.sagemathcloud/sage_server.py\", line 879, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 15, in <module>\n  File \"\", line 33, in strong\n  File \"\", line 16, in realize_what_remains\n  File \"\", line 16, in realize_what_remains\n  File \"\", line 16, in realize_what_remains\n  File \"\", line 9, in realize_what_remains\n  File \"\", line 18, in checkset\n  File \"\", line 4, in line_thru_direct\n  File \"\", line 2, in collinear\n  File \"sage/ext/interrupt.pyx\", line 183, in sage.ext.interrupt.sage_python_check_interrupt (build/cythonized/sage/ext/interrupt.c:1674)\n    sig_check()\n  File \"sage/ext/interrupt.pyx\", line 71, in sage.ext.interrupt.sig_raise_exception (build/cythonized/sage/ext/interrupt.c:808)\n    raise KeyboardInterrupt\nKeyboardInterrupt\n"}︡
︠6d05e50a-9bb5-4459-b9e0-7af0502bb643︠
def checkset( constraints, realization, pointindices, t, pp, p ):
    global printinfo
    if printinfo:
        print "rlzn: ", realization
        print "cstr: ", constraints
        for c in constraints:
            print "locs: ", realization.get(c)
    op = []
    if len(constraints) == 0:
        op = pp
    elif len(constraints) == 2:
        #op = line_thru_using_db (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p)
        op = line_thru_direct (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p)
    elif len(constraints) == 4:
        #for x in line_thru_using_db (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p):
        for x in line_thru_direct (pointindices[constraints[0]], pointindices[constraints[1]], t, pp, p):
            #if x in line_thru_using_db (pointindices[constraints[2]], pointindices[constraints[3]], t, pp, p):
            if x in line_thru_direct (pointindices[constraints[2]], pointindices[constraints[3]], t, pp, p):
                op += [x]
    v = realization.values()
    output = []
    for ostensible in op:
        if ostensible not in v:
            output += [ostensible]
    if printinfo:
        print "op: ", op
        print "tosearch: ", output
        print

    return output


# check that a partial realization is consistent with what the levi graph demands so far.

def is_it_good_so_far (detted, newpoint, realization, pointindices, t, c, pp, p):
    p1 = newpoint
    for p2 in detted:
        loc2 = realization.get(p2)
        for p3 in detted:
            loc3 = realization.get(p3)
            if p1 != p2 and p2 != p3 and p3 != p1:
                loci1 = pointindices[p1]
                loci2 = pointindices[p2]
                loci3 = pointindices[p3]
                #if t[loci1][loci2][loci3] != c[p1 - 1][p2 - 1][p3 -1]:
                if collinear(pp[loci1],pp[loci2],pp[loci3],p) != c[p1 - 1][p2 - 1][p3 - 1]:
                    return False
    return True

# MAIN METHOD:
# This algorithm imitates the Peilen process over a known projective plane.

def strong_ND (levi, plane, prime):

    global printinfo

    c = combinatorially_tripping(levi)

    pp = plane
    st = grab_start_points (levi)

    p = [False for x in xrange(10)]
    loc = [False for x in xrange(10)]
    constraints = [False for x in xrange(10)]
    pointindices = [False for x in xrange(11)]

    p[0] = st[0]                       # "combinatorial points"
    p[1] = st[1]
    p[2] = st[2]
    p[3] = st[3]
    p[4] = st[4]
    detted = set([p[0],p[1],p[2],p[3],p[4]])
    realization = {p[0]:[1,1,0],
                   p[1]:[1,0,0],
                   p[2]:[0,1,0],
                   p[3]:[0,0,1],
                   p[4]:[1,1,1]}
    for N in xrange(5):
        pointindices[p[N]] = pplookup( pp, realization.get(p[N]) )

    constraints = [False for x in xrange(10)]

    for N in xrange(5,10):
        p[N] = next_point (levi, detted)
        constraints[N] = find_constraints(levi, detted, p[N])
        detted.add(p[N])

    if printinfo:
        print "Before realize_...: we have p = ", p
    detted = detted.difference(set([p[5], p[6], p[7], p[8], p[9]]))

    i = 0
    j = 0

    return realize_what_remains (5, pp, p, loc, detted, realization, pointindices, constraints, t, c, prime)


def realize_what_remains( N, pp, p, loc, detted, realization, pointindices, constraints, t, c, prime ):
    global printinfo
    if N == 10:
        # print realization
        # visualize(list(realization.values()),prime)
        return 1
    else:
        j = 0
        for loc[N] in checkset( constraints[N], realization, pointindices, t, pp, prime ) :
            detted.add(p[N])
            realization.update({p[N]:loc[N]})
            pointindices[p[N]] = pplookup( pp, loc[N] )
            if printinfo:
                print "Detted::: ", detted
            if is_it_good_so_far (detted, p[N], realization, pointindices, t, c, pp, prime):
                j += realize_what_remains( N + 1, pp, p, loc, detted, realization, pointindices, constraints, t, c, prime )
            del realization[p[N]]
            detted.remove(p[N])
            pointindices[p[N]] = False
        return j

def pplookup ( pp, point ):
    for i in xrange(len(pp)):
        if point == pp[i]:
            return i
︠82b7ed5a-c503-4e15-9096-9eb5e09d5bc0s︠




pappus = BipartiteGraph( (range(1,10),range(10,19)), {1:[10,12]} )
︡af146194-7a71-4e16-bf10-1a02d7ab0976︡{"stderr":"Error in lines 1-1\n"}︡{"stderr":"Traceback (most recent call last):\n  File \"/projects/e16f4599-d2d3-4f68-be40-cb85ebb0091c/.sagemathcloud/sage_server.py\", line 881, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\n  File \"/projects/sage/sage-6.9/local/lib/python2.7/site-packages/sage/graphs/bipartite_graph.py\", line 368, in __init__\n    Graph.__init__(self, data, *args, **kwds)\n  File \"/projects/sage/sage-6.9/local/lib/python2.7/site-packages/sage/graphs/graph.py\", line 1255, in __init__\n    raise ValueError(\"This input cannot be turned into a graph\")\nValueError: This input cannot be turned into a graph\n"}︡
︠df11e45a-0a91-4311-b8ec-f359e6de555a︠









