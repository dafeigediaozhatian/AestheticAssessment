function H = HOGoperation(f)
% Based on Dahal and Triggs Histogram of gradients. RGB color space
% with no gamma correction; [-1,0,1] gradient filter with no smooting; 9
% orientation bins of 0~180 degree (unsigned); 16*16 pixel blocks for
% 8*8 pixel cells.

% the number of bins to use in histogram
numBins = 9;
% the cell size
cellSize = 8;

% empty vector to compute descriptor
H = [];

% ========================
% compute gradient vectors
% ========================
hx = [-1,0,1];
hy = hx';

dx = imfilter(double(f),hx);
dy = imfilter(double(f),hy);

% remove the 1 pixel border
dx = dx(2:(size(dx,1)-1),2:(size(dx,2)-1));
dy = dy(2:(size(dy,1)-1),2:(size(dy,2)-1));

% convet gradient vectors into polar coordinates
angles = atan2(dy,dx);
magnitude = ((dx.^2)+(dy.^2)).^.5;

% compute the number of cells horizontally and vertically of the entire img
nrows = size(dx,1);
ncols = size(dx,2);
numHorizCells = floor(ncols/8);
numVertCells = floor(nrows/8);

% ======================
% compute cell histogram
% ======================
histograms = zeros(numVertCells,numHorizCells,9);
for row = 0:(numVertCells-1)
    rowOffset = row*cellSize+1;
    for col = 0:(numHorizCells-1)
        colOffset = col*cellSize+1;
        % pixel indeces inside one cell
        rowIndeces = rowOffset:(rowOffset+cellSize-1);
        colIndeces = colOffset:(colOffset+cellSize-1);
        % angels and magnitude of pixels in one cell
        cellAngles = angles(rowIndeces,colIndeces);
        cellMags = magnitude(rowIndeces,colIndeces);
        % generate histogram for the cell
        histograms(row+1,col+1,:) = getHist(cellMags(:),cellAngles(:),numBins);
    end
end

% ===================
% block normalization
% ===================

for row = 1:(numVertCells-1)
    for col = 1:(numHorizCells-1)
        blockHists = histograms(row:row+1,col:col+1,:);
        magnitude = norm(blockHists(:))+0.01;
        normalized = blockHists/magnitude;
        
        H = [H;normalized(:)];
    end
end

        
        