function label_predict = kNN(dist_matrix,label_train,k)
%KNN compute the kNN classification label
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

% find the most frequent label in the k nearest neighbours
label_predict = mode(label_train_matrix(:,1:k),2);
label_predict = label_predict';

end

