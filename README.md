<<<<<<< HEAD
# README #

![What a machine!](https://jasondekarske.com/assets/side.jpg)

This REPO demonstrates the BADGER Lab's Motion Capture system applied to a 450mm quadcopter. The main interest to the lab is the integration of Optitrack Motive with MatLab. See the [documentation](https://v20.wiki.optitrack.com/index.php?title=Data_Streaming) for instruction on set-up. Download the NatNet SDK for use with MatLab. It should be set up on the lab computer, but I'm not sure if it applies to all user partitions. A MatLab example comes with the SDK.


## Quadcopter Usage
* Calibrate cameras liberally; ensure flight volume is thoroughly wanded and you receive an "exceptional" grade in all categories.
* Establish ground plane with the northwest corner of the forceplate.
* Line the quadcopter struts **EXACTLY** with the north end of the forceplate, motor one faces south.
* On GUI: ensure the rigid body moves with the correct axes, Frames per second match camera rate, abort button is greyed
* Start flight from hand, click motors on. Guide for a few seconds while the integral term catches up.

## Key Streaming Excerpts
* Initialize any variables under `function QuadcontrolV2_OpeningFcn(hObject, eventdata, handles, varargin)`
* The critical code comes from the initialization. Specify `addlistener( [rigidbody (probably '1')], [callback function])`.
```
c = natnet;
c.ConnectionType = 'Multicast';
c.connect
c.addlistener( 1 , 'ControlCallbackV2' );
```
* To grab position data in the callback, use the evnt structure. (Goodluck with the axes)
```
rbx = -double( evnt.data.RigidBodies( rbnum ).y );`
```
* Be sure to add buttons for `c.enable(0)` and `c.disable(0)` otherwise the script will not terminate and you will have to kill matlab via task manager and you'll be unhappy because you forget to do it properly after writing sticky notes to remind yourself.
* Use [set](https://www.mathworks.com/help/matlab/ref/set.html) and [drawnow](https://www.mathworks.com/help/matlab/ref/drawnow.html) functions for easy plotting and GUI stuff! *update: Don't use gui stuff while flying!! it adds significant computing time*


### Who should you contact when nothing works and is poorly commented?
[jdekarske@wisc.edu](mailto:jdekarske@wisc.edu?subject=Your%20code%20sucks)


*UW BADGER Lab 1/25/2018*
=======
# Quadcopter
Open-source flight controller software based on Optitrack position tracking
>>>>>>> Github/master
