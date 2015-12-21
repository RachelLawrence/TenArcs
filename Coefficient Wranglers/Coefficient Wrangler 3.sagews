︠06b399d9-218a-4335-b60c-02b5a19bb959︠

# HOW TO READ THIS CODE

# Part One – Preparation – in which we calculate inclusion numbers for all pairs of linear spaces.
#  This is the most significant time-suck of the program, and so we track those numbers in .sobj files.
#  The reason it looks messy right now is because we were trying to figure out how to parallelize it.
#  Those inclusion numbers are read in the next part:
# Part Two – Execution – this is the bona fide Iampolskaia, Skorobogatov, and Sorokin algorithm.
#  It's limited to the functions which calculate n_q and m_q.
# Part Three – Comprehension – this is to interpret the data dump which we get from the previous.
#  In particular, the variables need to be massaged so that they reflect strong realizations
#  rather than weak realizations, which is what the program most naturally outputs.
#  In this part you will also find the verification that the IEEE formula and ours match.


#load data
︡c6dc9b6f-fb7b-4223-b232-6d0e3d008f42︡︡{"done":true}
︠a095a121-b7f1-4c7d-bf03-b12696f18c8a︠
import timeit

#load linear space data
linearSpaceList = load('allLinearSpaces.sobj')
explodedSpaceList = load('allExplodedSpaces.sobj')
fullyExplodedSubsets = load('fullyExplodedSubsets.sobj')

#load poset data
# we're just going to leave the posets like this
OnePoset = {0: []}
TwoPoset = {0: []}
ThreePoset = {0: [1], 1: []}
FourPoset = {0: [1, 2], 1: [2], 2: []}
FivePoset = {0: [1, 2, 3, 4], 1: [2, 3, 4], 2: [3], 3: [], 4: [3]}
SixPoset = load('sixposet.sobj')
SevenPoset = load('sevenposet.sobj')
EightPoset = load('eightposet.sobj')
NinePoset = load('nineposet.sobj')


def linear_ext(dictio):
    LE = []
    for elt in range(len(dictio)):
        inyet = False
        for index in range(len(LE)):
            if not inyet and (LE[index] in dictio.get(elt)):
                LE.insert(index,elt)
                inyet = True
        if not inyet:
            LE += [elt]
    return LE
︡ce2078db-d000-4e84-9342-2e0343a93252︡︡{"done":true}
︠eee600f2-dd92-4196-92a5-a70a21be6909︠
# These are the computations which can be frontloaded.
# none of the frontloaded stuff is actually in use yet.

# First, create the bolster_db. Example -
# bolster_db[n][index] is the one with n points of index _
# (unlike in linearSpaceList - off by one lol sry)

# I just tried to change this so that it also adds subsets of len 0, 1, 2.
# new lines I have marked with a #.
def generateAllSubsetsEvenSmall(copyLinearSpaces, numPoints):
    tbr = []
    for preSpace in copyLinearSpaces:
        gs = preSpace.ground_set()     #
        space = preSpace.blocks()
        n = numPoints
        while n > 3:
            for block in space:
                if len(block) == n:
                    for combo in Combinations(block, n-1):
                        if combo not in space:
                            space.append(combo)
            n -= 1
        for n in xrange(3):                     #
            for combo in Combinations(gs, n):
                if combo not in space:
                    space += [combo]                #
        tbr.append(space)
    return tbr

# Returns the incidence structure with all (not just full) lines explicitly as blocks.
def bolster(f, numPoints):
    return IncidenceStructure(f.ground_set(),
                              generateAllSubsetsEvenSmall([IncidenceStructure(f.ground_set(),f.blocks())],numPoints)[0])

def make_bolster_db ( numPoints ):
    output = []
    for L in linearSpaceList[numPoints - 1]:
        output += [bolster(L, numPoints)]
    return output

# This was the code which produced bolster_db (But False was True)
if False:
    start = timeit.default_timer()
    bolster_db = ["Undef!" for x in range(11)]
    for n in range(3,11):
        bolster_db[n] = make_bolster_db(n)
    save(bolster_db, 'bolster_db')

bolster_db = load('bolster_db.sobj')

︡6d51017a-180c-43f8-8b69-7e7ef0e7fbf4︡︡{"done":true}
︠86ec1b77-a96d-4112-b358-433dd38e8b44︠

