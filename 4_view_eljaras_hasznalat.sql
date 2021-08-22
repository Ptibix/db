USE Factory
GO

-- Elõtte szükséges a táblák adatokkal feltöltése!

-- *****Eljárások, view-ek használata, tesztelése, teszt sql-ek *****

-- View-ek:

-- Visszaadja mely hibák lettek javítva, ki által és mivel

  SELECT * FROM dbo.viewMeasurementRepair 
  --where Unit_id=998877									-- Egység alapján szûrés
  --where User_name='VLaszlone'								-- Dolgozó alapján szûrés
  GO

  -- Az 1 hónapnál nem régebbi Date_Start orderkeben milyen egységek vannak, melyik állomáson, anyagszámmal

 SELECT * FROM dbo.viewOneMounthOrderUnit
 --where operation_id !=190									-- Mely egységek nem utolsó állomáson állnak
 GO

 --Melyek azok az egységek amelyek nem utolsó állomáson állnak és az order planned enden már túl vagyunk.

 SELECT * FROM dbo.viewNotFinishTooOldUnit
 GO


 -- Elsõ eljárás

-- Visszaadja egy egységrõl, hogy mely állomásokon volt 1-nél több hibája

-- Futtatás

EXEC dbo.UnitFailHistory '987654'


-- Második eljárás

-- Külsõ 'egységjavító' program ezen eljáráson át tudja a javítás eredményét beszúrni a REPAIR táblába
-- 2 féle használat lehetséges: 
-- - Megadjuk a javítandó egység Measurement táblában szerepló javítandó mérésének measurement_id-ját.
-- - Vagy megadjuk a javítandó egység mely operáció azonosítón végzett mely mérését akarjuk javítani.
-- Mindkét esetben a Measurement táblába léteznie kell a Fail-os mérésnek.


-- Futtatások:

-- Mode 1 meghívás - Ehhez tudni kell egy még nem lejavított Measurement ID-t.

EXEC dbo.InsertRepair @Mode=1 ,@Unit_id='998877' ,@Repair_code=4 ,@User_id=21 ,@Mea_id=11	-- Hibás bevitel

-- Mode 1 mûködõ teszt
-- Beszúrás a MEASUREMNT táblába:
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',180,'C2','1,9','nF','Fail',Getdate())
DECLARE @ID int										-- Measurement ID megszerzése a SET.
SET @ID= (select max(Measure_id) from MEASUREMENT)  --Mivel minden insert után ez automatikusan más lesz, így az eljárás meghívható, nem fut hibára.
EXEC dbo.InsertRepair @Mode=1 ,@Unit_id='A9B857' ,@Repair_code=4 ,@User_id=21 ,@Mea_id=@ID -- Eljárás hívás a beszúrás adatai alapján
select * from MEASUREMENT where Measure_id=@ID		-- Ellenõrzés
select * from REPAIR where Fail_id=@ID
GO


-- Mode 2 meghívás - Ehhez tudni kell egy le nem javított Operáció_id és Measure name és csak 1-szer legyen a MEASUREMENT táblában!
EXEC dbo.InsertRepair @Mode=2 ,@Unit_id='998877' ,@Repair_code=4 ,@User_id=21 ,@Op_id=140 ,@Mea_name='D1' -- Hibás bevitel, már létezik ez a javítás

-- Mode 2 mûködõ teszt:
-- Beszúrás a MEASUREMNT táblába:
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',140,'C1','1,91','nF','Fail',Getdate())
EXEC dbo.InsertRepair @Mode=2 ,@Unit_id='A9B857' ,@Repair_code=4 ,@User_id=21 ,@Op_id=140 ,@Mea_name='C1' -- Eljárás hívás a beszúrás adatai alapján
select * from MEASUREMENT where Unit_id='A9B857' and Operation_id=140 and Measure_name='C1'		-- Ellenõrzés
select * from REPAIR where Unit_id='A9B857'
GO

-- Harmadik eljárás

-- Új felhsználó felvitele az USER táblába a jog nevének, a leendõ felhasználónév (egyedi kell legyen), valós név és ágazat megadásával.

-- Futtatás:
-- @Username egyedi kell legyen!

EXEC dbo.InsertUser @Rightdef='Repair', @Username='PProba', @Realname='Proba Proba', @Dep='SMT'
select * from USERS where User_name='PProba' 
-- Trigger

-- Futtatás:

UPDATE PROCESS
SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=180 
WHERE Unit_id= '123' 
select * from PROCESS where Unit_id='123'
select * from PROCESSLOG where Unit_id='123'

UPDATE PROCESS
SET Status_unit = 'Rossz', Updater_name ='PKatalin'						-- Hibás mert a Status_unit Pass/Fail/Checkin lehet
WHERE Unit_id= '998877' 

UPDATE PROCESS
SET Status_unit = 'Pass', Updater_name ='SMTMachines' 
WHERE Unit_id= '998877' 
select * from PROCESS where Unit_id='998877'
select * from PROCESSLOG where Unit_id='998877'

UPDATE PROCESS
SET Status_unit = 'Fail', Updater_name ='KFerenc'	-- Õ nem manipulator hanem admin
WHERE Unit_id= '123' 
select * from PROCESS where Unit_id='123'
select * from PROCESSLOG where Unit_id='123'

		
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('999992',112233,100,'Checkin',GETDATE(),'PKatalin')
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('666667',112233,120,'Checkin',GETDATE(),'SMTMachines')  --Hibás, nem a 100-as elsõ állomásra hozzuk létre
select * from PROCESS where (Unit_id='999992' or Unit_id='666667')

DELETE FROM PROCESS WHERE Unit_id='522375'

-- Teszt SQL:

select * from USERS,RIGHTS
where USERS.Right_id=RIGHTS.Right_id
GO

select * from ORDERS,ORDERROUTING,ORDERSWITCH
where ORDERS.Order_id=ORDERSWITCH.Order_id and
ORDERROUTING.Operation_id=ORDERSWITCH.Operation_id
--and orders.order_id=234596
GO

select ORDERS.Order_id,ORDERS.Material_number,ORDERROUTING.Operation_id,ORDERROUTING.Operation_name from ORDERS,ORDERROUTING,ORDERSWITCH
where ORDERS.Order_id=ORDERSWITCH.Order_id and
ORDERROUTING.Operation_id=ORDERSWITCH.Operation_id and
--ORDERROUTING.Operation_id=140
ORDERS.Order_id=234596
GO

-- Milyen hibát mivel javítottak:

 select MEASUREMENT.Unit_id,MEASUREMENT.Operation_id,MEASUREMENT.Measure_name,MEASUREMENT.Measure_result,MEASUREMENT.Unitofmeasure, MEASUREMENT.Evaluation,REPAIR.Repair_code,REPAIRDEF.Repair_Definition,USERS.User_name from MEASUREMENT, REPAIR,USERS,REPAIRDEF where
 MEASUREMENT.Measure_id=REPAIR.Fail_id and
 REPAIR.User_id=USERS.User_id and
 REPAIR.Repair_code=REPAIRDEF.Repair_code and
 MEASUREMENT.Evaluation='Fail'
GO

select * from PROCESS
GO
INSERT INTO ORDERROUTING(Operation_id,Operation_name) VALUES(200,'First Station')
GO
select * from ORDERROUTING
GO