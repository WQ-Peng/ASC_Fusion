% predict with kNN
clc
clear

% set path
path_feature_origin = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature';
path_fearure_Qmax = join([path_feature_origin,'/Qmax'],'');
path_fold1_train = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/evaluation_setup/fold1_train.txt';
path_fold1_eval = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/evaluation_setup/fold1_evaluate.txt';
path_meta = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/meta.txt';

% list audio name
table_meta = readtable(path_meta,'Delimiter','tab','ReadVariableNames',false);
list_audio_name_temp = string(table2array(table_meta(:,1)));
list_audio_name_temp = split(list_audio_name_temp,["/","."]);
list_audio_name = list_audio_name_temp(:,2);    % list of audio name, eg, "b020_50_60"
label = ["beach","bus","cafe/restaurant","car","city_center","forest_path","grocery_store","home","library",...
    "metro_station","office","park","residential_area","train","tram",];
% list audio name and label of train set
table_fold1_train = readtable(path_fold1_train,'Delimiter','tab','ReadVariableNames',false);
list_audio_name_temp = string(table2array(table_fold1_train(:,1)));
list_audio_name_temp = split(list_audio_name_temp,["/","."]);
list_audio_train_name = list_audio_name_temp(:,2);    % list of audio name, eg, "b020_50_60"
label_train_str = string(table2array(table_fold1_train(:,2)));    % list of label, eg, "beach"
[~,label_train_int] = ismember(label_train_str,label);    % label:str --> int
% list audio name and label of eval set
table_fold1_eval = readtable(path_fold1_eval,'Delimiter','tab','ReadVariableNames',false);
list_audio_name_temp = string(table2array(table_fold1_eval(:,1)));
list_audio_name_temp = split(list_audio_name_temp,["/","."]);
list_audio_eval_name = list_audio_name_temp(:,2);    % list of audio name, eg, "b020_50_60"
label_eval_str = string(table2array(table_fold1_eval(:,2)));    % list of label, eg, "beach"
[~,label_eval_int] = ismember(label_eval_str,label);    % label:str --> int

% load and reconstruct the Qmax distance matrix
[~,Loc_train] = ismember(list_audio_train_name,list_audio_name);
[~,Loc_eval] = ismember(list_audio_eval_name,list_audio_name);
Qmax_all = readmatrix(join([path_fearure_Qmax,'/ERBBands.csv'],''));
Qmax_fold1 = Qmax_all(Loc_eval,Loc_train);

% kNN
label_predict = kNN(Qmax_fold1,label_train_int',100);
% calculat the accuracy
istrue = label_predict==label_eval_int';    % logical array
count_true = sum(istrue.*1);    % logical-->num, then count
accuracy = count_true/length(label_eval_int);
disp(join(["cross-validation1: accuracy:",accuracy]));