function R = CRP_FR(x,y,r)
    % Cross Recurrence Plot using fixed radius
    % return the cross recurrence plot of dynamics represented in two time series x & y
    % r is the radius
    if nargin < 3
        r=0.5;
    end
    
    % calculate the diatance and then normalize
    dist1=pdist2(x,y);    % the Euclidean distance
    max1=max(dist1,[],'all');
    dist1_normalized=dist1/max1;

    % calculate the diatance and then normalize
    dist2=dist1';
    max2=max(dist2,[],'all');
    dist2_normalized=dist2/max2;
    
    % construct threshold matrix and apply the thresholding
    A=repmat(r,size(dist1_normalized))-dist1_normalized;
    B=repmat(r,size(dist2_normalized))-dist2_normalized;
    
    % step function
    A(A>=0)=1;A(A<0)=0;
    B(B>=0)=1;B(B<0)=0;
    
    R=A.*B';
    end