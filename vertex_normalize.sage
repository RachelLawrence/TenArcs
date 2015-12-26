#Rename the vertices of BipartiteGraph 'bigraph' such that:
#{1,4,5} is always a triple 
#{2,3,5} is always a 3-point line
#and no three of 1,2,3,4 lie on a line

def vertex_normalize (G):
    bigraph = deepcopy(G)
    D = bigraph.to_dictionary()
    for p1234 in Arrangements(range(1,11), 4):
        valid = 1
        for val in D.values():
            if (Set([p1234[1],p1234[2],p1234[3]]).issubset(Set(val)) or Set([p1234[1],p1234[2],p1234[0]]).issubset(Set(val)) or Set([p1234[0],p1234[2],p1234[3]]).issubset(Set(val)) or Set([p1234[1],p1234[3],p1234[0]]).issubset(Set(val))):
                valid = 0
                break
        if valid == 1:
            #try each of these triples
            for threeEdge in D.values():
                if len(threeEdge) == 3 and Set([p1234[2], p1234[3]]).issubset(Set(threeEdge)):
                    #1, 2, 3, 4, and 5 are now defined. Just need to check if 145 is a triple
                    five = Set(threeEdge).difference(Set([p1234[2], p1234[3]]))
                    fiveList = five.list()
                    for val in D.values():
                        for f in fiveList:
                            if Set([p1234[1], p1234[0], f]).issubset(Set(val)):
                                others = Set(range(1,11)).difference(Set([p1234[1], p1234[2], p1234[3], p1234[0], f]))
                                o = others.list()
                                bigraph.relabel({p1234[1]:1, p1234[2]:2, p1234[3]:3, p1234[0]:4, f:5, o[0]:6, o[1]:7, o[2]:8, o[3]:9, o[4]:10})
                                return bigraph
    return 0