︠5568a99c-eb37-4a9b-ac1e-17d901f3b495︠
def autocard (A):
    automs = 0
    for a in A.isomorphic_substructures_iterator(A):
        automs += 1
    return automs

@parallel
def ways_to_extend (A, B, numPoints):
    A = bolster(A, numPoints)
    B = bolster(B, numPoints)
    inclusions = 0
    for a in B.isomorphic_substructures_iterator(A):
        inclusions += 1
    return inclusions / autocard(B)

@parallel
def ways_to_extend_indexed (linearSpaceList, i, j, numPoints):
    return (i,j, ways_to_extend( linearSpaceList[i], linearSpaceList[j], numPoints))
︡c0b366da-7997-43fd-a5a8-e0fa5917aaff︡︡{"done":true}
︠1ad6f705-3124-4aa3-b84f-eb7d61e4b318︠

start = timeit.default_timer()

# this should have w2e[nP][l][m] = ways_to_extend(linearSpaceList[nP-1][l], linearSpaceList[nP-1][m], nP)

def make_w2e_db():
    output = ["Undef!!" for x in range(11)]
    for n in range(3,11):
        row = []
        for L in linearSpaceList[n - 1]:
            rown = []
            for M in linearSpaceList[n - 1]:
                rown += [ways_to_extend(L, M, n)]
            row += [rown]
        output[n] = row
    return output

if False:
    w2e = make_w2e_db()
    save(w2e, 'w2e_up_to_9')

w2e = load('w2e_up_to_9.sobj')
w2e[9] = load('w2e_row_9.sobj')

print timeit.default_timer() - start
︡abe8afc6-3e04-46c4-9453-93f5b02aba5a︡︡{"stdout":"0.54979801178\n","done":false}︡{"done":true}
︠0e73eda8-7b2e-4257-8384-597a6415da63︠

# OLD-FASHIONED

w2e_row_9 = load('w2e_row_9.sobj')
for i in range(381,382):
    start = timeit.default_timer()
    rowi = []
    for M in linearSpaceList[8]:
        rowi += [ways_to_extend(linearSpaceList[8][i],M,9)]
    w2e_row_9[i] = rowi
    save(w2e_row_9, 'w2e_row_9')
    print timeit.default_timer() - start

︠76c883fa-f4a8-4895-9dde-b3bb212ca23e︠

w2e_row_10 = load('w2e_row_10.sobj')
for i in range(5243, 5250):
    start = timeit.default_timer()
    rowi = []
    for M in linearSpaceList[9]:
        rowi += [ways_to_extend(linearSpaceList[9][i],M,10)]
    w2e_row_10[i] = rowi
    save(w2e_row_10, 'w2e_row_10')
    print i, timeit.default_timer() - start
    
︡b351ac5a-b003-46f3-bbd9-ec4766b36007︡
︠e269b7e5-63e6-4f29-9566-f4e12d74404a︠
w2e_row_9 = load('w2e_row_9_testing.sobj')
for i in range(381,382):
    L = range(len(linearSpaceList[8]))
    start = timeit.default_timer()
    rowigen = ways_to_extend_indexed([ (linearSpaceList[8], i, j, 9) for j in L])
    rowi =['unk' for j in L]
    for tup in rowigen:
        rowi[tup[1][1]] = tup[1][2]
    w2e_row_9[i] = rowi
    save(w2e_row_9, 'w2e_row_9_testing')
    print timeit.default_timer() - start
︡13de8500-bd7e-4a13-8a4b-4d7b422694b2︡{"stdout":"138.783407927"}︡{"stdout":"\n"}︡
︠9a6d07af-8ff5-4971-8ddd-eac0374d702d︠
w2e_row_10 = load('w2e_row_10.sobj')
for i in range(5243,5250):
    L = range(len(linearSpaceList[9]))
    start = timeit.default_timer()
    rowigen = ways_to_extend_indexed([ (linearSpaceList[9], i, j, 10) for j in L])
    rowi =['unk' for j in L]
    for tup in rowigen:
        rowi[tup[1][1]] = tup[1][2]
    w2e_row_9[i] = rowi
    save(w2e_row_10, 'w2e_row_10')
    print timeit.default_timer() - start
