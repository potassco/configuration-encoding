%%% Types
type(pc).
type(internet_conn).
type(hd_unit).
type(hd_disk).
type(disk_port).
type(hd_controller).
type(controller_port).
type(mainboard).
type(cpu).
type(screen).
type(os).
type(application).

%%% Partonomy
part(pc,internet_conn,internet,0,1).
part(pc,hd_unit,hd_unit,1,2).
part(pc,mainboard,mb,1,1).
part(pc,screen,screen,1,2).
part(pc,os,os,1,1).
part(pc,application,app,1,#sup).
part(hd_unit,hd_disk,hd_disk,1,4).
part(hd_disk,disk_port,disk_port,1,1).
part(hd_unit,hd_controller,hd_controller,1,2).
part(hd_controller,controller_port,controller_port,4,4).
part(mainboard,cpu,cpu,1,2).

%%% Connections


%%% Attributes
attr(pc,usage).
attr(pc,efficiency).
attr(pc,price,"sum").
attr(internet_conn,price).
attr(hd_unit,price,"sum").
attr(hd_disk,type).
attr(hd_disk,capacity).
attr(hd_disk,price).
attr(hd_controller,type).
attr(hd_controller,price).
attr(mb,efficiency).
attr(mb,price).
attr(cpu,clockrate).
attr(cpu,price).
attr(screen,efficiency).
attr(screen,price).
attr(os,hd_capacity).
attr(os,price).
attr(application,hd_capacity).
attr(application,price).

dom(pc,usage,("internet";"scientific","multimedia")).
dom(pc,efficiency,("A","B","C")).
dom(internet_conn,price,50).
dom(hd_disk,type,("MedStoreDisk";"MaxStoreDisk")).
dom(hd_disk,capacity,(200;1000)).
dom(hd_disk,price,(200;500)).
dom(hd_controller,type,("MedStoreC";"MaxStoreC")).
dom(hd_controller,price,500).
dom(mb,efficiency,("A";"B")).
dom(mb,price,(250;350)).
dom(cpu,clockrate,("medium","fast")).
dom(cpu,price,(100,150)).
dom(screen,efficiency,("A";"B";"C")).
dom(screen,price,(100;150;200)).
dom(os,hd_capacity,(6;13)).
dom(os,price,(100;500)).
dom(application,hd_capacity,200).
dom(application,price,50).

%%% Aggregate paths
path(pc,price,(price,(internet_conn,()))).
path(pc,price,(price,(hd_unit,()))).
path(pc,price,(price,(mb,()))).
path(pc,price,(price,(screen,()))).
path(pc,price,(price,(os,()))).
path(pc,price,(price,(app,()))).

path(hd_unit,price,(price,(hd_disk,()))).
path(hd_unit,price,(price,(hd_controller,()))).

%%% Constraints
constraint((pc,0),"lte").
left((pc,0),(price,())).
right((pc,0),constant(2500)).

