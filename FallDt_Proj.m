clc
clear
global baseName vidName foldername0 foldername1 foldername2 foldername3 foldername4 foldername5 foldername6 
baseName = 'D:\Fall Detection' ;    VDO=1;  %change path name/ Input type 
%create results folder..
foldername0 = 'Results'; mkdir(baseName,foldername0);
% %INPUT
if VDO == 1 %%Video for input
    vidObj=VideoReader('D:\Fall Detection\dataset\Le2i\Lecture room\video (4).avi');
    BGMean_dir='D:\Fall Detection\dataset\Le2i\Lecture room\BGMean.tif';
    vidHeight = vidObj.Height; vidWidth = vidObj.Width;
    vidName=vidObj.Name;  vidName=vidName(1,1:double(max(size(vidName)))-4);
    %collect each frame in s(structure)
    inputVideo = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);
    k = 1;
    while hasFrame(vidObj)
        inputVideo(k).cdata = readFrame(vidObj);
        k = k+1;
    end
    
else %%if Sequence of images for input
    vidName='fall-01-cam0-rgb';
    Dir_im = [baseName '\dataset\UR Fall Detection Dataset\' vidName '\'];
    file=ls(Dir_im);
    file=cellstr(file);
    inputVideo_dir=size(file,1); 
    kout=1;
    for cdir = 3:inputVideo_dir
        inputVideo(kout).cdata=imread([Dir_im  file{cdir}]);
        kout=kout+1;
    end
    [vidHeight,vidWidth] = size(inputVideo(1).cdata);
    
end
% %create folder..
	CreateFD;
%         
set(gcf,'position',[240 320 vidWidth vidHeight]);
set(gca,'units','pixels');
set(gca,'position',[0 0 vidWidth vidHeight]);
close
cd(baseName)
cd(foldername2)

global K M D alpha foregroundThreshold sd_initial mean standardDeviation diffFromMean learningRate rankComponent weight
fr = imresize(inputVideo(1).cdata,[240 320]);           % read in 1st frame as background frame
fr_bw = rgb2gray(fr);               % convert background to greyscale

    fr_size = size(fr);                 % get the size of the frame
    width = fr_size(2);                 % get the width of the frame
    height = fr_size(1);                % get the height of the frame
K = 3;                                           % number of gaussian components (can be upto 3-5) 3
M = 3;                                           % number of background components 3
D = 2.5;                                         % positive deviation threshold 2.5
alpha = 0.01;                                    % learning rate (between 0 and 1) (from paper 0.01) 
foregroundThreshold = 0.3;                      % foreground threshold (0.25 or 0.75 in paper) 0.25
sd_initial = 6;                                  % initial standard deviation (for new components) var = 36 in paper
weight = zeros(height,width,K);                  % initialize weights array
mean = zeros(height,width,K);                    % pixel means
standardDeviation = zeros(height,width,K);       % pixel standard deviations
diffFromMean = zeros(height,width,K);            % difference of each pixel from mean
learningRate = alpha/(1/K);                      % initial p variable (used to update mean and sd)
rankComponent = zeros(1,K);                      % rank of components (w/sd)

% initialize components for the  means and weights 

pixel_depth = 8;                        % 8-bit resolution
pixel_range = 2^pixel_depth -1;         % pixel range (# of possible values)

for i=1:height
    for j=1:width
        for k=1:K
            
            mean(i,j,k) = rand*pixel_range;          % means random (0-255), it initialzes the mean to some random value.
            weight(i,j,k) = 1/K;                     % weights uniformly dist
            standardDeviation(i,j,k) = sd_initial;   % initialize to sd_init
            
        end
    end
end

Kk=0; Ort1=0; Asp1=0; Ctx1=0; Cty1=0;countvid=0; Dat=0;
% Loop=k;
BGsum=double(inputVideo(1).cdata);
BGMean=imread(BGMean_dir); BGMean=double(BGMean)./(2^8); BGMean=uint8(BGMean);

% for n=1955:length(inputVideo)
for n = 1:length(inputVideo)
    %reading the frames.
    fr = imresize(inputVideo(n).cdata,[240 320]);  img2=fr;
    % converting the frames to grayscale.
    fr_bw = rgb2gray(fr);  
    [img2,closedFrameBW]=im_Mog(n,fr,fr_bw,img2);
    
     %Create Mean filter as a bg
%      Frame=double(fr); 
%      BGsum(:,:,1) = double(BGsum(:,:,1)+Frame(:,:,1));
%      BGsum(:,:,2) = double(BGsum(:,:,2)+Frame(:,:,2));
%      BGsum(:,:,3) = double(BGsum(:,:,3)+Frame(:,:,3));
%      BGMean=uint8(BGsum/(n)); %Average bg 
     fBG=imresize(inputVideo(1).cdata,[240 320]); %BG filter(First BG)
%         
       lim=k-1; countIP=n     
        num=int2str(n);
        imwrite(inputVideo(n).cdata,[vidName '-' num '.jpg'])
%         img=inputVideo(n).cdata; [x1 y1 z1]=size(img); 
%         Imfall=imresize(img,[height width]); img=Imfall;
      fBG=imresize(fBG,[height width]);
      IS=imresize(BGMean,[height width]);%first BG          
         
      %%BG subtraction  
     [Ibw,num,img2,fr]=BGsubtr(fr,IS,fBG,num,closedFrameBW);

% figure(1),imshow(closedFrameBW)
%  figure(2),imshow(img2)
% 
%        imwrite(background,[baseName '\' foldername3 '\' vidName '- background'  num '.jpg'])
%        imwrite(foreground,[baseName '\' foldername3 '\' vidName '- foreground'  num '.jpg'])
%        imwrite(closedFrame,[baseName '\' foldername4 '\' vidName '- closedFrame'  num '.jpg'])  
%         imwrite(closedFrameBW,[baseName '\' foldername4 '\' vidName '- closedFrameBW'  num '.jpg'])  
        imwrite(img2,[baseName '\' foldername6 '\' vidName '- img2'  num '.jpg'])  
        imwrite(Ibw,[baseName '\' foldername4 '\' vidName '- Ibw'  num '.jpg'])  

figure(1),subplot(3,3,1),imshow(img2)


        
%       figure(3),imshow(Ibw)
%         imwrite(Ibw,[baseName '\' foldername4 '\' vidName '-' num '.jpg'])
%         hold off
% 
     if sum(sum(Ibw)) < 240*320/2              
%        [Ibw,Kk,k] = pcacaldat(Ibw,k,Kk,num,img2);
       [Ibw,Dat,Kk,k,Ort1,Asp1] = pcacaldat(Ibw,k,Kk,num,img,Ort1,Asp1,Dat);
    
     end
    Frame_R=getframe(gcf);
    FrameResult=Frame_R.cdata;
    imwrite(FrameResult,[baseName '\' foldername6 '\' vidName '- ' num '.jpg'])
    countvid=countvid+1;
    VFrame.n=FrameResult;
    img=inputVideo(k-1).cdata;
%     hold off  
     

  
end
  xlswrite([baseName '\' foldername6 '\' vidName  '_Dat.xlsx'],Dat)


%%
% %SAVE VIDEO
v = VideoWriter([baseName '\' foldername6 '\' vidName  '_Dat.avi']);
open(v)
for k = 1:length(inputVideo)
%for k = 1:1000
counVD=k
A=imread([baseName '\' foldername6  '\' vidName '- ' int2str(k) '.jpg']);
A=imresize(A,[240 320]);
writeVideo(v,A)
end
close(v)