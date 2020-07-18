clc
clear

%data = ["Qmax/BarkBands","Qmax/ERBBands","Qmax/MelBands","Qmax/MFCC"];
data = ["SNF/SNF1-10"];
fold = ["fold1","fold2","fold3","fold4"];
k = [5,10,30];
parfor i=1:length(data)
    for j=1:length(k)
        accuracy = 0;
        for l=1:length(fold)
            accuracy = accuracy + predict(data(i),fold(l),k(j));
        end
        disp(join(["cross-validation:"," data:",data(i),",k:",k(j),",accuracy:",accuracy/4],''));
    end
end
    