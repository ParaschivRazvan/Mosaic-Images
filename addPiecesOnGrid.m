function imgMosaic = addPiecesOnGrid(params)
%adds pieces of mosaic on the grid
%'mediumColorDistance' also selects different neighbours on both vertical and horizontal directions
imgMosaic = uint8(zeros(size(params.referenceImageResized)));
mosaicPiecesArrayDimenions = size(params.mosaicPieces);
dimImRefRes = size(params.referenceImageResized);
%vectorul de culori medii pentru fiecare piesa din colectie
mosaicPiecesMean = zeros(mosaicPiecesArrayDimenions(4), 3);
%matrix of positions for the neighbours validation  
%the matrix is bordered in order to treat the marginal cases
piecesPozitions = zeros(params.horizontalPiecesNumber + 2,params.verticalPiecesNumber + 2);
totalPieces = params.horizontalPiecesNumber * params.verticalPiecesNumber;
addedPieces = 0;

switch(params.criteria)
    case 'random'
        %pune o piese aleatoare in mozaic, nu tine cont de nimic

        for i =1:params.verticalPiecesNumber
            for j=1:params.horizontalPiecesNumber
                %alege un index aleator din cele N
                index = randi(mosaicPiecesArrayDimenions(4)); 
                
                if length(dimImRefRes) == 2 
                    imgMosaic((i-1)*mosaicPiecesArrayDimenions(1)+1:i*mosaicPiecesArrayDimenions(1),(j-1)*mosaicPiecesArrayDimenions(2)+1:j*mosaicPiecesArrayDimenions(2),:) = ...
                        rgb2gray(params.mosaicPieces(:,:,:,index));
                else 
                    imgMosaic((i-1)*mosaicPiecesArrayDimenions(1)+1:i*mosaicPiecesArrayDimenions(1),(j-1)*mosaicPiecesArrayDimenions(2)+1:j*mosaicPiecesArrayDimenions(2),:) = ...
                        params.mosaicPieces(:,:,:,index);   
                end
                addedPieces = addedPieces+1;
                fprintf('Building mosaic ... %2.2f%% \n',100*addedPieces/totalPieces);
            end
        end
        
    case 'mediumColorDistance'
        %calculate the mean color for all the pieces       
        for i = 1:mosaicPiecesArrayDimenions(4)
            auxImg = params.mosaicPieces(:,:,:,i);
            %treats the case when the reference image is in grayscale
            if length(dimImRefRes) == 2
                mosaicPiecesMean(i,:) = mean(reshape(rgb2gray(auxImg), size(rgb2gray(auxImg),1)...
                * size(rgb2gray(auxImg),2), size(rgb2gray(auxImg),3)));
            else
                mosaicPiecesMean(i,:) =  mean(reshape(auxImg, size(auxImg,1)...
                * size(auxImg,2), size(auxImg,3)));
            end
        end

        
        for i = 1:params.verticalPiecesNumber
            for j = 1:params.horizontalPiecesNumber
                auxMin = inf; index = 0;
                %selcts a region from the original image  
                imgBlock = params.referenceImageResized((i-1)*mosaicPiecesArrayDimenions(1)+1:i*mosaicPiecesArrayDimenions(1),(j-1)*mosaicPiecesArrayDimenions(2)+1:j*mosaicPiecesArrayDimenions(2),:);
                %calculate the mean color for the selected region
                imgBlockColors = mean(reshape(imgBlock, size(imgBlock,1)...
                * size(imgBlock,2), size(imgBlock,3)));
                %checks which image has the lowest euclidian distance and satisfies the neighbour constraint
                for m = 1:mosaicPiecesArrayDimenions(4)
                    if length(dimImRefRes) == 2
                        distEuclid = sqrt((mosaicPiecesMean(m,1) - imgBlockColors(1))^2);
                    else
                        distEuclid = sqrt(sum((mosaicPiecesMean(m,:) - imgBlockColors).^2)); 
                    end
            
                    if distEuclid < auxMin && m ~= piecesPozitions(j + 1, i) && m ~= piecesPozitions(j, i + 1) 
                        auxMin = distEuclid;
                        index = m;
                    end
                end
                %add the image to the mosaic
                if length(dimImRefRes) == 2
                    imgMosaic((i-1)*mosaicPiecesArrayDimenions(1)+1:i*mosaicPiecesArrayDimenions(1),(j-1)*mosaicPiecesArrayDimenions(2)+1:j*mosaicPiecesArrayDimenions(2)) = ...
                        rgb2gray(params.mosaicPieces(:,:,:,index));
                else
                    imgMosaic((i-1)*mosaicPiecesArrayDimenions(1)+1:i*mosaicPiecesArrayDimenions(1),(j-1)*mosaicPiecesArrayDimenions(2)+1:j*mosaicPiecesArrayDimenions(2),:) = ...
                        params.mosaicPieces(:,:,:,index);
                end

                %marks the added image into the positions matrix
                piecesPozitions(j+1,i+1) = index;
                
                addedPieces = addedPieces+1;
                fprintf('Building mosaic ... %2.2f%% \n',100*addedPieces/totalPieces);
         
            end
           
        end
       
    otherwise
        printf('ERROR, unrecognized option \n');
        
       
end
    
    
    
    
    
