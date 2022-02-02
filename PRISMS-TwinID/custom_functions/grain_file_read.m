% Zhe Chen, 2016-12-14
% based on 2015-10-28 code
% From type-1 or type-2 grain file (txt format).
% import matrix or cell array.
%
% chenzhe, 2017-08-14, use this to replace csvread to read grain file data
% directly from grain_file.txt.  Because csv file appear to have a limit,
% cannot export all data to csv.
%
% chenzhe, 2017-08-31, add 'header' as an output.

function [dataMatrix, header] = grain_file_read(grainFile)

fid = fopen(grainFile);
% scan text line by line, store it in 'C' which is n by 1 cell, n = number of lines in text
C=textscan(fid,'%s','delimiter','\n');
C=C{1,1};
fclose(fid);

% find how many header lines this file has (If line start with #, it is a header)
nHeaderRow = 0;
nTotalRow = size(C,1);
iHeaderRow = 1;
while strcmp('#',C{iHeaderRow}(1))
    nHeaderRow = nHeaderRow+1;
    iHeaderRow = iHeaderRow+1;
end
nDataRow = nTotalRow - nHeaderRow;

% compare words after '# Column XX', determine column names And type of grain file
iCSVHeader = 1;
grainFileType = 2;      % indicators of grainFileType
haveNeighborInfo1 = 0;  % indicators of having neighbor grain info
haveNeighborInfo2 = 0;
for iRow = 1:nHeaderRow
    string = C{iRow};
    [token, remain] = strtok(string,':');
    switch remain
        case ': Integer identifying grain'
            header{iCSVHeader} = 'grainId';
            iCSVHeader = iCSVHeader + 1;
        case ': Average orientation (phi1, PHI, phi2) in degrees'
            header{iCSVHeader} = 'phi1-d';
            header{iCSVHeader+1} = 'phi-d';
            header{iCSVHeader+2} = 'phi2-d';
            iCSVHeader = iCSVHeader + 3;
        case ': Average orientation (phi1, PHI, phi2) in radians'
            header{iCSVHeader} = 'phi1-r';
            header{iCSVHeader+1} = 'phi-r';
            header{iCSVHeader+2} = 'phi2-r';
            iCSVHeader = iCSVHeader + 3;
        case ': Average Position (x, y) in microns'
            header{iCSVHeader} = 'x-um';
            header{iCSVHeader+1} = 'y-um';
            iCSVHeader = iCSVHeader + 2;
        case ': Average Image Quality (IQ)'
            header{iCSVHeader} = 'IQ';
            iCSVHeader = iCSVHeader + 1;
        case ': Average Confidence Index (CI)'
            header{iCSVHeader} = 'CI';
            iCSVHeader = iCSVHeader + 1;
        case ': Average Fit (degrees)'
            header{iCSVHeader} = 'Fit';
            iCSVHeader = iCSVHeader + 1;
        case ': An integer identifying the phase'
            header{iCSVHeader} = 'phase';
            iCSVHeader = iCSVHeader + 1;
        case ': Edge grain (1) or interior grain (0)'
            header{iCSVHeader} = 'edge';
            iCSVHeader = iCSVHeader + 1;
        case ': Number of measurement points in the grain'
            header{iCSVHeader} = 'n-meas';
            iCSVHeader = iCSVHeader + 1;
        case ': Area of grain in square microns'
            header{iCSVHeader} = 'area-umum';
            iCSVHeader = iCSVHeader + 1;
        case ': Diameter of grain in microns'
            header{iCSVHeader} = 'grain-dia-um';
            iCSVHeader = iCSVHeader + 1;
        case ': ASTM grain size'
            header{iCSVHeader} = 'ASTM-gs';
            iCSVHeader = iCSVHeader + 1;
        case ': Aspect ratio of ellipse fit to grain'
            header{iCSVHeader} = 'aspectRatio';
            iCSVHeader = iCSVHeader + 1;
        case ': Length of major axis of ellipse fit to grain in microns'
            header{iCSVHeader} = 'majorAxis';
            iCSVHeader = iCSVHeader + 1;
        case ': Length of minor axis of ellipse fit to grain in microns'
            header{iCSVHeader} = 'minorAxis';
            iCSVHeader = iCSVHeader + 1;
        case ': Orientation (relative to the horizontal) of major axis of ellipse fit to grain in degrees'
            header{iCSVHeader} = 'majorOrient';
            iCSVHeader = iCSVHeader + 1;
        case ': Grain ellipticity'
            header{iCSVHeader} = 'ellipticity';
            iCSVHeader = iCSVHeader + 1;
        case ': Grain circularity'
            header{iCSVHeader} = 'circularity';
            iCSVHeader = iCSVHeader + 1;
        case ': Maximmum Feret diameter# Column 26: Minimum Feret diameter'
            header{iCSVHeader} = 'max-Feret-dia';
            header{iCSVHeader+1} = 'min-Feret-dia';
            iCSVHeader = iCSVHeader + 2;
        case ': Average orientation spread in grain (average misorientation of all point pairs)'
            header{iCSVHeader} = 'grain-spread';
            iCSVHeader = iCSVHeader + 1;
        case ': Average misorientation in grain (average misorientation of neighboring point pairs)'
            header{iCSVHeader} = 'grain-misorient';
            iCSVHeader = iCSVHeader + 1;
        case ': Number of grains neighboring current grain and their grain IDs (Count id1 id2 id3 ...)'
            header{iCSVHeader} = 'n-neighbor+id';
            iCSVHeader = iCSVHeader + 1;
            haveNeighborInfo1 = 1;
        case ': Number of grains neighboring current grain and their grain IDs (Count id1 (w1) id2 (w2) id3 (w3) ...)'
            if ~strcmp(header{iCSVHeader-1},'n-neighbor+id')
                header{iCSVHeader} = 'n-neighbor+id(+w)';
                iCSVHeader = iCSVHeader + 1;
            end
            haveNeighborInfo2 = 1;
        case ': phi1, PHI, phi2 (orientation of point in radians)' % this is type-1 grain file
            header = {'phi1-r','phi-r','phi2-r','x-um','y-um','IQ','CI','Fit','grain-ID','edge'};
            iCSVHeader = iCSVHeader + 10;
            grainFileType = 1;
            
    end
end
nCSVHeader = iCSVHeader - 1;

% read numeric data, and write to CSV file
if grainFileType == 1
    dataMatrix = zeros(nDataRow,10);
    for iRow = 1:nDataRow
        currentRowData = textscan(C{iRow + nHeaderRow},'%f',nCSVHeader);
        dataMatrix(iRow,:) = currentRowData{1,1}';
    end

end

if grainFileType == 2
    if haveNeighborInfo1 == 1
        for iRow = 1:nDataRow
            currentRowData = textscan(C{iRow + nHeaderRow},'%f',nCSVHeader);
            nNeighborGrain = currentRowData{1}(nCSVHeader);
            currentRowData = textscan(C{iRow + nHeaderRow},'%f',nCSVHeader+nNeighborGrain);
            dataCell{iRow,1} = currentRowData{1}';
        end
    elseif haveNeighborInfo2 == 1
        for iRow = 1:nDataRow
            currentRowString = textscan(C{iRow + nHeaderRow},'%s','delimiter','\n');
            currentRowString = currentRowString{1};
            currentRowString = strrep(currentRowString,'(','');
            currentRowString = strrep(currentRowString,')','');
            
            currentRowData = textscan(currentRowString{1},'%f',nCSVHeader);
            nNeighborGrain = currentRowData{1}(nCSVHeader);
            
            currentRowData = textscan(currentRowString{1},'%f',nCSVHeader+nNeighborGrain*2);
            dataCell{iRow,1} = currentRowData{1}';
        end
    end
    
    maxWidth = 0;
    for iRow = 1:nDataRow
        maxWidth = max(maxWidth,length(dataCell{iRow}));
    end
    dataMatrix = zeros(nDataRow,maxWidth);
    for iRow = 1:nDataRow
        dataMatrix(iRow,1:length(dataCell{iRow})) = dataCell{iRow};
    end
    
end

% disp('Header = ');
% disp(header);




