clc
clear

path_fearure_labeled = "/home/nchen/pwq/dataset/train_set/TUT-acoustic-scenes-2017-development/feature/labeled";
fold = ["fold1","fold2","fold3","fold4"];

for ind_fold="fold1"
    accuracy = 0;
    path_train = join([path_fearure_labeled,"/fold_RR0.1_GFCC/",ind_fold,"_train.csv"],'');    % 1.change path
    path_test = join([path_fearure_labeled,"/fold_RR0.1_GFCC/",ind_fold,"_test.csv"],'');
    accuracy = accuracy + kNN_feature(path_train,path_test,10);    % 2.change k
    disp(join(["cross-validation: accuracy:",accuracy/4],''));
end
    