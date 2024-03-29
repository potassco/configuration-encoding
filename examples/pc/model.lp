%%% Types
type(pc).
type(internet_conn).
type(hd_unit).
type(hd_disk).
type(disk_port).
type(hd_controller).
type(controller_port).
type(mb).
type(cpu).
type(screen).
type(os).
type(app).

%%% Partonomy
part(pc,internet_conn,internet).
multiplicity(pc,internet_conn,internet,0).
multiplicity(pc,internet_conn,internet,1).

part(pc,hd_unit,hd_unit).
multiplicity(pc,hd_unit,hd_unit,1).
multiplicity(pc,hd_unit,hd_unit,2).

part(pc,mb,mb).
multiplicity(pc,mb,mb,1).

part(pc,screen,screen).
multiplicity(pc,screen,screen,1).
multiplicity(pc,screen,screen,2).

part(pc,os,os).
multiplicity(pc,os,os,1).

part(pc,app,app).
multiplicity(pc,app,app,1).
multiplicity(pc,app,app,2).
multiplicity(pc,app,app,3).
multiplicity(pc,app,app,4).
multiplicity(pc,app,app,5).

part(hd_unit,hd_disk,hd_disk).
multiplicity(hd_unit,hd_disk,hd_disk,1).
multiplicity(hd_unit,hd_disk,hd_disk,2).
multiplicity(hd_unit,hd_disk,hd_disk,3).
multiplicity(hd_unit,hd_disk,hd_disk,4).

part(hd_disk,disk_port,disk_port).
multiplicity(hd_disk,disk_port,disk_port,1).

part(hd_unit,hd_controller,hd_controller).
multiplicity(hd_unit,hd_controller,hd_controller,1).
multiplicity(hd_unit,hd_controller,hd_controller,2).

part(hd_controller,controller_port,controller_port).
multiplicity(hd_controller,controller_port,controller_port,4).

part(mb,cpu,cpu).
multiplicity(mb,cpu,cpu,1).
multiplicity(mb,cpu,cpu,2).

%%% Connections
connection(disk_port,controller_port,connected).
multiplicity(disk_port,controller_port,connected,1).

%%% Attributes
attr(pc,usage,"discrete").
dom(pc,usage,("internet";"scientific","multimedia")).

attr(pc,efficiency,"discrete").
dom(pc,efficiency,("A","B","C")).

attr(pc,price,"sum"). % constraint prc1
attr(pc,total_capacity,"sum"). % for constraint resc2
attr(pc,capacity_used,"sum"). % for constraint resc2

attr(internet_conn,price,"discrete").
dom(internet_conn,price,50).

attr(hd_unit,price,"sum"). % constraint prc2

attr(hd_disk,type,"discrete").
dom(hd_disk,type,("MedStoreDisk";"MaxStoreDisk")).

attr(hd_disk,capacity,"discrete").
dom(hd_disk,capacity,(200;1000)).

attr(hd_disk,price,"discrete").
dom(hd_disk,price,(200;500)).

attr(hd_controller,type,"discrete").
dom(hd_controller,type,("MedStoreC";"MaxStoreC")).

attr(hd_controller,price,"discrete").
dom(hd_controller,price,500).

attr(mb,type,"discrete").
dom(mb,type,("MBSilver";"MBDiamond")).

attr(mb,efficiency,"discrete").
dom(mb,efficiency,("A";"B")).

attr(mb,price,"discrete").
dom(mb,price,(250;350)).

attr(cpu,type,"discrete").
dom(cpu,type,("CPUD";"CPUS")).

attr(cpu,clockrate,"discrete").
dom(cpu,clockrate,("medium","fast")).

attr(cpu,price,"discrete").
dom(cpu,price,(100,150)).

attr(screen,efficiency,"discrete").
dom(screen,efficiency,("A";"B";"C")).

attr(screen,price,"discrete").
dom(screen,price,(100;150;200)).

attr(os,type,"discrete").
dom(os,type,("OSBeta";"OSAlpha")).

attr(os,hd_capacity,"discrete").
dom(os,hd_capacity,(6;13)).

