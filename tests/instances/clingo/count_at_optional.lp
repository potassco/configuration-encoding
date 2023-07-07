% Count attribute for an optional part
type(a). type(b). type(c).
part(a,b,b).
multiplicity(a,b,b,0..1).
part(b,c,c).
multiplicity(b,c,c,1).

attr(b,cou,"count").
path(b,cou,(c,())).
