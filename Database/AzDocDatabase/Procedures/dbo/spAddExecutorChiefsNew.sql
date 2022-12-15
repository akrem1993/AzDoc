/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/
-- =============================================
-- Author:  Rufin Ahmadov
-- Create date: 02.10.2019
-- Description: Avtomatik vizalarin cixarilmasi
-- =============================================
CREATE PROCEDURE [dbo].[spAddExecutorChiefsNew]
@fileId INT, 
@vizaDocId INT,
@relatedDocId INT=NULL,
@answerDocIds nvarchar(max) null,
@signerWorkPlaceId INT = NULL,
@docTypeId INT,
@workPlaceId INT ,
@result INT output
WITH EXEC AS CALLER
AS

BEGIN TRY

	IF(NOT EXISTS(SELECT * FROM docs_viza v where v.VizaFileId=@fileId and v.VizaDocId=@vizaDocId and v.VizaFROMWorkflow=1 AND v.IsDeleted=0))
	  BEGIN
		
	
		DECLARE @departmentId INT,
				@departmenType INT,
				@chiefWorkPlaceId INT,
				@chiefDepartmentId INT,
				@positionGroupId INT,
				@signerPositionGroupId int,
				@organizationTopId int,
				@departmentTopId int,
				@chiefCountFirst int,
				@departmentPositionId int;
	
		DECLARE @AnswerDocs table(DocId int NULL);
	
		DECLARE	 @answerDocIdCount int = 0,			
				 @answerDocId int=0;

		IF(@answerDocIds IS NOT NULL)
		BEGIN
				SELECT @answerDocIdCount=count(0) 
				FROM OPENJSON(@answerDocIds);

				WHILE(@answerDocIdCount>0)
				BEGIN
					SELECT @answerDocId = S.[Value] 
					FROM (
					  SELECT A.[Value], row_number() over(ORDER BY A.[Value]) AS [row] 
					  FROM OPENJSON(@answerDocIds) AS A) AS S 
					WHERE S.[row] = @answerDocIdCount

				DECLARE @headWorkPlaceId int,
						@execCount int;

				SELECT @chiefWorkPlaceId=[dbo].[fnGetDepartmentChief](@workPlaceId);

				SELECT @headWorkPlaceId=dd.DirectionWorkplaceId
				FROM dbo.DOCS_EXECUTOR de 
				INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId=dd.DirectionId
				WHERE de.ExecutorDocId=@answerDocId 
				   AND de.DirectionTypeId=1
				   AND de.ExecutorWorkplaceId=@chiefWorkPlaceId      --@senderWorkPlaceId
				   AND de.ExecutorMain = 1 
				   AND de.SendStatusId=1
				   AND de.ExecutorReadStatus=(CASE WHEN @chiefWorkPlaceId=@workPlaceId THEN 0 ELSE 1 end)

				SELECT @execCount=count(0)
				FROM dbo.DOCS_DIRECTIONS dd 
				INNER JOIN dbo.DOCS_EXECUTOR de ON dd.DirectionId = de.ExecutorDirectionId
				WHERE dd.DirectionWorkplaceId=@headWorkPlaceId
				   AND dd.DirectionDocId=@answerDocId
				   AND dd.DirectionTypeId=1 
				   AND dd.DirectionConfirmed=1
				   AND de.SendStatusId=2

				IF(@execCount!=0)
				BEGIN
					SET @signerWorkPlaceId = 0;
				END;

				set @answerDocIdCount-=1;
			END
		 END;

	    DECLARE @Chief table(WorkPlaceId INT, 
							 OrderIndex INT,
							 DepartmentId INT, 
							 UserName nvarchar(500), 
							 RowNumber INT);
		
		SELECT @organizationTopId = do.OrganizationTopId,
			   @positionGroupId=ddp.PositionGroupId ,
			   @departmenType=dd.DepartmentTypeId,
			   @departmentId=dd.DepartmentId,
			   @departmentTopId=dd.DepartmentTopId,
			   @departmentPositionId=ddp.DepartmentPositionId
		FROM dbo.DC_WORKPLACE dw 
			INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
			INNER JOIN dbo.DC_DEPARTMENT dd ON dw.WorkplaceDepartmentId = dd.DepartmentId
			INNER JOIN dbo.DC_ORGANIZATION do ON dw.WorkplaceOrganizationId = do.OrganizationId
		WHERE dw.WorkplaceId = @workPlaceId
	
		SELECT @signerPositionGroupId=dpg.PositionGroupId 
		FROM dbo.DC_WORKPLACE dw  
		 	INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId 
		 	INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
		WHERE dw.WorkplaceId = @signerWorkPlaceId 

		SET @chiefWorkPlaceId=NULL;

		IF(@departmenType=6) -- eger departamentin tipi sektordursa
		BEGIN
				
			DECLARE @sectorChiefWorkPlaceId int=NULL;
	
			IF( @positionGroupId<>26) -- eger sektor mudiri ozu sened hazirlayirsa ozu vizada cixmir
			BEGIN
				SELECT @sectorChiefWorkPlaceId = dw.WorkplaceId,  -- vezIFeye esasen sexsin workplace-si tapilir
				   @chiefDepartmentId=dw.WorkplaceDepartmentId
				FROM dbo.DC_WORKPLACE dw
					INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
					INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
					INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
				WHERE ddp.DepartmentId=@departmentId 
				  AND ddp.PositionGroupId=26
				  AND dw.WorkPlaceStatus=1
				  AND du.UserStatus=1
				  AND dp.PersonnelStatus=1
			END		
				  
			IF(@sectorChiefWorkPlaceId IS NOT NULL)
			BEGIN
			INSERT INTO @Chief
			(
			    WorkPlaceId,
				OrderIndex,
			    DepartmentId,
			    UserName,
			    RowNumber
			)
			VALUES
			(
			    @sectorChiefWorkPlaceId, -- WorkPlaceId - INT
				1,
			    @chiefDepartmentId, -- DepartmentId - INT
			    [dbo].[fnGetPersonnelbyWorkPlaceId](@sectorChiefWorkPlaceId,106), -- UserName - nvarchar
			    1 -- RowNumber - INT
			);
			END;
			
			SELECT top(1) @chiefWorkPlaceId=dw.WorkplaceId, -- shobe mudiru
				   @chiefDepartmentId = dw.WorkplaceDepartmentId
			FROM dbo.DC_DEPARTMENT dd 
				INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dd.DepartmentTopId = ddp.DepartmentId
				INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
				INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
				INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
			WHERE dd.DepartmentId=@departmentId
				  AND ddp.PositionGroupId = 17
				  AND dw.WorkPlaceStatus=1
				  AND du.UserStatus=1
				  AND dp.PersonnelStatus=1
			
			IF(@chiefWorkPlaceId IS NULL) -- EGER SHOBE MUDIRI YOXDURSA QURUM REHBERINI VIZAYA ELAVE EDIRIK
			BEGIN
				SELECT @chiefWorkPlaceId=dw.WorkplaceId, -- bezi qurumlarda ust departamentde qurum rehberi oldugu ucun
					   @chiefDepartmentId=dw.WorkplaceDepartmentId
				FROM dbo.DC_DEPARTMENT dd 
					INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dd.DepartmentTopId = ddp.DepartmentId
					INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
					INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
					INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
				WHERE dd.DepartmentId=@departmentId
					AND ddp.PositionGroupId=5
					AND dw.WorkPlaceStatus=1
					AND du.UserStatus=1
					AND dp.PersonnelStatus=1
			END;

			IF(@chiefWorkPlaceId IS NOT NULL)
			BEGIN

				INSERT INTO @Chief
				(
				    WorkPlaceId,
					OrderIndex,
				    DepartmentId,
				    UserName,
				    RowNumber
				)
				VALUES
				(
				    @chiefWorkPlaceId, -- WorkPlaceId - INT
					CASE WHEN  @sectorChiefWorkPlaceId is NULL THEN 1 ELSE 2 END,
				    @chiefDepartmentId, -- DepartmentId - INT
				    [dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
				    CASE WHEN  @sectorChiefWorkPlaceId is null THEN 1 ELSE 2 END -- RowNumber - INT
				);
			END;

			SELECT @chiefWorkPlaceId=dw.WorkplaceId, -- departament mudiri ucun(BTRB)
				   @chiefDepartmentId=dw.WorkplaceDepartmentId
			FROM dbo.DC_DEPARTMENT_POSITION ddp 
				INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
				INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
				INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
			WHERE ddp.DepartmentId=@departmentTopId 
				AND ddp.PositionGroupId IN (13)
				AND du.UserStatus=1
				AND dw.WorkPlaceStatus=1
				AND dp.PersonnelStatus=1

			IF(@chiefWorkPlaceId IS NOT NULL)
			BEGIN

					INSERT INTO @Chief
					(
						WorkPlaceId,
						OrderIndex,
						DepartmentId,
						UserName,
						RowNumber
					)
					VALUES
					(
						@chiefWorkPlaceId, -- WorkPlaceId - INT
						ISNULL((SELECT max(OrderIndex) FROM @chief)+1,1),
						@chiefDepartmentId, -- DepartmentId - INT
						[dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
						ISNULL((SELECT Count(RowNumber) FROM @chief)+1,1) -- RowNumber - INT
					);
			END;

			SELECT @chiefWorkPlaceId=dw.WorkplaceId,-- QURUM REHBERINI VIZAYA ELAVE EDIRIK
				   @chiefDepartmentId=dw.WorkplaceDepartmentId
			FROM dbo.DC_DEPARTMENT dd 
				INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dd.DepartmentTopId = ddp.DepartmentId
				INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
				INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
				INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
			WHERE dd.DepartmentId=@departmentTopId
				AND ddp.PositionGroupId=5
				AND dw.WorkPlaceStatus=1
				AND du.UserStatus=1
				AND dp.PersonnelStatus=1

			SELECT @chiefCountFirst=count(0) FROM @Chief c

			IF(@chiefWorkPlaceId IS NOT NULL)
			BEGIN

				INSERT INTO @Chief
				(
				    WorkPlaceId,
					OrderIndex,
				    DepartmentId,
				    UserName,
				    RowNumber
				)
				VALUES
				(
				    @chiefWorkPlaceId, -- WorkPlaceId - INT
					CASE WHEN  @chiefCountFirst=1 THEN 2 WHEN @chiefCountFirst=2 THEN 3 ELSE 1 END,
				    @chiefDepartmentId, -- DepartmentId - INT
				    [dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
				    CASE WHEN  @chiefCountFirst=1 THEN 2 WHEN @chiefCountFirst=2 THEN 3 ELSE 1 END -- RowNumber - INT
				);
			END

			IF(@signerPositionGroupId IN (1,2,33) AND @organizationTopId IS NOT NULL) --  EGER IMZA EDEN WEXS NAZIR VE YA MUAVINLERIDIRSE QURUM REHBERI DE VIZAYA ELAVE OLUNUR
			BEGIN
				
				SELECT @chiefWorkPlaceId=dw.WorkplaceId,
					   @chiefDepartmentId=dw.WorkplaceDepartmentId
				FROM dbo.DC_DEPARTMENT dd 
					INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dd.DepartmentTopId = ddp.DepartmentId
					INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
					INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
					INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
				WHERE dd.DepartmentId=@departmentId
					AND ddp.PositionGroupId=5
					AND dw.WorkPlaceStatus=1
					AND du.UserStatus=1
					AND dp.PersonnelStatus=1

				IF(@chiefWorkPlaceId IS NOT NULL AND @chiefWorkPlaceId!=(SELECT c.WorkPlaceId FROM @Chief c WHERE c.OrderIndex=CASE WHEN @sectorChiefWorkPlaceId IS NULL THEN 1 ELSE 2 END))
				BEGIN

					INSERT INTO @Chief
					(
					    WorkPlaceId,
						OrderIndex,
					    DepartmentId,
					    UserName,
					    RowNumber
					)
					VALUES
					(
					    @chiefWorkPlaceId, -- WorkPlaceId - INT
						1,
					    @chiefDepartmentId, -- DepartmentId - INT
					    [dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
					    1 -- RowNumber - INT
					);
				END;	
			END;
		END
		ELSE IF(@departmenType=3)
		BEGIN
			SELECT @chiefWorkPlaceId=dw.WorkplaceId,
				   @chiefDepartmentId=dw.WorkplaceDepartmentId
			FROM dbo.DC_DEPARTMENT_POSITION ddp 
				INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
				INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
				INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
			WHERE ddp.DepartmentId=@departmentId 
				AND ddp.PositionGroupId=26
				AND dw.WorkPlaceStatus=1
				AND du.UserStatus=1
				AND dp.PersonnelStatus=1
	
			IF(@chiefWorkPlaceId IS NOT NULL)
			BEGIN

				INSERT INTO @Chief
				(
				    WorkPlaceId,
					OrderIndex,
				    DepartmentId,
				    UserName,
				    RowNumber
				)
				VALUES
				(
				    @chiefWorkPlaceId, -- WorkPlaceId - INT
					1,
				    @chiefDepartmentId, -- DepartmentId - INT
				    [dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
				    1 -- RowNumber - INT
				);
			END
		END
		ELSE IF (@departmenType=1)
		BEGIN

			SELECT @chiefWorkPlaceId=dw.WorkplaceId,
				   @chiefDepartmentId=dw.WorkplaceDepartmentId
			FROM dbo.DC_DEPARTMENT_POSITION ddp 
				INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
				INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
				INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
			WHERE ddp.DepartmentId=@departmentId 
				AND ddp.PositionGroupId IN ((CASE WHEN  (@organizationTopId IS NOT NULL AND @positionGroupId IN (5)) OR @positionGroupId=7 THEN 5 WHEN @positionGroupId=6 THEN 7 end),38)
				AND dw.WorkPlaceStatus=1
				AND du.UserStatus=1
				AND dp.PersonnelStatus=1

			IF(@chiefWorkPlaceId IS NULL) -- EGER SHOBE MUDIRI YOXDURSA QURUM REHBERINI VIZAYA ELAVE EDIRIK
			BEGIN
				SELECT @chiefWorkPlaceId=dw.WorkplaceId,-- eger sened hazirlayan wexs qurum rehberiyle eyni departamentde olarsa
					   @chiefDepartmentId=dw.WorkplaceDepartmentId
				FROM dbo.DC_DEPARTMENT dd 
					INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON ddp.DepartmentId = CASE WHEN @departmentTopId IS NULL then  dd.DepartmentId ELSE dd.DepartmentTopId end
					INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
					INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
					INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
				WHERE dd.DepartmentId=@departmentId
					AND ddp.PositionGroupId=5
					AND dw.WorkPlaceStatus=1
					AND du.UserStatus=1
					AND dp.PersonnelStatus=1
			END;

			IF(@chiefWorkPlaceId IS NOT NULL)
			BEGIN

				INSERT INTO @Chief
				(
				    WorkPlaceId,
					OrderIndex,
				    DepartmentId,
				    UserName,
				    RowNumber
				)
				VALUES
				(
				    @chiefWorkPlaceId, -- WorkPlaceId - INT
					1,
				    @chiefDepartmentId, -- DepartmentId - INT
				    [dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
				    1 -- RowNumber - INT
				);
			END;			
			

			IF(@signerPositionGroupId IN (1,2,33) AND @organizationTopId IS NOT NULL) --  EGER IMZA EDEN WEXS NAZIR VE YA MUAVINLERIDIRSE QURUM REHBERI DE VIZAYA ELAVE OLUNUR
			BEGIN
				
				SELECT @chiefWorkPlaceId=dw.WorkplaceId,
					   @chiefDepartmentId=dw.WorkplaceDepartmentId
				FROM dbo.DC_DEPARTMENT dd 
					INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dd.DepartmentTopId = ddp.DepartmentId
					INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
					INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
					INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
				WHERE dd.DepartmentId=@departmentId
					AND ddp.PositionGroupId=5
					AND dw.WorkPlaceStatus=1
					AND du.UserStatus=1
					AND dp.PersonnelStatus=1

				IF(@chiefWorkPlaceId IS NOT NULL AND @chiefWorkPlaceId!=(SELECT c.WorkPlaceId FROM @Chief c WHERE c.OrderIndex=1))
				BEGIN

					INSERT INTO @Chief
					(
					    WorkPlaceId,
						OrderIndex,
					    DepartmentId,
					    UserName,
					    RowNumber
					)
					VALUES
					(
					    @chiefWorkPlaceId, -- WorkPlaceId - INT
						1,
					    @chiefDepartmentId, -- DepartmentId - INT
					    [dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
					    1 -- RowNumber - INT
					);
				END;	
			END;
		END;
		ELSE IF(@departmenType in (5))
		BEGIN
					
			IF(@positionGroupId IN (32))--mushahide surasinin uzvu
			BEGIN
				INSERT INTO @Chief
				(
				    WorkPlaceId,
				    OrderIndex,
				    DepartmentId,
				    UserName,
				    RowNumber
				)
				SELECT dw.WorkplaceId,row_number() OVER(ORDER BY dw.WorkplaceId),dw.WorkplaceDepartmentId, NULL, row_number() OVER(ORDER BY dw.WorkplaceId) 
				FROM dbo.DC_WORKPLACE dw 
				WHERE dw.WorkplaceDepartmentPositionId=@departmentPositionId 
						AND dw.WorkplaceId!=@workPlaceId
				ORDER BY dw.WorkplaceUserId desc
			END;

			SELECT @chiefWorkPlaceId=dw.WorkplaceId,
				   @chiefDepartmentId=dw.WorkplaceDepartmentId
			FROM dbo.DC_DEPARTMENT_POSITION ddp 
				INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
				INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
				INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
			WHERE ddp.DepartmentId=@departmentId 
				and ddp.PositionGroupId IN (17)
				--AND ddp.PositionGroupId IN ((CASE WHEN (@positionGroupId=17 AND @organizationTopId IS NOT NULL) OR @positionGroupId IN (5) THEN 5 
				--								  WHEN @positionGroupId=6 THEN 7 
				--								  ELSE 17 end),38)
				AND du.UserStatus=1
				AND dw.WorkPlaceStatus=1
				AND dp.PersonnelStatus=1

			IF(@chiefWorkPlaceId IS NULL) -- EGER SHOBE MUDIRI YOXDURSA QURUM REHBERINI VIZAYA ELAVE EDIRIK
			BEGIN
				SELECT @chiefWorkPlaceId=dw.WorkplaceId,
					   @chiefDepartmentId=dw.WorkplaceDepartmentId
				FROM dbo.DC_DEPARTMENT dd 
					INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dd.DepartmentTopId = ddp.DepartmentId
					INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
					INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
					INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
				WHERE dd.DepartmentId=@departmentTopId
					AND ddp.PositionGroupId=5
					AND dw.WorkPlaceStatus=1
					AND du.UserStatus=1
					AND dp.PersonnelStatus=1
			END;

			IF(@chiefWorkPlaceId IS NOT NULL)
			BEGIN

					INSERT INTO @Chief
					(
						WorkPlaceId,
						OrderIndex,
						DepartmentId,
						UserName,
						RowNumber
					)
					VALUES
					(
						@chiefWorkPlaceId, -- WorkPlaceId - INT
						ISNULL((SELECT max(OrderIndex) FROM @chief)+1,1),
						@chiefDepartmentId, -- DepartmentId - INT
						[dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
						ISNULL((SELECT Count(RowNumber) FROM @chief)+1,1) -- RowNumber - INT
					);
			END;			
			
			SELECT @chiefWorkPlaceId=dw.WorkplaceId, -- departament mudiri ucun(BTRB)
				   @chiefDepartmentId=dw.WorkplaceDepartmentId
			FROM dbo.DC_DEPARTMENT_POSITION ddp 
				INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
				INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
				INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
			WHERE ddp.DepartmentId=@departmentTopId 
				AND ddp.PositionGroupId IN (13)
				AND du.UserStatus=1
				AND dw.WorkPlaceStatus=1
				AND dp.PersonnelStatus=1

			IF(@chiefWorkPlaceId IS NOT NULL)
			BEGIN

					INSERT INTO @Chief
					(
						WorkPlaceId,
						OrderIndex,
						DepartmentId,
						UserName,
						RowNumber
					)
					VALUES
					(
						@chiefWorkPlaceId, -- WorkPlaceId - INT
						ISNULL((SELECT max(OrderIndex) FROM @chief)+1,1),
						@chiefDepartmentId, -- DepartmentId - INT
						[dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
						ISNULL((SELECT Count(RowNumber) FROM @chief)+1,1) -- RowNumber - INT
					);
			END;

			IF(@signerPositionGroupId IN (1,2,33) AND @organizationTopId IS NOT NULL) --  EGER IMZA EDEN WEXS NAZIR VE YA MUAVINLERIDIRSE QURUM REHBERI DE VIZAYA ELAVE OLUNUR
			BEGIN
				
				SELECT @chiefWorkPlaceId=dw.WorkplaceId,
					   @chiefDepartmentId=dw.WorkplaceDepartmentId
				FROM dbo.DC_DEPARTMENT dd 
					INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dd.DepartmentTopId = ddp.DepartmentId
					INNER JOIN dbo.DC_WORKPLACE dw ON ddp.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
					INNER JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
					INNER JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
				WHERE dd.DepartmentId=@departmentId
					AND dw.WorkPlaceStatus=1
					AND ddp.PositionGroupId=5
					AND du.UserStatus=1
					AND dp.PersonnelStatus=1

				IF(@chiefWorkPlaceId IS NOT NULL AND @chiefWorkPlaceId NOT IN (SELECT c.WorkPlaceId FROM @Chief c))
				BEGIN

					INSERT INTO @Chief
					(
						WorkPlaceId,
						OrderIndex,
						DepartmentId,
						UserName,
						RowNumber
					)
					VALUES
					(
						@chiefWorkPlaceId, -- WorkPlaceId - INT
						ISNULL((SELECT max(OrderIndex) FROM @chief)+1,1),
						@chiefDepartmentId, -- DepartmentId - INT
						[dbo].[fnGetPersonnelbyWorkPlaceId](@chiefWorkPlaceId,106), -- UserName - nvarchar
						ISNULL((SELECT Count(RowNumber) FROM @chief)+1,1) -- RowNumber - INT
					);
				END;	
			END;	
		END
		ELSE
			BEGIN
				INSERT INTO @Chief
				(
				    WorkPlaceId,
					OrderIndex,
				    DepartmentId,
				    UserName,
				    RowNumber
				)
				VALUES
				(
				    @workPlaceId, -- WorkPlaceId - INT
					(SELECT OrderIndex FROM @chief)+1,
				    @departmentId, -- DepartmentId - INT
				    [dbo].[fnGetPersonnelbyWorkPlaceId](@workPlaceId,106), -- UserName - nvarchar
				    (SELECT rownumber FROM @chief)+1 -- RowNumber - INT
				);
			END
	
	          DECLARE @chiefCount INT,
					  @vizaSenderWorkPlaceId INT = @workPlaceId,
					  @count INT=0,
					  @orderIndex INT;
	
	          SELECT @chiefCount=count(0) FROM @Chief;

	          WHILE(@chiefCount>0)
	          BEGIN          
	            SET @count+=1;            
	
	            SELECT @chiefWorkPlaceId = WorkPlaceId, 
					   @orderIndex = OrderIndex
				FROM @Chief 
				WHERE RowNumber=@count;
				
	            DECLARE @oldChief INT,
						@chiefPositionGroupId INT;
	            
	    --        IF @chiefCount>1
	    --        BEGIN
					--SET  @oldChief = @chiefWorkPlaceId;              
	    --        END

				IF @count=1 AND @chiefCount>1 AND @positionGroupId NOT IN (32)
	            BEGIN
					SET  @oldChief = @chiefWorkPlaceId;              
	            END
	
			    SELECT @chiefPositionGroupId=dpg.PositionGroupId FROM dbo.DC_WORKPLACE dw  
				 	INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId 
				 	INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
			    WHERE dw.WorkplaceId = @chiefWorkPlaceId 
	
				SET @signerWorkPlaceId = CASE WHEN @signerWorkPlaceId IS NULL THEN 0 ELSE @signerWorkPlaceId END;
				
				IF	@positionGroupId IN (32)
				BEGIN
					            
					EXEC dbo.spVizaAdd
					@isDeleted=0, 
					@vizaDocId = @vizaDocId, 
					@vizaFileId=@fileId, 
					@vizaConfirmed=0, 
					@vizaOrderIndex=@orderIndex, 
					@vizaSendDate=NULL, 
					@vizaWorkPlaceId=@chiefWorkPlaceId, --55
					@vizaAgreementTypeId=1, 
					@vizaSenderWorkPlaceId=@vizaSenderWorkPlaceId, --51
					@vizaFromWorkFlow=1,
					@result = @result out;
				END
	            ELSE IF(@chiefWorkPlaceId <> @workPlaceId AND @positionGroupId NOT IN (17) AND @chiefPositionGroupId NOT IN (5) )--AND @signerWorkPlaceId <> @chiefWorkPlaceId -- iscinin razilasma sxemi
	            BEGIN
	
					IF @count>1
					BEGIN 
					  SET @vizaSenderWorkPlaceId = @oldChief;
					END;
					        
					EXEC dbo.spVizaAdd
					@isDeleted=0, 
					@vizaDocId = @vizaDocId, 
					@vizaFileId=@fileId, 
					@vizaConfirmed=0, 
					@vizaOrderIndex=@orderIndex, 
					@vizaSendDate=NULL, 
					@vizaWorkPlaceId=@chiefWorkPlaceId, --55
					@vizaAgreementTypeId=1, 
					@vizaSenderWorkPlaceId=@vizaSenderWorkPlaceId, --51
					@vizaFromWorkFlow=1,
					@result = @result out;
	            END
				ELSE IF(@chiefWorkPlaceId = @workPlaceId AND @positionGroupId IN (17)) --AND @workPlaceId<>@signerWorkPlaceId  -- sohbe mudurunun razilasma sxemi
				BEGIN
					IF @count>1
					BEGIN 
					    SET @vizaSenderWorkPlaceId = @oldChief;
					END;
					            
					EXEC dbo.spVizaAdd
					@isDeleted=0, 
					@vizaDocId = @vizaDocId, 
					@vizaFileId=@fileId, 
					@vizaConfirmed=0, 
					@vizaOrderIndex=@orderIndex, 
					@vizaSendDate=NULL, 
					@vizaWorkPlaceId=@chiefWorkPlaceId, --55
					@vizaAgreementTypeId=1, 
					@vizaSenderWorkPlaceId=@vizaSenderWorkPlaceId, --51
					@vizaFromWorkFlow=1,
					@result = @result out;
				 END
				 ELSE IF(@chiefWorkPlaceId = @workPlaceId AND @workPlaceId!=@signerWorkPlaceId and @positionGroupId IN (5)) -- elaqli-xidmeti sened ucun. qurum rehberini vizaya elave edir
				 BEGIN
					EXEC dbo.spVizaAdd
					@isDeleted=0, 
					@vizaDocId = @vizaDocId, 
					@vizaFileId=@fileId, 
					@vizaConfirmed=0, 
					@vizaOrderIndex=@orderIndex, 
					@vizaSendDate=NULL, 
					@vizaWorkPlaceId=@workPlaceId, --55
					@vizaAgreementTypeId=1, 
					@vizaSenderWorkPlaceId=@workPlaceId, --51
					@vizaFROMWorkFlow=1,
					@result = @result out;
				 END
				 ELSE IF(@chiefWorkPlaceId = @workPlaceId AND @signerWorkPlaceId<>@chiefWorkPlaceId)
				 BEGIN
					EXEC dbo.spVizaAdd
					  @isDeleted=0, 
					  @vizaDocId = @vizaDocId, 
					  @vizaFileId=@fileId, 
					  @vizaConfirmed=0, 
					  @vizaOrderIndex=@orderIndex, 
					  @vizaSendDate=NULL, 
					  @vizaWorkPlaceId=@workPlaceId, --55
					  @vizaAgreementTypeId=1, 
					  @vizaSenderWorkPlaceId=@workPlaceId, --51
					  @vizaFROMWorkFlow=1,
					  @result = @result out;
				 END
				 ELSE
				 BEGIN
					IF @count>1
					BEGIN 
					  SET @vizaSenderWorkPlaceId = @oldChief;
					END;
					        
					EXEC dbo.spVizaAdd
					@isDeleted=0, 
					@vizaDocId = @vizaDocId, 
					@vizaFileId=@fileId, 
					@vizaConfirmed=0, 
					@vizaOrderIndex=@orderIndex, 
					@vizaSendDate=NULL, 
					@vizaWorkPlaceId=@chiefWorkPlaceId, --55
					@vizaAgreementTypeId=1, 
					@vizaSenderWorkPlaceId=@vizaSenderWorkPlaceId, --51
					@vizaFromWorkFlow=1,
					@result = @result out;
				 END;
	
				 SET @chiefCount-=1;
	
	          END;
	      END;
	      
	      SET @result = 1;
END TRY
BEGIN CATCH
	INSERT INTO dbo.debugTable
	(
	    --id - column value is auto-generated
	    [text],
	    insertDate
	)
	VALUES
	(
	    -- id - INT
	    ERROR_MESSAGE(), -- text - nvarchar
	    dbo.sysdatetime() -- insertDate - datetime
	)	

END CATCH