attr(os,price,"discrete").
dom(os,price,(100;500)).

attr(app,hd_capacity,"discrete").
dom(app,hd_capacity,200).

attr(app,price,"discrete").
dom(app,price,50).

%%% Aggregate paths
path(pc,price,(price,(internet_conn,()))).
path(pc,price,(price,(hd_unit,()))).
path(pc,price,(price,(mb,()))).
path(pc,price,(price,(screen,()))).
path(pc,price,(price,(os,()))).
path(pc,price,(price,(app,()))).

path(pc,total_capacity,(capacity,(hd_disk,(hd_unit,())))). % for constraint resc2
path(pc,capacity_used,(hd_capacity,(os,()))). % for constraint resc2
path(pc,capacity_used,(hd_capacity,(app,()))). % for constraint resc2

path(hd_unit,price,(price,(hd_disk,()))).
path(hd_unit,price,(price,(hd_controller,()))).

%%% Constraints
% Encodes constraint resc1
constraint((pc,0),"lte").
left((pc,0),(price,())).
right((pc,0),constant(2500)).

% Encodes constraint resc2
constraint((pc,1),"lte").
left((pc,1),(capacity_used,())).
right((pc,1),(total_capacity,())).

% Encodes constraints gc1 and gc2
% TODO: Make this an incompatability instead
constraint((pc,2),"table").
column((pc,2),0,(type,(cpu,()))).   column((pc,2),1,(type,(mb,()))).
entry((pc,2),(0,0),"CPUS").         entry((pc,2),(1,0),"MBSilver").
entry((pc,2),(0,1),"CPUD").         entry((pc,2),(1,1),"MBDiamond").

% TODO: Encode constraint gc3 by means of a connection port?
% TODO: Same for crc1, crc2, crc3, crc4


% Encodes generalizations
constraint((hd_disk,0),"table").
column((hd_disk,0),0,(type,())).            column((hd_disk,0),1,(capacity,())). column((hd_disk,0),2,(price,())).
entry((hd_disk,0),(0,0),"MedStoreDisk").    entry((hd_disk,0),(1,0),200).        entry((hd_disk,0),(2,0),200).
entry((hd_disk,0),(0,1),"MaxStoreDisk").    entry((hd_disk,0),(1,1),1000).       entry((hd_disk,0),(2,1),500).

% Encodes generalizations
constraint((mb,0),"table").
column((mb,0),0,(type,())).        column((mb,0),1,(efficiency,())).  column((mb,0),2,(price,())).
entry((mb,0),(0,0),"MBSilver").    entry((mb,0),(1,0),"B").           entry((mb,0),(2,0),250).
entry((mb,0),(0,1),"MBDiamond").   entry((mb,0),(1,1),"A").           entry((mb,0),(2,1),350).

% Encodes generalizations
constraint((cpu,0),"table").
column((cpu,0),0,(type,())).    column((cpu,0),1,(clockrate,())).   column((cpu,0),2,(price,())).
entry((cpu,0),(0,0),"CPUD").    entry((cpu,0),(1,0),"fast").        entry((cpu,0),(2,0),150).
entry((cpu,0),(0,1),"CPUS").    entry((cpu,0),(1,1),"medium").      entry((cpu,0),(2,1),100).

% Encodes generalizations
constraint((os,0),"table").
column((os,0),0,(type,())).     column((os,0),1,(hd_capacity,())).  column((os,0),2,(price,())).
entry((os,0),(0,0),"OSBeta").   entry((os,0),(1,0),13).             entry((os,0),(2,0),500).
entry((os,0),(0,1),"OSAlpha").  entry((os,0),(1,1),6).              entry((os,0),(2,1),100).

% Encodes compc1, compc2 and compc3
constraint((screen,0),"table").
column((screen,0),0,(efficiency,())).   column((screen,0),1,(price,())).
entry((screen,0),(0,0),"A").            entry((screen,0),(1,0),200).
entry((screen,0),(0,1),"B").            entry((screen,0),(1,1),150).
entry((screen,0),(0,2),"C").            entry((screen,0),(1,2),100).
