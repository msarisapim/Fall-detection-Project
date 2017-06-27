function CreateFD
global baseName vidName foldername0 foldername1 foldername2 foldername3 foldername4 foldername5 foldername6 
foldername1 = [foldername0 '\' vidName]; mkdir(baseName,foldername1);
foldername2 = [foldername1 '\Frame' ]; mkdir(baseName,foldername2);
foldername3 = [foldername1 '\GrayImg']; mkdir(baseName,foldername3);
foldername4 = [foldername1 '\BWImg']; mkdir(baseName,foldername4);
foldername5 = [foldername1 '\PCA']; mkdir(baseName,foldername5);
foldername6 = [foldername1 '\ALL']; mkdir(baseName,foldername6);