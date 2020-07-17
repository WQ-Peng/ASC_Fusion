function label_predict = weighted_kNN(dist_matrix,label_train,k)
%weighted_KNN weighted kNN classification, using Gaussian distribution
%distribution
%   dist_matrix: each row is the distances of one eval data to each train data

count_eval = length(dist_matrix(:,1));    % number of evaluation data

% construct label matrix corresponding to dist_matrix
label_train_matrix = repmat(label_train,count_eval,1);
% sort distance in ascending order
[~,Index] = sort(dist_matrix,2);
% sort rows in the label_train_matrix in the same order of Index
for i=1:count_eval
    label_train_matrix(i,:) = label_train_matrix(i,Index(i,:));
end

% weighted
% sigma = 5;
weight = exp(-(1:k).^2)/k^2;

% find the most frequent label in the k nearest neighbours
count = zeros(count_eval,15);
for eval=1:count_eval
    for i=1:k
        count(eval,label_train_matrix(eval,i)) = ...
        count(eval,label_train_matrix(eval,i))+weight(i);
    end
end
[~,label_predict] = max(count,[],2);
label_predict = label_predict';

end