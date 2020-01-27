function TaylorFactor = TFtool(type,filename,angleformat)
%Author: Prof. Veera Sundararaghavan, University of Michigan Ann Arbor,
%Email: veeras@umich.edu
%%%%USE Examples
%%%%%for HCP:  TaylorFactor = TFtool('hexagonal','Foil1EBSD.txt','radians') 
%%%%%for FCC:  TaylorFactor = TFtool('cubic','eulerangles.txt','degrees') 
%%%%INPUTS
% type : CRYSTAL symmetry, possible values: 'cubic' or 'hexagonal'

% filename: Name of Euler angle file, %%%%%%%NOTE: REMOVE THE HEADERLINES
% IN THE EULER ANGLE FILE. SEE EXAMPLE 'Foil1EBSD.txt' FOR INPUT EULER
% ANGLE DATA FORMAT. Bunge format

% angleformat: Euler angle units, Possible values: 'degrees' or 'radians'

%%%%%%%


if type(1) == 'c'
   [m,n,ntwin,crss] = FCCinputs;
   load Cubicdata
end

if type(1) == 'h'
    [m,n,ntwin,crss] = HCPinputs;
    load Hexagonaldata
end

co = ws.frmesh.crd';
el = ws.frmesh.con';
nodes = length(co);

% odf = ws.frmesh.initval*ones(nodes,1);%random ODF assumed
odf = Convertodf(type,filename,angleformat);

Smat = bishophill(m,n,ntwin);

nel = size(el,1);
nno = size(co,1);
intpt = [0.25,0.25,0.25];
w = 1/6;

step = 1;
for angle = 0:18:180
    sum0 = 0;
    temp = 0;
    for e = 1:nel
        s1 = [1 co(el(e,1),1) co(el(e,1),2) co(el(e,1),3);...
            1 co(el(e,2),1) co(el(e,2),2) co(el(e,2),3);...
            1 co(el(e,3),1) co(el(e,3),2) co(el(e,3),3);...
            1 co(el(e,4),1) co(el(e,4),2) co(el(e,4),3)];
        Aval = [odf(el(e,1)) odf(el(e,2)) odf(el(e,3)) odf(el(e,4))]';
        
        alpha = inv(s1)*Aval;
        for i = 1:size(intpt,1)
            r(i,:) = ComputePositionAt(intpt(i,:),co,el,e);
        end
        detj = detJ(co,el,e);
        for i = 1:size(r,1)
            Aint = [1 r(i,:)]*alpha;
            rdotr = r(i,1)*r(i,1) + r(i,2)*r(i,2) + r(i,3)*r(i,3);
            detJxW = abs(detj*((1/(1+rdotr))^2)*w(i));
            temp = temp + (Aint * detJxW * GetTaylorFactor(r(i,:),angle, Smat, crss, ntwin));
            sum0 = sum0 + Aint*detJxW;
        end
    end
    TaylorFactor(step) = temp/sum0;
    Ang(step) = angle;
    step = step+1;
end

plot(Ang,TaylorFactor)
TaylorFactor = [Ang;TaylorFactor]';
xlabel('angle of loading (degrees wrt x axis)');
ylabel('Taylor Factor');



function detj = detJ(co,el,e)

shapeD = [-1 -1 -1;1 0 0;0 1 0;0 0 1];
J = zeros(3,3); 
for q=1:3 
    for p = 1:4 
        J(1,q) = J(1,q)+(shapeD(p,q) * co(el(e,p),1));
        J(2,q) = J(2,q)+(shapeD(p,q) * co(el(e,p),2));
        J(3,q) = J(3,q)+(shapeD(p,q) * co(el(e,p),3));
    end
end

detj =  det(J);

function p = ComputePositionAt(x,co,el,e)
shapeF = [1-sum(x),x(1),x(2),x(3)]; 

p(1) = 0;
p(2) = 0;
p(3) = 0;

for j=1:4
    p(1) = p(1) + (co(el(e,j),1) * shapeF(j));
    p(2) = p(2) + (co(el(e,j),2) * shapeF(j));
    p(3) = p(3) + (co(el(e,j),3) * shapeF(j));
