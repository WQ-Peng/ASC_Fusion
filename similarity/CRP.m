function R = CRP(x,y,k)
% return the cross recurrence plot of dynamics represented in two time series
% k is the percentage of nearest neighbours to determine the radius r, which is the threshold
if nargin < 3
    k=0.1;
end

% calculate the threshold distance epsilon(x)
dist1=pdist2(x,y);    % the Euclidean distance
temp1=sort(dist1,2);     % sort by distance
num_x=ceil(size(temp1,2)*k);    % number of nearest neighbours
Ex=(temp1(:,num_x)+temp1(:,num_x+1))/2;    %threshold epsilon(x)

% calculate the threshold distance epsilon(y)
dist2=dist1';
temp2=sort(dist2,2);
num_y=ceil(size(temp2,2)*k);
Ey=(temp2(:,num_y)+temp2(:,num_y+1))/2;

% construct threshold matrix and apply the thresholding
A=repmat(Ex,1,size(dist1,2))-dist1;
B=repmat(Ey,1,size(dist2,2))-dist2;

% step function
A(A>=0)=1;A(A<0)=0;
B(B>=0)=1;B(B<0)=0;

R=A.*B';
end