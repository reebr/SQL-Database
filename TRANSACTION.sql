-- *** 1. تعطيل وضع التحديث الآمن (لحل خطأ 1175) ***
SET SQL_SAFE_UPDATES = 0;

DELETE FROM COMMAND_LOG;
DELETE FROM CONSUMPTION_READING WHERE Device_ID IN (1, 2, 3);
DELETE FROM APPLIED_TARIFF;
DELETE FROM SMART_DEVICE WHERE Device_ID IN (1, 2, 3);
DELETE FROM House WHERE House_ID IN (101, 102);
DELETE FROM TARIFF WHERE Tariff_ID IN (10, 20);
DELETE FROM USER WHERE User_ID IN (1, 2);

-- إدخال البيانات التجريبية الأساسية (للتحقق من المفاتيح الخارجية)
INSERT INTO USER (User_ID, Full_Name, Email) VALUES 
(1, 'Ahmed Alahmari', 'a.alahmari@example.com'),
(2, 'Sara Salem', 'sara.salem@example.com');

INSERT INTO TARIFF (Tariff_ID, Tariff_Name, Price_per_kWh) VALUES 
(10, 'Peak Hours Tariff', 0.25),
(20, 'Off-Peak Tariff', 0.10);

INSERT INTO House (House_ID, Address, Area_sqm, User_ID) VALUES 
(101, 'Jeddah, Al-Salamah Dist.', 250.50, 1),
(102, 'Riyadh, Al-Quds Dist.', 300.00, 2);

INSERT INTO SMART_DEVICE (Device_ID, House_ID, Device_Name, Type, Model, Status) VALUES 
(1, 101, 'Central AC Unit', 'HVAC', 'ACME-X9000', 'ON'),
(2, 101, 'Water Heater', 'Heater', 'WH-2024', 'OFF'),
(3, 102, 'Smart Fridge', 'Appliance', 'SAMSUNG-RF32', 'STANDBY');

INSERT INTO APPLIED_TARIFF (House_ID, Tariff_ID, Start_Date_Time, End_Date_Time) VALUES 
(101, 10, '2025-10-01 16:00:00', '2025-10-01 22:00:00'), 
(101, 20, '2025-10-01 22:00:00', NULL); 

START TRANSACTION;
    SET @target_device = 2; 
    SET @target_user = 1;
    UPDATE SMART_DEVICE SET Status = 'ON' WHERE Device_ID = @target_device;
    INSERT INTO COMMAND_LOG (User_ID, Device_ID, Command_Type, Execution_Time, Execution_Status)
    VALUES (@target_user, @target_device, 'TURN_ON', NOW(), 'SUCCESS');
COMMIT;

START TRANSACTION;
    SET @target_device_fail = 1; 
    UPDATE SMART_DEVICE SET Status = 'OFF' WHERE Device_ID = @target_device_fail; 
    INSERT INTO COMMAND_LOG (User_ID, Device_ID, Command_Type, Execution_Time, Execution_Status)
    VALUES (@target_user, @target_device_fail, 'TURN_OFF', NOW(), 'FAILED');
ROLLBACK;