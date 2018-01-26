function v = rotation(angles,vel)
%changes the velocity frame of reference where VE = R*VQ
%only transforms yaw
psi = angles(3);
R = [cos(psi) -sin(psi);...
    sin(psi) cos(psi)];
v = R*vel(1:2);
v(3) = -vel(3);
end