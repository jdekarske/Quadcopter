function setspeed()
global s m1 m2 m3 m4 tm1 tm2 tm3 tm4 abort rbz abortbtn motorsonbtn axes2 ang
%convert desired angular velocity to pwm

% 
pwm1 = m1*166.32 + 1033; %THIS NEEDS TO BE CALIBRATED
pwm2 = m2*166.32 + 1033;
pwm3 = m3*166.32 + 1033;
pwm4 = m4*166.32 + 1033;

%print to gui
set(tm1, 'String', num2str(round(pwm1)));
set(tm2, 'String', num2str(round(pwm2)));
set(tm3, 'String', num2str(round(pwm3)));
set(tm4, 'String', num2str(round(pwm4)));
set(axes2, 'YData', [round(pwm1); round(pwm2); round(pwm3); round(pwm4)]);

%correction to prevent motor cutoff
if pwm1<1055
    pwm1 = 1055;
end
if pwm2<1055
    pwm2 = 1055;
end
if pwm3<1055
    pwm3 = 1055;
end
if pwm4<1055
    pwm4 = 1055;
end
if pwm1>1800
    pwm1 = 1800;
end
if pwm2>1800
    pwm2 = 1800;
end
if pwm3>1800
    pwm3 = 1800;
end
if pwm4>1800
    pwm4 = 1800;
end

drawnow
if ((rbz <.2) || (abs(ang(1))>.3) || (abs(ang(2))>.3))
    abort = 1;
    set(abortbtn,'Enable', 'Off');
    set(motorsonbtn,'Enable', 'On');
end
if abort
    pwm1=1000;
    pwm2=1000;
    pwm3=1000;
    pwm4=1000;
end
speedstring = strcat("a",num2str(round(pwm1)),num2str(round(pwm2)),num2str(round(pwm3)),num2str(round(pwm4)));
fprintf(s,'%s',speedstring);