︡5d7d86f7-96d8-46c9-b1a8-af72f59b3f70︡︡{"done":false,"stderr":"Error in lines 2-11\n"}︡{"done":false,"stderr":"Traceback (most recent call last):\n  File \"/projects/sage/sage-6.9/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 905, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 6, in <module>\n  File \"/projects/sage/sage-6.9/local/lib/python2.7/site-packages/sage/parallel/use_fork.py\", line 148, in __call__\n    pid = os.wait()[0]\n  File \"sage/ext/interrupt/interrupt.pyx\", line 203, in sage.ext.interrupt.interrupt.sage_python_check_interrupt (/projects/sage/sage-6.9/src/build/cythonized/sage/ext/interrupt/interrupt.c:1890)\n    sig_check()\n  File \"sage/ext/interrupt/interrupt.pyx\", line 88, in sage.ext.interrupt.interrupt.sig_raise_exception (/projects/sage/sage-6.9/src/build/cythonized/sage/ext/interrupt/interrupt.c:924)\n    raise KeyboardInterrupt\nKeyboardInterrupt\n"}︡{"done":true}
︠899bf7b7-7e12-4541-8f42-ed90f5531e4f︠
w2e_row_9 =  load('w2e_row_9.sobj')
w2e_row_9_t = load('w2e_row_9_testing.sobj')
for i in range(384):
    if not w2e_row_9_t[381][i] == w2e_row_9[381][i]:
        print "alert", i
︡fbc8cf21-63dd-4586-80b1-01161c6d6284︡
︠98b1ba0e-c155-4dd7-90c6-209333441336︠

w2e_row_10 = load('w2e_row_10.sobj')
for i in range(5241,5250):
    if (w2e_row_10[i] == 'Undef!!!'):
        print i
︡9a42f700-052a-4830-8f37-85053223304d︡︡{"stdout":"5243\n5244\n5245\n5246\n5247\n5248\n5249\n","done":false}︡{"done":true}
︠6ea8d569-3a41-46a5-80e4-f5dcc8e68b31︠













︠c5612d3f-c93a-4994-a301-ce261b28553bi︠

printinfo = True

def n_q_with_careful_labeling (index, old_m_q_list, old_n_q_list, numPoints):

    #define the original configuration f & initialize yo' shit
    f = linearSpaceList[numPoints - 1][index]

    found = False
    I = [[],[]]
    removedPointIndex = False
    #Choose a low-index point to remove, thus creating f_prime
    removedv = False
    for v in range(0, numPoints):
        if f.degree(v) <= 2:
            removedv = v
            removedPointIndex = f.degree(v)
            found = True
            count = 0
            blockscopy = deepcopy(f.blocks())
            for block in f.blocks(): #write down the lines that your low index point was on.
                if v in block:
                    I[count] = block
                    count += 1
            #delete your vertex
            f = IncidenceStructure(f.ground_set(), blockscopy)
            f_prime = substructure_finder(f, v, numPoints)
            break
    # So at this point f_prime has numPoints - 1 total points,
    # and should be somewhere in the list of linear spaces.

    # uncomment this if you want to identify the index of f_prime.

    # for v in xrange(len(linearSpaceList[numPoints - 2])):
    #    ls = linearSpaceList[numPoints - 2][v]
    #    if (ls.blocks() == [] and f_prime.blocks() == []) or (ls.is_isomorphic(f_prime)):
    #        f_prime_index = v

    #remove your target vertex wherever it appears in I.
    for entryIndex in range(0, len(I)):
        for pointIndex in range(0, len(I[entryIndex])):
            if I[entryIndex][pointIndex] == removedv:
                del I[entryIndex][pointIndex]
                break
    #or if no low-index point exists, it's a superfig! Gotta just return a new variable.
    if not found:
        return var('A_' + str(numPoints) + 'at' + str(index))

    f_prime = bolster(f_prime, numPoints - 1)

    sum = 0
    for g in range(len(linearSpaceList[numPoints - 2])):
        B = linearSpaceList[numPoints - 2][g]
        B = bolster(B, numPoints - 1)

        # s is keeping track of the term to add to the sum
        f_prime = bolster(f_prime, numPoints - 1)
        s = 0
        for a in B.isomorphic_substructures_iterator(f_prime):

            # relabel I to fit inside g
            I_relab = deepcopy(I)
            for i in I_relab:
                for j in xrange(len(i)):
                    i[j] = a.get(i[j])
            I_prime = generateI_prime_where_I_relab (I_relab, g, numPoints)

            for i in I_relab:
                for j in i:
                    if type(j) == type(None):
                        print "None-error in I_relab"
            for i in I_prime:
                for j in i:
                    if type(j) == type(None):
                        print "None-error in I_prime"

            mu = 0
            if removedPointIndex == 0:
                mu = (q^2 + q + 1 - (numPoints - 1))
            if I_prime != []:
                I_len_0 = len(I_prime[0])
            else:
                I_len_0 = 2
            if removedPointIndex == 1:
                mu =  q + 1 - (I_len_0)
            elif removedPointIndex == 2:
                #Do I[0] and I[1] overlap in g?
                I_intersection_type = determineIntersectionType(I_prime)
                #straight from the last page of the French paper! Set mu_g based on intersection type
                if I_intersection_type == 0:
                    mu = 1
                elif I_intersection_type == 1:
                    mu = 0
                elif I_intersection_type == 2:
                    mu = (q + 1 - (I_len_0))
            elif removedPointIndex != 0:
                print "error: len(I) not 0, 1, or 2"
            s += mu

        m_g = old_m_q_list[g]
        sum += m_g * s / autocard(B)
    return sum

