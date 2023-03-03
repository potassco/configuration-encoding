%%% Model
type(bike). type(bag).
part(bike,bag,bags,0,2).

attr(bike,color).
attr(bike,color,("red";"yellow";"green")).
attr(bag,color).
attr(bag,color,("red";"yellow";"green")).

constraint(bike,0).
constraint(bike,0,(color,()),0,"red"). constraint(bike,0,(color,(bags,())),0,("red";"yellow")).
constraint(bike,0,(color,()),1,"green"). constraint(bike,0,(color,(bags,())),1,("green";"yellow")).
% constraint(bike,0,(color,()),1,"green"). constraint(bike,0,(color,(bag,())),1,"yellow").

%%% Alternative constraint formats
% constraint((bike,0)).
% constraint((bike,0),0,(color,())). constraint((bike,0),1,(color,(bags,()))).
% constraint((bike,0),0,0,"red"). constraint((bike,0),1,0,("red";"yellow")).
% constraint((bike,0),0,1,"green"). constraint((bike,0),1,1,("green";"yellow")).

% constraint((bike,0)).
% constraint((bike,0),0,(color,())). constraint((bike,0),1,(color,(bags,()))).
% constraint((bike,0),0,0,"red"). constraint((bike,0),1,0,"red").
% constraint((bike,0),0,1,"red"). constraint((bike,0),1,1,"yellow").
% constraint((bike,0),0,2,"green"). constraint((bike,0),1,2,"green").
% constraint((bike,0),0,3,"green"). constraint((bike,0),1,3,"yellow").

%%% Instantiation
object(()).
object((bags,((),0))).
object((bags,((),1))).

val(((),color),"red").
val(((bags,((),0)),color),"red").
val(((bags,((),1)),color),"yellow").

