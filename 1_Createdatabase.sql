
USE master
DROP DATABASE IF EXISTS Factory
GO 


-- ***** Adatbázis elkészítés *****

USE [master]
GO

CREATE DATABASE [Factory]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Factory', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Factory.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Factory_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Factory_log.ldf' , SIZE = 8192KB , MAXSIZE = 1318912KB , FILEGROWTH = 65536KB ) -- Maxsize=Filegrowth*20 (1,3GB)
 COLLATE Hungarian_CI_AS
GO

-- ***** Táblaszerkezet elkészítése *****

USE Factory

CREATE TABLE [ORDERS](																-- Megrendelések
Order_id int NOT NULL,				
Material_number varchar(25) NOT NULL,
Order_initialqty int NOT NULL,
Order_actualqty int default 0,
Date_start date NOT NULL,			
Date_planned_end date NOT NULL,
CONSTRAINT CHK_Date CHECK (Date_planned_end>=Date_start)
); 
ALTER TABLE [ORDERS]
ADD CONSTRAINT PK_OrderOrderId PRIMARY KEY (Order_id);


CREATE TABLE PROCESS (																-- Egységek aktuális állapota
Unit_id varchar(30) NOT NULL,		
Order_id int NOT NULL,				
Operation_id tinyint NOT NULL,		
Status_unit varchar(10) NOT NULL CHECK (Status_unit in ('Checkin','Pass','Fail','Scrap')),	--Checkin/pass/fail Ellenõrzés, hogy az-e a tartalom!
Update_time datetime2 NOT NULL,		
Updater_name varchar(20) NOT NULL
);
ALTER TABLE PROCESS
ADD CONSTRAINT PK_PROCESSUnitId PRIMARY KEY (Unit_id); 


CREATE TABLE PROCESSLOG (															-- Trigger által töltött log tábla
Id int IDENTITY(1,1),
Unit_id varchar(30) NOT NULL,		
Order_id int NOT NULL,				
Operation_id tinyint NOT NULL,		
Status_unit varchar(10) NOT NULL,
Update_time datetime2 NOT NULL,		
Updater_name varchar(20) NOT NULL,
[Action] varchar(10) NOT NULL
);
ALTER TABLE PROCESSLOG
ADD CONSTRAINT PK_PROCESSLOGId PRIMARY KEY (Id); 


CREATE TABLE [ORDERROUTING](														-- Megrendelésekhez tartozó állomások/munkafolyamatok
Operation_id tinyint NOT NULL,
Operation_name varchar(30)
)
ALTER TABLE ORDERROUTING
ADD CONSTRAINT PK_OrderRoutingId PRIMARY KEY (Operation_id) 


CREATE TABLE ORDERSWITCH(															--Kapcsolat (kapcsolótábla) az ORDERS és ORDERROUTING tábla közt
Order_id int NOT NULL,			
Operation_id tinyint NOT NULL,	
)
ALTER TABLE [ORDERSWITCH]
ADD CONSTRAINT PK_OrderSwitch PRIMARY KEY (Order_id,Operation_id);


CREATE TABLE MEASUREMENT(															-- Gyártás közbeni mérések táblája
Measure_id int IDENTITY(1,1),		
Unit_id varchar(30) NOT NULL,		
Operation_id tinyint NOT NULL,		
Measure_name varchar(30),
Measure_result varchar(15),
Unitofmeasure varchar(15),			-- Mértékegység
Evaluation varchar(8)  CHECK (Evaluation in ('Pass','Fail','N/A')),
Measure_date datetime2
)
ALTER TABLE MEASUREMENT
ADD CONSTRAINT PK_MEASUREMENTId PRIMARY KEY (Measure_id);


CREATE TABLE REPAIR(																-- Javítások táblája
Unit_id varchar(30) NOT NULL,		
Fail_id int NOT NULL,				
Repair_code tinyint NOT NULL,		
User_id int NOT NULL,				
Repair_Date datetime2 NOT NULL 
)
ALTER TABLE REPAIR
ADD CONSTRAINT PK_REPAIRId PRIMARY KEY (Fail_id);