def compute_all_n_q(old_m_q_list, old_n_q_list, numPoints):
    #cycle thru all configs. Store & return results in a nice list.
    n_q_list = [False for x in xrange(len(linearSpaceList[numPoints-1]))]
    for index in range(0, len(linearSpaceList[numPoints-1])):
        n = n_q_with_careful_labeling(index, old_m_q_list, old_n_q_list, numPoints)
        n_q_list[index] = n
    return n_q_list

def determineIntersectionType(I_prime):
    if len(I_prime) >= 2:
        list1 = set(I_prime[0])
        list2 = set(I_prime[1])
    else:
        print "error: I_prime has too few entries. ABORT"
        return
    #G is a weak realization of F
    #need to relabel G to match F
    intersection = list1.intersection(list2)
    if len(intersection) >= 2:
        return 2
    if len(intersection) == 1:
        return 1
    return 0

def generateI_prime_where_I_relab (I_relab, g, numPoints):
    I_prime = []
    gConfig = linearSpaceList[numPoints-2][g]
    for I_block in I_relab:
        if I_block != []:
            found = False
            for g_block in gConfig:
                if Set(I_block).issubset(Set(g_block)):
                        I_prime.append(g_block)
                        found = True
            if found == False:
                I_prime.append(I_block)
    return I_prime


#return a new structure that's f but with point v removed
def substructure_finder(f, v, numPoints):
    newblocks = []
    for block in f.blocks():
        if v not in block:
            newblocks.append(block)
        else:
            blockcopy = deepcopy(block)
            del blockcopy[block.index(v)]
            newblocks.append(blockcopy)
    f_ground_set_without_v = [pt for pt in f.ground_set() if pt != v]
    return IncidenceStructure(f_ground_set_without_v, newblocks)

︡d3c63497-462f-4fd6-8a14-2a867b24b1b6︡
︠36157169-7688-4392-8b01-e0416d4c3bff︠

#M calculations below
︡eb957c27-0857-4671-8391-e489da7f382f︡
︠44533a00-1962-40df-91ae-f338658d22a0i︠

def m_q(index, n_q_list, m_q_list, numPoints):
    summation = 0
    f = linearSpaceList[numPoints - 1][index]
    f = bolster(f, numPoints)
    F = len(f.blocks())
    # this used to be over posetGraph[index]
    for i in xrange(len(linearSpaceList[numPoints - 1])): #get summation term for every weak realization g of f
        if i != index:
            g = linearSpaceList[numPoints - 1][i]
            g = bolster( g, numPoints)
            w = w2e[numPoints][index][i]
            if w > 0:
                summation += w * m_q_list[i]
    output = n_q_list[index] - summation
    return output

def compute_all_m_q(n_q_list, numPoints, poset):
    #cycle thru all configs in the proper order. Store & return results in a nice list
    # be warned... extended slice syntax ahead
    m_q_list = ["Undefined!" for x in xrange(len(n_q_list))]
    for index in linear_ext( poset )[::-1]:
        m = m_q(index, n_q_list, m_q_list, numPoints)
        m2 = m.expand()
        m_q_list[index] = m2
    return m_q_list


︡ddf92385-0fcb-4b06-863a-e93d83685c81︡
︠b2701982-c2bf-4272-8e54-2eda98e8b112︠
#####
#
# PART TWO: EXECUTION
#
#####
︠420364ca-c955-43b4-9d4f-01c35f2716a1︠

