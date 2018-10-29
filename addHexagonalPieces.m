function imgMosaic = addHexagonalPieces(params)

mosaicPiecesArrayDimensions = size(params.mosaicPieces);
dimImRefRes1 = size(params.referenceImageResized);
mosaicPiecesMean = zeros(mosaicPiecesArrayDimensions(4), 3);
%resize the image so the hexagons fit thoroughly
params.referenceImageResized = imresize(params.referenceImageResized,...
    [dimImRefRes1(1), dimImRefRes1(2) - mod(dimImRefRes1(2), 4 * mosaicPiecesArrayDimensions(2) / 3) - mosaicPiecesArrayDimensions(2)/3]  + 1);
%create 2 images which contain columns of hexagonal pieces
imgMosaicHexa1 = uint8(zeros(size(params.referenceImageResized)));
imgMosaicHexa2 = uint8(zeros(size(params.referenceImageResized)));

dimImgMosaicHexa2 = size(imgMosaicHexa2);
dimImRefRes = size(params.referenceImageResized);
%matrix which contains the positions of the hexagons
positionsMatrix = zeros(2*dimImRefRes(1)+2, 2*(dimImRefRes(2)+ mosaicPiecesArrayDimensions(2)/3 - 1)+2);
%calculate the mean values of the hexagonal pieces
for i = 1:mosaicPiecesArrayDimensions(4)
    auxImg = params.hexaPiecesMosaic(:,:,:,i);
    if length(dimImRefRes) == 2
        mosaicPiecesMean(i,:) = mean(reshape(rgb2gray(auxImg), size(rgb2gray(auxImg),1)...
        * size(rgb2gray(auxImg),2), size(rgb2gray(auxImg),3)));
    else
        mosaicPiecesMean(i,:) =  mean(reshape(auxImg, size(auxImg,1)...
        * size(auxImg,2), size(auxImg,3)));
    end
end
%initialize start positions within the matrix
 linePozition1 = 3;
%create the first image which contains columns of hexagonal pieces with blank spaces inbetween them
for i =1:mosaicPiecesArrayDimensions(1):dimImRefRes(1)-mosaicPiecesArrayDimensions(1)
    columnPozition1 = 3;
    for j=1:4*mosaicPiecesArrayDimensions(2)/3 :dimImRefRes(2)
        auxMin = inf; indice = 0;
        imgBlock = params.referenceImageResized(i:i + mosaicPiecesArrayDimensions(1)-1,j :j+mosaicPiecesArrayDimensions(2)-1,:);
        %calcularea mediei culorilor blocului selectat
        imgBlockColors = mean(reshape(imgBlock, size(imgBlock,1)...
        * size(imgBlock,2), size(imgBlock,3)));
        %verifica piesele mozaicului pentru distanta euclidiana cea mai
        %mica si sa aiba vecini distincti
        for m = 1:mosaicPiecesArrayDimensions(4)
            if length(dimImRefRes) == 2
                distEuclid = sqrt((mosaicPiecesMean(m,1) - imgBlockColors(1))^2);
            else
                distEuclid = sqrt(sum((mosaicPiecesMean(m,:) - imgBlockColors).^2)); 
            end
            %verifica sa aibe vecini distincti
            if distEuclid < auxMin && positionsMatrix(linePozition1 - 2, columnPozition1) ~= m
                auxMin = distEuclid;
                indice = m;
            end
        end
        
        if length(dimImRefRes) == 2
            imgMosaicHexa1(i:i + mosaicPiecesArrayDimensions(1)-1,j :j+mosaicPiecesArrayDimensions(2)-1,:) = ...
            rgb2gray(params.hexaPiecesMosaic(:,:,:,indice)); 
        else
            imgMosaicHexa1(i:i + mosaicPiecesArrayDimensions(1)-1,j :j+mosaicPiecesArrayDimensions(2)-1,:) = ...
            params.hexaPiecesMosaic(:,:,:,indice);   
        end
        positionsMatrix(linePozition1, columnPozition1 ) = indice;
        columnPozition1 = columnPozition1 + 2;
    end
    linePozition1 = linePozition1 + 2;      
end

%assambles the second image which fills the blank spaces left within the first image
%initialize the start pozitions within the matrix
linePozition2 = 4;
for i = mosaicPiecesArrayDimensions(1)/2:mosaicPiecesArrayDimensions(1):dimImRefRes(1)-mosaicPiecesArrayDimensions(1)
    columnPozition2 = 4;
    for j=2*mosaicPiecesArrayDimensions(2)/3:4*mosaicPiecesArrayDimensions(2)/3:dimImRefRes(2)-4*mosaicPiecesArrayDimensions(2)/3
        auxMin = inf; indice = 0;
        imgBlock = params.referenceImageResized(i:i + mosaicPiecesArrayDimensions(1)-1,j :j+mosaicPiecesArrayDimensions(2)-1,:);
        %calculates the mean color value of the selected block
        imgBlockColors = mean(reshape(imgBlock, size(imgBlock,1)...
        * size(imgBlock,2), size(imgBlock,3)));
        %searches for the mosaic image withe the smallest euclidian distance and which
        %satisfies the neighbour constraint
        for m = 1:mosaicPiecesArrayDimensions(4)
            if length(dimImRefRes) == 2
                distEuclid = sqrt((mosaicPiecesMean(m,1) - imgBlockColors(1))^2);
            else
                distEuclid = sqrt(sum((mosaicPiecesMean(m,:) - imgBlockColors).^2)); 
            end
            if distEuclid < auxMin && m ~= positionsMatrix(linePozition2-2, columnPozition2) && ...
                    m ~= positionsMatrix(linePozition2 -1 ,columnPozition2 -1 ) &&...
                    m ~= positionsMatrix(linePozition2 + 1, columnPozition2 -1) && ...
                    m ~= positionsMatrix(linePozition2 -1, columnPozition2 + 1) &&...
                    m ~= positionsMatrix(linePozition2 + 1, columnPozition2 + 1) 
                auxMin = distEuclid;
                indice = m;
            end
        end

        if length(dimImRefRes) == 2
        imgMosaicHexa2(i:i + mosaicPiecesArrayDimensions(1)-1,j :j+mosaicPiecesArrayDimensions(2)-1,:) = ...
        rgb2gray(params.hexaPiecesMosaic(:,:,:,indice)); 
        else
        imgMosaicHexa2(i:i + mosaicPiecesArrayDimensions(1)-1,j :j+mosaicPiecesArrayDimensions(2)-1,:) = ...
        params.hexaPiecesMosaic(:,:,:,indice);   
        end
        positionsMatrix(linePozition2, columnPozition2 ) = indice;
       columnPozition2 = columnPozition2 + 2;
    end
    linePozition2 = linePozition2 + 2;
end

imshow(imgMosaicHexa1);
hold on 
h = imshow(imgMosaicHexa2); 
hold off
%creates the transparency mask for the images superimposing
B = ones(dimImgMosaicHexa2(1),dimImgMosaicHexa2(2));

for i =1:dimImgMosaicHexa2(1)
    for j = 1:dimImgMosaicHexa2(2)
    if(imgMosaicHexa2(i,j) ==0)
        B(i,j) = 0;
    end
    end
end
set(h, 'AlphaData', B);
%obtain the image from the displayed frame in order to return it as an output argument of the function
F = getframe(gcf);
imgMosaic = frame2im(F);
 
cleanHexFolder(params);
end