CREATE TABLE REPAIRDEF(																-- Elvégzett javítások definiciós táblája
Repair_code tinyint NOT NULL UNIQUE,		
Repair_Definition varchar(30)
)
ALTER TABLE REPAIRDEF
ADD CONSTRAINT PK_REPAIRDEFCODE PRIMARY KEY (Repair_code);


CREATE TABLE [USERS](																-- Felhasználók
User_id int NOT NULL,				
User_name varchar(20) NOT NULL UNIQUE,	--Felhasználónév
Right_id tinyint NOT NULL,			
Real_Name varchar(50) NOT NULL,
Department varchar(40) NOT NULL			--Osztály ahol dolgozik
);
ALTER TABLE [USERS]
ADD CONSTRAINT PK_USERID PRIMARY KEY (User_id);
 

CREATE TABLE RIGHTS(																-- Jogok tábla
Right_id tinyint NOT NULL,			
Right_Definition varchar(30)
)
ALTER TABLE RIGHTS
ADD CONSTRAINT PK_RIGHTSId PRIMARY KEY (Right_id);


-- ***** Foreign keys *****

ALTER TABLE PROCESS
ADD CONSTRAINT FK_PROCESSOrderOrder
FOREIGN KEY (Order_id) REFERENCES [ORDERS](Order_id); 
ALTER TABLE PROCESS
ADD CONSTRAINT FK_PROCESSOrderOperation
FOREIGN KEY (Operation_id) REFERENCES ORDERROUTING(Operation_id);

ALTER TABLE ORDERSWITCH
ADD CONSTRAINT FK_OrderSwitch
FOREIGN KEY (Order_id) REFERENCES [ORDERS](Order_id); 
ALTER TABLE ORDERSWITCH
ADD CONSTRAINT FK_RoutingSwitch
FOREIGN KEY (Operation_id) REFERENCES ORDERROUTING(Operation_id);

ALTER TABLE MEASUREMENT
ADD CONSTRAINT FK_MEASUREMENTUnitId
FOREIGN KEY (Unit_id) REFERENCES PROCESS(Unit_id);
ALTER TABLE MEASUREMENT
ADD CONSTRAINT FK_MEASUREMENTOperation
FOREIGN KEY (Operation_id) REFERENCES ORDERROUTING(Operation_id);

ALTER TABLE REPAIR
ADD CONSTRAINT FK_REPAIRPROCESSUnitid
FOREIGN KEY (Unit_id) REFERENCES PROCESS(Unit_id);
ALTER TABLE REPAIR
ADD CONSTRAINT FK_EVAUSERId
FOREIGN KEY (User_id) REFERENCES [USERS](User_id);
ALTER TABLE REPAIR
ADD CONSTRAINT FK_REPAIRREPAIRDef
FOREIGN KEY (Repair_code) REFERENCES REPAIRDEF(Repair_code);
ALTER TABLE REPAIR
ADD CONSTRAINT FK_REPAIRFailid
FOREIGN KEY (Fail_id) REFERENCES MEASUREMENT(Measure_id);

ALTER TABLE [USERS]
ADD CONSTRAINT FK_USERRIGHT
FOREIGN KEY (Right_id) REFERENCES RIGHTS(Right_id);

ALTER TABLE PROCESSLOG
ADD CONSTRAINT FK_PROCESSLOGUnit
FOREIGN KEY (Unit_id) REFERENCES PROCESS(Unit_id);


-- ***** Indexek *****
USE Factory
GO

CREATE NONCLUSTERED INDEX IX_Processlog_UnitId ON dbo.PROCESSLOG (Unit_id)
GO

CREATE NONCLUSTERED INDEX IX_Measurement_UnitId ON dbo.MEASUREMENT (Unit_id)
GO

CREATE NONCLUSTERED INDEX IX_Repair_UnitId ON dbo.REPAIR (Unit_id)
GO

-- CREATE UNIQUE NONCLUSTERED INDEX IX_Users_UserName ON dbo.USERS (User_name)  --Nagyon sok felhasználónál érdemes használni csak!
-- GO