end


function OrientationMatrix = odfpoint(r)

rdotr = 0.0;

for i=1:3
    rdotr = rdotr+r(i)*r(i);
end

term1 = 1.0 - (rdotr);
term2 = 1.0 + (rdotr);

OrientationMatrix = eye(3).*term1;


for  i=1:3
    for j = 1:3
        OrientationMatrix(i, j) = OrientationMatrix(i, j) + 2*(r(i)*r(j));
    end
end
OrientationMatrix(1, 2) = OrientationMatrix(1, 2)-2.0*r(3);
OrientationMatrix(1, 3) =  OrientationMatrix(1, 3)+2.0*r(2);
OrientationMatrix(2, 3) = OrientationMatrix(2, 3)-2.0*r(1);
OrientationMatrix(2, 1) =  OrientationMatrix(2, 1)+2.0*r(3);
OrientationMatrix(3, 1) = OrientationMatrix(3, 1)-2.0*r(2);
OrientationMatrix(3, 2) =  OrientationMatrix(3, 2)+2.0*r(1);

OrientationMatrix = OrientationMatrix.*1.0/term2;

function CrystalTaylorFactor = GetTaylorFactor(x,angle,Smat,crss,ntwin)

straintensor = zeros(3,3);
straintensor(1,1) = 1;
straintensor(2,2) = -0.5;
straintensor(3,3) = -0.5;

dev = straintensor - eye(3)*trace(straintensor)/3;
vonmisesstrain = (2/3)*sqrt((1.5*(dev(1,1)^2 + dev(2,2)^2 + dev(3,3)^2)) + 3*(dev(1,2)^2 + dev(2,3)^2 + dev(3,1)^2));

angle_radian = angle*pi/180.0;
r(1,1) =cos(angle_radian); 
r(1,2) =-sin(angle_radian);  
r(2,1) =sin(angle_radian); 
r(2,2) =cos(angle_radian); 
r(3,3) =1;

scratch = r*straintensor*r';
OrientationMatrix = odfpoint(x);
straintensorlocal = OrientationMatrix'*scratch*OrientationMatrix;

CrystalTaylorFactor = taylorfac(straintensorlocal,Smat,crss,ntwin,vonmisesstrain);

function Y = taylorfac(Dcrystal,Smat,crss,ntwin,vonmisesstrain)
%ref = taucrss*depsvonmises

crssvec = [crss(1:end-ntwin);crss(1:end-ntwin);crss(end-ntwin+1:end)];

D = Dcrystal;

p = [D(2,2); D(3,3); D(2,3); D(1,3); D(1,2)];
[X,FVAL] = linprog(crssvec,-eye(length(crssvec)),zeros(length(crssvec),1),Smat',p);%FVAL is energy density =  stress*strain


Y = FVAL/crss(1)/vonmisesstrain; %von mises yield stress divided by crss1



function Smat = bishophill(m,n,ntwin)
% Smat*[T22-T11;T33-T11;2T23;2T13;2T12] = [tau1;tau2;tau3;tau4;tau5] = [-C,B,2F,2G,2H],
% m,n all slip systems
% BH notation: A = T22-T33,B  = T33-T11,C = T11-T22,F = T23,G = T13,H = T12

nsys = size(m,1);
for i=1:nsys
    S{i} = (m(i,:)'*n(i,:));
end

nslip = nsys-ntwin;
for i = 1:nslip
    Smat(i,:) = [S{i}(2,2) S{i}(3,3)  (S{i}(2,3)+S{i}(3,2))/2   (S{i}(1,3)+S{i}(3,1))/2   (S{i}(2,1)+S{i}(1,2))/2 ];
end

Smat((nslip+1):2*nslip,:) = -Smat(1:nslip,:);

for i = 2*nslip+1:2*nslip+ntwin
    j = i-nslip;
    Smat(i,:) = [S{j}(2,2) S{j}(3,3)  (S{j}(2,3)+S{j}(3,2))/2   (S{j}(1,3)+S{j}(3,1))/2   (S{j}(2,1)+S{j}(1,2))/2 ];
end





