start = timeit.default_timer()

printinfo = False

#main

#base case

q = var("q")
n_q_list_2 =  [(q^2 + q + 1)*(q^2 + q)] #n_q's on 2 point
m_q_list_2 =  [(q^2 + q + 1)*(q^2 + q)] #m_q's on 2 point

numPoints = 3
n_q_list_3 = compute_all_n_q(m_q_list_2, n_q_list_2, numPoints)
m_q_list_3 = compute_all_m_q(n_q_list_3, numPoints, ThreePoset)

numPoints = 4
n_q_list_4 = compute_all_n_q(m_q_list_3, n_q_list_3, numPoints)
m_q_list_4 = compute_all_m_q(n_q_list_4, numPoints, FourPoset)

numPoints = 5
n_q_list_5 = compute_all_n_q(m_q_list_4, n_q_list_4, numPoints)
m_q_list_5 = compute_all_m_q(n_q_list_5, numPoints, FivePoset)

numPoints = 6
n_q_list_6 = compute_all_n_q(m_q_list_5, n_q_list_5, numPoints)
m_q_list_6 = compute_all_m_q(n_q_list_6, numPoints, SixPoset)

numPoints = 7
n_q_list_7 = load('saved_n_q_list_7.sobj')
m_q_list_7 = load('saved_m_q_list_7.sobj')

n_q_list_8 = load('saved_n_q_list_8.sobj')
m_q_list_8 = load('saved_m_q_list_8.sobj')

n_q_list_9 = load('n_q_list_9_so_far.sobj')
m_q_list_9 = load('m_q_list_9_so_far.sobj')

print timeit.default_timer() - start
︡f3322e77-7618-463f-857d-879319fa680a︡{"stdout":"1.19941782951\n"}︡
︠af896ac0-c1c6-4b3c-94ed-5598f8d344ce︠

########################################
#   PART 3: COMPREHENSION
########################################


# This is the "variable dump" which allows us to plug'n'play with formulae in the future. Annoying, but necessary!
# Naming these for the 151 superfigurations on 10 should be automated to reduce chances of error.


A_7at23 = var('A_7at23')
A_8at68 = var('A_8at68')
A_9at368 = var('A_9at368')
A_9at373 = var('A_9at373')
A_9at375 = var('A_9at375')
A_9at376 = var('A_9at376')
A_9at377 = var('A_9at377')
A_9at378 = var('A_9at378')
A_9at380 = var('A_9at380')
A_9at381 = var('A_9at381')
A_9at382 = var('A_9at382')
A_9at383 = var('A_9at383')

M_7at23 = var('M_7at23')
M_8at68 = var('M_8at68')
M_9at368 = var('M_9at368')
M_9at373 = var('M_9at373')
M_9at375 = var('M_9at375')
M_9at376 = var('M_9at376')
M_9at377 = var('M_9at377')
M_9at378 = var('M_9at378')
M_9at380 = var('M_9at380')
M_9at381 = var('M_9at381')
M_9at382 = var('M_9at382')
M_9at383 = var('M_9at383')

D_7at23 = n_q_list_7[23] - m_q_list_7[23]
D_8at68 = n_q_list_8[68] - m_q_list_8[68]
D_9at368 = n_q_list_9[368] - m_q_list_9[368]
D_9at373 = n_q_list_9[373] - m_q_list_9[373]
D_9at375 = n_q_list_9[375] - m_q_list_9[375]
D_9at376 = n_q_list_9[376] - m_q_list_9[376]
D_9at377 = n_q_list_9[377] - m_q_list_9[377]
D_9at378 = n_q_list_9[378] - m_q_list_9[378]
D_9at380 = n_q_list_9[380] - m_q_list_9[380]
D_9at381 = n_q_list_9[381] - m_q_list_9[381]
D_9at382 = n_q_list_9[382] - m_q_list_9[382]
D_9at383 = n_q_list_9[383] - m_q_list_9[383]


︡06d474aa-ee6b-462e-9449-4c6f55bdeeb1︡
︠6028c3c8-f0dd-4be8-b5fe-cf8ad5117a06︠
# Proof: our formula matches glynn for 7-arcs.

m_7_arc_ours = m_q_list_7[0]
m_fano = m_q_list_7[-1]
glynn = (1/factorial(7))*((q^2+q+1)*(q+1)*(q^3)*(q-1)^2 *(q-3)*(q-5)*(q^4 - 20*q^3 + 148*q^2 - 468*q + 498) - 30*m_fano)

