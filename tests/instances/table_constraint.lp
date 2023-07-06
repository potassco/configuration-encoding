type(bike). type(bag).
part(bike,bag,bags).
multiplicity(bike,bag,bags,2).

attr(bike,color).
dom(bike,color,("red";"yellow";"green")).
attr(bag,color).
dom(bag,color,("red";"yellow";"green")).

% constraint((bike,0)).
% column((bike,0),0,(color,())). column((bike,0),1,(color,(bags,()))).
% entry((bike,0),(0,0),"red").     entry((bike,0),(1,0),"red").
% entry((bike,0),(0,1),"red").     entry((bike,0),(1,1),"yellow").
% entry((bike,0),(0,2),"green").   entry((bike,0),(1,2),"green").
% entry((bike,0),(0,3),"green").   entry((bike,0),(1,3),"yellow").

constraint((bike,0)).
column((bike,0),0,(color,())). column((bike,0),1,(color,(bags,()))).
entry((bike,0),(0,0),"red").     entry((bike,0),(1,0),("red";"yellow")).
entry((bike,0),(0,1),"green").   entry((bike,0),(1,1),("green";"yellow")).
