function rate = RR(CRP)
%RR calculate the recurrence rate(RR) of CPRs
%   
n = length(CRP);
s = sum(CRP,'all');
rate = s/(n^2);
end

