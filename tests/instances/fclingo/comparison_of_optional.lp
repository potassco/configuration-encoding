type(a). type(b).
part(a,b,b).
multiplicity(a,b,b,(0;2)).

% attr(b,c,"discrete").
% dom(b,c,1..2).

attr(b,c,"numeric").
dom(b,c,1,2).

constraint((a,0),"eq").
    left((a,0),  (c,(b,()))).
    right((a,0), (c,(b,()))).
