%function accuracy = kNN_feature(path_train,path_test,k)
%kNN clasiffication, similarities as features

k = 10;

path_train = "/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature/labeled/RR0.15_GFCC.csv";
path_test = "/home/nchen/pwq/dataset/eval_set/TUT-acoustic-scenes-2017-evaluation/feature/labeled/RR0.15_GFCC.csv";

label = ["beach","bus","cafe/restaurant","car","city_center", ...
    "forest_path","grocery_store","home","library","metro_station", ...
    "office","park","residential_area","train","tram",];

table_train = readtable(path_train);
table_test = readtable(path_test);

num_train = size(table_train,1);
num_test = size(table_test,1);

matrix_train = table2array(table_train(:,1:num_train));
matrix_test = table2array(table_test(:,1:num_train));


label_train = table_train.label;
[~,label_train_int] = ismember(label_train,label);    % label:str --> int
label_test = table_test.label;
[~,label_test_int] = ismember(label_test,label);    % label:str --> int
label_predict = zeros(num_test,1);

for ind_test=1:num_test
    distance = zeros(num_train,1);
    array_test = matrix_test(ind_test,:);
    parfor ind_train=1:num_train
        distance(ind_train,1) = pdist2(array_test, matrix_train(ind_train,:));
    end
    [~,Index] = sort(distance,1,'ascend');
    label_predict(ind_test,1) = mode(label_train_int(Index(1:k)));
end

istrue = label_predict==label_test_int;    % logical array
count_true = sum(istrue.*1);    % logical-->num, then count
accuracy = count_true/length(label_test_int);

%end