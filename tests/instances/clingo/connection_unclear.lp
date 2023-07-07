%%% Unclear what the desired behavior should be here.
%%% Can objects be connected to themselves?
type(a). type(b).
part(a,b,b).
multiplicity(a,b,b,3).

connection(b,b,c).
multiplicity(b,b,c,1).
