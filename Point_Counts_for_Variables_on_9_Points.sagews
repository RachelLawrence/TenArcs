︠edf506c6-c860-48a9-a454-f3863f4a50dci︠
%html
<p>The goal of this worksheet is to present an idea for automating some of the computations related to counting $10$-arcs in $\mathbb{P}^2(\mathbb{F}_q)$. &nbsp;Here is the setup:</p>
<p>By Glynn's results we know that the formula for $10$-arcs is of the form</p>
<p>\[ f(q) + \sum_{s\in S} p_s(q) A_s(q),\]</p>
<p>where $A_s(q)$ denotes the number of copies of the configuration 's' inside of $\mathbb{P}^2(\mathbb{F}_q)$. &nbsp;This worksheet only addresses the question of finding these functions $A_s(q)$. &nbsp;In many cases (40?), $A_s(q) = 0$ for all $q$. &nbsp;That is, the configuration is not realizable over any algebraic finite projective plane. &nbsp;For many (some number that hopefully we can compute) others, the function $A_s(q)$ will be quasipolynomial in $q$. &nbsp;For the majority of these quasipolynomial functions, the polynomial will be linear in $q$.</p>
<p>Here is the idea of the worksheet. &nbsp;A configuration on $10$ points is defined by a set of lines. &nbsp;That is, we are told for each of the lines exactly which points lie on the lines. &nbsp;This is equivalent to giving a set of collinear triples among our $10$ points. &nbsp;We know that we can fix our first five points to be $[1,0,0], [0,1,0], [0,0,1], [1,1,1]$ and $[1,1,0]$. &nbsp;This means that one of our lines is $z=0$. &nbsp;If we suppose that $z=0$ is a line containing exactly three points, which is fair since there is always at least one three point line, then every other point can be taken of the form $[x_i, y_i,1]$ for some $x_i, y_i \in \mathbb{F}_q$. &nbsp;We have ten variables total, two for each $i \in [6,10]$.</p>
<p>Each collinear triple then gives some polynomial equation satisfied by the variables defining these three points. &nbsp;A weak realization of a configuration is then a solution in $x_6,y_6,\ldots, x_{10}, y_{10}$ to the polynomial equations defined by the collinear triples. &nbsp;To move on to strong realizations we would also need to impose the condition that certain determinants are nonzero, but this is harder. &nbsp;By computing the weak-realizations of a given configuration and of its refinements we can compute the number of strong realizations of the configuration.</p>
<p>In this worksheet we carry out this procedure for each of the configurations mentioned in the $9$-arcs paper (except the Fano plane).</p>

<p>This short program takes in three points in the form of triples of three points and spits out an equation defined by the determinant.</p>

︡1a2ed01c-8afd-4009-9af0-4aefcdfdcffa︡{"html": "<p>The goal of this worksheet is to present an idea for automating some of the computations related to counting $10$-arcs in $\\mathbb{P}^2(\\mathbb{F}_q)$. &nbsp;Here is the setup:</p>\n<p>By Glynn's results we know that the formula for $10$-arcs is of the form</p>\n<p>\\[ f(q) + \\sum_{s\\in S} p_s(q) A_s(q),\\]</p>\n<p>where $A_s(q)$ denotes the number of copies of the configuration 's' inside of $\\mathbb{P}^2(\\mathbb{F}_q)$. &nbsp;This worksheet only addresses the question of finding these functions $A_s(q)$. &nbsp;In many cases (40?), $A_s(q) = 0$ for all $q$. &nbsp;That is, the configuration is not realizable over any algebraic finite projective plane. &nbsp;For many (some number that hopefully we can compute) others, the function $A_s(q)$ will be quasipolynomial in $q$. &nbsp;For the majority of these quasipolynomial functions, the polynomial will be linear in $q$.</p>\n<p>Here is the idea of the worksheet. &nbsp;A configuration on $10$ points is defined by a set of lines. &nbsp;That is, we are told for each of the lines exactly which points lie on the lines. &nbsp;This is equivalent to giving a set of collinear triples among our $10$ points. &nbsp;We know that we can fix our first five points to be $[1,0,0], [0,1,0], [0,0,1], [1,1,1]$ and $[1,1,0]$. &nbsp;This means that one of our lines is $z=0$. &nbsp;If we suppose that $z=0$ is a line containing exactly three points, which is fair since there is always at least one three point line, then every other point can be taken of the form $[x_i, y_i,1]$ for some $x_i, y_i \\in \\mathbb{F}_q$. &nbsp;We have ten variables total, two for each $i \\in [6,10]$.</p>\n<p>Each collinear triple then gives some polynomial equation satisfied by the variables defining these three points. &nbsp;A weak realization of a configuration is then a solution in $x_6,y_6,\\ldots, x_{10}, y_{10}$ to the polynomial equations defined by the collinear triples. &nbsp;To move on to strong realizations we would also need to impose the condition that certain determinants are nonzero, but this is harder. &nbsp;By computing the weak-realizations of a given configuration and of its refinements we can compute the number of strong realizations of the configuration.</p>\n<p>In this worksheet we carry out this procedure for each of the configurations mentioned in the $9$-arcs paper (except the Fano plane).</p>\n\n<p>This short program takes in three points in the form of triples of three points and spits out an equation defined by the determinant.</p>"}︡
︠caa9afad-9980-4998-9f7a-89536ff938bfs︠
def three_point_triple(p1,p2,p3):
    a1 = p1[0]
    b1 = p1[1]
    c1 = p1[2]
    a2 = p2[0]
    b2 = p2[1]
    c2 = p2[2]
    a3 = p3[0]
    b3 = p3[1]
    c3 = p3[2]
    return(Matrix(R,[[a1,b1,c1],[a2,b2,c2],[a3,b3,c3]]).determinant())