expand(m_7_arc_ours - factorial(7)*glynn)

# And for 8-arcs.

m_8_arc_ours = m_q_list_8[0]
m_mob = m_q_list_8[68]

glynn_8 = (1/factorial(8) *
           (q^2 + q + 1) *
           (q + 1) *
           (q^3) *
           (q - 1)^2 *
           (q - 5) *
           (q^7 - 43*q^6 + 788*q^5 - 7937*q^4 + 47097*q^3 - 162834*q^2 + 299280*q - 222960) +
           m_mob / 48 -
           (q^2 - 20*q + 78) * m_fano / 168)

expand(factorial(8)*glynn_8 - m_8_arc_ours)
︡5d2d6225-b254-40e4-8273-eb8c7003c747︡{"stdout":"0\n"}︡{"stdout":"0\n"}︡
︠8afc7401-412e-4437-9a34-c48f88198b33︠
# My hunch says that this is really important. Useless as it stands now.

NewNinePo = {}
for i in xrange(len(linearSpaceList[8])):
    entry = []
    for j in xrange(len(linearSpaceList[8])):
        if i != j and w2e[9][i][j] > 0:
            entry += [j]
    NewNinePo.update({i:entry})


︡4a517bb9-a281-48b1-b5b2-42fc87368968︡
︠f37006f8-8f24-4132-adb1-bf7876759d65︠

# This is going to be what I am working with most directly right now.

m_9_arc = m_q_list_9[0]

m_9_rephrased = m_9_arc(A_7at23  =M_7at23 + D_7at23,
                        A_8at68  =M_8at68 + D_8at68,
                        A_9at368 =M_9at368 + D_9at368,
                        A_9at373 =M_9at373 + D_9at373,
                        A_9at375 =M_9at375 + D_9at375,
                        A_9at376 =M_9at376 + D_9at376,
                        A_9at377 =M_9at377 + D_9at377,
                        A_9at378 =M_9at378 + D_9at378,
                        A_9at380 =M_9at380 + D_9at380,
                        A_9at381 =M_9at381 + D_9at381,
                        A_9at382 =M_9at382 + D_9at382,
                        A_9at383 =M_9at383 + D_9at383)
m_9_rephrased.args()
m_9_rephrased = m_9_rephrased(A_7at23  =M_7at23 + D_7at23,
                        A_8at68  =M_8at68 + D_8at68,
                        A_9at368 =M_9at368 + D_9at368,
                        A_9at373 =M_9at373 + D_9at373,
                        A_9at375 =M_9at375 + D_9at375,
                        A_9at376 =M_9at376 + D_9at376,
                        A_9at377 =M_9at377 + D_9at377,
                        A_9at378 =M_9at378 + D_9at378,
                        A_9at380 =M_9at380 + D_9at380,
                        A_9at381 =M_9at381 + D_9at381,
                        A_9at382 =M_9at382 + D_9at382,
                        A_9at383 =M_9at383 + D_9at383)
m_9_rephrased.args()
m_9_rephrased = m_9_rephrased(A_7at23  =M_7at23 + D_7at23,
                        A_8at68  =M_8at68 + D_8at68,
                        A_9at368 =M_9at368 + D_9at368,
                        A_9at373 =M_9at373 + D_9at373,
                        A_9at375 =M_9at375 + D_9at375,
                        A_9at376 =M_9at376 + D_9at376,
                        A_9at377 =M_9at377 + D_9at377,
                        A_9at378 =M_9at378 + D_9at378,
                        A_9at380 =M_9at380 + D_9at380,
                        A_9at381 =M_9at381 + D_9at381,
                        A_9at382 =M_9at382 + D_9at382,
                        A_9at383 =M_9at383 + D_9at383)
m_9_rephrased.args()
m_9_rephrased = m_9_rephrased(A_7at23  =M_7at23 + D_7at23,
                        A_8at68  =M_8at68 + D_8at68,
                        A_9at368 =M_9at368 + D_9at368,
                        A_9at373 =M_9at373 + D_9at373,
                        A_9at375 =M_9at375 + D_9at375,
                        A_9at376 =M_9at376 + D_9at376,
                        A_9at377 =M_9at377 + D_9at377,
                        A_9at378 =M_9at378 + D_9at378,
                        A_9at380 =M_9at380 + D_9at380,
                        A_9at381 =M_9at381 + D_9at381,
                        A_9at382 =M_9at382 + D_9at382,
                        A_9at383 =M_9at383 + D_9at383)

