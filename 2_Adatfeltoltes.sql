-- *****Táblák feltöltése adatokkal *****

USE Factory
GO

INSERT INTO RIGHTS(Right_id,Right_Definition) VALUES(1,'Administrator') 
INSERT INTO RIGHTS(Right_id,Right_Definition) VALUES(5,'User manupulator')
INSERT INTO RIGHTS(Right_id,Right_Definition) VALUES(10,'Repair')
INSERT INTO RIGHTS(Right_id,Right_Definition) VALUES(11,'Packing')
INSERT INTO RIGHTS(Right_id,Right_Definition) VALUES(20,'RepairPacking')
INSERT INTO RIGHTS(Right_id,Right_Definition) VALUES(100,'Unit Manipulation')
GO

INSERT INTO USERS(USER_id,User_name,Right_id,Real_Name,Department) VALUES(10,'KFerenc', 1,'Kiss Ferenc','IT')
INSERT INTO USERS(USER_id,User_name,Right_id,Real_Name,Department) VALUES(11,'KAladár', 5,'Kerti Aladár','Engineering')
INSERT INTO USERS(USER_id,User_name,Right_id,Real_Name,Department) VALUES(21,'NIlona', 10,'Nagy Ilona','SMT')
INSERT INTO USERS(USER_id,User_name,Right_id,Real_Name,Department) VALUES(22,'HKatalin', 10,'Hajdú Katalin','SMT') 
INSERT INTO USERS(USER_id,User_name,Right_id,Real_Name,Department) VALUES(25,'VLaszlone', 20,'Virág Lászlóné','BE')
INSERT INTO USERS(USER_id,User_name,Right_id,Real_Name,Department) VALUES(30,'PKatalin', 100,'Polgár Katalin','Engineering')
INSERT INTO USERS(USER_id,User_name,Right_id,Real_Name,Department) VALUES(9999,'SMTMachines', 100,'SMTMachines','Engineering')
GO

INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(100,'First Station')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(110,'Glue')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(120,'Glue AOI')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(130,'Pasting')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(140,'Pasta AOI')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(150,'Inserting')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(160,'Oven')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(170,'AOI')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(180,'Repair AOI')
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(190,'Last station') 
GO

INSERT INTO ORDERS(Order_id,Material_number,Order_initialqty,Order_actualqty,Date_start,Date_planned_end) VALUES(112233,'A2C356987',1000,980,'2021-07-10','2021-07-15')
INSERT INTO ORDERS(Order_id,Material_number,Order_initialqty,Order_actualqty,Date_start,Date_planned_end) VALUES(234596,'9865E2',2000,100,'2021-07-20','2021-07-25')
INSERT INTO ORDERS(Order_id,Material_number,Order_initialqty,Order_actualqty,Date_start,Date_planned_end) VALUES(555555,'4966E23',55,1,'2021-07-22','2021-07-25')
INSERT INTO ORDERS(Order_id,Material_number,Order_initialqty,Date_start,Date_planned_end) VALUES(676767,'6666E23',155,'2021-08-2','2021-08-25')
INSERT INTO ORDERS(Order_id,Material_number,Order_initialqty,Order_actualqty,Date_start,Date_planned_end) VALUES(232323,'A2C900600',100,2,'2021-08-12','2021-09-25')
INSERT INTO ORDERS(Order_id,Material_number,Order_initialqty,Order_actualqty,Date_start,Date_planned_end) VALUES(111222,'A2C356987',10000,9500,'2021-08-10','2021-09-15')
GO

INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,100)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,110)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,120)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,130)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,140)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,150)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,160)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,170)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,180)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(112233,190)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,100)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,130)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,140)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,150)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,160)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,170)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,180)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(234596,190)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,100)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,110)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,120)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,130)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,140)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,150)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,160)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,170)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,180)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(555555,190)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,100)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,110)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,120)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,130)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,140)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,150)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,160)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,170)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,180)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(676767,190)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,100)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,110)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,120)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,130)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,140)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,150)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,160)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,170)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,180)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(232323,190)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,100)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,110)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,120)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,130)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,140)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,150)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,160)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,170)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,180)
INSERT INTO ORDERSWITCH(Order_id,Operation_id) VALUES(111222,190)
GO

