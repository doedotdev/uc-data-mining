function x = recursiveSplit(allEverythingTable, level, parent, builderString)
    disp('-----CALCULATE NEW NODE----');
    sz = size(allEverythingTable);
    rows = sz(1);
    cols = sz(2);
    fprintf('Data Size: Rows: %i Cols: %i\n\n', rows, cols);
    level = level + 1;
    
    if (rows > 1)
        
        % calculate
        coeffs = [];
        for i = 1:11
           temp = corrcoef(allEverythingTable(:,i), allEverythingTable(:,12), 'rows','complete');
           coeffs = [coeffs, temp(2,1)];
        end

        bestIndex = find(coeffs == max(coeffs));
        bestIndex = bestIndex(1);
        

        sortDataSetOnAttribute = sortrows(allEverythingTable, bestIndex);

        dataSetLen = size(sortDataSetOnAttribute);
        dataSetLen = dataSetLen(1);
    %     if (mod(dataSetLen,2) == 0) 
    %         lefthalfTop = 
    %     else
    %         
    %     end

        newTestDataLeft = sortDataSetOnAttribute(1:ceil(dataSetLen/2), :);
        meanLeft = mean(sortDataSetOnAttribute(1:ceil(dataSetLen/2), 12));
        newTestDataRight = sortDataSetOnAttribute(ceil(dataSetLen/2)+1:end,:);
        meanRight = mean(sortDataSetOnAttribute(ceil(dataSetLen/2)+1, 12));


        valSplit = mean([sortDataSetOnAttribute(ceil(dataSetLen/2), bestIndex),sortDataSetOnAttribute(ceil((dataSetLen/2)+1), bestIndex)]);

        sR = size(newTestDataRight);
        sR = sR(1);
        sL = size(newTestDataLeft);
        sL = sL(1);

        diffSquared = [];
        for i = 1:sL
            diff = newTestDataLeft(i, 12) - meanLeft;
            diffSquared = [ diffSquared, diff.^2;];
        end
        for i = 1:sR
            diff = newTestDataRight(i, 12) - meanRight;
            diffSquared = [ diffSquared, diff.^2;];
        end

        MSE = mean(diffSquared);

        uniqueNodeValue = strcat('node',num2str(level),'n',num2str(MSE));

        if (MSE > 1)
            fprintf('Node: %s on level %i with parent: %s \n', uniqueNodeValue, level, parent);
            fprintf('IF INDEX: %i <= %f return %f \n',bestIndex, valSplit, meanLeft);
            fprintf('IF INDEX: %i > %f return %f \n',bestIndex, valSplit, meanRight);
            fprintf('This Node has the MSE of: %f which is over threshold. Calculate MORE Nodes. \n\n', MSE);
            buildStr = strcat(' Node:',uniqueNodeValue,'w/ MSE:', num2str(MSE));
            builderString = strcat(builderString,' =>',' ',buildStr);
            myFun(newTestDataLeft, level, uniqueNodeValue, builderString);
            myFun(newTestDataRight, level, uniqueNodeValue, builderString);
        else
            fprintf('Node: %s on LEAFlevel %i with parent: %s \n', uniqueNodeValue, level, parent);
            fprintf('IF INDEX: %i <= %f return %f \n',bestIndex, valSplit, meanLeft);
            fprintf('IF INDEX: %i > %f return %f \n',bestIndex, valSplit, meanRight);
            buildStr = strcat(' Node:',uniqueNodeValue,'w/ MSE:', num2str(MSE));
            builderString = strcat(builderString,' =>',' ',buildStr);
            fprintf('This Node has the MSE of: %f which is under threshold. This is a LEAF. \n', MSE);
            fprintf('LEAF: %s\n\n',builderString);
        end
    else
        uniqueNodeValue = strcat('node',num2str(level),'n0');
        buildStr = strcat(' Node:',uniqueNodeValue,'w/ MSE:0');
        builderString = strcat(builderString,' =>',' ',buildStr);
        uniqueNodeValue = strcat('node',num2str(allEverythingTable(1,12)));
        fprintf('Node: %s on LEAFlevel %i with parent: %s\n', uniqueNodeValue, level, parent);
        fprintf('Return Value =  %f\n', allEverythingTable(1,12));
        fprintf('LEAF: %s\n\n',builderString);
    end

    
end