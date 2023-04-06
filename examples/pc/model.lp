%%% Types
type(pc).
type(internet_conn). % Could be implemented as an attribute? But how to deal with price then?
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
part(pc,internet_conn,internet,0,1).
part(pc,hd_unit,hd_unit,1,2).
part(pc,mb,mb,1,1).
part(pc,screen,screen,1,2).
part(pc,os,os,1,1).
part(pc,app,app,1,5).
part(hd_unit,hd_disk,hd_disk,1,4).
part(hd_disk,disk_port,disk_port,1,1).
part(hd_unit,hd_controller,hd_controller,1,2).
part(hd_controller,controller_port,controller_port,4,4).
part(mb,cpu,cpu,1,2).

%%% Connections
% connection(controller_port,disk_port,c2d,0,1).

%%% Attributes
attr(pc,usage).
attr(pc,efficiency).
attr(pc,price,"sum"). % constraint prc1
attr(pc,total_capacity,"sum"). % for constraint resc2
attr(pc,capacity_used,"sum"). % for constraint resc2
attr(internet_conn,price).
attr(hd_unit,price,"sum"). % constraint prc2
attr(hd_disk,type).
attr(hd_disk,capacity).
attr(hd_disk,price).
attr(hd_controller,type).
attr(hd_controller,price).
attr(mb,efficiency).
attr(mb,price).
attr(mb,type).
attr(cpu,clockrate).
attr(cpu,price).
attr(cpu,type).
attr(screen,efficiency).
attr(screen,price).
attr(os,hd_capacity).
attr(os,price).
attr(app,hd_capacity).
attr(app,price).

dom(pc,usage,("internet";"scientific";"multimedia")).
dom(pc,efficiency,("A";"B";"C")).
dom(internet_conn,price,50).
dom(hd_disk,type,("MedStoreDisk";"MaxStoreDisk")).
dom(hd_disk,capacity,(200;1000)).
dom(hd_disk,price,(200;500)).
dom(hd_controller,type,("MedStoreC";"MaxStoreC")).
dom(hd_controller,price,500).
dom(mb,type,("MBSilver";"MBDiamond")).
dom(mb,efficiency,("A";"B")).
dom(mb,price,(250;350)).
dom(cpu,type,("CPUD";"CPUS")).
dom(cpu,clockrate,("medium";"fast")).
dom(cpu,price,(100;150)).
dom(screen,efficiency,("A";"B";"C")).
dom(screen,price,(100;150;200)).
dom(os,type,("OSBeta";"OSAlpha")).
dom(os,hd_capacity,(6;13)).
dom(os,price,(100;500)).
dom(app,hd_capacity,200).
dom(app,price,50).

% %%% Aggregate paths
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

constraint((hd_unit,0),"lte").
left((hd_unit,0),(price,())).
right((hd_unit,0),constant(1000)).

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

% gc3: Each OS of type OSAlpha requires a CPU of type CPUD.
% constraint((pc,3),"requires").
% condition((pc,3),(type,(os,())),"OSAlpha").
% requires((pc,3),(type,(cpu,())),"CPUD").
constraint((pc,3),"table").
column((pc,3),0,(type,(os,()))).        column((pc,3),1,(type,(cpu,()))).
entry((pc,3),(0,0),"OSAlpha").   entry((pc,3),(1,0),"CPUD").
entry((pc,3),(0,1),"OSBeta").   entry((pc,3),(1,1),"CPUD").
entry((pc,3),(0,2),"OSBeta").   entry((pc,3),(1,2),"CPUS").

% crc1: Intended internet usage or multimedia usage (attribute of PC)
%       requires the existence of an Internet connection (InternetConn).
constraint((pc,4),"requires").
condition((pc,4),(usage,()),"internet").
requires((pc,4),(internet_conn,())).

constraint((pc,5),"requires").
condition((pc,5),(usage,()),"multimedia").
requires((pc,4),(internet_conn,())).

% crc2: scientific usage requires CPUs of type CPUD
% constraint((pc,6),"requires").
% condition((pc,6),(usage,()),"scientific").
% requires((pc,6),(type,(cpu,())),"CPUD").
constraint((pc,6),"table").
column((pc,6),0,(usage,())).        column((pc,6),1,(type,(cpu,()))).
entry((pc,6),(0,0),"scientific").   entry((pc,6),(1,0),"CPUD").
entry((pc,6),(0,1),"multimedia").   entry((pc,6),(1,1),"CPUD").
entry((pc,6),(0,2),"multimedia").   entry((pc,6),(1,2),"CPUS").
entry((pc,6),(0,3),"internet").     entry((pc,6),(1,3),"CPUD").
entry((pc,6),(0,4),"internet").     entry((pc,6),(1,4),"CPUS").

% crc3: The required energy efficiency (attribute efficiency of PC) must be supported by the MB
% Is this an equal or gte?
constraint((pc,7),"eq").
left((pc,7),(efficiency,())).
right((pc,7),(efficiency,(mb,()))).

% crc4: The required energy efficiency (attribute efficiency of PC) must be supported by the included Screens.
% Is this an equal or gte?
constraint((pc,8),"eq").
left((pc,8),(efficiency,())).
right((pc,8),(efficiency,(screen,()))).
