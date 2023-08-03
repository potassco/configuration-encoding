% Partonomy has to be acyclic and rooted
partonomic_path(X,Y) :- part(X,Y,_).
partonomic_path(X,Z) :- partonomic_path(X,Y), partonomic_path(Y,Z).
:- partonomic_path(X,X).

root(T) :- type(T), not partonomic_path(_,T).
:- {root(T)} > 1.

% Generate maximal object tree
object((),T) :- root(T).
object((D,(O,0..Max-1)),T) :- object(O,S), part(S,T,D), Max = #max { N : multiplicity(S,T,D,N)}.
object(O) :- object(O,T).

% Select subtree (root has to be selected)
selected((),T) :- root(T).
{ selected(O,T) : object(O,T) }.
selected(O) :- selected(O,_).

% You can only select an object if its "parent object" is selected as well
:- selected(O1), O1 = (_,(O2,_)), not selected(O2).

% Select such that indices are in ascending order
:- selected((D,(O,I))), not selected((D,(O,I-1))), I > 0.

% Select at least minimal number of required objects
selected((D,(O,0..Min-1)),T) :- selected(O,S), part(S,T,D), Min = #min { N : multiplicity(S,T,D,N)}.

% Check part multiplicities
:- part(S,T,D), not multiplicity(S,T,D,X), selected(O,S), X = #count { I : selected((D,(O,I)),T) }.

% Create all possible connection ports and select
association(O1,O2,D,"connection") :- connection(S,T,D), object(O1,S), object(O2,T).
{ connected(O1,O2,D) : association(O1,O2,D,"connection") }.

:- connected(O1,O2,_), not selected(O1).
:- connected(O1,O2,_), not selected(O2).

% :- connected(O,O,_). % Should this be allowed or not?

% Check connection multiplicities
:- connection(S,T,D), not multiplicity(S,T,D,X),
   selected(O1,S), X = #count { O2 : connected(O1,O2,D) }.

% Assign values to attribute variables
{ val((O,D),V) : dom(T,D,V) } :- selected(O,T), attr(T,D,"discrete").
&fin{ Min..Max } =: (O,D) :- selected(O,T), attr(T,D,"numeric"), dom(T,D,Min,Max).

% Exactly one value has to be assigned for an attribute variable
:- attr(T,D,"discrete"), selected(O,T), not val((O,D),_).
:- val(X,V1), val(X,V2), V1 < V2.

%%% Selectors
% An object selector (O,P,O') selects
%   all objects O' which lie on
%   path P relative to object O
selector(O,(),O) :- object(O).
selector(O,(D,P),(D,(O',I))):- selector(O,P,O'), object((D,(O',I))).

% An attribute selector (O,P,X) selects
%   all attribute variables X which lie on
%   path P relative to object O
selector(O,(D,P),(O',D)) :- selector(O,P,O'), object(O',T), attr(T,D,_).

%%% Aggregates
% Count
% TODO: Implement for discrete attributes
% val((O,D),V) :- object(O,T), attr(T,D,"count"), V = #count { O',P : path(T,D,P), selector(O,P,O') }.
&fsum{ 1,O' : path(T,D,P), selector(O,P,O'), selected(O') } =: (O,D) :- selected(O,T), attr(T,D,"count").
% Sum
&fsum{ X : path(T,D,P), selector(O,P,X) } =: (O,D) :- selected(O,T), attr(T,D,"sum").
% Min
&fmin{ X : path(T,D,P), selector(O,P,X) } =: (O,D) :- selected(O,T), attr(T,D,"min").
% Max
&fmax{ X : path(T,D,P), selector(O,P,X) } =: (O,D) :- selected(O,T), attr(T,D,"max").

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Table constraints
path_expansion((O,C),Col,(X,())) :- column((T,C),Col,P), selector(O,P,X), X=(O',_), not column((T,C),Col+1,_),
                                    selected(O,T), selected(O').
path_expansion((O,C),Col,(X',X)) :- path_expansion((O,C),Col+1,X), column((T,C),Col,P), Col>=0, selector(O,P,X'), X' = (O',_),
                                    selected(O,T), selected(O').
path_expansion((O,C),GP)         :- path_expansion((O,C),0,GP).

in_path((X,GP'),GP',X) :- path_expansion(_,(X,GP')).
in_path(GP,GP',X)      :- in_path(GP,(X,GP'),_).
in_path(GP,X)          :- in_path(GP,_,X).

non_numeric(X) :- object(O,T), attr(T,D,"discrete"), X=(O,D).

hit_cell((O,C),GP,(Col,Row)) :- entry((T,C),(Col,Row),V), column((T,C),Col,P), selector(O,P,X), X = (O',_),
                                selected(O,T), selected(O'), val(X,V), non_numeric(X),
                                path_expansion((O,C),GP), in_path(GP,X).
hit_cell((O,C),GP,(Col,Row)) :- entry((T,C),(Col,Row),V), column((T,C),Col,P), selector(O,P,X), X = (O',_),
                                selected(O,T), selected(O'), &fsum{X} = V, not non_numeric(X),
                                path_expansion((O,C),GP), in_path(GP,X).
hit_row((O,C),GP,Row) :- entry((T,C),(_,Row),_), 0 = #sum{ 1,Col: entry((T,C),(Col,Row),_); -1,Col': hit_cell((O,C),GP,(Col',Row)) },
                         selected(O,T), path_expansion((O,C),GP).

:- constraint((T,C),"table"), selected(O,T), path_expansion((O,C),GP), not hit_row((O,C),GP,_).

%%% Comparison constraints
left_compare((O,C),Op,(O',D))  :- constraint((T,C),Op), left((T,C),P), selector(O,P,(O',D)), selected(O,T), selected(O').
right_compare((O,C),Op,(O',D)) :- constraint((T,C),Op), right((T,C),P),selector(O,P,(O',D)), selected(O,T), selected(O').

left_compare((O,C),Op,P)  :- constraint((T,C),Op), left((T,C),P), P = constant(N), selected(O,T).
right_compare((O,C),Op,P) :- constraint((T,C),Op), right((T,C),P),P = constant(N), selected(O,T).

% Auxiliary val atoms for comparison with constants
% TODO: Is there are a simpler way to declare constants?
&fsum{N} =: P :- left_compare(_,_,P), P=constant(N).
&fsum{N} =: P :- right_compare(_,_,P), P=constant(N).

% TODO: Implement this for discrete attributes as well

&fsum{X1} = X2 :- left_compare(C,"eq",X1),  right_compare(C,"eq",X2).
&fsum{X1} !=X2 :- left_compare(C,"neq",X1), right_compare(C,"neq",X2).
&fsum{X1} < X2 :- left_compare(C,"lt",X1),  right_compare(C,"lt",X2).
&fsum{X1} <=X2 :- left_compare(C,"lte",X1), right_compare(C,"lte",X2).
&fsum{X1} > X2 :- left_compare(C,"gt",X1),  right_compare(C,"gt",X2).
&fsum{X1} >=X2 :- left_compare(C,"gte",X1), right_compare(C,"gte",X2).

% Define statements
#defined type/1.
#defined part/3.
#defined multiplicity/4.
#defined connection/3.
#defined connected/2.
#defined connected/3.
#defined attr/2.
#defined attr/3.
#defined dom/3.
#defined dom/4.
#defined path/3.
#defined constraint/2.
#defined column/3.
#defined entry/3.
#defined left/2.
#defined right/2.

#show selected/2.
#show val/2.
&show {(O,D) : object(O,T), attr(T,D,_), not non_numeric((O,D))}.
#show connected/3.