-- ***** Függvény *****


-- Vizsgálja az adott orderben van-e hely és így ad vissza 0-át vagy 1-et és 2-õt ha nemlétezõ order.

USE Factory
GO

	CREATE OR ALTER FUNCTION dbo.FuncOrderCount									-- Az adott orderbe van-e még hely?
		(@order int)															-- A vizsgált order
		RETURNS INT
	BEGIN
		--SET NOCOUNT ON
		DECLARE @orderactual int = 5											-- Order aktuális értéke
		DECLARE @isOrderNotFull int = 0 
		SET @orderactual = (SELECT Order_actualqty
		FROM ORDERS WHERE Order_id=@order )

			IF (@orderactual>=1)												-- Ha több mint 1 a hely
				BEGIN
				SET @isOrderNotFull = 1
				END
				ELSE IF (@orderactual IS NULL)									-- Ha nem létezik az order
					BEGIN
					SET @isOrderNotFull = 2
					END
						ELSE
						BEGIN
						SET @isOrderNotFull = 0									-- Ha létezik és 1-nél kevesebb a hely
						END

		RETURN @isOrderNotFull
	END	
	GO


-- ***** View-ek *****

USE Factory
GO

CREATE OR ALTER VIEW dbo.viewMeasurementRepair AS									-- Visszaadja mely hibák lettek javítva, ki által és mivel
select MEASUREMENT.Unit_id,MEASUREMENT.Operation_id,MEASUREMENT.Measure_name,MEASUREMENT.Measure_result,MEASUREMENT.Unitofmeasure, MEASUREMENT.Evaluation,REPAIR.Repair_code,REPAIRDEF.Repair_Definition,USERS.User_name,REPAIR.Repair_Date
from MEASUREMENT, REPAIR, USERS, REPAIRDEF where
MEASUREMENT.Measure_id=REPAIR.Fail_id and
REPAIR.User_id=USERS.User_id and
REPAIR.Repair_code=REPAIRDEF.Repair_code and
MEASUREMENT.Evaluation='Fail'
GO
  
	--*****

-- Az 1 hónapnál nem régebbi Date_Start orderkeben milyen egységek vannak, melyik állomáson, anyagszámmal

USE Factory
GO

CREATE OR ALTER VIEW dbo.viewOneMounthOrderUnit AS
select p.Unit_id,p.Order_id,p.Operation_id,p.Status_unit,CAST(p.Update_time as date) as Update_Time ,p.Updater_name
, o.Material_number,o.Order_actualqty,o.Date_start,o.Date_planned_end from PROCESS p
INNER JOIN ORDERS o ON p.Order_id=o.Order_id
where o.Date_start > (SELECT DATEADD(month, -1, GETDATE()))
GO

	-- ****

--Melyek azok az egységek amelyek nem utolsó állomáson állnak és az order planned enden már túl vagyunk.

USE Factory
GO

CREATE OR ALTER VIEW dbo.viewNotFinishTooOldUnit AS
select p.Unit_id,p.Order_id,p.Operation_id,p.Status_unit,CAST(p.Update_time as date) as Update_Time ,p.Updater_name
, o.Material_number,o.Order_actualqty,o.Date_planned_end from PROCESS p
INNER JOIN ORDERS o ON p.Order_id=o.Order_id
where p.Operation_id!=190 and
getdate()>o.Date_planned_end
GO


-- ***** Eljárások *****


-- Elsõ eljárás

-- Visszaadja egy egységrõl, hogy mely állomásokon volt 1-nél több hibája

USE Factory
GO

CREATE OR ALTER PROC dbo.UnitFailHistory   
		@Unit_id varchar(30)
		
	AS
		SET NOCOUNT ON
		SELECT Rep.Operation_id, Ord.Operation_name, count(Evaluation) as 'Fail Count' FROM dbo.viewMeasurementRepair Rep
		join ORDERROUTING Ord on Rep.Operation_id=Ord.Operation_id
		where Unit_id=@Unit_id
		group by Rep.Operation_id,Ord.Operation_name
		having count(Evaluation)>=2
		
		
	GO


