SELECT 
    SD.Device_Name,
    SD.Type AS Device_Type,
    SUM(CR.Consumption_kWh) AS Total_Consumption_kWh
FROM 
    CONSUMPTION_READING CR
JOIN 
    SMART_DEVICE SD ON CR.Device_ID = SD.Device_ID
WHERE 
    CR.Reading_Timestamp >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY 
    SD.Device_Name, SD.Type
ORDER BY 
    Total_Consumption_kWh DESC
LIMIT 5;
SELECT 
    H.Address,
    SUM(CR.Consumption_kWh * T.Price_per_kWh) AS Total_Energy_Cost
FROM 
    CONSUMPTION_READING CR
JOIN 
    SMART_DEVICE SD ON CR.Device_ID = SD.Device_ID
JOIN 
    House H ON SD.House_ID = H.House_ID
JOIN 
    APPLIED_TARIFF AT ON H.House_ID = AT.House_ID
JOIN 
    TARIFF T ON AT.Tariff_ID = T.Tariff_ID
WHERE 
    H.House_ID = 101 
    AND CR.Reading_Timestamp >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    -- الشرط الزمني الحاسم: التأكد من أن القراءة تقع ضمن فترة التعرفة المطبقة
    AND CR.Reading_Timestamp BETWEEN AT.Start_Date_Time AND IFNULL(AT.End_Date_Time, NOW());
DELIMITER //

CREATE TRIGGER After_Command_Success
AFTER INSERT ON COMMAND_LOG
FOR EACH ROW
BEGIN
    
    IF NEW.Execution_Status = 'SUCCESS' THEN
        
        IF NEW.Command_Type = 'TURN_ON' THEN
            UPDATE SMART_DEVICE
            SET Status = 'ON'
            WHERE Device_ID = NEW.Device_ID;
        ELSEIF NEW.Command_Type = 'TURN_OFF' THEN
            UPDATE SMART_DEVICE
            SET Status = 'OFF'
            WHERE Device_ID = NEW.Device_ID;
        END IF;
    END IF;
END;
//
DELIMITER ;

CREATE VIEW Daily_Consumption_Summary AS
SELECT
    DATE(CR.Reading_Timestamp) AS Reading_Date,
    SD.Device_Name,
    SD.Type,
    AVG(CR.Consumption_kWh) AS Avg_Daily_Consumption,
    MAX(CR.Consumption_kWh) AS Peak_Consumption
FROM
    CONSUMPTION_READING CR
JOIN
    SMART_DEVICE SD ON CR.Device_ID = SD.Device_ID
GROUP BY
    Reading_Date, SD.Device_Name, SD.Type;
    SELECT
    SD.Type AS Device_Type,
    COUNT(SD.Device_ID) AS Number_of_Devices,
    AVG(CR.Consumption_kWh) AS Avg_Consumption_per_Reading,
    SUM(CR.Consumption_kWh) AS Total_Consumption_Type
FROM
    SMART_DEVICE SD
JOIN
    CONSUMPTION_READING CR ON SD.Device_ID = CR.Device_ID
GROUP BY
    SD.Type
HAVING
    COUNT(SD.Device_ID) > 1 
ORDER BY
    Avg_Consumption_per_Reading DESC;