︡496aaff3-3af3-4ce9-aa47-c64c68b51e70︡
︠4e510379-63f2-489d-9733-32e5ec919dc0i︠
%html
<p>Here we give a list of each of the first five points.&nbsp;</p>

︡095d1357-83af-474a-9cee-9a3f4790c2cd︡{"html": "<p>Here we give a list of each of the first five points.&nbsp;</p>"}︡
︠9ebd79f7-bae3-4627-89ff-ddb342187076s︠
p1 = [1,0,0]
p2 = [0,1,0]
p3 = [0,0,1]
p4 = [1,1,1]
p5 = [1,1,0]
︡479e755f-8183-466e-9020-02121fa5a023︡
︠db7af9ce-aa7b-4a33-9164-286b8f32fc87i︠
%html
<p>We first give the one $8$-point example. &nbsp;The point of printing out the equations in this particular kind of list is that we will next feed these equations into Magma which has efficient built-in methods for counting the number of points satisfying a set of polynomial equations over a fixed finite field.</p>

︡f077f6f9-bb73-4e7f-8e45-e9100f7966ac︡{"html": "<p>We first give the one $8$-point example. &nbsp;The point of printing out the equations in this particular kind of list is that we will next feed these equations into Magma which has efficient built-in methods for counting the number of points satisfying a set of polynomial equations over a fixed finite field.</p>"}︡
︠0bf99679-b7aa-41a0-9deb-0c432aa8a6e9s︠
#This is the Mobius-Kantor configuration.

R.<x6,y6,x7,y7,x8,y8> =  QQ[]

p6 = [x6,y6,1]
p7 = [x7,y7,1]
p8 = [x8,y8,1]

