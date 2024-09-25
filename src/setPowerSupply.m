function setPowerSupply(PowerSupply, supplyMode, supplyVoltage)
    % This function configures a programmable power supply by selecting a 
    % specific mode and setting the output voltage. 
    %
    % Parameters
    % PowerSupply:   Handle representing the power supply object. The
    %                instrument must support SCPI.
    % supplyMode:    A string specifying the mode of the power supply. 
    %                Mode descriptions:
    %                - 'P6V'  (0V to 6V)
    %                - 'P25V' (6V to 25V)
    %                - 'N25V' (-25V to 0V)
    % supplyVoltage: A numeric value specifying the output voltage.

    switch supplyMode
        case 'P6V'
            if supplyVoltage > 6 || supplyVoltage < 0
                error('Supply voltage out of range for P6V mode');
            end
        case 'P25V'
            if supplyVoltage > 25 || supplyVoltage < 6
                error('Supply voltage out of range for P25V mode');
            end
        case 'N25V'
            if supplyVoltage > 0 || supplyVoltage < -25
                error('Supply voltage out of range for N25V mode');
            end
    end
    
    % Reset the power supply
    writeline(PowerSupply, '*RST');
    % Set power supply in remote mode
    writeline(PowerSupply, ':SYSTem:REMote');
    % Set the power supply mode and voltage
    writeline(PowerSupply, sprintf(':APPLy %s,%g,%s', supplyMode, supplyVoltage, 'MAXimum'));
end

