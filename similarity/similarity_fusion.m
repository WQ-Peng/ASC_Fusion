% Fuse silimarity matrix of audio samples based on different type of features
% use SNF methods: http://compbio.cs.toronto.edu/SNF/SNF/Software.html

% set path
path_feature_Qmax = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature/Qmax';
path_feature_SNF = '/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature/SNF';

% put all the Qmax matrix into a cell
list_Qmax = ["BarkBands","ERBBands","MelBands","MFCC","HPCP","Tonal","Pitch","SilenceRate","Spectral","GFCC"];
for i=1:length(list_Qmax)
    table_Qmax = readtable(join([path_feature_Qmax,"/",list_Qmax(i),'.csv'],''),'ReadVariableNames',true);
    Qmax{i} = table2array(table_Qmax);
end

% First, set all the parameters.
K = 20;%number of neighbors, usually (10~30)
alpha = 0.5; %hyperparameter, usually (0.3~0.8)
T = 20; %Number of Iterations, usually (10~20)

% next, we fuse all the matrix
% then the overall matrix can be computed by similarity network fusion(SNF):
W = SNF(Qmax, K, T);

% save fused matrix to csv
list_audio_name = table_Qmax.Properties.VariableNames;
table_SNF = array2table(W,'VariableNames',list_audio_name);
writetable(table_SNF,join([path_feature_SNF,"/SNF1-10.csv"],''),'WriteVariableNames',true);