︡8ba0367d-4c2f-49cb-81e5-17741e24c32c︡{"stdout":"(A_9at378, A_9at381, A_9at382, A_9at383, M_7at23, M_8at68, M_9at368, M_9at373, M_9at375, M_9at376, M_9at377, M_9at378, M_9at380, M_9at381, M_9at382, M_9at383, q)\n"}︡{"stdout":"(A_9at382, A_9at383, M_7at23, M_8at68, M_9at368, M_9at373, M_9at375, M_9at376, M_9at377, M_9at380, M_9at382, M_9at383, q)\n"}︡{"stdout":"(A_9at383, M_7at23, M_8at68, M_9at368, M_9at373, M_9at375, M_9at376, M_9at377, M_9at380, M_9at383, q)\n"}︡
︠6a5d647f-62e4-49b7-a3fe-1fd0dbed2e42︠
for p in [368,373,375,376,377,380,381,382,383]:
    print p, linearSpaceList[8][p].blocks(), autocard(bolster(linearSpaceList[8][p],9))

︡aca5c459-3ace-49f8-92bb-6b15a98c489c︡{"stdout":"368 [[0, 1, 2], [0, 3, 4], [0, 6, 7], [1, 3, 5], [1, 4, 6], [2, 4, 8], [2, 5, 7], [3, 7, 8], [5, 6, 8]] 12\n373 [[0, 1, 2], [0, 3, 4], [0, 5, 8], [0, 6, 7], [1, 3, 5], [1, 4, 7], [1, 6, 8], [2, 3, 7, 8], [2, 4, 5, 6]] 12\n375 [[0, 1, 2], [0, 3, 4], [0, 6, 7], [1, 3, 5], [1, 4, 7], [1, 6, 8], [2, 3, 7, 8], [2, 5, 6], [4, 5, 8]] 4\n376 [[0, 1, 2], [0, 3, 4], [0, 6, 7], [1, 3, 5], [1, 4, 6], [2, 5, 7], [2, 6, 8], [3, 7, 8], [4, 5, 8]] 9\n377 [[0, 1, 2], [0, 3, 6], [0, 5, 7], [1, 3, 8], [1, 4, 7], [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]] 108\n380 [[0, 1, 2], [0, 3, 4], [0, 5, 8], [0, 6, 7], [1, 3, 5], [1, 4, 7], [1, 6, 8], [2, 3, 6], [2, 7, 8], [4, 5, 6]] 6\n381 [[0, 1, 2], [0, 3, 4], [0, 5, 8], [0, 6, 7], [1, 3, 5], [1, 4, 7], [1, 6, 8], [2, 3, 6], [2, 4, 8], [2, 5, 7]] 36\n382 [[0, 1, 2], [0, 3, 6], [0, 5, 7], [1, 3, 8], [1, 4, 7], [1, 5, 6], [2, 3, 7], [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]] 36\n383 [[0, 1, 2], [0, 3, 6], [0, 4, 8], [0, 5, 7], [1, 3, 8], [1, 4, 7], [1, 5, 6], [2, 3, 7], [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]] "}︡{"stdout":"432\n"}︡
︠efddd360-729d-4ddc-8c27-70f4b19e6f59︠

# A guide to which of the configurations in the IEEE paper are which of ours
# type 12: 373
# TYPE 11: 375
# pappus: 377   conf
# type 4: 376   conf
# type 5: 368
# type 7: 380
# type 8: 381   conf
# type 9: 382
# type 10: 383

# Here's our beloved IEEE theorem

ieee_a = var('ieee_a')
ieee_b = var('ieee_b')
ieee_c = var('ieee_c')
ieee_d = var('ieee_d')
ieee_e = var('ieee_e')

ieee = (q^2 + q + 1)*(q^2 + q)*(q^2)*(q-1)^2 * (
                                                q^10 - 75*q^9 + 2530*q^8 - 50466*q^7 + 657739*q^6
                                                - 5835825*q^5 + 35563770*q^4 - 146288034*q^3
                                                + 386490120*q^2 - 588513120*q + 389442480
                                                - 1080*(q^4 - 47*q^3 + 807*q^2 - 5921*q + 15134)*ieee_a
                                                + 840*(9*q^2 -243*q + 1684)*ieee_b
                                                + 30240*(-9*ieee_c + 9 * ieee_d + 2* ieee_e))

