% RQA measures
% calculate 15 types of RQA measures, based on 10 types of features
clc
clear

% set up
path_feature_origin = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature';
path_fearure_RQA = join([path_feature_origin,'RQA'],'/');
path_meta = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/meta.txt';

table_meta = readtable(path_meta,'Delimiter','tab','ReadVariableNames',false);
list_audio_name_temp = string(table2array(table_meta(:,1)));
list_audio_name_temp = split(list_audio_name_temp,["/","."]);
list_audio_name = list_audio_name_temp(:,2);    % list of audio name, eg, "b020_50_60"
clear list_audio_name_temp table_meta

feature_type_list = ["BarkBands","ERBBands","MelBands","MFCC","HPCP","Tonal","Pitch","SilenceRate","Spectral","GFCC"];
rqa_type_list = ["RR","DET","L","L_max","L_entr","LAM","TT","V_max","RT_1","RT_2",...
                 "RPD_entr","CC","TRANS","ratio_DET_RR","ratio_LAM_DET"];

num_audio = length(list_audio_name);    % number of audio
num_rqa_type = length(rqa_type_list);    % number of rqa type

tic;    % timer

% calculate RQA matrix of each feature
for feature_name=feature_type_list
    path_fearure_foler = join([path_feature_origin,'freesound_extractor',feature_name],'/');    % path of feature folder

    % construct RQA matrix
    RQA_measure_temp = [];    % [(num_audio*num_audio),num_rqa_type] dimension, unshaped

    % calculate RQA matrix
    % upper triangular matrix
    for i=1:num_audio
        disp(join(['Calculating audio ',i,',feature: ' feature_name,',time:',toc,'s']))
        feature_1 = readmatrix(join([path_fearure_foler,"/",list_audio_name(i),".csv"],''));
        rqa_temp = zeros(num_audio,num_rqa_type-2);
        parfor j=i:num_audio
            index = (1:num_audio)+i.*num_audio;
            feature_2 = readmatrix(join([path_fearure_foler,'/',list_audio_name(j),'.csv'],''));
            % calculate RQA measure using CRP_Tollbox crqa(...), returns a 1x13 array
            rqa_temp(j,:) = crqa(feature_1,feature_2,2,1,0.1,[],'fan','euclidean','silent');
        end
        rqa_temp(:,14) = rqa_temp(:,2)./rqa_temp(:,1);    % calculate ratio_DET_RR
        rqa_temp(:,15) = rqa_temp(:,6)./rqa_temp(:,2);    % calculate ratio_LAM_DET
        RQA_measure_temp = cat(1,RQA_measure_temp,rqa_temp);
    end
    
    % reshape RQA_measure_temp into a [num_audio,num_audio,num_rqa_type] dimension matrix
    RQA_measure = reshape(RQA_measure_temp,num_audio,num_audio,[]);
    
    % lower triangular matrix
    for i=1:num_audio
        for j=i:num_audio
            RQA_measure(i,j,:) = RQA_measure(j,i,:);
        end
    end
        
    % save RQA matrix into csv file
    % use datatype 'table' to save the index
    for rqa_type_index=1:num_rqa_type
        RQA_measure_each = RQA_measure(:,:,rqa_type_index);
        target_folder = join([path_fearure_RQA,rqa_type_list(rqa_type_index)],'/');
        table_RQA = array2table(RQA_measure_each,'VariableNames',list_audio_name);
        writetable(table_RQA, join([target_folder,'/',feature_name,'.csv'],''),'WriteVariableNames',true);
    end
end