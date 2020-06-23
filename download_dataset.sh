# download dataset and unzip

#train_set
cd ../
mkdir dataset
cd dataset
mkdir train_set
mkdir test_set

for i in 1 2 3 4 5 6 7 8 9 10
do
wget https://zenodo.org/record/400515/files/TUT-acoustic-scenes-2017-development.audio.$i.zip?download=1
unzip TUT-acoustic-scenes-2017-development.audio.$i.zip?download=1 -d train_set
rm -f TUT-acoustic-scenes-2017-development.audio.$i.zip?download=1
done

wget https://zenodo.org/record/400515/files/TUT-acoustic-scenes-2017-development.doc.zip?download=1
unzip TUT-acoustic-scenes-2017-development.doc.zip?download=1 -d train_set
rm -f TUT-acoustic-scenes-2017-development.doc.zip?download=1

wget https://zenodo.org/record/400515/files/TUT-acoustic-scenes-2017-development.error.zip?download=1
unzip TUT-acoustic-scenes-2017-development.error.zip?download=1 -d train_set
rm -f TUT-acoustic-scenes-2017-development.error.zip?download=1

wget https://zenodo.org/record/400515/files/TUT-acoustic-scenes-2017-development.meta.zip?download=1
unzip TUT-acoustic-scenes-2017-development.meta.zip?download=1 -d train_set
rm -f TUT-acoustic-scenes-2017-development.meta.zip?download=1

#test_set
for i in 1 2 3 4
do
wget https://zenodo.org/record/1040168/files/TUT-acoustic-scenes-2017-evaluation.audio.$i.zip?download=1
unzip TUT-acoustic-scenes-2017-evaluation.audio.$i.zip?download=1 -d test_set
rm -f TUT-acoustic-scenes-2017-evaluation.audio.$i.zip?download=1
done

wget https://zenodo.org/record/1040168/files/TUT-acoustic-scenes-2017-evaluation.doc.zip?download=1
unzip TUT-acoustic-scenes-2017-evaluation.doc.zip?download=1 -d test_set
rm -f TUT-acoustic-scenes-2017-evaluation.doc.zip?download=1
wget https://zenodo.org/record/1040168/files/TUT-acoustic-scenes-2017-evaluation.meta.zip?download=1
unzip TUT-acoustic-scenes-2017-evaluation.meta.zip?download=1 -d test_set
rm -f TUT-acoustic-scenes-2017-evaluation.meta.zip?download=1
