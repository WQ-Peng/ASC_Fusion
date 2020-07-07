% calculate Recurrence Plot of each type of features of audio samples
% and then calculate Qmax to measure the similarity between audio samples based on each type of feature
% save results in /Qmax folder
clc
clear
clear all

% set path
path_feature_origin = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature';
path_fearure_Qmax = join([path_feature_origin,'/Qmax'],'');
path_meta = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/meta.txt';

% list audio name
table_meta = readtable(path_meta,'Delimiter','tab','ReadVariableNames',false);
list_audio_name_temp = string(table2array(table_meta(:,1)));
list_audio_name_temp = split(list_audio_name_temp,["/","."]);
list_audio_name = list_audio_name_temp(:,2);    % list of audio name, eg, "b020_50_60"

% calculate Qmax matrix of each feature
for featureName = ["BarkBands","ERBBands","MelBands","MFCC","HPCP","Tonal","Pitch","SilenceRate","Spectral","GFCC"]
    path_fearure_foler = join([path_feature_origin, featureName],'/');    % path of feature folder

    % construct Qmax matrix
    num_audio = length(list_audio_name);
    Qmax_measure = zeros(num_audio,num_audio);

    % calculate Qmax matrix
    for i=1:num_audio
        disp(join(['Calculating similarity for audio ', i, ', feature: ', featureName]))
        feature_1 = readmatrix(join([path_fearure_foler, "/", list_audio_name(i), ".csv"],''));
        for j=1:num_audio
            feature_2 = readmatrix(join([path_fearure_foler, '/', list_audio_name(i), '.csv'],''));
            RP_temp = RP(feature_1, feature_2);
            Qmax_measure(i,j) = Qmax(RP_temp);
        end
    end

    % save Qmax matrix into csv file
    % use datatype 'table' to save the index
    table_Qmax = array2table(Qmax_measure,'VariableNames',list_audio_name);
    writetable(table_Qmax, join([path_fearure_Qmax,'/',featureName,'.csv'],''),'WriteVariableNames',true);
end


