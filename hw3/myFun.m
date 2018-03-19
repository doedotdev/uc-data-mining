function y = recursiveSplit(allEverythingTable, level, parent)
    disp('-----CALCULATE NEW NODE----');
    sz = size(allEverythingTable);
    rows = sz(1);
    cols = sz(2);
    fprintf('Rows: %i Cols: %i\n', rows, cols);
    level = level + 1;
    
    if (rows > 1)
        
        % calculate
        coeffs = [];
        for i = 1:32
           temp = corrcoef(allEverythingTable(:,i), allEverythingTable(:,33), 'rows','complete');
           coeffs = [coeffs, temp(2,1)];
        end

        bestIndex = find(coeffs == max(coeffs));

        sortDataSetOnAttribute = sortrows(allEverythingTable, bestIndex);

        dataSetLen = size(sortDataSetOnAttribute);
        dataSetLen = dataSetLen(1);
    %     if (mod(dataSetLen,2) == 0) 
    %         lefthalfTop = 
    %     else
    %         
    %     end

        newTestDataLeft = sortDataSetOnAttribute(1:ceil(dataSetLen/2), :);
        meanLeft = mean(sortDataSetOnAttribute(1:ceil(dataSetLen/2), 33));
        newTestDataRight = sortDataSetOnAttribute(ceil(dataSetLen/2)+1:end,:);
        meanRight = mean(sortDataSetOnAttribute(ceil(dataSetLen/2)+1, 33));


        valSplit = mean([sortDataSetOnAttribute(ceil(dataSetLen/2), bestIndex),sortDataSetOnAttribute(ceil((dataSetLen/2)+1), bestIndex)]);

        sR = size(newTestDataRight);
        sR = sR(1)
        sL = size(newTestDataLeft);
        sL = sL(1);

        diffSquared = [];
        for i = 1:sL
            diff = newTestDataLeft(i, 33) - meanLeft;
            diffSquared = [ diffSquared, diff.^2;];
        end
        for i = 1:sR
            diff = newTestDataRight(i, 33) - meanRight;
            diffSquared = [ diffSquared, diff.^2;];
        end

        MSE = mean(diffSquared);

        uniqueNodeValue = strcat('node',num2str(MSE));

        fprintf('Node: %s on level %i with parent: %s \n', uniqueNodeValue, level, parent);
        fprintf('IF INDEX: %i < %f return %f \n',bestIndex, valSplit, meanLeft);
        fprintf('IF INDEX: %i > %f return %f \n',bestIndex, valSplit, meanRight);
        fprintf('This Node has the MSE of: %f \n', MSE);
        if (MSE > 1000)
            fprintf('MSE too High, generate more nodes \n \n \n');
            myFun(newTestDataLeft, level, uniqueNodeValue);
            myFun(newTestDataRight, level, uniqueNodeValue);
        else
            fprintf('MSE under threshold, this is a leaf \n \n \n');
        end
    else
        uniqueNodeValue = strcat('node',num2str(allEverythingTable(1,33)));
        fprintf('Node: %s on level %i with parent: %s\n', uniqueNodeValue, level, parent);
        fprintf('Value =  %f\n\n', allEverythingTable(1,33));
    end

    
end