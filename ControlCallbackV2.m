
function ControlCallback( ~ , evnt )


global abort axes1 rbx rby rbz xc yc zc lasttime m1 m2 m3 m4 lastPerror lastAerror Aerrsum Perrsum ang count anglesave possave starttime
dt = 1/240; %240 hz max via optitrack framerate CHECK THIS
rbnum = 1; %rigid body id
timenow = cputime; %for timing purposes
commandedposition = [0;-1.60;1]; %get this from the gui
if abort
    Perrsum = 0;
    Aerrsum = 0;
    starttime = timenow;
end
% Get the rb position
if ((timenow - lasttime) > (dt))
    if abort
        count = 0;
    else
        count = count+1;
    end
    
    try
        rby = double( evnt.data.RigidBodies( rbnum ).x ); % CHECK THE GLOBAL FRAME FROM OPTITRACK EVERYTIME
    catch
        errordlg('Run the Quadcontrol script');
    end
    rbx = -double( evnt.data.RigidBodies( rbnum ).y );
    rbz = double( evnt.data.RigidBodies( rbnum ).z );
    qw = double( evnt.data.RigidBodies( rbnum ).qw);
    qx = double( evnt.data.RigidBodies( rbnum ).qx);
    qy = double( evnt.data.RigidBodies( rbnum ).qy);
    qz = double( evnt.data.RigidBodies( rbnum ).qz);
    quat = [qw qx qy qz];
    ang = quaternion2euler(quat)';
    ang(3) = -ang(3);
    %mydata = evnt.data.RigidBodies( rbnum );
    position = [rbx;rby;rbz]
    bRi = [cos(ang(3)) sin(ang(3)) 0;...
        -sin(ang(3)) cos(ang(3)) 0;...
        0 0 1];
    Perror = commandedposition-position;
    Perror_bodyframe = bRi*Perror 
    Perror_bodyframe([1 2]) = Perror_bodyframe([2 1]); %the error in the y direction is controlled by rotation around x, so switch them
    Perror_bodyframe(1) = -Perror_bodyframe(1);
    
    
    Perrsum = Perrsum + Perror_bodyframe.*dt; %cumulative error. I think only vertical is necessary to compensate for battery power loss
        
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %~~~~~~~~~~THINGS TO ADJUST~~~~~~~~~~%
    KPang = [19;25;25];
    KIang = [2.1;1.3;3];
    KDang = [.8;.8;0]; %roll pitch yaw
    KPpos = [.27;.27;.6*9];
    KIpos = [.2;.1;1.2*9*.2842];
    KDpos = [.0015;.0017;3*9*.2842/40]; %x y z
    %The ones below are close enough
    m = .914;
    I = [.0085532;.0085532;.05225]; %values from paper, should be similar
    g = 9.806;
    l = .225;
    %k = 2.980*10^-6; %see note below
    %b = 1.140*10^-7;
    %~~~~~~~~~~THINGS TO ADJUST~~~~~~~~~~%
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    
    desiredposition = KPpos.*Perror_bodyframe + KDpos.*(Perror_bodyframe-lastPerror)/dt + KIpos.*(Perrsum);
    
    Aerror = desiredposition - ang
    Aerror(3) = -ang(3);
    
    Aerrsum = Aerrsum + Aerror.*dt;
    
    T = m*((desiredposition(3)+g))/(cos(ang(1))*cos(ang(2)));
    torque = (KPang.*Aerror + KDang.*(Aerror-lastAerror)/dt + KIang.*(Aerrsum)).*I; %degrees
    m1 = T/4-torque(2)/(l)+torque(3)/4; %*k/(4*b); I don't think this correction is necessary, it levels out gains a bit
    m2 = T/4-torque(1)/(l)-torque(3)/4;  %seperate thrusts between couples
    m3 = T/4+torque(2)/(l)+torque(3)/4;
    m4 = T/4+torque(1)/(l)-torque(3)/4;
    setspeed()
    
    savePerror = lastPerror;
    saveAerror = lastAerror;
    
    lasttime = timenow;
    lastPerror = Perror_bodyframe;
    lastAerror = Aerror;
    
end
%for plotting purposes
set(axes1,'XData',[rbx xc]','YData',[rby yc]','ZData',[rbz zc]');
drawnow
if abort == 0
    anglesave(count+1,1:15) = [Aerror' torque' (KPang.*Aerror)' (KDang.*(Aerror-saveAerror)/dt)' (KIang.*(Aerrsum))'].*(180/3.14);
    possave(count+1,1:15) = [Perror_bodyframe' desiredposition' (KPpos.*Perror_bodyframe)' (KDpos.*(Perror_bodyframe-savePerror)/dt)' (KIpos.*(Perrsum))'];
end

end



