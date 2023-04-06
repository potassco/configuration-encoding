%%% Model
type(bike). type(basket). %type(wheel).
% part(bike,wheel,wheels,1,1).
part(bike,basket,basket,0,1).

attr(bike,type).
dom(bike,type,("city";"race")).
% attr(wheel,size).
% dom(wheel,size,(25;27)).

% TODO: A race bike is incompatible with a basket (but a city bike does not require one)
constraint((bike,0),"table").
column((bike,0),0,(type,()))
condition((bike,0),(type,()),"city").
requires((bike,0),((basket,()))).
