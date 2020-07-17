function accuracy = predict(name,fold,k)
%predict predict with kNN

% set path
path_dcase2017_origin = "/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/";
path_fold1_train = join([path_dcase2017_origin,"evaluation_setup/",fold,"_train.txt"],'');
path_fold1_eval = join([path_dcase2017_origin,"evaluation_setup/",fold,"_evaluate.txt"],'');
path_meta = join([path_dcase2017_origin,"meta.txt"],'');

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
data_all = readmatrix(join([path_dcase2017_origin,"feature/",name,".csv"],''));
data_fold = data_all(Loc_eval,Loc_train);

% kNN
label_predict = kNN(data_fold,label_train_int',k);
% calculat the accuracy
istrue = label_predict==label_eval_int';    % logical array
count_true = sum(istrue.*1);    % logical-->num, then count
accuracy = count_true/length(label_eval_int);
% disp(join(["cross-validation:",fold,",data:",name,",k:",k,",accuracy:",accuracy],''));