INSERT INTO REPAIRDEF(Repair_code,Repair_Definition) VALUES(1,'Álló Alkatrész') 
INSERT INTO REPAIRDEF(Repair_code,Repair_Definition) VALUES(2,'Elcsúszott Alkatrész')
INSERT INTO REPAIRDEF(Repair_code,Repair_Definition) VALUES(3,'Hiányzó Alkatrész')
INSERT INTO REPAIRDEF(Repair_code,Repair_Definition) VALUES(4,'Rossz Forrasztás')
INSERT INTO REPAIRDEF(Repair_code,Repair_Definition) VALUES(9,'Téves Riszatás')
GO

INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('A9B855',112233,100,'Pass','2021-07-11','SMTMachines')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=110  WHERE Unit_id= 'A9B855'
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('A9B857',112233,100,'Pass','2021-07-12','SMTMachines')
UPDATE PROCESS SET Status_unit = 'Fail', Updater_name ='SMTMachines', operation_id=120  WHERE Unit_id= 'A9B857'
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('522375',234596,100,'Pass','2021-07-22','SMTMachines')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=130  WHERE Unit_id= '522375'
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('522379',234596,100,'Pass','2021-07-22','SMTMachines')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=160  WHERE Unit_id= '522379'
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('998877',555555,100,'Pass','2021-07-23','SMTMachines')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=190  WHERE Unit_id= '998877'
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('123',112233,100,'Checkin','2021-08-01','SMTMachines')
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('987654',112233,100,'Pass','2021-07-22','PKatalin')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='Pkatalin', operation_id=190  WHERE Unit_id= '987654'
GO

INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('998877',555555,190,'Fail','2021-07-24','PKatalin','UPDATE')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B855',112233,100,'Pass','2021-07-11','SMTMachines','INSERT')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B855',112233,110,'Pass','2021-07-11','SMTMachines','INSERTUPD')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B855',112233,100,'Pass','2021-07-11','SMTMachines','DELETEUPD')
GO

INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,100,'Pass','2021-07-12','SMTMachines','INSERT')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,110,'Pass','2021-07-12','SMTMachines','INSERTUPD')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,100,'Pass','2021-07-12','SMTMachines','DELETEUPD')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,120,'Checkin','2021-07-12','SMTMachines','INSERTUPD')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,110,'Pass','2021-07-12','SMTMachines','DELETEUPD')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,120,'Fail','2021-07-12','SMTMachines','INSERTUPD')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,120,'Checkin','2021-07-12','SMTMachines','DELETEUPD')
INSERT INTO PROCESSLOG(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name,[action]) VALUES('A9B857',112233,120,'Fail','2021-07-12','SMTMachines','INSERTUPD')
GO

INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',120,'R1','1,01','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',120,'R2','1,1','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',120,'R3','1,02','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',120,'R4','1,05','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',120,'R1','1,01','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',120,'R2','1,01','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',120,'R3','1,08','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',120,'R4','1,04','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',140,'C1','1,01','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',140,'C2','0,95','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',140,'D1','1,28','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',140,'D2','1,11','V','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',140,'R5','1,02','MOhm','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',180,'C2','1,1','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',180,'D2','1,51','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('998877',180,'R5','1,02','MOhm','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522375',120,'R1','1,01','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522375',120,'R2','1,02','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522375',120,'R3','1,07','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522375',120,'R4','1,02','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',120,'R1','1,01','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',120,'R2','1,02','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',120,'R3','1,07','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',120,'R4','1,02','Poz','Pass','2021-07-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',140,'C1','1,31','nF','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',140,'C2','0,95','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',140,'D1','1,48','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',140,'D2','1,11','V','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('522379',140,'R5','1,02','MOhm','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',120,'R1','1,31','Poz','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',120,'R2','1,01','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',120,'R3','1,08','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',120,'R4','1,04','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',140,'C1','1,51','nF','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',140,'C2','1,95','nF','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',140,'D1','1,28','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',140,'D2','1,11','V','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',140,'R5','1,02','MOhm','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',180,'C2','1,1','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',180,'D2','2,51','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('123',180,'R5','1,02','MOhm','Pass','2021-07-23')
GO

-- Csak adatfeltöltés nincs mögötte Process mozgás
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',120,'R1','1,01','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',120,'R2','1,51','Poz','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',120,'R3','1,58','Poz','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',120,'R4','1,04','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',140,'C1','1,01','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',140,'C2','2,95','nF','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',140,'D1','3,28','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',140,'D2','3,11','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',140,'R5','3,02','MOhm','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',180,'C2','1,1','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',180,'D2','1,51','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('987654',180,'R5','4,02','MOhm','Fail','2021-07-23')

INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('998877',11,9,21,'2021-07-23')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('998877',15,2,22,'2021-07-23')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('522379',25,1,22,'2021-07-12')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('522379',27,3,22,'2021-07-23')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('123',30,2,25,'2021-07-23')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('123',34,3,25,'2021-07-23')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('123',35,3,25,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('123',36,3,25,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('123',40,9,25,'2021-07-24')

INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',43,9,21,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',44,9,21,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',47,9,25,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',48,9,25,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',49,9,25,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',50,9,25,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',52,9,25,'2021-07-24')
INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES('987654',53,9,25,'2021-07-24')

GO

-- Egység hozzáadás
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('C125C85',112233,100,'Checkin','2021-08-11 12:00:00','SMTMachines')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=100  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=110  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=110  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=120  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=120  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=130  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=130  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=140  WHERE Unit_id= 'C125C85' 
UPDATE PROCESS SET Status_unit = 'Fail', Updater_name ='SMTMachines', operation_id=140  WHERE Unit_id= 'C125C85' 
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',120,'R1','1,01','Poz','Pass','2021-08-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',120,'R2','1,01','Poz','Pass','2021-08-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',120,'R3','1,08','Poz','Pass','2021-08-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',120,'R4','1,05','Poz','Pass','2021-08-12')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',140,'C1','1,51','nF','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',140,'C2','1,95','nF','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',140,'D1','1,58','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',140,'D2','1,161','V','Fail','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C85',140,'R5','1,072','MOhm','Fail','2021-07-23')
UPDATE PROCESS SET Status_unit = 'Scrap', Updater_name ='PKatalin', operation_id=140  WHERE Unit_id= 'C125C85'
GO

INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('C125C99',234596,100,'Checkin','2021-08-11 12:00:00','SMTMachines')
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=100  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=130  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=130  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=140  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=140  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=150  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=150  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=160  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=160  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=170  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=170  WHERE Unit_id= 'C125C99'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=180  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=180  WHERE Unit_id= 'C125C99'
UPDATE PROCESS SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=190  WHERE Unit_id= 'C125C99' 
UPDATE PROCESS SET Status_unit = 'Pass', Updater_name ='SMTMachines', operation_id=190  WHERE Unit_id= 'C125C99'

INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',120,'R1','1,31','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',120,'R2','1,01','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',120,'R3','1,08','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',120,'R4','1,04','Poz','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',140,'C1','1,51','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',140,'C2','1,95','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',140,'D1','1,08','V','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',140,'D2','1,11','V','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',140,'R5','1,02','MOhm','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',180,'C2','1,1','nF','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',180,'D2','2,51','V','Pass','2021-07-23')
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('C125C99',180,'R5','1,02','MOhm','Pass','2021-07-23')
GO
