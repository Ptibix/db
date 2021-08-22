USE Factory
GO

-- El�tte sz�ks�ges a t�bl�k adatokkal felt�lt�se!

-- *****Elj�r�sok, view-ek haszn�lata, tesztel�se, teszt sql-ek *****

-- View-ek:

-- Visszaadja mely hib�k lettek jav�tva, ki �ltal �s mivel

  SELECT * FROM dbo.viewMeasurementRepair 
  --where Unit_id=998877									-- Egys�g alapj�n sz�r�s
  --where User_name='VLaszlone'								-- Dolgoz� alapj�n sz�r�s
  GO

  -- Az 1 h�napn�l nem r�gebbi Date_Start orderkeben milyen egys�gek vannak, melyik �llom�son, anyagsz�mmal

 SELECT * FROM dbo.viewOneMounthOrderUnit
 --where operation_id !=190									-- Mely egys�gek nem utols� �llom�son �llnak
 GO

 --Melyek azok az egys�gek amelyek nem utols� �llom�son �llnak �s az order planned enden m�r t�l vagyunk.

 SELECT * FROM dbo.viewNotFinishTooOldUnit
 GO


 -- Els� elj�r�s

-- Visszaadja egy egys�gr�l, hogy mely �llom�sokon volt 1-n�l t�bb hib�ja

-- Futtat�s

EXEC dbo.UnitFailHistory '987654'


-- M�sodik elj�r�s

-- K�ls� 'egys�gjav�t�' program ezen elj�r�son �t tudja a jav�t�s eredm�ny�t besz�rni a REPAIR t�bl�ba
-- 2 f�le haszn�lat lehets�ges: 
-- - Megadjuk a jav�tand� egys�g Measurement t�bl�ban szerepl� jav�tand� m�r�s�nek measurement_id-j�t.
-- - Vagy megadjuk a jav�tand� egys�g mely oper�ci� azonos�t�n v�gzett mely m�r�s�t akarjuk jav�tani.
-- Mindk�t esetben a Measurement t�bl�ba l�teznie kell a Fail-os m�r�snek.


-- Futtat�sok:

-- Mode 1 megh�v�s - Ehhez tudni kell egy m�g nem lejav�tott Measurement ID-t.

EXEC dbo.InsertRepair @Mode=1 ,@Unit_id='998877' ,@Repair_code=4 ,@User_id=21 ,@Mea_id=11	-- Hib�s bevitel

-- Mode 1 m�k�d� teszt
-- Besz�r�s a MEASUREMNT t�bl�ba:
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',180,'C2','1,9','nF','Fail',Getdate())
DECLARE @ID int										-- Measurement ID megszerz�se a SET.
SET @ID= (select max(Measure_id) from MEASUREMENT)  --Mivel minden insert ut�n ez automatikusan m�s lesz, �gy az elj�r�s megh�vhat�, nem fut hib�ra.
EXEC dbo.InsertRepair @Mode=1 ,@Unit_id='A9B857' ,@Repair_code=4 ,@User_id=21 ,@Mea_id=@ID -- Elj�r�s h�v�s a besz�r�s adatai alapj�n
select * from MEASUREMENT where Measure_id=@ID		-- Ellen�rz�s
select * from REPAIR where Fail_id=@ID
GO


-- Mode 2 megh�v�s - Ehhez tudni kell egy le nem jav�tott Oper�ci�_id �s Measure name �s csak 1-szer legyen a MEASUREMENT t�bl�ban!
EXEC dbo.InsertRepair @Mode=2 ,@Unit_id='998877' ,@Repair_code=4 ,@User_id=21 ,@Op_id=140 ,@Mea_name='D1' -- Hib�s bevitel, m�r l�tezik ez a jav�t�s

-- Mode 2 m�k�d� teszt:
-- Besz�r�s a MEASUREMNT t�bl�ba:
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',140,'C1','1,91','nF','Fail',Getdate())
EXEC dbo.InsertRepair @Mode=2 ,@Unit_id='A9B857' ,@Repair_code=4 ,@User_id=21 ,@Op_id=140 ,@Mea_name='C1' -- Elj�r�s h�v�s a besz�r�s adatai alapj�n
select * from MEASUREMENT where Unit_id='A9B857' and Operation_id=140 and Measure_name='C1'		-- Ellen�rz�s
select * from REPAIR where Unit_id='A9B857'
GO

-- Harmadik elj�r�s

-- �j felhszn�l� felvitele az USER t�bl�ba a jog nev�nek, a leend� felhaszn�l�n�v (egyedi kell legyen), val�s n�v �s �gazat megad�s�val.

-- Futtat�s:
-- @Username egyedi kell legyen!

EXEC dbo.InsertUser @Rightdef='Repair', @Username='PProba', @Realname='Proba Proba', @Dep='SMT'
select * from USERS where User_name='PProba' 
-- Trigger

-- Futtat�s:

UPDATE PROCESS
SET Status_unit = 'Checkin', Updater_name ='SMTMachines', operation_id=180 
WHERE Unit_id= '123' 
select * from PROCESS where Unit_id='123'
select * from PROCESSLOG where Unit_id='123'

UPDATE PROCESS
SET Status_unit = 'Rossz', Updater_name ='PKatalin'						-- Hib�s mert a Status_unit Pass/Fail/Checkin lehet
WHERE Unit_id= '998877' 

UPDATE PROCESS
SET Status_unit = 'Pass', Updater_name ='SMTMachines' 
WHERE Unit_id= '998877' 
select * from PROCESS where Unit_id='998877'
select * from PROCESSLOG where Unit_id='998877'

UPDATE PROCESS
SET Status_unit = 'Fail', Updater_name ='KFerenc'	-- � nem manipulator hanem admin
WHERE Unit_id= '123' 
select * from PROCESS where Unit_id='123'
select * from PROCESSLOG where Unit_id='123'

		
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('999992',112233,100,'Checkin',GETDATE(),'PKatalin')
INSERT INTO PROCESS(Unit_id,Order_id,Operation_id,Status_unit,Update_time,Updater_name) VALUES('666667',112233,120,'Checkin',GETDATE(),'SMTMachines')  --Hib�s, nem a 100-as els� �llom�sra hozzuk l�tre
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

-- Milyen hib�t mivel jav�tottak:

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