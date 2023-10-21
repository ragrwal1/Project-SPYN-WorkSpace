
SensorPort = 1;  
while true  % Infinite loop
    colorStr = getColor(brick, SensorPort);  % Call the getColor function
    disp(['Detected color: ', colorStr]);  % Display the color in the terminal
    pause(2);  % Wait for 2 seconds before checking again
end




function colorStr = getColor(brick, SensorPort)
    % Set Color Sensor connected to SensorPort to Color Code Mode
    brick.SetColorMode(SensorPort, 2);

    % Get Color on SensorPort
    colorCode = brick.ColorCode(SensorPort);

    % Map color code to string
    switch colorCode
        case 0
            colorStr = 'No color';
        case 1
            colorStr = 'Black';
        case 2
            colorStr = 'Blue';
        case 3
            colorStr = 'Green';
        case 4
            colorStr = 'Yellow';
        case 5
            colorStr = 'Red';
        case 6
            colorStr = 'White';
        case 7
            colorStr = 'Brown';
        otherwise
            colorStr = 'Unknown';
    end
end
