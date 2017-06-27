function  [img2,closedFrameBW]=im_Mog(n,fr,fr_bw,img2)
global baseName vidName foldername3 foldername4 foldername6
global K M D alpha foregroundThreshold sd_initial mean standardDeviation diffFromMean learningRate rankComponent weight

    fr_size = size(fr);                 % get the size of the frame
    width = fr_size(2);                 % get the width of the frame
    height = fr_size(1);                % get the height of the frame
    foreground = zeros(height, width);  % initialize variable to store foreground
    foregroundbwimg= zeros(height, width);  
    background = zeros(height, width);       % initialize variable to store background
    % calculating the difference of each pixel values from mean.
    for m=1:K
        diffFromMean(:,:,m) = abs(double(fr_bw) - double(mean(:,:,m)));
    end
     
    % update gaussian components for each pixel values.
    for i=1:height
        for j=1:width
            
            match = 0; % its changed to 1 if the component is matched
            for k=1:K  
                % pixel matches component
                if (abs(diffFromMean(i,j,k)) <= D*standardDeviation(i,j,k))       
                    % variable to signal component match
                    match = 1;                          
                    
                    % update weights, mean, standard deviation and
                    % learning factor
                    weight(i,j,k) = (1-alpha)*weight(i,j,k) + alpha;
                    learningRate = alpha/weight(i,j,k);                  
                    mean(i,j,k) = (1-learningRate)*mean(i,j,k) + learningRate*double(fr_bw(i,j));
                    standardDeviation(i,j,k) =   sqrt((1-learningRate)*(standardDeviation(i,j,k)^2) + learningRate*((double(fr_bw(i,j)) - mean(i,j,k)))^2);
                else                                    % if pixel doesn't match component
                    weight(i,j,k) = (1-alpha)*weight(i,j,k);      % weight slighly decreases
                    
                end
            end
            
            weight(i,j,:) = weight(i,j,:)./sum(weight(i,j,:));
            
            %Save the background using all the components of gaussian.            
            background(i,j)=0;
            for k=1:K
                background(i,j) = background(i,j)+ mean(i,j,k)*weight(i,j,k);
            end
            
            % if no components match, create new component and decrease the
            % parameters values
            if (match == 0)
                [min_w, min_w_index] = min(weight(i,j,:));  
                mean(i,j,min_w_index) = double(fr_bw(i,j));
                standardDeviation(i,j,min_w_index) = sd_initial;
            end

            rankComponent = weight(i,j,:)./standardDeviation(i,j,:);             % calculate component's rank
            rankIndex = [1:1:K];
            
            % sort rank values
            for k=2:K               
                for m=1:(k-1)
                    
                    if (rankComponent(:,:,k) > rankComponent(:,:,m))                     
                        % swap max values
                        rank_temp = rankComponent(:,:,m);  
                        rankComponent(:,:,m) = rankComponent(:,:,k);
                        rankComponent(:,:,k) = rank_temp;
                        
                        % swap max index values
                        rank_ind_temp = rankIndex(m);  
                        rankIndex(m) = rankIndex(k);
                        rankIndex(k) = rank_ind_temp;    

                    end
                end
            end
            
            % calculate foreground and save it.
            match = 0;
            k=1;
            
            foreground(i,j) = 0; 
            foregroundbwimg(i,j) = 0;
            while ((match == 0)&&(k<=M))

                if (weight(i,j,rankIndex(k)) >= foregroundThreshold)
                    if (abs(diffFromMean(i,j,rankIndex(k))) <= D*standardDeviation(i,j,rankIndex(k)))
                        foreground(i,j) = 0;
                        match = 1;
                        foregroundbwimg(i,j) = 0;
                    else
                        foreground(i,j) = fr_bw(i,j);  
                        foregroundbwimg(i,j) = 1;
                    end
                end
                k = k+1;
            end
        end
    end
    
    %Structure element for performing morphological operations
     SE=[0 0 0 0 0
        0 1 1 1 0
        0 1 1 1 0
        0 1 1 1 0
        0 0 0 0 0];
    
    %Performing closing on the foreground frames using SE
    closedFrame=imclose(foreground,SE);  
%     closedFrameBW=imclose(foregroundbwimg,SE); 
    closedFrameBW=imfill(foregroundbwimg); 
    closedFrameBW=bwareaopen(closedFrameBW,10);
%     closedFrameBW=imclose(closedFrameBW,SE); 
    
%        lineIbw = edge(closedFrameBW,'Canny');
%        for i = 1:size(lineIbw,1)
%                 for j = 1:size(lineIbw,2)
%                     if lineIbw(i,j) == 1
%                          img2(round(i,j),1) = 0;
%                          img2(round(i),round(j),2) = 255;
%                          img2(round(i),round(j),3) = 0;
%                     end
%                 end
%        end  

    num=int2str(n);
%     % Plotting the foreground , background , original video and the morphed
%     % video on the screen.
%     figure(1),
%     subplot(2,2,1),imshow(fr), title('Original Video');
%     subplot(2,2,2),imshow(uint8(background)), title('Background Model');
%     subplot(2,2,3),imshow(uint8(foreground)) , title('Foreground( Moving Objects )');
%     subplot(2,2,4),imshow(uint8(closedFrame)) , title('After Morphological operation');
%     
%      figure(2),imshow(img2)
% 
%        imwrite(background,[baseName '\' foldername3 '\' vidName '- background'  num '.jpg'])
%        imwrite(foreground,[baseName '\' foldername3 '\' vidName '- foreground'  num '.jpg'])
%        imwrite(closedFrame,[baseName '\' foldername4 '\' vidName '- closedFrame'  num '.jpg'])  
        imwrite(closedFrameBW,[baseName '\' foldername4 '\' vidName '- _Mog'  num '.jpg'])  
%        imwrite(img2,[baseName '\' foldername6 '\' vidName '- img2'  num '.jpg'])  
%         