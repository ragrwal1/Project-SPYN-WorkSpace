% this is a global constants for quick adjustments
turnKP = 0.5;
turnKI = 0.0;
turnKD = 0.1;

forwardKP = 0.7;
forwardKI = 0.0;
forwardKD = 0.2;

straightSpeed = 10;
timeBackFromWall = 0.1;



forwardUntilBreak(brick, SensorPort, straightSpeed, forwardKP, forwardKI, forwardKD);

pause(0.5);

forwardFor(brick, SensorPort, -straightSpeed, forwardKP, forwardKI, forwardKD, timeBackFromWall);








%function movers forward using PID based adjustment until the force sensor is pressed. 
function forwardUntilBreak(brick, SensorPort, speed, kp, ki, kd)
    % Initialize variables
    previous_error = 0;
    integral = 0;

    % Calibrate gyro sensor
    brick.GyroCalibrate(SensorPort);
    pause(2); % Add a small pause after calibration

    % Initial gyro reading using while loop
    while true
        initial_angle = brick.GyroAngle(SensorPort);
        disp(['Initial angle: ', num2str(initial_angle)]); % Debugging line
        if initial_angle == 0
            break;
        end
        pause(0.5);
    end

    while true
        % Check for button press and exit if pressed
        if brick.TouchPressed(4)
            brick.StopAllMotors('Brake');
            break;
        end
        
        % Read current gyro angle
        current_angle = brick.GyroAngle(SensorPort);
        
        % Error in orientation
        error = initial_angle - current_angle;
        
        % Integral and Derivative
        integral = integral + error;
        derivative = error - previous_error;
        
        % PID output
        output = kp * error + ki * integral + kd * derivative;
        
        % Update motor speed
        base_speed = speed; % set a base speed
        brick.MoveMotor('B', base_speed + output);
        brick.MoveMotor('C', base_speed - output);
        
        % Update previous error
        previous_error = error;
        
        % Pause for a short while to avoid excessive looping
        pause(0.05);
    end
end



%function moves forward using PID based adjustment for a specified amount of time. Includes a safety mechanism if force is felt. 
function forwardFor(brick, SensorPort, speed, kp, ki, kd, timeLimit)
    % Initialize variables
    previous_error = 0;
    integral = 0;

    % Calibrate gyro sensor
    brick.GyroCalibrate(SensorPort);
    pause(2); % Add a small pause after calibration

    % Initial gyro reading using while loop
    while true
        initial_angle = brick.GyroAngle(SensorPort);
        disp(['Initial angle: ', num2str(initial_angle)]); % Debugging line
        if initial_angle == 0
            break;
        end
        pause(0.5);
    end
    
    % Start the timer
    startTime = tic;

    while true
        % Get the elapsed time
        elapsedTime = toc(startTime);

        % Check for button press and exit if pressed
        if brick.TouchPressed(4)
            brick.StopAllMotors('Brake');
            break;
        end

        % Exit if time limit is reached
        if elapsedTime >= timeLimit
            brick.StopAllMotors('Brake');
            break;
        end

        % Read current gyro angle
        current_angle = brick.GyroAngle(SensorPort);
        
        % Error in orientation
        error = initial_angle - current_angle;
        
        % Integral and Derivative
        integral = integral + error;
        derivative = error - previous_error;
        
        % PID output
        output = kp * error + ki * integral + kd * derivative;
        
        % Update motor speed
        base_speed = speed; % set a base speed
        brick.MoveMotor('B', base_speed + output);
        brick.MoveMotor('C', base_speed - output);
        
        % Update previous error
        previous_error = error;
        
        % Pause for a short while to avoid excessive looping
        pause(0.05);
    end
end




%rudimentary motor start
function startMotors(speed)
    brick.moveMotor('BC', speed);
end


%rudimentary motor stop
function stopMotors()
    brick.stopMotor('BC', 'Brake')
end

%PID based turn function that takes a target angle. 
function turnPID(brick, SensorPort, target_angle, kp, ki, kd)
    % Initialize variables
    previous_error = 0;
    integral = 0;
    % Calibrate gyro sensor
    brick.GyroCalibrate(SensorPort);
    pause(2); % Add a small pause after calibration
    % Initial gyro reading using while loop
    while true
        current_angle = brick.GyroAngle(SensorPort);
        disp(['Initial angle: ', num2str(current_angle)]); % Debugging line
        if current_angle == 0
            break;
        end
        pause(0.5);
    end
    % Initialize timer
    tStart = tic;
    while abs(current_angle - target_angle) > 0.5
        % Check for 3-second timeout
        elapsedTime = toc(tStart);
        if elapsedTime > 3
            break;
        end
        % Error
        error = target_angle - current_angle;
        % Integral
        integral = integral + error;
        % Derivative
        derivative = error - previous_error;
        % PID control
        output = kp * error + ki * integral + kd * derivative;
        disp(['PID output: ', num2str(output)]); % Debugging line
        % Update motor speed
        brick.MoveMotor('B', output);
        brick.MoveMotor('C', -output);
        % Update previous error and read new angle
        previous_error = error;
        current_angle = brick.GyroAngle(SensorPort);
        disp(['Current angle: ', num2str(current_angle)]); % Debugging line
        % Small delay to avoid excessive looping
        pause(0.05);
    end
    % Stop motors
    brick.StopMotor('B', 'Brake');
    brick.StopMotor('C', 'Brake');
end


%deprecated function 
function leftTurnWithPID(brick, SensorPort, target_angle, kp, ki, kd)
    % Initialize variables
    previous_error = 0;
    integral = 0;
    % Calibrate gyro sensor
    brick.GyroCalibrate(SensorPort);
    pause(2); % Add a small pause after calibration
    % Initial gyro reading using while loop
    while true
        current_angle = brick.GyroAngle(SensorPort);
        disp(['Initial angle: ', num2str(current_angle)]); % Debugging line
        if current_angle == 0
            break;
        end
        pause(0.5);
    end
    % Initialize timer
    tStart = tic;
    while abs(current_angle - (-target_angle)) > 0.5
        % Check for 3-second timeout
        elapsedTime = toc(tStart);
        if elapsedTime > 3
            break;
        end
        % Error
        error = (-target_angle) - current_angle;
        % Integral
        integral = integral + error;
        % Derivative
        derivative = error - previous_error;
        % PID control
        output = kp * error + ki * integral + kd * derivative;
        disp(['PID output: ', num2str(output)]); % Debugging line
        % Update motor speed
        brick.MoveMotor('B', -output);
        brick.MoveMotor('C', output);
        % Update previous error and read new angle
        previous_error = error;
        current_angle = brick.GyroAngle(SensorPort);
        disp(['Current angle: ', num2str(current_angle)]); % Debugging line
        % Small delay to avoid excessive looping
        pause(0.05);
    end
    % Stop motors
    brick.StopMotor('B', 'Brake');
    brick.StopMotor('C', 'Brake');
end