-- Eljárás eldobása:

--Drop procedure dbo.UnitFailHistory
--GO


-- Második eljárás

-- Külsõ 'egységjavító' program ezen eljáráson át tudja a javítás eredményét beszúrni a REPAIR táblába
-- 2 féle használat lehetséges: 
-- - Megadjuk a javítandó egység Measurement táblában szerepló javítandó mérésének measurement_id-ját.
-- - Vagy megadjuk a javítandó egység mely operáció azonosítón végzett mely mérését akarjuk javítani.
-- Mindkét esetben a Measurement táblába léteznie kell a Fail-os mérésnek.

USE Factory
GO

CREATE OR ALTER PROC dbo.InsertRepair	
		@Mode tinyint = null,					-- Ha 1 akkor measurement_id, ha 2 akkor Operation_id & Measure_name
		@Unit_id varchar(30)= null,				-- Egység azonosító
		@Repair_code tinyint= null,				-- Repair code
		@User_id int= null,						-- Felhasználó id
		@Mea_id int= null,						-- A failos mérés azonosítója amit javítunk
		@Op_id int= null,						-- Az operáció ahol a hiba van
		@Mea_name varchar(30)= null				-- A hiba 'neve'

AS
		SET NOCOUNT ON 


	DECLARE @ID int = NULL
	DECLARE @RIGHT tinyint = NULL

	SET @RIGHT =( select  Right_id from USERS where User_id=@User_id )	--Mi a módosító joga?
	IF ( @RIGHT = 10 or @RIGHT = 20)									--Ha 10 vagy 20 a joga rendben
			BEGIN
			Print 'DOLGOZHATSZ'  
				IF @Mode=1
					BEGIN
					BEGIN TRY
						INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES(@Unit_id,@Mea_id,@Repair_code,@User_id,GETDATE())
						Return (1)										-- 1 a return ha sikeres
					END TRY
					BEGIN CATCH  

				/*	SELECT   
					ERROR_NUMBER() AS ErrorNumber  
				    ,ERROR_SEVERITY() AS ErrorSeverity  
				    ,ERROR_STATE() AS ErrorState  
				    ,ERROR_PROCEDURE() AS ErrorProcedure  
				    ,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  */
					Print 'Sikertelen adatbeszúrás a Repair táblába!'
					Print 'Error number:' + CAST( ERROR_NUMBER() AS  nvarchar )
					Print 'Error message:' + ERROR_MESSAGE()
					RETURN (-1)
 
					END CATCH;
					END													-- IF @Mode=1 vége
				ELSE IF @Mode=2
				BEGIN
				BEGIN TRY
					set @ID = (select Measure_id from MEASUREMENT where (Unit_id=@Unit_id and operation_id=@Op_id  and Measure_name=@Mea_name))
					INSERT INTO REPAIR(Unit_id,Fail_id,Repair_code,User_id,Repair_date) VALUES(@Unit_id,@ID,@Repair_code,@User_id,GETDATE())
				
					Return (1)											-- 1 a return ha sikeres
					END TRY
					BEGIN CATCH  

				/*	SELECT   
					ERROR_NUMBER() AS ErrorNumber  
				   -- ,ERROR_SEVERITY() AS ErrorSeverity  
				   -- ,ERROR_STATE() AS ErrorState  
				    ,ERROR_PROCEDURE() AS ErrorProcedure  
				    ,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  */
					Print 'Sikertelen adatbeszúrás a Repair táblába!'
					Print 'Error number:' + CAST( ERROR_NUMBER() AS  nvarchar )
					Print 'Error message:' + ERROR_MESSAGE()
					RETURN (-1)
 
					END CATCH;
					END												-- IF @Mode=2 vége		
				ELSE
				Print'Hibás paraméter megadás!'

			END														-- Jogok If zárása
		Print'Nincs megfelelõ jog!'
	GO
