function [pos, theta, detectedList, visArea] = testSensorData(sObs, mode) 
    coder.extrinsic('serial', 'instrfind')   
    coder.extrinsic('tic')
    coder.extrinsic('toc')
    persistent t1 
    if isempty(t1)
        t1 = tic;
    end
    
    time = toc(t1);
    t1 = tic;
    t2 = tic;
    fprintf('total calculation completed in %f seconds\n', time)
    fprintf('***************************************************\n');
    
    port_hokuyo = '/dev/ttyACM1';
    port_pozyx = '/dev/ttyUSB0';
    
    persistent COM_hokuyo COM_pozyx
    
    pos = [0 0];
    theta = 0;
    
    %% Real position and orientation 
    if mode == 0
        if isempty(COM_pozyx)
            if isempty(instrfind('Port', port_pozyx))
                COM_pozyx = serial(port_pozyx); 
            else
                COM_pozyx = instrfind('Port', port_pozyx');
            end
            set(COM_pozyx, 'BaudRate', 115200)
            set(COM_pozyx, 'Timeout', 10)
            set(COM_pozyx, 'InputBufferSize', 32)
            set(COM_pozyx, 'OutputBufferSize', 1)
            set(COM_pozyx, 'Terminator', {'CR/LF', ''});
            set(COM_pozyx, 'ReadAsyncMode', 'continuous')
            fclose(COM_pozyx);
            fopen(COM_pozyx); 
        end
        
        [pos, theta] = getPozyxData(COM_pozyx);
         pos = [40 10];
         theta = 0;
    end
    
    %% Simulation position and orientation 
    % starting position and orientation from simulink config
    global sPos sTheta   

    if mode == 1 
        % update simulation position and theta 
        pos = sPos;
        theta = sTheta;
    end
    
    %% Create vision area visual object 
    if mode == 1 
        % visArea opening angle above/below horizontal and leg length 
        coneAngle = pi/4;
        coneDepth = 10;
        
        % 4 points to make visArea in polar rotated to current theta  
        t = [0 coneAngle -coneAngle 0] + theta;
        r = [0 coneDepth coneDepth 0];
        
        % convert to cartesian, z column for compatability with built-in trig 
        [x, y] = pol2cart(t, r);
        z = zeros(1,4);
        
        % list format and translate to current pos 
        visArea = rot90(vertcat(z,y,x),3);
        visArea(:,1) = visArea(:,1) + pos(1);
        visArea(:,2) = visArea(:,2) + pos(2);
    else 
        lineLength = 8;
        t = [-3*pi/4 0 0 3*pi/4] + theta;
        r = [lineLength 0 0 lineLength];
        
        [x, y] = pol2cart(t, r);
        z = zeros(1,4);
        
        visArea = rot90(vertcat(z,y,x),3);
        visArea(:,1) = visArea(:,1) + pos(1);
        visArea(:,2) = visArea(:,2) + pos(2);
        
    end
    
    %% Real obstacle detection
    % lidar scan list from Hokuyo UTM-30LX
    nPoints = 1081;
    detectedList = repmat([nan nan], nPoints, 1); 
    if mode == 0
        if isempty(COM_hokuyo)
            if isempty(instrfind('Port', port_hokuyo))
                COM_hokuyo = serial(port_hokuyo); 
            else
                COM_hokuyo = instrfind('Port', port_hokuyo');
            end
            set(COM_hokuyo, 'Timeout', 10)
            set(COM_hokuyo, 'InputBufferSize', 4096)
            fclose(COM_hokuyo);
            fopen(COM_hokuyo); 
        end

        detectedList = getHokuyoScan(COM_hokuyo);
%         thetas = rot90(deg2rad(-45:0.25:225),3);
%         distances = randi([500 30000], 1081, 1);
%         distances(distances > 2000) = 30000;
%         detectedList = [thetas distances];
    end
    
    %% Simulation obstacle detection 
    if mode == 1
        % get detected vector 
        sObsList = reshape(permute(sObs,[2,1,3]),size(sObs,2),[])';
        detected = detectRotated(sObsList, visArea);

        % list obstacles that are detected 
        if any(detected)
            detectedListTemp2 = repmat([nan nan], nPoints, 1); 

            sObsListX = sObsList(:,1);
            sObsListY = sObsList(:,2);
            detectedListX = sObsListX(detected==1);
            detectedListY = sObsListY(detected==1);
            detectedListTemp1 = horzcat(detectedListX, detectedListY);
            detectedListTemp2(:) = vertcat(detectedListTemp1,...
                repmat([nan nan], nPoints-size(detectedListTemp1, 1), 1));
            detectedList = detectedListTemp2;
        end
    end
    
    time = toc(t2);
    fprintf('getSensorData completed in %f seconds\n', time)
end