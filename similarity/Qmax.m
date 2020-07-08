function qmax=Qmax(R,yo,ye)
%***Qmax measures
% R is the CRP,
% yo is the penalty for a disruption onset,
% ye is the penalty for a disruption extension.

if nargin < 2
    yo=5;
end
if nargin < 3
    ye=0.5;
end

Nx=size(R,1);
Ny=size(R,2);
Q=zeros(Nx,Ny);
gamma=zeros(Nx,Ny);
gamma(R==0)=ye;
gamma(R==1)=yo;
for i=3:Nx
    for j=3:Ny
        if R(i,j)==1
            Q(i,j)=max(max(Q(i-1,j-1),Q(i-2,j-1)),Q(i-1,j-2))+1;
        else
            Q(i,j)=max(max(0,Q(i-1,j-1)-gamma(i-1,j-1)), ...,
                   max(Q(i-2,j-1)-gamma(i-2,j-1),Q(i-1,j-2)-gamma(i-1,j-2)));
        end
    end
end
Q1=max(max(Q));
qmax=sqrt(size(Q,2))/Q1;
end