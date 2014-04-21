

%Load all data into cell array for easy access
C = cell(6,1);
for i=1:6
    path = ['C:\Users\liam\Desktop\KINECT\kbox\data\' num2str(i) '\'];
    data = loadKinectData2(path);
    data = diff(data,1,1); %Columnwise Differentiation - Remove effect of distance from Kinect
    C{i} = data;
end

%For every category of punch
for i=1:length(C) 

    %Create Eignen Spaces for Both
    [Xm1,EV1,Ev1]=createES(C{i},3);

    %Reconstruct the data
    jred=reconstructPose(C{i},Xm1,EV1);

    %Smooth PC1,PC2,PC3

    C{i} = kinsmooth(jred);

    % Min/Max of smoothed curve
    [zmax,zmin,imax,imin] = getminmax(C{i});

    % [zmax,zmin,imax,imin] = findfit2(Z2);
    maxima = vertcat(zmax,imax)';
    maxima = sortrows(maxima,1);

    %Need to normalise graph # Might not need to do this anymore
    %divframes = max(max(imin),max(imax))/size(M1,2);

    %Segement punches & resample
    k = 2;
    framenum = linspace(maxima(k,1),maxima(k+1,1),20);
    for k=3:1:length(maxima)-1
        framenum = vertcat(framenum,linspace(maxima(k,1),maxima(k+1,1),20));
    end
    framenum = round(framenum); 
    framenum_sort = sort(framenum(:,1));

    % Runs a Dimensional Reduction comparison 
    %DRcomp(M1);

    %gets punch features & resizes for processing with neural networks.
    punchfeat = C{i}(:,framenum); 
    rowno = ceil(((size(punchfeat,1)*size(punchfeat,2)))/60);
    C{i} = reshape(punchfeat',60,rowno)';
end








