function [data] = readRaw(sheet)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    % Specify the Excel file and sheet
    excelFile = 'QuadCutsRawToRead.xlsx'; 
    sheetName = sheet; 

    %% Read data from the specified sheet into a table
    tab1 = readtable(excelFile, 'Sheet', sheetName);

    nanIndices = ismissing(tab1); % Identify NaN values in the table
    [r, c] = size(nanIndices); % Ugly lil script to replace NaN values with 0
    for i = 1:r
        for ii = 1:c
            if nanIndices(i,ii) == 1
                tab1(i,ii) = {0};
            end 
        end
    end
    
    % determine from A B C colums what the location is
    for ii = 1:r
        if tab1.A(ii) == 1
            tab1.loc(ii) = "D";
        elseif tab1.B(ii) == 1
            tab1.loc(ii) = "G";
        else
            tab1.loc(ii) = "R";
        end
    end
                
    
    %% return table
    data = tab1;
end

