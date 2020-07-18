% calculate CRP of each type of features of audio samples
% and then calculate RQA measure of the CRPs the similarity between audio samples based on each type of feature
clc
clear

% set path
path_feature_origin = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature';
path_fearure_RQA = join([path_feature_origin,'/RR'],'');
path_meta = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/meta.txt';

% list audio name
table_meta = readtable(path_meta,'Delimiter','tab','ReadVariableNames',false);
list_audio_name_temp = string(table2array(table_meta(:,1)));
list_audio_name_temp = split(list_audio_name_temp,["/","."]);
list_audio_name = list_audio_name_temp(:,2);    % list of audio name, eg, "b020_50_60"

tic;    % timer

% calculate Qmax matrix of each feature
for featureName = ["BarkBands","ERBBands","MelBands","MFCC","HPCP","Tonal","Pitch","SilenceRate","Spectral","GFCC"]
    path_fearure_foler = join([path_feature_origin,'freesound_extractor',featureName],'/');    % path of feature folder

    % construct Qmax matrix
    num_audio = length(list_audio_name);
    RQA_measure = zeros(num_audio,num_audio);

    % calculate Qmax matrix
    % upper triangular matrix
    for i=1:num_audio
        disp(join(['Calculating similarity for audio ',i,',feature: ' featureName,',time:',toc,'s']))
        feature_1 = readmatrix(join([path_fearure_foler,"/",list_audio_name(i),".csv"],''));
        parfor j=i:num_audio
            feature_2 = readmatrix(join([path_fearure_foler,'/',list_audio_name(j),'.csv'],''));
            RQA_temp = CRP(feature_1, feature_2);    % calculate CRP
            RQA_measure(i,j) = RR(RQA_temp);    % calculate RQA measure
        end
    end
    % lower triangular matrix
    for i=1:num_audio
        for j=1:i
            RQA_measure(i,j) = RQA_measure(j,i);
        end
    end
        
    % save Qmax matrix into csv file
    % use datatype 'table' to save the index
    table_RQA = array2table(RQA_measure,'VariableNames',list_audio_name);
    writetable(table_RQA, join([path_fearure_RQA,'/',featureName,'.csv'],''),'WriteVariableNames',true);
end