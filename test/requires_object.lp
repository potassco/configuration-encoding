%%% Model
type(bike). type(wheel). type(bag).
part(bike,wheel,wheels,1,1).
part(bike,bag,bags,0,2).

attr(wheel,size).
dom(wheel,size,(25;27)).
attr(bag,volume).
dom(bag,volume,(10;20;50)).

% TODO: A wheel of size 21 requires training wheels (object)
% OR: A city bike requires a basket
constraint((bike,0),"requires").
condition((bike,0),(size,(wheels,())),25).
requires((bike,0),(volume,(bag,())),10).
