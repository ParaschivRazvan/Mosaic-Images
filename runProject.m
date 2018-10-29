%mosaic creation project

%sets the parameters for the function
%read the image which is going to be transformed
params.referenceImage = imread('../data/imaginiTest/tomJerry.jpeg');
%sets the director in which the collection of images is being stored
params.directorName = '../data/flori/';

%sets the type of the images used for the mosaic build
params.imageType = 'png';

%sets the number of pieces displayed on the horizontal side of the new image
%try 25, 50, 75, 100
params.horizontalPiecesNumber = 100;

%the number of pieces on the vertical side will be determined automatically

%sets the option of printing the first 100 images from the collection
params.showMosaicPieces = 0;

%sets how the pieces will be arranged
%options: 'random','grid','hexagonal'
params.arrangeMode = 'hexagonal';

%sets the criteria by which the pieces will be arranged
%options: 'random','mediumColorDistance'
params.criteria = 'mediumColorDistance';

%main function call
imgMosaic = buildMosaic(params);

imwrite(imgMosaic,'mosaic.jpg');
%dont print the hexagonal image, since it is being printed within the hexagonal arrangement function
if ~strcmp(params.arrangeMode, 'hexagonal') 
figure, imshow(imgMosaic)
end



 