/*

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
GO


-- Mode 2 meghívás - Ehhez tudni kell egy le nem javított Operáció_id és Measure name és csak 1-szer legyen a MEASUREMENT táblában!
EXEC dbo.InsertRepair @Mode=2 ,@Unit_id='998877' ,@Repair_code=4 ,@User_id=21 ,@Op_id=140 ,@Mea_name='D1' -- Hibás bevitel, már létezik ez a javítás

-- Mode 2 mûködõ teszt:
-- Beszúrás a MEASUREMNT táblába:
INSERT INTO MEASUREMENT(Unit_id,Operation_id,Measure_name,Measure_result,Unitofmeasure,Evaluation,Measure_date) VALUES('A9B857',140,'C1','1,91','nF','Fail',Getdate())
EXEC dbo.InsertRepair @Mode=2 ,@Unit_id='A9B857' ,@Repair_code=4 ,@User_id=21 ,@Op_id=140 ,@Mea_name='C1' -- Eljárás hívás a beszúrás adatai alapján
select * from MEASUREMENT where Unit_id='A9B857' and Operation_id=140 and Measure_name='C1'		-- Ellenõrzés
GO
*/

-- Eljárás eldobása:
-- DROP PROCEDURE dbo.InsertRepair


-- Harmadik eljárás

-- Új felhsználó felvitele az USER táblába a jog nevének, a leendõ felhasználónév (egyedi kell legyen), valós név és ágazat megadásával.

USE Factory
GO


CREATE OR ALTER PROC dbo.InsertUser	
		@Rightdef varchar(30)= null,	-- Rights tábla Right_Definition				
		@Username varchar(20)= null,	-- Létrehozandó felhasználónév		
		@Realname varchar(50)= null,	-- Valós név	
		@Dep varchar(20)= null			-- Department ahol dolgozik		

AS
		SET NOCOUNT ON 

		DECLARE @UID int=NULL			-- A második legmagasabb User_id (+1) (A legmagasabb 9999-el az SMTMachines)
		DECLARE @RIGT int =NULL			-- A right_definition milyen Right_id-t takar

		BEGIN
			BEGIN TRY
					
			SET @RIGT = ( select Right_id from RIGHTS where Right_Definition=@Rightdef)		--Milyen id-t takar a jog
			SET @UID=(select MIN(User_id) from (select TOP(2) User_id from USERS order by User_id desc)Temp)	--Mi a második legnagyobb User_id? A legnagyobb a 9999 SMTMachines
  
			SET @UID=@UID+1
  
			INSERT INTO USERS (User_id,User_name,Right_id,Real_Name,Department) VALUES(@UID,@Username,@RIGT,@Realname,@Dep)	--USER Insert

			Return (1)										-- 1 a return ha sikeres
			END TRY
			BEGIN CATCH  

					Print 'Sikertelen adatbeszúrás az USER táblába!'
					Print 'Error number:' + CAST( ERROR_NUMBER() AS  nvarchar )
					Print 'Error message:' + ERROR_MESSAGE()
					RETURN (-1)
 
					END CATCH;
					END											
				

	GO
	
	
-- Eljárás eldobása:
-- DROP PROCEDURE dbo.InsertUser


-- ***** Trigger *****


--	A Process táblában történõ adatmódosítást logolja a PROCESSLOG táblába ( törlést nem engedve), ellenõrizve a módosítást végzõ jogát, hogy Unit manipulátor vagy administrator.
USE Factory
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER trgProcessLog ON dbo.PROCESS
		  INSTEAD OF INSERT, UPDATE, DELETE
	AS
