
% Declare global variable in main workspace
global direction

% Initialize to 'north' if you want
direction = 'north';

% Update and print the direction
updateDirection('left');
disp(['The current direction is: ', direction]);

updateDirection('flip');
disp(['The current direction is: ', direction]);

updateDirection('right');
disp(['The current direction is: ', direction]);



function updateDirection(operation)
    % Declare global variable
    global direction

    % Initialize the directions array and index
    directions = {'north', 'east', 'south', 'west'};
    if isempty(direction)
        idx = 1; % Start pointing to 'north'
        direction = directions{idx};
    else
        idx = find(strcmp(directions, direction));
    end

    % Update the pointer based on the operation
    switch operation
        case 'left'
            idx = mod(idx - 2, 4) + 1;
        case 'right'
            idx = mod(idx, 4) + 1;
        case 'flip'
            idx = mod(idx + 1, 4) + 1;
        otherwise
            % Invalid operation, do nothing
            return;
    end

    % Update the global direction variable
    direction = directions{idx};
end