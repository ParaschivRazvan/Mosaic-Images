function imgMosaic = addPiecesRandomly(params)

imgMosaic = uint8(zeros(size(params.referenceImageResized)));
mosaicPiecesArrayDimensions = size(params.mosaicPieces);
dimImgRefRes = size(params.referenceImageResized);
mosaicPiecesMean = zeros(mosaicPiecesArrayDimensions(4), 3);

switch(params.criteria)
    case 'random'
        totalNoPixels =size(params.referenceImageResized,1)*size(params.referenceImageResized,2);
        % create matrix of zeros with the same sized as the resized reference image
        % mark with '1' the pixels which have been covered
        pixelLocations = zeros(size(params.referenceImageResized,1),size(params.referenceImageResized,2));
        
        emptyLocations = find(pixelLocations==0);
        
        while ~isempty(emptyLocations)
            % generate 500 empty locations
            candidateLocations = unique(randi(numel(emptyLocations), 1, 10000));
            
            % replace with '1'
            pixelLocations(emptyLocations(candidateLocations)) = 1;
            
            % find lines and columns of the selected indexes
            [row,col] = ind2sub([size(params.referenceImageResized,1),size(params.referenceImageResized,2)],emptyLocations(candidateLocations));
            
            
            for i = 1: numel(candidateLocations)
                % put the pieces
                startRow   = max(row(i)-mosaicPiecesArrayDimensions(1)/2-1,  1);
                endRow     = min(row(i)+mosaicPiecesArrayDimensions(1)/2-1,  size(params.referenceImageResized,1));
                startColumn = max(col(i)-mosaicPiecesArrayDimensions(2)/2-1,  1);
                endColumn   = min(col(i)+mosaicPiecesArrayDimensions(2)/2-1,  size(params.referenceImageResized,2));
                
                % treat the case where is a marginal pixel
                % use matrix of zeros, pozs, to mark
                % how many pixels for the current image will be displayed into the reference image
                
                pozs = zeros(size(params.mosaicPieces(:,:,:,1),1),size(params.mosaicPieces(:,:,:,1),2));
                if endRow - startRow<size(params.mosaicPieces(:,:,:,1),1)
                    pozs(size(params.mosaicPieces(:,:,:,1),1)-(endRow - startRow)+1:end,:) = ...
                        pozs(size(params.mosaicPieces(:,:,:,1),1)-(endRow - startRow)+1:end,:) + 1;
                end
                if endColumn-startColumn < size(params.mosaicPieces(:,:,:,1),2)
                    pozs(:,size(params.mosaicPieces(:,:,:,1),2) - (endColumn-startColumn)+1:end) = ...
                        pozs(:,size(params.mosaicPieces(:,:,:,1),2) - (endColumn-startColumn)+1:end) + 1;
                end
                
                % find the lines and columns where '1' was added
                [linii,coloane] = find(pozs==max(pozs(:)));
                
                % pick a random piece
                indice = randi(mosaicPiecesArrayDimensions(4));
                
                % get the needed pixels
                toAdd = params.mosaicPieces(min(linii):max(linii),min(coloane):max(coloane),:,indice);
                
                % add the piece
                if length(dimImgRefRes) == 2
                    imgMosaic(startRow:endRow-1,startColumn:endColumn-1,:) =  rgb2gray(toAdd);
                else
                    imgMosaic(startRow:endRow-1,startColumn:endColumn-1,:) =  toAdd;
                end
            end
            addedPieces = numel(emptyLocations);
            fprintf('Discovered pixels ... %2.2f%% \n',100*addedPieces/totalNoPixels);
            
            emptyLocations = find(pixelLocations==0);
            
        end
        
    %same algorithm applies  for the random positions
    %the mediumColorDistance algorithm is the same as in the grid case   
    case 'mediumColorDistance'
        totalNoPixels =size(params.referenceImageResized,1)*size(params.referenceImageResized,2);
        pixelLocations = zeros(size(params.referenceImageResized,1),size(params.referenceImageResized,2));
        
        emptyLocations = find(pixelLocations==0);
    
        for i = 1:mosaicPiecesArrayDimensions(4)
            auxImg = params.mosaicPieces(:,:,:,i);
            
            if length(dimImgRefRes) == 2
                mosaicPiecesMean(i,:) = mean(reshape(rgb2gray(auxImg), size(rgb2gray(auxImg),1)...
                    * size(rgb2gray(auxImg),2), size(rgb2gray(auxImg),3)));
            else
                mosaicPiecesMean(i,:) =  mean(reshape(auxImg, size(auxImg,1)...
                    * size(auxImg,2), size(auxImg,3)));
            end
        end
        
        while ~isempty(emptyLocations)
            
            candidateLocations = unique(randi(numel(emptyLocations), 1, 10000));

            pixelLocations(emptyLocations(candidateLocations)) = 1;
            
            [row,col] = ind2sub([size(params.referenceImageResized,1),size(params.referenceImageResized,2)],emptyLocations(candidateLocations));
            
            for i = 1: numel(candidateLocations)
            
                startRow   = int32(max(row(i)-mosaicPiecesArrayDimensions(1)/2-1,  1));
                endRow     = int32(min(row(i)+mosaicPiecesArrayDimensions(1)/2-1,  size(params.referenceImageResized,1)));
                startColumn = int32(max(col(i)-mosaicPiecesArrayDimensions(2)/2-1,  1));
                endColumn   = int32(min(col(i)+mosaicPiecesArrayDimensions(2)/2-1,  size(params.referenceImageResized,2)));
                
                pozs = zeros(size(params.mosaicPieces(:,:,:,1),1),size(params.mosaicPieces(:,:,:,1),2));
                if endRow - startRow<size(params.mosaicPieces(:,:,:,1),1)
                    pozs(size(params.mosaicPieces(:,:,:,1),1)-(endRow - startRow)+1:end,:) = ...
                        pozs(size(params.mosaicPieces(:,:,:,1),1)-(endRow - startRow)+1:end,:) + 1;
                end
                if endColumn-startColumn < size(params.mosaicPieces(:,:,:,1),2)
                    pozs(:,size(params.mosaicPieces(:,:,:,1),2) - (endColumn-startColumn)+1:end) = ...
                        pozs(:,size(params.mosaicPieces(:,:,:,1),2) - (endColumn-startColumn)+1:end) + 1;
                end
                
                [linii,coloane] = find(pozs==max(pozs(:)));
                
                auxMin = inf; indice = 0;
                imgBlock = params.referenceImageResized(startRow:endRow-1,startColumn:endColumn-1,:);

                imgBlockColors = mean(reshape(imgBlock, size(imgBlock,1)...
                    * size(imgBlock,2), size(imgBlock,3)));
                for m = 1:mosaicPiecesArrayDimensions(4)
                    if length(dimImgRefRes) == 2
                        distEuclid = sqrt((mosaicPiecesMean(m,1) - imgBlockColors(1))^2);
                    else
                        distEuclid = sqrt(sum((mosaicPiecesMean(m,:) - imgBlockColors).^2));
                    end
                    
                    if distEuclid < auxMin
                        auxMin = distEuclid;
                        indice = m;
                    end
                end
                
                toAdd = params.mosaicPieces(min(linii):max(linii),min(coloane):max(coloane),:,indice);
                
                if length(dimImgRefRes) == 2
                    imgMosaic(startRow:endRow-1,startColumn:endColumn-1) =  rgb2gray(toAdd);
                else 
                    imgMosaic(startRow:endRow-1,startColumn:endColumn-1,:) =  toAdd;
                end
                
                               
            end
            addedPieces = numel(emptyLocations);
            fprintf('Discovered pixels ... %2.2f%% \n',100*addedPieces/totalNoPixels);
            emptyLocations = find(pixelLocations==0);
            
        end
    ...   
    otherwise
    printf('EROR, unrecognized option \n');
    
end