BEGIN

	DECLARE @updater VARCHAR(20)						-- Ki a módisító?
	DECLARE @updater_right int							-- Milyen joga van?
	DECLARE @ins int = (select count(*) from inserted)	--Hány sor az insertedbe?
	DECLARE @del int = (select count(*) from deleted)	--Hány sor a deletedbe?

	SET @updater = (select Updater_name from inserted)	--Ki módosít

	SET @updater_right =( select  Right_id from USERS where User_name=@updater )	--Mi a módosító joga?
		If @updater_right IS NULL
			Print'Nincs Jog, nem végezheti el a mûveletet!'

		IF (@ins = 0) AND (@del = 0)												--Ha nincs semmi az insertedbe és deletedbe valami hiba van
		Print ' Hibás paraméter megadás!'
	
		IF ( (@updater_right = 100) or (@updater_right = 1))													--Ha 100 vagy 1 a joga rendben
			BEGIN
			--Print 'DOLGOZHATSZ'  
				IF (@del = 0 and @ins>=1)
				BEGIN
					--Print 'INSERT ÁG'
					DECLARE @ordertoorder int = (select Order_id from inserted )		--Melyik order darabszámot kell vizsgálni
					DECLARE @unitidins varchar(30) = (select unit_id from inserted )	--Milyen unit_id-t insertálnak
					DECLARE @unitid varchar(30) = (select unit_id from PROCESS where Unit_id=@unitidins)	--Létezik-e a process táblába amit insertálnának unit_id
					DECLARE @processid int = (select operation_id from inserted )		-- Milyen operációra akarnak insertálni
						
						IF ((@unitid IS NULL ) and (@processid=100))					-- Ha elsõ állomás (100) és nem létezik a process táblában mehet
							BEGIN
								--Print 'Ellenõrzés oké'

								DECLARE @isOrdertrue int = (select dbo.FuncOrderCount(@ordertoorder)) --Ebbe mentem az output változót és funkció hívás					

							IF @isOrdertrue = 1
							BEGIN

									INSERT INTO dbo.PROCESS
									SELECT * FROM inserted
									 --print'insert ok'
									INSERT INTO dbo.PROCESSLOG
									SELECT i.Unit_id,i.order_id,i.operation_id,i.status_unit,GETDATE(),i.updater_name,'INSERT'
									FROM inserted i
									--print'log insert ok'
									UPDATE ORDERS										-- Order érték 1-el csökkentés
									SET Order_actualqty = Order_actualqty-1
									where Order_id=@ordertoorder
									--print'order update ok'

								END
								ELSE IF @isOrdertrue = 0
								BEGIN
								print'Nulla az order!'
								END
								ELSE IF @isOrdertrue = 2
								BEGIN
								print'Nem létezik az order!'
								END
							END
						ELSE
							print 'Már létezik az egység vagy nem elsõ állomás!!'

				END
				ELSE IF (@del>=1 and @ins = 0)
				BEGIN
					--Print 'DElete ÁG'
					Print ' Nem törlünk egységet a Process táblából! Használj update-t ha kell!'
	
				END 
				ELSE
				BEGIN
					--print 'Update ÁG'
		
					INSERT INTO dbo.PROCESSLOG
					SELECT i.Unit_id,i.order_id,i.operation_id,i.status_unit,GETDATE(),i.updater_name,'INSERTUPD'
					FROM inserted i
					JOIN deleted d on d.Unit_id=i.Unit_id 

					INSERT INTO dbo.PROCESSLOG
					SELECT d.Unit_id,d.order_id,d.operation_id,d.status_unit,GETDATE(),d.updater_name,'DELETEUPD'
					FROM deleted d
					JOIN inserted i on d.Unit_id=i.Unit_id 
		
					UPDATE pr															-- Tényleges update a process táblába
					SET 
					pr.unit_id=i.Unit_id , pr.order_id=i.order_id, pr.operation_id=i.Operation_id, pr.status_unit=i.Status_unit,
					pr.update_time=GETDATE(), pr.updater_name=i.Updater_name
					FROM dbo.PROCESS pr
					INNER JOIN
					inserted i ON pr.Unit_id=i.Unit_id


				END 

			END																		--Eddig tart az IF igaz ága, van jog.
			ELSE
				IF (@ins != 0 and @del=0)											--Ha a nincs jog, és a delete tábla üres
					BEGIN
					Print 'Nincs joga a mûvelethez!'								--Akkor nem delete volt
				END
				ELSE																--Nincs jog, de van a delete táblába vagyis törlés volt.
				BEGIN	
					--Print 'DElete ÁG Kint'
					Print ' Nem törlünk egységet a Process táblából! Használj update ha kell!'
				END
	
