%%% Model
type(bike).
type(frame).
type(wheel).

part(bike,wheel,front_wheel,1,1).
part(bike,wheel,rear_wheel,1,1).

%%% Instantiation
object(()).
object((front_wheel,((),0))).
object((rear_wheel,((),0))).
