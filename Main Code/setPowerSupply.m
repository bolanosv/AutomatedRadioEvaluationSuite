function setPowerSupply(PowerSupply, supplyMode, supplyVoltage)
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