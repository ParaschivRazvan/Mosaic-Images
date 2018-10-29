function imgMosaic = buildMosaic(params)
%main function of the project

%loads all the images needed for the mosaic construction
params = loadMosaicPieces(params);

%calculates the new dimensions of the image
params = calculateMosaicDimensions(params);

%add mosaic pieces
switch params.arrangeMode
    case 'grid'
        imgMosaic = addPiecesOnGrid(params);
    case 'random'
        imgMosaic = addPiecesRandomly(params);
    case 'hexagonal'
        %creates hexagonal pieces
        params = loadHexagonalMosaicPieces(params);
        imgMosaic = addHexagonalPieces(params);
        
end