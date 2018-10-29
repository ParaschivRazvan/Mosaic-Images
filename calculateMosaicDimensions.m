function params = calculateMosaicDimensions(params)
%calculates the mosaic dimensions
%redimensions the reference image
 mosaicPieceDimensions = size(params.mosaicPieces(:, :, :, 1));
 initialReferenceImageDimensions = size(params.referenceImage);

%automatically calculates the number of pieces on the vertical side
 params.verticalPiecesNumber = round((initialReferenceImageDimensions(1) * params.horizontalPiecesNumber * ...
 mosaicPieceDimensions(2))/(mosaicPieceDimensions(1) * initialReferenceImageDimensions(2)));
 
%resizes the intial iamge based on the new dimensions
params.referenceImageResized = imresize(params.referenceImage, [mosaicPieceDimensions(1) * params.verticalPiecesNumber,...
mosaicPieceDimensions(2)* params.horizontalPiecesNumber]);

