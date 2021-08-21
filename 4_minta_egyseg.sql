-- ***** Egy minta egység a valós mûködés szimulálásához *****

-- Mivel késleltetések vannak benne így 10-15 mp a futása.
-- A processlog,measurement,reapir táblákban így valósan látható az egység élete, mikor milyen állapotban volt az idõbejegyzések alapján
-- Az idõkben 0.7mp késleltetés van.
-- A feltöltés egyszer futtatható

USE Factory
GO

DECLARE @ID int

INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('MINTA1',232323,100,'Checkin',GETDATE(),'SMTMachines')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=100  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=110  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=110  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=120  WHERE Unit_id= 'MINTA1'
WAITFOR DELAY '00:00:00.700'
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',120,'R1','1,01','Poz','Pass',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',120,'R2','1,1','Poz','Pass',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',120,'R3','2,02','Poz','Fail',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',120,'R4','1,05','Poz','Pass',GETDATE())
UPDATE PROCESS SET Status_unit = 'Fail', Updater_name ='SMTMachines', operation_id=120  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
set @ID = (select Measure_id from MEASUREMENT where (Unit_id='MINTA1' and operation_id=120  and Evaluation='Fail'))
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('MINTA1',@ID,2,21,GETDATE())
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='PKatalin', operation_id=120  WHERE Unit_id= 'MINTA1'
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=130  WHERE Unit_id= 'MINTA1'
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=130  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=140  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',140,'C1','1,11','nF','Pass',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',140,'C2','0,97','nF','Pass',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',140,'D1','0,28','V','Fail',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',140,'D2','1,13','V','Pass',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',140,'R5','1,06','MOhm','Pass',GETDATE())
UPDATE PROCESS SET Status_unit = 'Fail', Updater_name ='SMTMachines', operation_id=140  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
set @ID = (select Measure_id from MEASUREMENT where (Unit_id='MINTA1' and operation_id=140  and Evaluation='Fail'))
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('MINTA1',@ID,4,21,GETDATE())
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='PKatalin', operation_id=140  WHERE Unit_id= 'MINTA1'
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=150  WHERE Unit_id= 'MINTA1' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=150  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=160  WHERE Unit_id= 'MINTA1' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=160  WHERE Unit_id= 'MINTA1' 
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=170  WHERE Unit_id= 'MINTA1' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=170  WHERE Unit_id= 'MINTA1'
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=180  WHERE Unit_id= 'MINTA1'
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',180,'C2','1,1','nF','Pass',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',180,'D2','1,01','V','Pass',GETDATE())
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('MINTA1',180,'R5','2,02','MOhm','Fail',GETDATE())
UPDATE PROCESS SET Status_unit = 'Fail', Updater_name ='SMTMachines', operation_id=180  WHERE Unit_id= 'MINTA1'
WAITFOR DELAY '00:00:00.700'
set @ID = (select Measure_id from MEASUREMENT where (Unit_id='MINTA1' and operation_id=180  and Evaluation='Fail'))
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('MINTA1',@ID,4,22,GETDATE())
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='PKatalin', operation_id=180  WHERE Unit_id= 'MINTA1'
WAITFOR DELAY '00:00:00.700'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=190  WHERE Unit_id= 'MINTA1' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=190  WHERE Unit_id= 'MINTA1'
GO

--select * from PROCESSLOG where Unit_id='MINTA1'
--select * from MEASUREMENT where Unit_id='MINTA1'
--select * from REPAIR where Unit_id='MINTA1'