print "a :=",three_point_triple(p1,p4,p8),";"
print "b :=",three_point_triple(p1,p6,p7),";"
print "c :=",three_point_triple(p2,p3,p6),";"
print "d :=",three_point_triple(p2,p4,p7),";"
print "e :=",three_point_triple(p3,p7,p8),";"
print "f :=",three_point_triple(p5,p6,p8),";"
︡22f2ead9-ccd1-42ff-96fa-e946780ce2db︡{"stdout":"a := -y8 + 1 ;\n"}︡{"stdout":"b := y6 - y7 ;\n"}︡{"stdout":"c := x6 ;\n"}︡{"stdout":"d := x7 - 1 ;\n"}︡{"stdout":"e := -y7*x8 + x7*y8 ;\n"}︡{"stdout":"f := -x6 + y6 + x8 - y8 ;\n"}︡
︠ff487e34-b454-4194-b0ef-9dc5896c09fei︠
%html
<p>The next cell uses Magma to count the number of choices of $x_6,y_6,x_7,y_7, x_8,y_8$ satisfying the determinental equations given by the set of $8$ three-point lines. &nbsp;For each prime power we create the affine space $\mathbb{F}_q^6$ and then input the same $6$ polynomial equations. &nbsp;We define $C$, the 'scheme' (which is really just a variety), cut out by these six equations. &nbsp;It then prints out [q,# of points].</p>
<p>From this output it should be pretty clear that the answer is quasipolynomial depending on $q$ modulo $3$.</p>

︡f54e0738-ebc0-4b86-a10a-16f40c1ec252︡{"html": "<p>The next cell uses Magma to count the number of choices of $x_6,y_6,x_7,y_7, x_8,y_8$ satisfying the determinental equations given by the set of $8$ three-point lines. &nbsp;For each prime power we create the affine space $\\mathbb{F}_q^6$ and then input the same $6$ polynomial equations. &nbsp;We define $C$, the 'scheme' (which is really just a variety), cut out by these six equations. &nbsp;It then prints out [q,# of points].</p>\n<p>From this output it should be pretty clear that the answer is quasipolynomial depending on $q$ modulo $3$.</p>"}︡
︠52327c17-6d71-4c9a-baf9-f927d7025430︠
%magma
for q := 2 to 50 do
    if IsPrimePower(q) then
        A<x6,y6,x7,y7,x8,y8> := AffineSpace(FiniteField(q),6);
        a := -y8 + 1 ;
        b := y6 - y7 ;
        c := x6 ;
        d := x7 - 1 ;
        e := -y7*x8 + x7*y8 ;
        f := -x6 + y6 + x8 - y8 ;
        C := Scheme(A,[a,b,c,d,e,f]);
        print([q,#RationalPoints(C)]);
    end if;
end for;
︡d4382286-1f1c-40a3-88a9-b5bd7998d6cd︡{"stdout": "[ 2, 0 ]\n[ 3, 1 ]\n[ 4, 2 ]\n[ 5, 0 ]\n[ 7, 2 ]\n[ 8, 0 ]\n[ 9, 1 ]\n[ 11, 0 ]\n[ 13, 2 ]\n[ 16, 2 ]\n[ 17, 0 ]\n[ 19, 2 ]\n[ 23, 0 ]\n[ 25, 2 ]\n[ 27, 1 ]\n[ 29, 0 ]\n[ 31, 2 ]\n[ 32, 0 ]\n[ 37, 2 ]\n[ 41, 0 ]\n[ 43, 2 ]\n[ 47, 0 ]\n[ 49, 2 ]"}︡
︠b7bd6426-7b1e-410c-bc86-0080c79db150i︠
%html
<p>It is pretty clear that we could simplify the previous equations a little bit. &nbsp;In some cases, the value of the corresponding variable is constant. &nbsp;In other cases we can set some variables equal to each other, or equal to simple combinations of the other variables. &nbsp;We can simplify the equations as follows.</p>

︡68130afc-7e19-4cf5-be6e-6c264871373d︡{"html": "<p>It is pretty clear that we could simplify the previous equations a little bit. &nbsp;In some cases, the value of the corresponding variable is constant. &nbsp;In other cases we can set some variables equal to each other, or equal to simple combinations of the other variables. &nbsp;We can simplify the equations as follows.</p>"}︡
︠f76602a7-aadf-4a0f-8f57-3f4f9b400b7f︠
%magma

A<x6,y6,x7,y7,x8,y8> := AffineSpace(Rationals(),6);
a := -y8 + 1 ;
b := y6 - y7 ;
c := x6 ;
d := x7 - 1 ;
e := -y7*x8 + x7*y8 ;
f := -x6 + y6 + x8 - y8 ;
C := Scheme(A,[a,b,c,d,e,f]);
︡e5252fc0-6add-449c-b930-d4970ff4edf9︡︡
︠f7297feb-e5c9-45d2-94f5-a7762cdf9531i︠
%html
<p>Equation c means that x6 = 0, equation a means y8 =1, and equation d means that x7 = 1. &nbsp;We substitute these equations in and get the following.</p>

︡1b8d93f6-e1ae-47e3-87eb-127f3173adcc︡{"html": "<p>Equation c means that x6 = 0, equation a means y8 =1, and equation d means that x7 = 1. &nbsp;We substitute these equations in and get the following.</p>"}︡
︠69fa2426-929c-48c4-95ac-7b3313ad398f︠
%magma

A<y6,y7,x8> := AffineSpace(Rationals(),3);
b := y6 - y7 ;
e := -y7*x8 + 1 ;
f := y6 + x8 - 1 ;
C := Scheme(A,[b,e,f]);
︡404bc2a4-5f5a-48ad-8b4f-e7889f938fad︡︡
︠3b44c74e-cf76-4c25-8b90-c0b7f8f9ae7ai︠
%html
<p>#We then see that equation b means that y6 = y7.</p>

︡f4dfe98f-8e3e-4cf4-a8ce-6a92ffe5b81d︡{"html": "<p>#We then see that equation b means that y6 = y7.</p>"}︡
︠046becfd-d76f-40e7-8876-f4a1c3bea38a︠
%magma

A<y6,x8> := AffineSpace(Rationals(),2);
e := -y6*x8 + 1 ;
f := y6 + x8 - 1 ;
C := Scheme(A,[e,f]);
︡ee737c87-c315-451b-955b-635951eb6777︡︡
︠7e6cd77f-c982-4564-95f5-df9979b9edf6i︠
%html
<p>#Finally, equation f means that y6 = 1-x8. This gives a single polynomial equation in one variable.</p>

︡43b19cac-32a2-4fe9-90be-2813f5cb5d19︡{"html": "<p>#Finally, equation f means that y6 = 1-x8. This gives a single polynomial equation in one variable.</p>"}︡
︠97fab99d-c106-4fd7-b196-ae179809d863︠
%magma

A<x8> := AffineSpace(Rationals(),2);
e := -(1-x8)*x8 + 1 ;
C := Scheme(A,[e]);
print(C)
︡de0dce6a-6c9d-4edf-90f0-0dc5d78d9f1f︡{"stdout": "Scheme over Rational Field defined by\nx8^2 - x8 + 1"}︡
︠68f01438-3e77-489f-98ba-dd4ca46ddda7i︠
%html
<p>We now define the polynomial ring with two extra variables that comes up when studying the $9$-point configurations.</p>

︡72bdaf99-1925-4b99-a120-d8dd20e060b8︡{"html": "<p>We now define the polynomial ring with two extra variables that comes up when studying the $9$-point configurations.</p>"}︡
︠fa5ad7e7-8715-4c21-872f-8ca431d91362︠
R.<x6,y6,x7,y7,x8,y8,x9,y9> =  QQ[]
︡aaf70afe-3653-4176-b1ed-bcba6b1f7719︡︡
︠6443e09f-47b7-4cc0-90be-84840fed0bae︠
#This counts weak realizations of Pappus.
    
p6 = [x6,y6,1]
p7 = [x7,y7,1]
p8 = [x8,y8,1]
p9 = [x9,y9,1]

print "a :=",three_point_triple(p1,p3,p7),";"
print "b :=",three_point_triple(p1,p6,p9),";"
print "c :=",three_point_triple(p2,p4,p6),";"
print "d :=",three_point_triple(p2,p7,p8),";"
print "e :=",three_point_triple(p3,p6,p8),";"
print "f :=",three_point_triple(p4,p7,p9),";"
print "g :=",three_point_triple(p5,p8,p9),";"
︡dc488580-54af-4f3d-848f-474dbc7bd162︡{"stdout": "a := -y7 ;\nb := y6 - y9 ;\nc := x6 - 1 ;\nd := -x7 + x8 ;\ne := -y6*x8 + x6*y8 ;\nf := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;\ng := -x8 + y8 + x9 - y9 ;"}︡
︠ae70367a-f83a-4611-a2ac-a02afd42a3a1i︠
%html
<p>We now count the number of solutions to these equations.</p>

︡c008dd26-d310-4840-be07-ab4f8a920f39︡{"html": "<p>We now count the number of solutions to these equations.</p>"}︡
︠a2dd4d7b-6658-482c-a34b-f0682fd7f1ff︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);
        a := -y7 ;
        b := y6 - y9 ;
        c := x6 - 1 ;
        d := -x7 + x8 ;
        e := -y6*x8 + x6*y8 ;
        f := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;
        g := -x8 + y8 + x9 - y9 ;
        C := Scheme(A,[a,b,c,d,e,f,g]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡4c475bed-eb66-4f75-b3b2-0614b23eb5e1︡{"stdout": "[ 2, 4 ]\n[ 3, 9 ]\n[ 4, 16 ]\n[ 5, 25 ]\n[ 7, 49 ]\n[ 8, 64 ]\n[ 9, 81 ]\n[ 11, 121 ]\n[ 13, 169 ]\n[ 16, 256 ]\n[ 17, 289 ]\n[ 19, 361 ]\n[ 23, 529 ]\n[ 25, 625 ]\n[ 27, 729 ]\n[ 29, 841 ]\n[ 31, 961 ]\n[ 32, 1024 ]\n[ 37, 1369 ]\n[ 41, 1681 ]\n[ 43, 1849 ]\n[ 47, 2209 ]\n[ 49, 2401 ]"}︡
︠8abf2a90-2e0d-4bcb-bd17-781965320449i︠
%html
<p>It is pretty easy to see that the total number of solutions is $q^2$, which is not what the $9$-arcs paper gives for Pappus. &nbsp;This is because we are counting weak realizations here. &nbsp;An analysis similar to what happens above would reduce this to a form where we can see why we get $q^2$.</p>

︡8b6776b4-9a6c-4f35-8b42-a923b650ee1e︡{"html": "<p>It is pretty easy to see that the total number of solutions is $q^2$, which is not what the $9$-arcs paper gives for Pappus. &nbsp;This is because we are counting weak realizations here. &nbsp;An analysis similar to what happens above would reduce this to a form where we can see why we get $q^2$.</p>"}︡
︠8f13c524-3b37-4470-8f4b-af84cc960ebd︠
#Type 4 in 9-arcs paper.

print "a :=",three_point_triple(p1,p3,p7),";"
print "b :=",three_point_triple(p1,p6,p8),";"
print "c :=",three_point_triple(p2,p4,p9),";"
print "d :=",three_point_triple(p2,p7,p8),";"
print "e :=",three_point_triple(p3,p6,p9),";"
print "f :=",three_point_triple(p4,p6,p7),";"
print "g :=",three_point_triple(p5,p8,p9),";"
︡cabd14f4-21ab-417c-81e8-6b8b0d561c6c︡{"stdout": "a := -y7 ;\nb := y6 - y8 ;\nc := x9 - 1 ;\nd := -x7 + x8 ;\ne := -y6*x9 + x6*y9 ;\nf := -y6*x7 + x6*y7 - x6 + y6 + x7 - y7 ;\ng := -x8 + y8 + x9 - y9 ;"}︡
︠66643bf1-ae36-4956-9e04-ee3e8c42b388︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);
        a := -y7 ;
        b := y6 - y8 ;
        c := x9 - 1 ;
        d := -x7 + x8 ;
        e := -y6*x9 + x6*y9 ;
        f := -y6*x7 + x6*y7 - x6 + y6 + x7 - y7 ;
        g := -x8 + y8 + x9 - y9 ;
        C := Scheme(A,[a,b,c,d,e,f,g]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡9c68fcc9-32ec-4fa0-a7af-ce1f7a00f46f︡{"stdout": "[ 2, 3 ]\n[ 3, 4 ]\n[ 4, 5 ]\n[ 5, 9 ]\n[ 7, 11 ]\n[ 8, 15 ]\n[ 9, 16 ]\n[ 11, 21 ]\n[ 13, 23 ]\n[ 16, 29 ]\n[ 17, 33 ]\n[ 19, 35 ]\n[ 23, 45 ]\n[ 25, 47 ]\n[ 27, 52 ]\n[ 29, 57 ]\n[ 31, 59 ]\n[ 32, 63 ]\n[ 37, 71 ]\n[ 41, 81 ]\n[ 43, 83 ]\n[ 47, 93 ]\n[ 49, 95 ]"}︡
︠73ce050b-c3ec-4ddd-b624-fea13de81546i︠
%html
<p>Looking closely at these numbers a pretty straightforward guess arises. &nbsp;For $q$ odd we get $2q-2$ and for $q$ even we get $2q-1$.</p>

︡a87cc418-9b6f-416f-aff1-7415546a9b8b︡{"html": "<p>Looking closely at these numbers a pretty straightforward guess arises. &nbsp;For $q$ odd we get $2q-2$ and for $q$ even we get $2q-1$.</p>"}︡
︠f7743712-39a1-4d12-8969-b416602b8145︠
#Type 5 in 9-arcs paper.  This counts weak realizations.

print "a :=",three_point_triple(p1,p3,p8),";"
print "b :=",three_point_triple(p1,p4,p7),";"
print "c :=",three_point_triple(p2,p3,p9),";"
print "d :=",three_point_triple(p2,p6,p7),";"
print "e :=",three_point_triple(p4,p6,p9),";"
print "f :=",three_point_triple(p5,p6,p8),";"
print "g :=",three_point_triple(p7,p8,p9),";"
︡dba37ff9-80fa-4dcf-be11-e17e8f534da4︡{"stdout": "a := -y8 ;\nb := -y7 + 1 ;\nc := x9 ;\nd := -x6 + x7 ;\ne := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;\nf := -x6 + y6 + x8 - y8 ;\ng := -y7*x8 + x7*y8 + y7*x9 - y8*x9 - x7*y9 + x8*y9 ;"}︡
︠06d74a4a-b14d-479c-a04e-fdf6222d1730︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);
        a := -y8 ;
        b := -y7 + 1 ;
        c := x9 ;
        d := -x6 + x7 ;
        e := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;
        f := -x6 + y6 + x8 - y8 ;
        g := -y7*x8 + x7*y8 + y7*x9 - y8*x9 - x7*y9 + x8*y9 ;
        C := Scheme(A,[a,b,c,d,e,f,g]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡ec04fd2e-4828-46ba-9c8f-9267154fe1a1︡{"stdout": "[ 2, 3 ]\n[ 3, 4 ]\n[ 4, 7 ]\n[ 5, 8 ]\n[ 7, 12 ]\n[ 8, 15 ]\n[ 9, 16 ]\n[ 11, 20 ]\n[ 13, 24 ]\n[ 16, 31 ]\n[ 17, 32 ]\n[ 19, 36 ]\n[ 23, 44 ]\n[ 25, 48 ]\n[ 27, 52 ]\n[ 29, 56 ]\n[ 31, 60 ]\n[ 32, 63 ]\n[ 37, 72 ]\n[ 41, 80 ]\n[ 43, 84 ]\n[ 47, 92 ]\n[ 49, 96 ]"}︡
︠e055238d-ed15-4ce1-89ab-67866ab89d77i︠
%html
<p>This set of counts is exactly the same as for the previous counts.</p>

︡bd83eae4-d4a0-402e-97b3-add329d12145︡{"html": "<p>This set of counts is exactly the same as for the previous counts.</p>"}︡
︠568a4cdb-4fb6-49ff-b470-51793d514cca︠
#Type 6.  This is the same as Type 5 but with one extra line.  So, the count here should be subtracted off from the previous count.

print "a :=",three_point_triple(p1,p3,p8),";"
print "b :=",three_point_triple(p1,p4,p7),";"
print "c :=",three_point_triple(p2,p3,p9),";"
print "d :=",three_point_triple(p2,p6,p7),";"
print "e :=",three_point_triple(p4,p6,p9),";"
print "f :=",three_point_triple(p5,p6,p8),";"
print "g :=",three_point_triple(p7,p8,p9),";"
print "h :=",three_point_triple(p2,p4,p8),";"
︡e83130a4-8c4b-470e-a4a6-3a0da371a712︡{"stdout": "a := -y8 ;\nb := -y7 + 1 ;\nc := x9 ;\nd := -x6 + x7 ;\ne := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;\nf := -x6 + y6 + x8 - y8 ;\ng := -y7*x8 + x7*y8 + y7*x9 - y8*x9 - x7*y9 + x8*y9 ;\nh := x8 - 1 ;"}︡
︠1fb5cd49-6ff6-493c-bc0e-f100fbb0b5f4︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);
        a := -y8 ;
        b := -y7 + 1 ;
        c := x9 ;
        d := -x6 + x7 ;
        e := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;
        f := -x6 + y6 + x8 - y8 ;
        g := -y7*x8 + x7*y8 + y7*x9 - y8*x9 - x7*y9 + x8*y9 ;
        h := x8 - 1 ;
        C := Scheme(A,[a,b,c,d,e,f,g,h]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡9df92b22-2b05-4c05-bb76-3a0df6d360f0︡{"stdout": "[ 2, 1 ]\n[ 3, 0 ]\n[ 4, 3 ]\n[ 5, 0 ]\n[ 7, 0 ]\n[ 8, 7 ]\n[ 9, 0 ]\n[ 11, 0 ]\n[ 13, 0 ]\n[ 16, 15 ]\n[ 17, 0 ]\n[ 19, 0 ]\n[ 23, 0 ]\n[ 25, 0 ]\n[ 27, 0 ]\n[ 29, 0 ]\n[ 31, 0 ]\n[ 32, 31 ]\n[ 37, 0 ]\n[ 41, 0 ]\n[ 43, 0 ]\n[ 47, 0 ]\n[ 49, 0 ]"}︡
︠3f4c8ed5-ba7b-46c1-9396-4ae49abb7011i︠
%html
<p>It's also pretty clear what's happening here. &nbsp;For $q$ odd we get zero, and for $q$ even we get $q-1$.</p>

︡8ef14d52-20b1-4eb4-a588-20e4a6e25038︡{"html": "<p>It's also pretty clear what's happening here. &nbsp;For $q$ odd we get zero, and for $q$ even we get $q-1$.</p>"}︡
︠bcbadde6-c2d6-450d-af2a-4c48a6ae6225︠
#Type 7.

print "a :=",three_point_triple(p1,p3,p9),";"
print "b :=",three_point_triple(p1,p4,p8),";"
print "c :=",three_point_triple(p1,p6,p7),";"
print "d :=",three_point_triple(p2,p3,p6),";"
print "e :=",three_point_triple(p2,p4,p7),";"
print "f :=",three_point_triple(p4,p6,p9),";"
print "g :=",three_point_triple(p5,p6,p8),";"
print "h :=",three_point_triple(p7,p8,p9),";"
︡b9ff8bec-147f-4b77-81cc-a252a1d87cec︡{"stdout": "a := -y9 ;\nb := -y8 + 1 ;\nc := y6 - y7 ;\nd := x6 ;\ne := x7 - 1 ;\nf := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;\ng := -x6 + y6 + x8 - y8 ;\nh := -y7*x8 + x7*y8 + y7*x9 - y8*x9 - x7*y9 + x8*y9 ;"}︡
︠44e4db14-fb8e-4296-9bd4-694d48320779︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);
        a := -y9 ;
        b := -y8 + 1 ;
        c := y6 - y7 ;
        d := x6 ;
        e := x7 - 1 ;
        f := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;
        g := -x6 + y6 + x8 - y8 ;
        h := -y7*x8 + x7*y8 + y7*x9 - y8*x9 - x7*y9 + x8*y9 ;
        C := Scheme(A,[a,b,c,d,e,f,g,h]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡46a8dbea-ad85-4af1-9f78-ada060366865︡{"stdout": "[ 2, 0 ]\n[ 3, 0 ]\n[ 4, 0 ]\n[ 5, 2 ]\n[ 7, 0 ]\n[ 8, 0 ]\n[ 9, 2 ]\n[ 11, 0 ]\n[ 13, 2 ]\n[ 16, 0 ]\n[ 17, 2 ]\n[ 19, 0 ]\n[ 23, 0 ]\n[ 25, 2 ]\n[ 27, 0 ]\n[ 29, 2 ]\n[ 31, 0 ]\n[ 32, 0 ]\n[ 37, 2 ]\n[ 41, 2 ]\n[ 43, 0 ]\n[ 47, 0 ]\n[ 49, 2 ]"}︡
︠7c489760-947f-4a49-87ea-5190e59eb7fai︠
%html
<p>This seems to only occur for $q \equiv 0, \pm 1 \pmod{5}$.</p>

︡4f154025-4e34-4205-ae79-3be7bacde541︡{"html": "<p>This seems to only occur for $q \\equiv 0, \\pm 1 \\pmod{5}$.</p>"}︡
︠c9035b16-357f-45e3-b7bf-c09de79a9060︠
#Pappus with one extra line.  Again, weak realizations.

print "a :=",three_point_triple(p1,p3,p7),";"
print "b :=",three_point_triple(p1,p6,p9),";"
print "c :=",three_point_triple(p2,p4,p6),";"
print "d :=",three_point_triple(p2,p7,p8),";"
print "e :=",three_point_triple(p3,p6,p8),";"
print "f :=",three_point_triple(p4,p7,p9),";"
print "g :=",three_point_triple(p5,p8,p9),";"
print "h :=",three_point_triple(p2,p3,p9),";"
︡dd39c6c5-752e-4810-b78b-b9909c9cc242︡{"stdout": "a := -y7 ;\nb := y6 - y9 ;\nc := x6 - 1 ;\nd := -x7 + x8 ;\ne := -y6*x8 + x6*y8 ;\nf := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;\ng := -x8 + y8 + x9 - y9 ;\nh := x9 ;"}︡
︠b3c83666-1371-403a-9747-51ec4b7ae197︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);       	
        a := -y7 ;
        b := y6 - y9 ;
        c := x6 - 1 ;
        d := -x7 + x8 ;
        e := -y6*x8 + x6*y8 ;
        f := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;
        g := -x8 + y8 + x9 - y9 ;
        h := x9 ;
        C := Scheme(A,[a,b,c,d,e,f,g,h]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡2411f86e-0c4a-4f1f-a0ce-7ab77d0c3b9f︡{"stdout": "[ 2, 1 ]\n[ 3, 2 ]\n[ 4, 3 ]\n[ 5, 4 ]\n[ 7, 6 ]\n[ 8, 7 ]\n[ 9, 8 ]\n[ 11, 10 ]\n[ 13, 12 ]\n[ 16, 15 ]\n[ 17, 16 ]\n[ 19, 18 ]\n[ 23, 22 ]\n[ 25, 24 ]\n[ 27, 26 ]\n[ 29, 28 ]\n[ 31, 30 ]\n[ 32, 31 ]\n[ 37, 36 ]\n[ 41, 40 ]\n[ 43, 42 ]\n[ 47, 46 ]\n[ 49, 48 ]"}︡
︠6b0f9611-b6d6-42be-a301-877a0a6b85b1i︠
%html
<p>This seems to give $q-1$ for any value of $q$.</p>

︡b7f4ed51-3f00-44e2-a1d4-0824aa3df160︡{"html": "<p>This seems to give $q-1$ for any value of $q$.</p>"}︡
︠d9e85e34-fe3e-46b5-812a-13536d74289f︠
#Type 9: Pappus plus two extra lines, weak realizations.  This is the 'nonrepresentable' one in the 9-arcs paper.


print "a :=",three_point_triple(p1,p3,p7),";"
print "b :=",three_point_triple(p1,p6,p9),";"
print "c :=",three_point_triple(p2,p4,p6),";"
print "d :=",three_point_triple(p2,p7,p8),";"
print "e :=",three_point_triple(p3,p6,p8),";"
print "f :=",three_point_triple(p4,p7,p9),";"
print "g :=",three_point_triple(p5,p8,p9),";"
print "h :=",three_point_triple(p2,p3,p9),";"
print "i :=",three_point_triple(p1,p4,p8),";"
︡531c9d68-8769-412b-96fa-826082510f41︡{"stdout": "a := -y7 ;\nb := y6 - y9 ;\nc := x6 - 1 ;\nd := -x7 + x8 ;\ne := -y6*x8 + x6*y8 ;\nf := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;\ng := -x8 + y8 + x9 - y9 ;\nh := x9 ;\ni := -y8 + 1 ;"}︡
︠ad2f8ae1-f15e-43e3-ae90-d7b35cc4b80b︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);       	
        a := -y7 ;
        b := y6 - y9 ;
        c := x6 - 1 ;
        d := -x7 + x8 ;
        e := -y6*x8 + x6*y8 ;
        f := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;
        g := -x8 + y8 + x9 - y9 ;
        h := x9 ;
        i := -y8 + 1 ;
        C := Scheme(A,[a,b,c,d,e,f,g,h,i]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡b5d4cf4b-5a7e-4459-a677-b1e73356de2f︡{"stdout": "[ 2, 0 ]\n[ 3, 1 ]\n[ 4, 2 ]\n[ 5, 0 ]\n[ 7, 2 ]\n[ 8, 0 ]\n[ 9, 1 ]\n[ 11, 0 ]\n[ 13, 2 ]\n[ 16, 2 ]\n[ 17, 0 ]\n[ 19, 2 ]\n[ 23, 0 ]\n[ 25, 2 ]\n[ 27, 1 ]\n[ 29, 0 ]\n[ 31, 2 ]\n[ 32, 0 ]\n[ 37, 2 ]\n[ 41, 0 ]\n[ 43, 2 ]\n[ 47, 0 ]\n[ 49, 2 ]"}︡
︠bf7f9ea5-1783-45ad-8717-84e57b9eede5i︠
%html
<p>This seems to depend on $q$ modulo $3$. &nbsp;As above, doing the substitutions described above would give the relevant polynomial.</p>

︡0a2673a3-5dbc-4eba-9138-097d5d020fed︡{"html": "<p>This seems to depend on $q$ modulo $3$. &nbsp;As above, doing the substitutions described above would give the relevant polynomial.</p>"}︡
︠5696e77e-d20d-43d7-8209-ca14fa73368f︠
#AG(2,3).  That is, Pappus plus all the extra lines.

print "a :=",three_point_triple(p1,p3,p7),";"
print "b :=",three_point_triple(p1,p6,p9),";"
print "c :=",three_point_triple(p2,p4,p6),";"
print "d :=",three_point_triple(p2,p7,p8),";"
print "e :=",three_point_triple(p3,p6,p8),";"
print "f :=",three_point_triple(p4,p7,p9),";"
print "g :=",three_point_triple(p5,p8,p9),";"
print "h :=",three_point_triple(p2,p3,p9),";"
print "i :=",three_point_triple(p1,p4,p8),";"
print "j :=",three_point_triple(p5,p6,p7),";"
︡9fc8ba4f-02d8-4b79-95b8-955b16d93600︡{"stdout": "a := -y7 ;\nb := y6 - y9 ;\nc := x6 - 1 ;\nd := -x7 + x8 ;\ne := -y6*x8 + x6*y8 ;\nf := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;\ng := -x8 + y8 + x9 - y9 ;\nh := x9 ;\ni := -y8 + 1 ;\nj := -x6 + y6 + x7 - y7 ;"}︡
︠51e08904-e607-45e6-9082-5d85bb0d46e2︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);       	
        a := -y7 ;
        b := y6 - y9 ;
        c := x6 - 1 ;
        d := -x7 + x8 ;
        e := -y6*x8 + x6*y8 ;
        f := -y7*x9 + x7*y9 - x7 + y7 + x9 - y9 ;
        g := -x8 + y8 + x9 - y9 ;
        h := x9 ;
        i := -y8 + 1 ;
        j := -x6 + y6 + x7 - y7 ;
        C := Scheme(A,[a,b,c,d,e,f,g,h,i,j]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡fa7f86fc-c044-4531-8ec4-2422eb1e792f︡{"stdout": "[ 2, 0 ]\n[ 3, 1 ]\n[ 4, 2 ]\n[ 5, 0 ]\n[ 7, 2 ]\n[ 8, 0 ]\n[ 9, 1 ]\n[ 11, 0 ]\n[ 13, 2 ]\n[ 16, 2 ]\n[ 17, 0 ]\n[ 19, 2 ]\n[ 23, 0 ]\n[ 25, 2 ]\n[ 27, 1 ]\n[ 29, 0 ]\n[ 31, 2 ]\n[ 32, 0 ]\n[ 37, 2 ]\n[ 41, 0 ]\n[ 43, 2 ]\n[ 47, 0 ]\n[ 49, 2 ]"}︡
︠bf1f3e8e-c2c9-408e-93e9-fd4293c8b382i︠
%html
<p>This is exactly the same set of numbers as for the previous set of lines. &nbsp;This means that there are no strong realizations of the previous point-line incidence structure.</p>

︡bfd9d638-3d73-4acd-8119-8fe79d1d9caa︡{"html": "<p>This is exactly the same set of numbers as for the previous set of lines. &nbsp;This means that there are no strong realizations of the previous point-line incidence structure.</p>"}︡
︠0eb77be2-f303-4e74-970e-3ba8b5337b04︠
#Type 11.


print "a :=",three_point_triple(p1,p3,p6),";"
print "b :=",three_point_triple(p1,p3,p8),";"
print "c :=",three_point_triple(p1,p4,p7),";"
print "d :=",three_point_triple(p2,p3,p9),";"
print "e :=",three_point_triple(p2,p7,p8),";"
print "f :=",three_point_triple(p4,p6,p9),";"
print "g :=",three_point_triple(p5,p6,p7),";"
print "h :=",three_point_triple(p5,p8,p9),";"
︡e0df16e8-8508-49c9-a85c-bf3422c4450c︡{"stdout": "a := -y6 ;\nb := -y8 ;\nc := -y7 + 1 ;\nd := x9 ;\ne := -x7 + x8 ;\nf := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;\ng := -x6 + y6 + x7 - y7 ;\nh := -x8 + y8 + x9 - y9 ;"}︡
︠2333498c-1ca6-4391-b1fa-bd28f8d296a5︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);       	
        a := -y6 ;
        b := -y8 ;
        c := -y7 + 1 ;
        d := x9 ;
        e := -x7 + x8 ;
        f := -y6*x9 + x6*y9 - x6 + y6 + x9 - y9 ;
        g := -x6 + y6 + x7 - y7 ;
        h := -x8 + y8 + x9 - y9 ;
        C := Scheme(A,[a,b,c,d,e,f,g,h]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡3d5ba14d-cb7e-4935-b31c-7e1bd47f9832︡{"stdout": "[ 2, 0 ]\n[ 3, 0 ]\n[ 4, 2 ]\n[ 5, 1 ]\n[ 7, 0 ]\n[ 8, 0 ]\n[ 9, 2 ]\n[ 11, 2 ]\n[ 13, 0 ]\n[ 16, 2 ]\n[ 17, 0 ]\n[ 19, 2 ]\n[ 23, 0 ]\n[ 25, 1 ]\n[ 27, 0 ]\n[ 29, 2 ]\n[ 31, 2 ]\n[ 32, 0 ]\n[ 37, 0 ]\n[ 41, 2 ]\n[ 43, 0 ]\n[ 47, 0 ]\n[ 49, 2 ]"}︡
︠a957cc13-82ea-41b5-9fca-3cce0dab434ei︠
%html
<p>Again, pretty clearly quasipolynomial depending on $q$ modulo $5$.</p>

︡6f979a2e-88e4-446f-8e42-d464a33a7506︡{"html": "<p>Again, pretty clearly quasipolynomial depending on $q$ modulo $5$.</p>"}︡
︠a1fb8af3-8359-4da1-9b3b-b52ada6caa78︠
#Type 12.


print "a :=",three_point_triple(p1,p4,p6),";"
print "b :=",three_point_triple(p1,p4,p8),";"
print "c :=",three_point_triple(p1,p7,p9),";"
print "d :=",three_point_triple(p2,p3,p6),";"
print "e :=",three_point_triple(p2,p3,p9),";"
print "f :=",three_point_triple(p2,p4,p7),";"
print "g :=",three_point_triple(p3,p7,p8),";"
print "h :=",three_point_triple(p5,p6,p7),";"
print "i :=",three_point_triple(p5,p8,p9),";"
︡50d24c95-cacf-4562-a685-eb0c88ac4db3︡{"stdout": "a := -y6 + 1 ;\nb := -y8 + 1 ;\nc := y7 - y9 ;\nd := x6 ;\ne := x9 ;\nf := x7 - 1 ;\ng := -y7*x8 + x7*y8 ;\nh := -x6 + y6 + x7 - y7 ;\ni := -x8 + y8 + x9 - y9 ;"}︡
︠69bdf763-6277-48bb-b859-e93e9ef85a12︠
%magma
for p := 2 to 50 do
    if IsPrimePower(p) then
        A<x6,y6,x7,y7,x8,y8,x9,y9> := AffineSpace(FiniteField(p),8);       	
        a := -y6 + 1 ;
        b := -y8 + 1 ;
        c := y7 - y9 ;
        d := x6 ;
        e := x9 ;
        f := x7 - 1 ;
        g := -y7*x8 + x7*y8 ;
        h := -x6 + y6 + x7 - y7 ;
        i := -x8 + y8 + x9 - y9 ;
        C := Scheme(A,[a,b,c,d,e,f,g,h,i]);
        print([p,#RationalPoints(C)]);
    end if;
end for;
︡a5eee53f-a436-4c41-8ff5-2b0f5da96564︡{"stdout": "[ 2, 0 ]\n[ 3, 1 ]\n[ 4, 0 ]\n[ 5, 0 ]\n[ 7, 0 ]\n[ 8, 0 ]\n[ 9, 1 ]\n[ 11, 0 ]\n[ 13, 0 ]\n[ 16, 0 ]\n[ 17, 0 ]\n[ 19, 0 ]\n[ 23, 0 ]\n[ 25, 0 ]\n[ 27, 1 ]\n[ 29, 0 ]\n[ 31, 0 ]\n[ 32, 0 ]\n[ 37, 0 ]\n[ 41, 0 ]\n[ 43, 0 ]\n[ 47, 0 ]\n[ 49, 0 ]"}︡









