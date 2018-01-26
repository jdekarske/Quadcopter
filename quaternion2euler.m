function e = quaternion2euler(q)
e1 = atan2(2*(q(1)*q(2)+q(3)*q(4)),1-2*(q(2)*q(2)+q(3)*q(3)));
e2 = asin(2*(q(1)*q(3)-q(4)*q(2)));
e3 = atan2(2*(q(1)*q(4)+q(2)*q(3)),1-2*(q(3)*q(3)+q(4)*q(4)));
e = -[e2 -e1 e3];%*180/3.1415;% SWITCH FOR RIGHT HAND SYSTEM
end

%https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles