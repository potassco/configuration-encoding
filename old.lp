% association((travel_bike,0),(wheel,0),"front_wheel").
% association((travel_bike,0),(wheel,1),"rear_wheel").
% association((travel_bike,0),(frame,0),"frame").
% association((travel_bike,0),(carrier,0),"carrier").
% association((frame,0),(bag,0),"bags").
% association((frame,0),(bag,1),"bags").
% association((carrier,0),(bag,2),"bags").
% There cannot be an association without a corresponding part relationship (hard constraint)
% :- association((S,_),(T,_),D), not part(S,T,D,_,_).

% val(((wheel,0),"size"),27).
% val(((wheel,1),"size"),27).
% val(((wheel,0),"weight"),2100).
% val(((wheel,1),"weight"),2100).

% val(((bag,0),"volume"),20).
% val(((bag,0),"material"),"Cotton").
% val(((bag,1),"material"),"Leather").


% % Assign values to attribute variables
% % { val(((T,I),D),V) : attr(T,D,V) } = 1:- object((T,I)), attr(T,D).

% %%% Table constraints

% % Chosen values need to be in the same row (for an object and a corresponding constraint)
% row((T,I),J,K) :- object((T,I)), val(((T,I),D),V), constraint(T,J,(D),K,V).
% % unsat((T,I),J) :- object((T,I)), constraint(T,J), not row((T,I),J,_).
% unsat(O,J) :- row(O,J,K), row(O,J,K2), K < K2.

% :- unsat(O,J).

% % Check partonomic cardinalities
% count(S,T,D,X) :- part(S,T,D,Min,Max), X = #count { IS,IT : association((S,IS),(T,IT),D) }.

% constraint(travel_bike,"total_bags","count").
% path(travel_bike,"total_bags",("frame","bags")).
% path(travel_bike,"total_bags",("carrier","bags")).



% % Selectors
% selector((travel_bike,0),(),(travel_bike,0)).
% selector((travel_bike,0),("frame"),(frame,0)).
% selector((travel_bike,0),("frame","bags"),(bag,0)).
% selector((travel_bike,0),("frame","bags"),(bag,1)).

% selector((travel_bike,0),("carrier"),(carrier,0)).
% selector((travel_bike,0),("carrier","bags"),(bag,2)).

% agg((T,I),D,P,V) :- object((T,I)), constraint(T,D,"count"), path(T,D,P), V = #count { O' : selector(O,P,O') }.
% agg((T,I),D,V) :- object((T,I)), constraint(T,D,"count"), V = #sum { V',P : agg((T,I),D,P,V') }.
% % Aggregate constraints
% % agg(T,D) :- constraint(T,D,"count"), type(T), attr(T,D), X = #count {association(),path(T,D,)}.



% % #show attr/3.
% #show agg/3.
% #show agg/4.
% % #show unsat/4.
