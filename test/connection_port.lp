type(pc).
type(hdd).
type(hd_controller).
type(disk_port).
type(controller_port).

part(pc,hdd,hdd).
multiplicity(pc,hdd,hdd,1). % 1+2  = 3 combinations
multiplicity(pc,hdd,hdd,2). % 1+4  = 5
multiplicity(pc,hdd,hdd,3). % 1+8  = 9
multiplicity(pc,hdd,hdd,4). % 1+16 = 17

part(pc,hd_controller,hd_controller).
multiplicity(pc,hd_controller,hd_controller,1).
multiplicity(pc,hd_controller,hd_controller,2).

part(hdd,disk_port,port).
multiplicity(hdd,disk_port,port,1).

part(hd_controller,controller_port,port).
multiplicity(hd_controller,controller_port,port,1).

connection(disk_port,controller_port,connected).
multiplicity(disk_port,controller_port,connected,1).
