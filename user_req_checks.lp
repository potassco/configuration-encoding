%%%%%%%%%%%%%%%%%%%%%%%%%
%%% User requirements check
%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: How can users specify objects and how can the correctness be checked?
% :- type(T), object(O), not objecttype(O,T).

% Given attribute values have to lie inside range (TODO: Distinguish between user given)
% :- val((O,D),V), attr(T,D), object(O,T), not dom(T,D,V).

% Check that all objects have values assigned (totality)?