END

GO


-- ***** Adatbázis Loginok, Felhasználók, Role-ok *****


-- Application Role
-- Lehetõvé teszi hogy az orderekkel kapcsolatos táblákra (Orders,Orderrouting,Orderswitch) select,update,insert, delete utasítást lehessen végrehajtani.

USE [Factory]
GO
CREATE APPLICATION ROLE [Ordersadmin] WITH DEFAULT_SCHEMA = [dbo], PASSWORD = N'ORDERSADMIN'
GO
use [Factory]
GO
GRANT DELETE ON [dbo].[ORDERROUTING] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT INSERT ON [dbo].[ORDERROUTING] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[ORDERROUTING] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT UPDATE ON [dbo].[ORDERROUTING] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT DELETE ON [dbo].[ORDERSWITCH] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT INSERT ON [dbo].[ORDERSWITCH] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[ORDERSWITCH] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT UPDATE ON [dbo].[ORDERSWITCH] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT DELETE ON [dbo].[ORDERS] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT INSERT ON [dbo].[ORDERS] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[ORDERS] TO [Ordersadmin]
GO
use [Factory]
GO
GRANT UPDATE ON [dbo].[ORDERS] TO [Ordersadmin]
GO

-- Database role
-- lehetõvé teszi, hogy csak a Process és Processlog táblákat olvassa. A Processreader felhasználó használja.

USE [Factory]
GO
CREATE ROLE [Processread]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[PROCESS] TO [Processread]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[PROCESSLOG] TO [Processread]
GO


-- Loginok és User-ek

-- SMT Service - A soron lévõ gépek programjai ezen át tudnak írni/olvasni az adatbázisba és eljárást futttni.

USE [master]
GO

CREATE LOGIN [SMT Service] WITH PASSWORD=N'SMTSERVICE', DEFAULT_DATABASE=[Factory], DEFAULT_LANGUAGE=[magyar], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


USE [Factory]
GO
CREATE USER [SMT Service] FOR LOGIN [SMT Service]
GO
USE [Factory]
GO
ALTER ROLE [db_datareader] ADD MEMBER [SMT Service]
GO
USE [Factory]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [SMT Service]
GO
use [Factory]
GO
GRANT EXECUTE ON [dbo].[InsertRepair] TO [SMT Service]
GO
use [Factory]
GO
GRANT EXECUTE ON [dbo].[UnitFailHistory] TO [SMT Service]
GO

--------------------------------------

-- Repair - Lehetõvé tesz a Repair táblába való adatbevitelt és a táblába adatbevivõ tárolt eljárás futtatását.

USE [master]
GO

CREATE LOGIN [Repair] WITH PASSWORD=N'REPAIR', DEFAULT_DATABASE=[Factory], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [Factory]
GO
CREATE USER [Repair] FOR LOGIN [Repair]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[PROCESS] TO [Repair]
GO
use [Factory]
GO
GRANT INSERT ON [dbo].[REPAIR] TO [Repair]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[REPAIR] TO [Repair]
GO
use [Factory]
GO
GRANT UPDATE ON [dbo].[REPAIR] TO [Repair]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[RIGHTS] TO [Repair]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[USERS] TO [Repair]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[MEASUREMENT] TO [Repair]
GO
use [Factory]
GO
GRANT EXECUTE ON [dbo].[InsertRepair] TO [Repair]
GO
----------------------

-- Reader - Adatbázis olvasása, de csak olvasás


USE [master]
GO

CREATE LOGIN [Reader] WITH PASSWORD=N'READER', DEFAULT_DATABASE=[Factory], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [Factory]
GO
CREATE USER [Reader] FOR LOGIN [Reader]
GO

USE [Factory]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Reader]
GO

------------

-- Manipulation - A Process és Processlog tábla manipulálását (kivéve törlés) teszi lehetõvé (egységek mozgatása)

USE [master]
GO

CREATE LOGIN [Manipulation] WITH PASSWORD=N'MANIPULATION', DEFAULT_DATABASE=[Factory], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