def get_a (p,r):
    if p == 2:
        return 1
    else:
        return 0
    
def get_b (p,r):
    if p == 3:
        return 1
    elif kronecker(-3,p) == 1:
        return 2
    elif kronecker(-3,p) == -1:
        if r % 2 == 0:
            return 2
        else:
            return 0

def get_c (p,r):
    if p == 3:
        return 1
    else:
        return 0

def get_d (p,r):
    if p == 5:
        return 1
    elif kronecker(5, p) == 1:
        return 2
    elif kronecker(5, p) == -1:
        if r % 2 == 0:
            return 2
        else:
            return 0
def get_e (p,r):
    if p == 2:
        return 1
    elif kronecker(-1, p) == 1:
        return 2
    elif kronecker(-1, p) == -1:
        if r % 2 == 0:
            return 2
        else:
            return 0

def ieee_predicts (p,r):
    return ieee(q = p^r, ieee_a = get_a(p,r), ieee_b = get_b(p,r), ieee_c = get_c(p,r), ieee_d = get_d(p,r), ieee_e = get_e(p,r))

︡7f54e1c1-292d-4ff0-9dae-a60dbee29ac3︡
︠71ac7511-01f9-4720-aa60-1ffb16edeca5︠
# Here's a nice example of a calculation via the IEEE theorem.

ieee(q=23,ieee_a=0,ieee_b=0, ieee_c = 0, ieee_d = 0, ieee_e = 0)
ieee_predicts(7,1)
we_predict(7,1)

def we_predict(p, r):
    q = p^r
    arcfac = (q^2 + q + 1)*(q^2 + q)*(q^2)*(q-1)^2
    a = get_a (p,r)
    b = get_b (p,r)
    c = get_c (p,r)
    d = get_d (p,r)
    e = get_e (p,r)
    return m_9_rephrased(q= p^r,
                         M_7at23= a*arcfac,
                         M_8at68= b*arcfac,
                         M_9at368= (q-3)*(1 - a)*arcfac,
                         M_9at373= c*arcfac,
                         M_9at375= d*arcfac,
                         M_9at376= (q - 2 - b)*arcfac,
                         M_9at377= ((q-5)*(q-2) + (q - 3)*b)*arcfac,
                         M_9at380= (e - a)*arcfac,
                         M_9at383= b*arcfac)

def reproduce_formula(q):
    arcfac = (q^2 + q + 1)*(q^2 + q)*(q^2)*(q-1)^2
    a = var('ieee_a')
    b = var('ieee_b')
    c = var('ieee_c')
    d = var('ieee_d')
    e = var('ieee_e')
    return m_9_rephrased(q= q,
                         M_7at23= a*arcfac,
                         M_8at68= b*arcfac,
                         M_9at368= (q-3)*(1 - a)*arcfac,
                         M_9at373= c*arcfac,
                         M_9at375= d*arcfac,
                         M_9at376= (q - 2 - b)*arcfac,
                         M_9at377= ((q-2-b)*(q-5) + b*(q-3) )*arcfac,
                         M_9at380= (e - a)*arcfac,
                         M_9at383= b*arcfac)

expand(reproduce_formula(var('q')) - ieee)

expand(m_9_rephrased)
︡400f9b4a-4840-4f16-ae9e-e0a2a9617be7︡{"stdout":"q^18 - 75*q^17 + 2529*q^16 - 50392*q^15 + 655284*q^14 - 5787888*q^13 + 34956422*q^12 - 141107418*q^11 + 356715069*q^10 - 477084077*q^9 + 143263449*q^8 + 237536370*q^7 + 52873326*q^6 - 1080*M_7at23*q^4 - 2811240*q^5 + 50760*M_7at23*q^3 - 588466080*q^4 - 871560*M_7at23*q^2 + 7560*M_8at68*q^2 + 389304720*q^3 + 6364440*M_7at23*q - 204120*M_8at68*q - 16193520*M_7at23 + 1383480*M_8at68 - 30240*M_9at368 - 272160*M_9at373 + 272160*M_9at375 - 40320*M_9at376 - 3360*M_9at377 + 60480*M_9at380 - 2520*M_9at383\n"}︡
︠c36e9147-59cf-4c5b-ab34-1c90cc44981e︠









