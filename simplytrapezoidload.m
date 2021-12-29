%simply supported beam with UDL/UVL/Trapezoidal load
clear all;
clc;
E=input('Youngs Modulus or Modulus of elasticity in Pascals \n E=')
I=input('Area moment of inertia in m^4\n I=')
L=input('Length of beam in meters \n L=')
fprintf('1.Uniformly distributed load UDL from left to right\n')
fprintf('2.UVL Uniformly increasing load from left to right\n')
fprintf('3.UVL Uniformly decreasing load from left to right\n')
fprintf('4.Trapezoidal increasing load from left to right\n')
fprintf('5.Trapezoidal decreasing load from left to right\n')
Load_Type=input('Load Type=')
if Load_Type==1
   w1=input('Enter Intensity of UDL w in N/m \n w=')
   w2=w1
elseif Load_Type==2
    w1=0
    w2=input('Enter max Intensity of UVL w in N/m \n w=')
elseif Load_Type==3
    w1=input('Enter max Intensity of UVL w in N/m \n w=')
    w2=0
else
    w1=input('Enter Intensity of load w in N/m \n w1=')
    w2=input('Enter Intensity of load w in N/m \n w2=')
end 
syms x M(x) SF(X); 
syms C1 C2 C3; 
syms slope(x) deflection(x); 
Y=0:0.1:L;
if w2>w1
    Ra=(w1*L/2)+(0.5*(w2-w1)*L/3);
    Rb=(w1*L)+(0.5*(w2-w1)*L)-Ra;
    M(x)=(Ra*x)-(((w2-w1)*(x)^3)/(6*L))-(w1*(x^2)/2);
    X=Y
elseif w2<w1
    Rb=(w2*L/2)+((w1-w2)*L/6);
    Ra=(w2*L)+(0.5*(w1-w2)*L)-Rb;
    M(x)=(Rb*x)-(((w1-w2)*(x)^3)/(6*L))-(w2*(x^2)/2);
    X=L-Y
elseif w1==w2
        Ra=(w1*L/2)+(0.5*(w2-w1)*L/3);
    Rb=(w1*L)+(0.5*(w2-w1)*L)-Ra;
    M(x)=(Ra*x)-(((w2-w1)*(x)^3)/(6*L))-(w1*(x^2)/2);
    X=Y    
end
%first section
format long;
SF(x)=diff(M(x),x);
deflection(x,C2,C3)=((int(int(M(x),x),x))+(C2*x)+C3)/(E*I);
D1y(x,C2,C3)=diff(deflection,x);
eq2 =deflection(0,C2,C3) == 0;
eq3 =deflection(L,C2,C3) == 0;
[aa,bb]= vpasolve([eq2,eq3],[C2,C3]);       
C2=eval(aa);
C3=eval(bb);
deflection(x)=deflection(x,C2,C3);
slope(x)=diff(deflection(x),x);
figure
area(Y,double(SF(X)))
ylabel('Shear Force in N');
xlabel('Location on beam from extreme left along length in m');
figure
area(Y,double(M(X)))
ylabel('Bending Moment in N-m');
xlabel('Location on beam from extreme left along length in m');
figure
area(Y,double(slope(X)))
ylabel('Slope of bend curvature of beam');
xlabel('Location on beam from extreme left along length in m');
figure
plot(Y,double(deflection(X)))
ylabel('Deflection in m');
xlabel('Location on beam from extreme left along length in m');
% Maximum Bending Moment
BM_max_loc=vpasolve(diff(M(x),x)==0,x,[0,L]);
BM_max_loc=eval(BM_max_loc);
max_BM=double(M(BM_max_loc));
% Maximum deflection
Def_max_loc=vpasolve(diff(deflection(x),x)==0,x,[0,L]);
Def_max_loc=eval(Def_max_loc);
max_def=double(deflection(Def_max_loc));
if w2<w1
    BM_max_loc=L-BM_max_loc
    Def_max_loc=L-Def_max_loc
end
fprintf('Maximum BM is at %f m from extreme left side of beam \n',BM_max_loc);
fprintf('Maximum BM is %f N-m \n',max_BM);
fprintf('Maximum deflection is at %f m from extreme left side of beam \n',Def_max_loc);
fprintf('Maximum deflection is %f m \n',max_def);