USE [Factory]
GO
CREATE USER [Manipulation] FOR LOGIN [Manipulation]
GO
use [Factory]
GO
GRANT INSERT ON [dbo].[PROCESS] TO [Manipulation]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[PROCESS] TO [Manipulation]
GO
use [Factory]
GO
GRANT UPDATE ON [dbo].[PROCESS] TO [Manipulation]
GO
use [Factory]
GO
GRANT INSERT ON [dbo].[PROCESSLOG] TO [Manipulation]
GO
use [Factory]
GO
GRANT SELECT ON [dbo].[PROCESSLOG] TO [Manipulation]
GO
use [Factory]
GO
GRANT UPDATE ON [dbo].[PROCESSLOG] TO [Manipulation]
GO

------------

-- Admin - DB owner jogok

USE [master]
GO

CREATE LOGIN [Admin] WITH PASSWORD=N'ADMIN', DEFAULT_DATABASE=[Factory], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [Factory]
GO
CREATE USER [Admin] FOR LOGIN [Admin]
GO
USE [Factory]
GO
ALTER ROLE [db_owner] ADD MEMBER [Admin]
GO

----------

-- Processreader - a saját készítésû databaserole-t használja, Process,Processlog táblák olvasása 

USE [master]
GO
CREATE LOGIN [Processreader] WITH PASSWORD=N'PROCESSREADER', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
use [Factory];
GO
use [master];
GO
USE [Factory]
GO
CREATE USER [Processreader] FOR LOGIN [Processreader]
GO
USE [Factory]
GO
ALTER ROLE [Processread] ADD MEMBER [Processreader]
GO


-- Mindezeken kívûl, a fehasználóknak létezniük kell az USERS táblában és jogaiknak lenni a RIGHTS táblában a teljeskörû használathoz
-- A táblák megövetelik ezek meglétét mert van ilyen oszlopuk Pl.:Process,Repair


-- ***** Backup job-ok beállítása *****

-- Full Backup

USE [msdb]			--Full
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Back Up Database - Factory', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-OD081LQ\polga', @job_id = @jobId OUTPUT
--select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Back Up Database - Factory', @server_name = N'DESKTOP-OD081LQ'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Back Up Database - Factory', @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [Factory] TO  DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Factory.bak'' WITH NOFORMAT, NOINIT,  NAME = N''Factory-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Back Up Database - Factory', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-OD081LQ\polga', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Back Up Database - Factory', @name=N'Sunday Full', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210820, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
--select @schedule_id
GO

-- Differential Backup

USE [msdb]		--Diff
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Back Up Diff Database - Factory', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-OD081LQ\polga', @job_id = @jobId OUTPUT
--select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Back Up Diff Database - Factory', @server_name = N'DESKTOP-OD081LQ'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Back Up Diff Database - Factory', @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [Factory] TO  DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Factory.bak'' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N''Factory-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Back Up Diff Database - Factory', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-OD081LQ\polga', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Back Up Diff Database - Factory', @name=N'Daily Differential', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210820, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
--select @schedule_id
GO

-- Log backup

USE [msdb]		--Log
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Back Up Log Database - Factory', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-OD081LQ\polga', @job_id = @jobId OUTPUT
--select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Back Up Log Database - Factory', @server_name = N'DESKTOP-OD081LQ'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Back Up Log Database - Factory', @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP LOG [Factory] TO  DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Factory.bak'' WITH NOFORMAT, NOINIT,  NAME = N''Factory-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Back Up Log Database - Factory', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-OD081LQ\polga', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Back Up Log Database - Factory', @name=N'Log backup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=2, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210820, 
		@active_end_date=99991231, 
		@active_start_time=2000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
--select @schedule_id
GO

-- ***** Backup Master és msdb database *****

BACKUP DATABASE [master] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\master.bak' WITH NOFORMAT, NOINIT,  NAME = N'master-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
BACKUP DATABASE [msdb] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\msdb.bak' WITH NOFORMAT, NOINIT,  NAME = N'msdb-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO