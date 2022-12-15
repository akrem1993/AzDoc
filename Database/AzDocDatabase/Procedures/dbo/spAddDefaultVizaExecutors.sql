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
-- Create date: 24.06.2019
-- Description: <Cavab senedi hazirlayan zaman razilasma sxemine cixacaq sexsleri teyin edir>
-- =============================================
CREATE   PROCEDURE [dbo].[spAddDefaultVizaExecutors] @fileId      INT, 
													 @answerDocId INT = NULL, 
													 @signerWorkPlaceId int = NULL,
													 @vizaDocId   INT, 
													 @workPlaceId INT, 
													 @result      INT OUT
AS
    BEGIN
  BEGIN TRY
     DECLARE @chiefWorkPlaceId INT,  -- cavab senedi hazirlayan wexsin shobe mudurunun(eger varsa) WorkPlaceId-si
       @currentDepartmentId INT, -- cavab senedi hazirlayan wexsin departmentId-si
       @senderDirectionId int, -- senedi shobe mudirine gonderen wexsin DirectionId-si
       @senderWorkPlaceId int,
       @maxOrderIndex int,
       @headWorkPlaceId int, -- senedi shobe mudirine gonderen wexsin WorkPlaceId-si
       @headPositionGroupId int,
       @execCount int=0,
       @orderIndex int,
       @vizaWorkPlaceId int,
       @dateTime datetime = dbo.sysdatetime(), 
       @vizaConfirmed int,
       @vizaSenderWorkPlaceId int,
       @positionGroupId int,
	   @existsAnswerDoc int,
	   @headSenderDirectionId int, -- senedi derkenarla icra ucun gonderen wexs(nazir muavini, nazir ve.s)
	   @vizaCount int  = 0,
	   @organizationTopId int,
	   @vizaFromWorkFlow int;

	    --ExecutorMain = 1 -- İcra üçün 
		--ExecutorMain = 2 -- İcra və Məlumat üçün
		--ExecutorMain = 3 -- Məlumat üçün
		--ExecutorMain = 4 -- Məlumat və nəzarət üçün 

		--SendStatus = 1	--İcra üçün
		--SendStatus = 2	--İcra və Məlumat üçün
		--SendStatus = 3	--Məlumat üçün
		--SendStatus = 4	--Məlumat və nəzarət üçün
		--SendStatus = 5	--Dərkənar layihəsinin təsdiqi üçün

     DECLARE @otherExecutors TABLE(WorkPlaceId int null, 
									OrderIndex int  null, 
									VizaConfirmed int, 
									VizaSenderWorkPlaceId int,
									VizaFromWorkFlow int null);  -- diger musterek icracilar ucun

     SELECT @chiefWorkPlaceId =[dbo].[fnGetDepartmentChief](@workPlaceId); -- hal hazirda cavab senedi hazirlayan wexsin sobe muduru
     
     DECLARE @OldVizas table(VizaWorkPlaceId int, OrderIndex int, VizaFromWorkFlow int);
     DECLARE @oldVizaCount int = 0;

     SELECT @positionGroupId=dpg.PositionGroupId,
			@organizationTopId=do.OrganizationTopId
	 FROM dbo.DC_WORKPLACE dw 
	   INNER JOIN dbo.DC_ORGANIZATION do ON dw.WorkplaceOrganizationId = do.OrganizationId
       INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
       INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
     WHERE dw.WorkplaceId=@workPlaceId

	 SELECT top(1) @existsAnswerDoc=dr.RelatedDocumentId  -- eger cavab senedi varsa 
	 FROM dbo.DOCS_RELATED dr 
	 WHERE dr.RelatedTypeId = 2 
			AND dr.RelatedDocId=@vizaDocId
	 
	 

     IF((@workPlaceId <> @chiefWorkPlaceId OR @workPlaceId = @chiefWorkPlaceId) AND @positionGroupId IN (26)) -- eger sektor mudiri cavab senedi hazirlayirsa 
     BEGIN

      SELECT @senderWorkPlaceId=dd.DirectionWorkplaceId,
			 @senderDirectionId=de.ExecutorDirectionId--senedi bize icra ucun gonderen wexsin WorkPlaceId-si
      FROM dbo.DOCS_EXECUTOR de 
      INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
      WHERE de.ExecutorDocId=@answerDocId 
         AND de.DirectionTypeId=1
         AND de.ExecutorWorkplaceId=@workPlaceId      
         AND de.ExecutorMain = 1 
         AND de.SendStatusId=1
         
      SELECT @senderDirectionId=de.ExecutorDirectionId -- nazir ve ya nazir muavininin directionId-si
      FROM dbo.DOCS_EXECUTOR de 
      WHERE de.ExecutorDocId=@answerDocId 
         AND de.DirectionTypeId=1 
         AND de.ExecutorReadStatus=1 
         AND de.ExecutorMain=1 
         AND de.SendStatusId=1 
         AND de.ExecutorWorkplaceId=@senderWorkPlaceId


      INSERT INTO @OldVizas -- senedin kohne vizalarina baxiriq
         SELECT dv.VizaWorkPlaceId, dv.VizaOrderindex, dv.VizaFromWorkflow 
         FROM dbo.DOCS_VIZA dv 
         WHERE dv.VizaDocId=@vizaDocId 
            AND dv.VizaFromWorkflow=1;

      SELECT @oldVizaCount = count(0) FROM @OldVizas ov;

      IF(@oldVizaCount>0)-- eger kohne vizasi varsa yeni vizalari novbeti orderIndex-lere elave edirik
      BEGIN
       SELECT @maxOrderIndex=max(ov.OrderIndex) FROM @OldVizas ov;
      END;
      
       
      INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex,VizaConfirmed,VizaSenderWorkPlaceId) --senedi bize icra ucun gonderen wexsin musterek icracilari
         SELECT de.ExecutorWorkplaceId, (@maxOrderIndex + 1), 0, @senderWorkPlaceId
         FROM dbo.DOCS_EXECUTOR de 
         WHERE de.ExecutorDirectionId = @senderDirectionId
            AND de.DirectionTypeId=1 
            AND de.ExecutorWorkplaceId!=@senderWorkPlaceId
            AND de.SendStatusId=2
			AND de.ExecutorWorkplaceId NOT IN (SELECT dv.VizaWorkPlaceId -- n sayda senedi 1 cavab senedi ile baglayanda 
											   FROM dbo.DOCS_VIZA dv 
											   WHERE dv.VizaDocId=@vizaDocId 
													AND dv.VizaFromWorkflow in (1,4)
											   		AND dv.IsDeleted=0
											   		AND dv.VizaConfirmed=0)

      SELECT @execCount=count(0) FROM @otherExecutors;
   
      WHILE(@execCount>0)
      BEGIN
	  
       SELECT @orderIndex=o.OrderIndex, 
         @vizaWorkPlaceId = o.WorkPlaceId ,
         @vizaConfirmed = o.VizaConfirmed, 
         @vizaSenderWorkPlaceId = o.VizaSenderWorkPlaceId
       FROM 
         (SELECT oe.OrderIndex,
           oe.WorkPlaceId , 
           oe.VizaConfirmed, 
           oe.VizaSenderWorkPlaceId, 
           row_number() OVER (ORDER BY oe.OrderIndex) AS r from @otherExecutors oe) AS o
       WHERE o.r = @execCount;

       INSERT INTO dbo.DOCS_VIZA
       (
           --VizaId - column value is auto-generated
           VizaDocId,
		   VizaFileId,
           VizaWorkPlaceId,
		   VizaReplyDate,
           VizaOrderindex,
           VizaSenderWorkPlaceId,
		   VizaSenddate,
           VizaConfirmed,
		   IsDeleted,
           VizaAgreementTypeId,
		   VizaFromWorkflow,
		   VizaAnswerDocId,
		   VizaPersonnelId
       )
       VALUES
       (
           -- VizaId - int
           @vizaDocId, -- VizaDocId - int
           @fileId, -- VizaFileId - int
           @vizaWorkPlaceId, -- VizaWorkPlaceId - int
           NULL, -- VizaReplyDate - datetime
           @orderIndex, -- VizaOrderindex - int
           @vizaSenderWorkPlaceId, -- VizaSenderWorkPlaceId - int
           NULL, -- VizaSenddate - datetime
           @vizaConfirmed, -- VizaConfirmed - tinyint
           0, -- IsDeleted - bit
           1, -- VizaAgreementTypeId - int
           4, -- VizaFromWorkflow - int
		   @answerDocId,
		   0
       )

       set @execCount=@execCount-1;

      END;
	  SET @result=1;
	  RETURN @result;
     END;

     IF(@workPlaceId = @chiefWorkPlaceId AND @positionGroupId NOT IN (17,22,21))--eger cavab senedi hazirlayan wexsin sobe muduru yoxdursa(hazirlayan wexs shobe mudiri deyilse)
     BEGIN      
      
      SELECT @senderWorkPlaceId=dd.DirectionWorkplaceId, @senderDirectionId	=dd.DirectionId  -- senedi icra ucun gonderen wexsin workplace-si
      FROM dbo.DOCS_EXECUTOR de 
	      INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
      WHERE de.ExecutorDocId = @answerDocId 
             AND de.ExecutorMain=1 
             AND de.DirectionTypeId=1
             AND de.SendStatusId = 1 
             AND de.ExecutorWorkplaceId  = @workPlaceId
             AND de.ExecutorReadStatus = CASE 
											 WHEN @existsAnswerDoc IS NOT NULL THEN 1 
											 ELSE 0 END; -- eger bu senede evvelceden cavab senedi baglanibsa demeli senede sonradan cavab senedi elave olunub

      SELECT @vizaCount = count(dv.VizaId) -- eger senedi icra ucun gonderen wexs evvelceden vizaya elave olunmuyubsa
      FROM dbo.DOCS_VIZA dv 
      WHERE dv.VizaDocId = @vizaDocId 
         AND dv.VizaWorkPlaceId = @senderWorkPlaceId 
         AND dv.VizaConfirmed = 0
		 AND dv.IsDeleted=0;

      SELECT @execCount = count(0) -- senedi icra ve melumat ucun gondeerilenlerin sayi
      FROM dbo.DOCS_EXECUTOR de 
      WHERE de.ExecutorDocId = @answerDocId 
         AND de.ExecutorDirectionId in (SELECT dd.DirectionId FROM dbo.DOCS_DIRECTIONS dd 
										WHERE 
										dd.DirectionWorkplaceId=@senderWorkPlaceId	 
										AND dd.DirectionDocId=@answerDocId	 
										AND dd.DirectionConfirmed=1 
										AND dd.DirectionSendStatus=1
										AND dd.DirectionTypeId=1)
         AND de.DirectionTypeId=1
		 --AND de.ExecutorMain=2
         AND de.SendStatusId=2;

      IF (@vizaCount = 0)
      BEGIN
       IF(@execCount > 0)-- eger senedi gonderenin musterek icracilari varsa ve ozu evvelceden vizaya elava edilmeyibse elave edirik
       BEGIN
        INSERT INTO @otherExecutors -- cavab hazirlayan wexsi 1 index nomresiyle elave edirik
        (
			WorkPlaceId,
			OrderIndex,
			VizaConfirmed,
			VizaSenderWorkPlaceId
        )
        VALUES
        (
			@workPlaceId, -- WorkPlaceId - int
			1, -- OrderIndex - int,
			1,
			@workPlaceId
        );
       END
      END;

      IF (@execCount > 0)
      BEGIN
       INSERT INTO @otherExecutors(WorkPlaceId, OrderIndex,VizaConfirmed, VizaSenderWorkPlaceId)-- diger musterek icracilari 2 indeks nomresiyle elave edirik
            SELECT de.ExecutorWorkplaceId, 2, 0, @workPlaceId
            FROM dbo.DOCS_EXECUTOR de 
            WHERE de.ExecutorDocId = @answerDocId 
               AND de.ExecutorDirectionId IN (SELECT dd.DirectionId FROM dbo.DOCS_DIRECTIONS dd 
											  WHERE 
											  dd.DirectionWorkplaceId=@senderWorkPlaceId	 
											  AND dd.DirectionDocId=@answerDocId	 
											  AND dd.DirectionConfirmed=1 
											  AND dd.DirectionSendStatus=1
											  AND dd.DirectionTypeId=1)
				AND de.DirectionTypeId=1
				--AND de.ExecutorMain=2
				AND de.SendStatusId=2
				AND de.ExecutorWorkplaceId NOT IN (SELECT dv.VizaWorkPlaceId -- n sayda senedi 1 cavab senedi ile baglayanda 
												   FROM dbo.DOCS_VIZA dv 
												   WHERE dv.VizaDocId=@vizaDocId 
														AND dv.VizaFromWorkflow in (1,4)
												   		AND dv.IsDeleted=0
												   		AND dv.VizaConfirmed=0)
      END;      
	  
      --SELECT @senderWorkPlaceId=dd.DirectionWorkplaceId -- senedi sohbe mudurune gonderen wexs(qurum rehberi tapilir)
      --FROM dbo.DOCS_DIRECTIONS dd 
      --WHERE dd.DirectionDocId = @answerDocId 
      --        AND dd.DirectionId = @senderDirectionId
      --        AND dd.DirectionTypeId = 1;
      
      --SELECT @headPositionGroupLevel = dpg.PositionGroupLevel--eger qurum rehberi senede ozu cavab senedi hazirlayirsa vizalarda nazir ve nazir muavinleri cixmamalidir
      --FROM dbo.DC_WORKPLACE dw
      --  INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
      --  INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
      --WHERE dw.WorkplaceId = @senderWorkPlaceId;
      
      --SELECT @maxOrderIndex=max(oe.OrderIndex) FROM @otherExecutors oe;

      --SELECT @maxOrderIndex = CASE 
      --       WHEN @maxOrderIndex IS NULL THEN (SELECT max(dv.VizaOrderindex) FROM dbo.DOCS_VIZA dv WHERE dv.VizaDocId=@vizaDocId)
      --       ELSE @maxOrderIndex
      --      END;
                     
      --IF(@headPositionGroupLevel NOT IN (1,2)) -- eger senedi icra ucun gonderen nazir ve ya nazir muavini deyilse
      --BEGIN
      -- if(@senderWorkPlaceId<>@signerWorkPlaceId) -- eger senedi icra ucun gonderen wexs imza eden wexs deyilse
      -- begin
      --  INSERT INTO @otherExecutors(WorkPlaceId, OrderIndex, VizaConfirmed, VizaSenderWorkPlaceId) -- qurum rehberi 3 index nomresiyle cedvele elave olunur
      --  VALUES(@senderWorkPlaceId, (@maxOrderIndex + 1), 0, @workPlaceId)  
      -- end;            
      --END;

      --DECLARE @headSenderDirectionId int; -- senedi derkenarla icra ucun gonderen wexs(nazir muavini, nazir ve.s)

      --SELECT @headSenderDirectionId = de.ExecutorDirectionId 
      --FROM dbo.DOCS_EXECUTOR de 
      --WHERE  de.ExecutorDocId = @answerDocId 
      --       AND de.ExecutorMain=1 
      --       AND de.DirectionTypeId=1
      --       AND de.SendStatusId = 1 
      --       AND de.ExecutorWorkplaceId = @senderWorkPlaceId;

      --SELECT @maxOrderIndex=max(oe.OrderIndex) FROM @otherExecutors oe

      
      --INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex, VizaConfirmed, VizaSenderWorkPlaceId)
      --SELECT de.ExecutorWorkplaceId, (@maxOrderIndex+1), 0, @senderWorkPlaceId
      --    FROM dbo.DOCS_EXECUTOR de 
      --    WHERE de.ExecutorDocId = @answerDocId 
      --           AND de.ExecutorDirectionId = @headSenderDirectionId 
      --           AND de.ExecutorWorkplaceId!=@senderWorkPlaceId
      --           AND de.DirectionTypeId = 1;

      SELECT @execCount=count(0) FROM @otherExecutors;
         
      WHILE(@execCount>0)
      BEGIN

       SELECT @orderIndex=o.OrderIndex, 
         @vizaWorkPlaceId = o.WorkPlaceId ,
         @vizaConfirmed = o.VizaConfirmed, 
         @vizaSenderWorkPlaceId = o.VizaSenderWorkPlaceId
       FROM 
         (SELECT oe.OrderIndex,
           oe.WorkPlaceId , 
           oe.VizaConfirmed, 
           oe.VizaSenderWorkPlaceId, 
           row_number() OVER (ORDER BY oe.OrderIndex) AS r from @otherExecutors oe) AS o
       WHERE o.r = @execCount;

       INSERT INTO dbo.DOCS_VIZA
       (
           --VizaId - column value is auto-generated
           VizaDocId,VizaFileId,
           VizaWorkPlaceId,
		   VizaReplyDate,
           VizaOrderindex,
           VizaSenderWorkPlaceId,
		   VizaSenddate,
           VizaConfirmed,
		   IsDeleted,
           VizaAgreementTypeId,
		   VizaFromWorkflow,
		   VizaPersonnelId,
		   VizaAnswerDocId
       )
       VALUES
       (
           -- VizaId - int
           @vizaDocId, -- VizaDocId - int
           @fileId, -- VizaFileId - int
           @vizaWorkPlaceId, -- VizaWorkPlaceId - int
           NULL, -- VizaReplyDate - datetime
           @orderIndex, -- VizaOrderindex - int
           @vizaSenderWorkPlaceId, -- VizaSenderWorkPlaceId - int
           NULL, -- VizaSenddate - datetime
           @vizaConfirmed, -- VizaConfirmed - tinyint
           0, -- IsDeleted - bit
           1, -- VizaAgreementTypeId - int
           4, -- VizaFromWorkflow - int,
		   0,
		   @answerDocId
       )

       set @execCount=@execCount-1;

      END;
	  SET @result=1;

	  RETURN @result;
     END;

	 IF(@workPlaceId = @chiefWorkPlaceId AND @positionGroupId IN (17))--eger cavab senedi hazirlayan wexsin sobe muduru yoxdursa(hazirlayan wexs shobe mudiri olarsa)
     BEGIN      
      
      SELECT @senderWorkPlaceId=dd.DirectionWorkplaceId, @senderDirectionId	=dd.DirectionId  -- senedi icra ucun gonderen wexsin workplace-si
      FROM dbo.DOCS_EXECUTOR de 
	      INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
      WHERE de.ExecutorDocId = @answerDocId 
             AND de.ExecutorMain=1 
             AND de.DirectionTypeId=1
             AND de.SendStatusId = 1 
             AND de.ExecutorWorkplaceId  = @workPlaceId
             AND de.ExecutorReadStatus = CASE 
											 WHEN @existsAnswerDoc IS NOT NULL THEN 1 
											 ELSE 0 END; -- eger bu senede evvelceden cavab senedi baglanibsa demeli senede sonradan cavab senedi elave olunub


      SELECT @vizaCount = count(dv.VizaId) -- eger senedi icra ucun gonderen wexs evvelceden vizaya elave olunmuyubsa
      FROM dbo.DOCS_VIZA dv 
      WHERE dv.VizaDocId = @vizaDocId 
         AND dv.VizaWorkPlaceId = CASE WHEN @organizationTopId IS NULL then @workPlaceId ELSE @senderWorkPlaceId end 
         AND dv.VizaConfirmed = 0
		 AND dv.VizaFromWorkflow=1
		 AND dv.IsDeleted=0;

      SELECT @execCount = count(0) -- senedi icra ve melumat ucun gondeerilenlerin sayi
      FROM dbo.DOCS_EXECUTOR de 
      WHERE de.ExecutorDocId = @answerDocId 
         AND de.ExecutorDirectionId in (SELECT dd.DirectionId FROM dbo.DOCS_DIRECTIONS dd 
										WHERE 
										dd.DirectionWorkplaceId=@senderWorkPlaceId	 
										AND dd.DirectionDocId=@answerDocId	 
										AND dd.DirectionConfirmed=1 
										AND dd.DirectionSendStatus=1
										AND dd.DirectionTypeId=1)
         AND de.DirectionTypeId=1
		 AND de.ExecutorWorkplaceId!=@workPlaceId --eger sened hazirlayan wexse sened hemde icra ve melumat ucun gelibse
		 --AND de.ExecutorMain=2
         AND de.SendStatusId=2;

      IF (@vizaCount = 0)
      BEGIN
       IF(@execCount > 0)-- eger senedi gonderenin musterek icracilari varsa ve ozu evvelceden vizaya elava edilmeyibse elave edirik
       BEGIN
        INSERT INTO @otherExecutors -- cavab hazirlayan wexsi 1 index nomresiyle elave edirik
        (
			WorkPlaceId,
			OrderIndex,
			VizaConfirmed,
			VizaSenderWorkPlaceId,
			VizaFromWorkFlow
        )
        VALUES
        (
			CASE WHEN @organizationTopId IS NULL then @workPlaceId ELSE @senderWorkPlaceId end , -- WorkPlaceId - int
			1, -- OrderIndex - int,
			1,
			@workPlaceId,
			1
        );
       END
      END;

      IF (@execCount > 0)
      BEGIN
       INSERT INTO @otherExecutors(WorkPlaceId, OrderIndex,VizaConfirmed, VizaSenderWorkPlaceId)-- diger musterek icracilari 2 indeks nomresiyle elave edirik
            SELECT de.ExecutorWorkplaceId, 2, 0, @workPlaceId
            FROM dbo.DOCS_EXECUTOR de 
            WHERE de.ExecutorDocId = @answerDocId 
               AND de.ExecutorDirectionId IN (SELECT dd.DirectionId FROM dbo.DOCS_DIRECTIONS dd 
											  WHERE 
											  dd.DirectionWorkplaceId=@senderWorkPlaceId	 
											  AND dd.DirectionDocId=@answerDocId	 
											  AND dd.DirectionConfirmed=1 
											  AND dd.DirectionSendStatus=1
											  AND dd.DirectionTypeId=1)
				AND de.DirectionTypeId=1
				--AND de.ExecutorMain=2
				AND de.SendStatusId=2
				AND de.ExecutorWorkplaceId!=@workPlaceId
				AND de.ExecutorWorkplaceId NOT IN (SELECT dv.VizaWorkPlaceId -- n sayda senedi 1 cavab senedi ile baglayanda 
												   FROM dbo.DOCS_VIZA dv 
												   WHERE dv.VizaDocId=@vizaDocId 
														AND dv.VizaFromWorkflow in (1,4)
												   		AND dv.IsDeleted=0
												   		AND dv.VizaConfirmed=0)
      END;      
	  
      --SELECT @senderWorkPlaceId=dd.DirectionWorkplaceId -- senedi sohbe mudurune gonderen wexs(qurum rehberi tapilir)
      --FROM dbo.DOCS_DIRECTIONS dd 
      --WHERE dd.DirectionDocId = @answerDocId 
      --        AND dd.DirectionId = @senderDirectionId
      --        AND dd.DirectionTypeId = 1;
      
      SELECT @headPositionGroupId = dpg.PositionGroupId--eger qurum rehberi senede ozu cavab senedi hazirlayirsa vizalarda nazir ve nazir muavinleri cixmamalidir
      FROM dbo.DC_WORKPLACE dw
        INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
        INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
      WHERE dw.WorkplaceId = @senderWorkPlaceId;
      
      SELECT @maxOrderIndex=max(oe.OrderIndex) FROM @otherExecutors oe;

      SELECT @maxOrderIndex = CASE 
             WHEN @maxOrderIndex IS NULL THEN (SELECT max(dv.VizaOrderindex) FROM dbo.DOCS_VIZA dv WHERE dv.VizaDocId=@vizaDocId AND dv.IsDeleted=0)
             ELSE @maxOrderIndex
            END;
                     
      IF(@headPositionGroupId NOT IN (1,2,33)) -- eger senedi icra ucun gonderen nazir ve ya nazir muavini deyilse
      BEGIN
       if(@senderWorkPlaceId<>@signerWorkPlaceId) AND NOT EXISTS(SELECT dv.VizaId FROM dbo.DOCS_VIZA dv WHERE dv.VizaWorkPlaceId=@senderWorkPlaceId AND dv.IsDeleted=0) -- eger senedi icra ucun gonderen wexs imza eden wexs deyilse
       begin
        INSERT INTO @otherExecutors(WorkPlaceId, OrderIndex, VizaConfirmed, VizaSenderWorkPlaceId) -- qurum rehberi 3 index nomresiyle cedvele elave olunur
        VALUES(@senderWorkPlaceId, (@maxOrderIndex + 1), 0, @workPlaceId)  
       end;            
      END;

      --DECLARE @headSenderDirectionId int; -- senedi derkenarla icra ucun gonderen wexs(nazir muavini, nazir ve.s)

      SELECT @headSenderDirectionId = de.ExecutorDirectionId 
      FROM dbo.DOCS_EXECUTOR de 
      WHERE  de.ExecutorDocId = @answerDocId 
             AND de.ExecutorMain=1 
             AND de.DirectionTypeId=1
             AND de.SendStatusId = 1 
             AND de.ExecutorWorkplaceId = @senderWorkPlaceId;

      SELECT @maxOrderIndex=max(oe.OrderIndex) FROM @otherExecutors oe

	  IF @maxOrderIndex IS NULL
	  BEGIN
		SELECT @maxOrderIndex=max(dv.VizaOrderindex) FROM dbo.DOCS_VIZA dv WHERE dv.VizaFromWorkflow=1 AND dv.VizaDocId=@vizaDocId AND dv.IsDeleted=0;
	  END
      
      INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex, VizaConfirmed, VizaSenderWorkPlaceId)
      SELECT de.ExecutorWorkplaceId, CASE WHEN @maxOrderIndex IS NULL THEN 1 else (@maxOrderIndex +1) end, 0, @senderWorkPlaceId
          FROM dbo.DOCS_EXECUTOR de 
          WHERE de.ExecutorDocId = @answerDocId 
                 AND de.ExecutorDirectionId = @headSenderDirectionId 
				 AND de.SendStatusId=2
                 AND de.DirectionTypeId = 1
				 AND de.ExecutorWorkplaceId!=@senderWorkPlaceId
				 AND de.ExecutorWorkplaceId NOT IN (SELECT dv.VizaWorkPlaceId -- n sayda senedi 1 cavab senedi ile baglayanda 
								   FROM dbo.DOCS_VIZA dv 
								   WHERE dv.VizaDocId=@vizaDocId 
										AND dv.VizaFromWorkflow in (1,4)
								   		AND dv.IsDeleted=0
								   		AND dv.VizaConfirmed=0);

      SELECT @execCount=count(0) FROM @otherExecutors;
         
      WHILE(@execCount>0)
      BEGIN

       SELECT @orderIndex=o.OrderIndex, 
         @vizaWorkPlaceId = o.WorkPlaceId ,
         @vizaConfirmed = o.VizaConfirmed, 
         @vizaSenderWorkPlaceId = o.VizaSenderWorkPlaceId,
		 @vizaFromWorkFlow=o.VizaFromWorkFlow
       FROM 
         (SELECT oe.OrderIndex,
           oe.WorkPlaceId , 
           oe.VizaConfirmed, 
           oe.VizaSenderWorkPlaceId, 
		   oe.VizaFromWorkFlow,
           row_number() OVER (ORDER BY oe.OrderIndex) AS r from @otherExecutors oe) AS o
       WHERE o.r = @execCount;

       INSERT INTO dbo.DOCS_VIZA
       (
           --VizaId - column value is auto-generated
           VizaDocId,VizaFileId,
           VizaWorkPlaceId,
		   VizaReplyDate,
           VizaOrderindex,
           VizaSenderWorkPlaceId,
		   VizaSenddate,
           VizaConfirmed,
		   IsDeleted,
           VizaAgreementTypeId,
		   VizaFromWorkflow,
		   VizaPersonnelId,
		   VizaAnswerDocId
       )
       VALUES
       (
           -- VizaId - int
           @vizaDocId, -- VizaDocId - int
           @fileId, -- VizaFileId - int
           @vizaWorkPlaceId, -- VizaWorkPlaceId - int
           NULL, -- VizaReplyDate - datetime
           @orderIndex, -- VizaOrderindex - int
           @vizaSenderWorkPlaceId, -- VizaSenderWorkPlaceId - int
           NULL, -- VizaSenddate - datetime
           @vizaConfirmed, -- VizaConfirmed - tinyint
           0, -- IsDeleted - bit
           1, -- VizaAgreementTypeId - int
           ISNULL(@vizaFromWorkFlow, 4), -- VizaFromWorkflow - int,
		   0,
		   @answerDocId
       )

       set @execCount=@execCount-1;

      END;

	  SET @result=1;

	  RETURN @result;
     END;

     IF((@workPlaceId <> @chiefWorkPlaceId) AND @positionGroupId NOT IN (26, 17)) -- eger isci cavab senedi hazirlayirsa 
     BEGIN   

      SELECT @senderWorkPlaceId=dd.DirectionWorkplaceId --senedi bize icra ucun gonderen wexsin DirectionId-si
      FROM dbo.DOCS_EXECUTOR de 
      INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
      WHERE de.ExecutorDocId=@answerDocId 
         AND de.DirectionTypeId=1
         AND de.ExecutorWorkplaceId=@workPlaceId      
         AND de.ExecutorMain = 1 
         AND de.SendStatusId=1
         AND de.ExecutorReadStatus=CASE 
									WHEN @existsAnswerDoc IS NOT NULL THEN 1 
									ELSE 0 END; -- eger bu senede evvelceden cavab senedi baglanibsa demeli senede sonradan cavab senedi elave olunub

   SELECT @positionGroupId=dpg.PositionGroupId FROM dbo.DC_WORKPLACE dw  -- eger senedi bize gonderen wexs sektor muduridirse
     INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
     INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
   WHERE dw.WorkplaceId=@senderWorkPlaceId

      IF(@positionGroupId IN (26)) -- EGER SENEDI BIZE GONDEREN WEXS SEKTOR MUDURU  OLARSA
      BEGIN

       SELECT	@senderWorkPlaceId=dd.DirectionWorkplaceId -- SEKTOR MUDIRINE SENEDI GONDEREN WEXS TAPILIR
       FROM dbo.DOCS_EXECUTOR de 
	   INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
       WHERE de.ExecutorDocId=@answerDocId 
          AND de.DirectionTypeId=1 
          AND de.ExecutorReadStatus=1 
          AND de.ExecutorMain=1 
          AND de.SendStatusId=1 
          AND de.ExecutorWorkplaceId=@senderWorkPlaceId

       SELECT	@senderDirectionId=dd.DirectionId-- SENEDI SHOBE MUDIRINE SENEDI GONDEREN WEXS TAPILIR
       FROM dbo.DOCS_EXECUTOR de 
	   INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
       WHERE de.ExecutorDocId=@answerDocId 
          AND de.DirectionTypeId=1 
          AND de.ExecutorReadStatus=1 
          AND de.ExecutorMain=1 
          AND de.SendStatusId=1 
          AND de.ExecutorWorkplaceId=@senderWorkPlaceId

       INSERT INTO @OldVizas
          SELECT dv.VizaWorkPlaceId, dv.VizaOrderindex, dv.VizaFromWorkflow 
          FROM dbo.DOCS_VIZA dv 
          WHERE dv.VizaDocId=@vizaDocId 
             AND dv.VizaFromWorkflow=1;

       SELECT @oldVizaCount = count(0) FROM @OldVizas ov;
      
       IF(@oldVizaCount>0)
       BEGIN
        SELECT @maxOrderIndex=max(ov.OrderIndex) FROM @OldVizas ov;
       END;      
       
       INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex,VizaConfirmed,VizaSenderWorkPlaceId) --senedi bize icra ucun gonderen wexsin musterek icracilari
          SELECT de.ExecutorWorkplaceId, (@maxOrderIndex + 1), 0, @senderWorkPlaceId
          FROM dbo.DOCS_EXECUTOR de 
          WHERE de.ExecutorDirectionId = @senderDirectionId
             AND de.DirectionTypeId=1 
             AND de.ExecutorWorkplaceId!=@senderWorkPlaceId 
             AND de.SendStatusId=2
			 AND de.ExecutorWorkplaceId NOT IN (SELECT dv.VizaWorkPlaceId -- n sayda senedi 1 cavab senedi ile baglayanda 
											    FROM dbo.DOCS_VIZA dv 
											    WHERE dv.VizaDocId=@vizaDocId 
												 	AND dv.VizaFromWorkflow in (1,4)
											    	AND dv.IsDeleted=0
											    	AND dv.VizaConfirmed=0)

       SELECT @execCount=count(0) FROM @otherExecutors;
       
       WHILE(@execCount>0)
       BEGIN

       SELECT @orderIndex=o.OrderIndex, 
         @vizaWorkPlaceId = o.WorkPlaceId ,
         @vizaConfirmed = o.VizaConfirmed, 
         @vizaSenderWorkPlaceId = o.VizaSenderWorkPlaceId
       FROM 
         (SELECT oe.OrderIndex,
           oe.WorkPlaceId , 
           oe.VizaConfirmed, 
           oe.VizaSenderWorkPlaceId, 
           row_number() OVER (ORDER BY oe.OrderIndex) AS r from @otherExecutors oe) AS o
       WHERE o.r = @execCount;

       INSERT INTO dbo.DOCS_VIZA
       (
           --VizaId - column value is auto-generated
           VizaDocId,
		   VizaFileId,
           VizaWorkPlaceId,
		   VizaReplyDate,
           VizaOrderindex,
           VizaSenderWorkPlaceId,
		   VizaSenddate,
           VizaConfirmed,
		   IsDeleted,
           VizaAgreementTypeId,
		   VizaFromWorkflow,
			VizaAnswerDocId,
			VizaPersonnelId
       )
       VALUES
       (
           -- VizaId - int
           @vizaDocId, -- VizaDocId - int
           @fileId, -- VizaFileId - int
           @vizaWorkPlaceId, -- VizaWorkPlaceId - int
           NULL, -- VizaReplyDate - datetime
           @orderIndex, -- VizaOrderindex - int
           @vizaSenderWorkPlaceId, -- VizaSenderWorkPlaceId - int
           NULL, -- VizaSenddate - datetime
           @vizaConfirmed, -- VizaConfirmed - tinyint
           0, -- IsDeleted - bit
           1, -- VizaAgreementTypeId - int
           4, -- VizaFromWorkflow - int
		   @answerDocId,
		   0
       )

       set @execCount=@execCount-1;

       END;
	    SET @result=1;
		RETURN @result;
       END ;
        --=============================================================================================================================>
       BEGIN
   
		declare @directionTypeId int=0;
   
      SELECT @directionTypeId=dd.DirectionTypeId
      FROM dbo.DOCS_EXECUTOR de 
      INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId=dd.DirectionId
      WHERE de.ExecutorDocId=@answerDocId 
         --AND de.DirectionTypeId=1
         AND de.ExecutorWorkplaceId=@senderWorkPlaceId      --@senderWorkPlaceId
       --  AND de.ExecutorMain = 1 
         AND de.SendStatusId=1
         --AND de.ExecutorReadStatus=1
      
      if(@directionTypeId=18)
      begin
        SELECT @headWorkPlaceId=dd.DirectionWorkplaceId
         FROM dbo.DOCS_EXECUTOR de 
         INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId=dd.DirectionId
         WHERE de.ExecutorDocId=@answerDocId 
            --AND de.DirectionTypeId=1
            AND de.ExecutorWorkplaceId=@senderWorkPlaceId      --@senderWorkPlaceId
            --AND de.ExecutorMain = 1 
            AND de.SendStatusId=1
            AND de.ExecutorReadStatus=1
      end
      else
      begin
          SELECT @headWorkPlaceId=dd.DirectionWorkplaceId
           FROM dbo.DOCS_EXECUTOR de 
           INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId=dd.DirectionId
           WHERE de.ExecutorDocId=@answerDocId 
              AND de.DirectionTypeId=1
              AND de.ExecutorWorkplaceId=@senderWorkPlaceId      --@senderWorkPlaceId
              AND de.ExecutorMain = 1 
              AND de.SendStatusId=1
              AND de.ExecutorReadStatus=1
      end

	  SELECT @maxOrderIndex=max(dv.VizaOrderindex) -- eger shobe mudiri vizalarda varsa diger musterekleri 3 orderiyle atiriq
	  FROM dbo.DOCS_VIZA dv 
	  WHERE dv.VizaDocId=@vizaDocId 
			AND dv.IsDeleted=0 
			AND dv.VizaFromWorkflow=1

   INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex,VizaConfirmed,VizaSenderWorkPlaceId) -- senedi isciye gonderen sexsin(sob muduruunun) musterek icracilari
   SELECT de.ExecutorWorkplaceId, @maxOrderIndex+1, 0,@senderWorkPlaceId 
   FROM dbo.DOCS_DIRECTIONS dd 
   INNER JOIN dbo.DOCS_EXECUTOR de ON dd.DirectionId = de.ExecutorDirectionId
   WHERE dd.DirectionWorkplaceId=@headWorkPlaceId
      AND dd.DirectionDocId=@answerDocId
      AND dd.DirectionTypeId=1 
      AND dd.DirectionConfirmed=1
      AND de.SendStatusId=2
      AND de.ExecutorWorkplaceId NOT IN (SELECT dv.VizaWorkPlaceId -- n sayda senedi 1 cavab senedi ile baglayanda 
              FROM dbo.DOCS_VIZA dv 
              WHERE dv.VizaDocId=@vizaDocId 
                 AND dv.VizaFromWorkflow in (1,4)
				 AND dv.IsDeleted=0
				 AND dv.VizaConfirmed=0)

   SELECT @execCount  = count(0) FROM @otherExecutors oe;

   IF(@execCount=0)
   BEGIN
    SELECT @orderIndex=max(dv.VizaOrderindex) FROM dbo.DOCS_VIZA dv WHERE dv.VizaDocId=@vizaDocId AND dv.IsDeleted=0
   END
   ELSE
   BEGIN
    SELECT @orderIndex =max(oe.OrderIndex) FROM @otherExecutors oe
   END

   SELECT @positionGroupId=dpg.PositionGroupId FROM dbo.DC_WORKPLACE dw 
   INNER JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
   INNER JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
   WHERE dw.WorkplaceId=@headWorkPlaceId

   SELECT @headSenderDirectionId=dd.DirectionId  -- senedi qurum rehberine gonderen sexsin DirectionId-si
   FROM dbo.DOCS_EXECUTOR de 
     INNER JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
   WHERE de.ExecutorDocId = @answerDocId 
      AND de.DirectionTypeId=1 
      AND de.SendStatusId = 1
      AND de.ExecutorMain = 1
      AND de.ExecutorReadStatus=1 
      AND de.ExecutorWorkplaceId=@headWorkPlaceId

   IF (@positionGroupId NOT IN (1, 2, 33) AND @headSenderDirectionId IS NOT NULL)
   BEGIN
    IF (@signerWorkPlaceId = @headWorkPlaceId) -- eger qurum rehberi imza eden wexsdirse ve ve qurum rehberinin musterek icracilari varsa qurum rehberi vizaya elave olunur
    BEGIN

     SELECT @execCount = count(0)
     FROM dbo.DOCS_EXECUTOR de  
     WHERE de.ExecutorDirectionId=@headSenderDirectionId
        AND de.DirectionTypeId=1
        AND de.ExecutorWorkplaceId!=@headWorkPlaceId
        --AND de.ExecutorMain=0
        AND de.SendStatusId=2
        AND de.ExecutorDocId=@answerDocId

    IF(@execCount>0) -- EGER MUSTEREK ICRACILAR YOXDURSA VIZAYA ELAVE OLUNMUR QURUM  REHBERI
    BEGIN
     IF NOT EXISTS(SELECT dv.VizaId FROM dbo.DOCS_VIZA dv WHERE dv.VizaDocId=@vizaDocId AND dv.VizaFromWorkflow=4 AND dv.VizaConfirmed=0 AND dv.IsDeleted=0)-- n sayda senedi 1 cavab senedi ile baglayanda 
     begin
      INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex,VizaConfirmed,VizaSenderWorkPlaceId) -- qurum rehberi elave olunur
      VALUES(@headWorkPlaceId, (@orderIndex+1), 0, @senderWorkPlaceId);
     END
    END;
   END
   ELSE
   BEGIN
     IF NOT EXISTS(SELECT dv.VizaId FROM dbo.DOCS_VIZA dv WHERE dv.VizaDocId=@vizaDocId AND dv.VizaFromWorkflow=4 AND dv.VizaConfirmed=0)-- n sayda senedi 1 cavab senedi ile baglayanda 
	 begin
	  INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex,VizaConfirmed,VizaSenderWorkPlaceId) -- qurum rehberi elave olunur
	  VALUES(@headWorkPlaceId, (@orderIndex+1), 0, @senderWorkPlaceId);
	 END
   END;

   SELECT @orderIndex = max(oe.OrderIndex) FROM @otherExecutors oe

   INSERT INTO @otherExecutors(WorkPlaceId,OrderIndex,VizaConfirmed,VizaSenderWorkPlaceId) -- qurum rehberinin musterek icracilari elave olunur
   SELECT de.ExecutorWorkplaceId, (@orderIndex+1), 0, @headWorkPlaceId
   FROM dbo.DOCS_EXECUTOR de  
   WHERE de.ExecutorDirectionId=@headSenderDirectionId
      AND de.DirectionTypeId=1
      AND de.ExecutorWorkplaceId!=@headWorkPlaceId
      --AND de.ExecutorMain=0
      AND de.SendStatusId=2
      AND de.ExecutorDocId=@answerDocId
      AND de.ExecutorWorkplaceId NOT IN (SELECT dv.VizaWorkPlaceId  -- 2 senedi 1 cavab senedi ile baglayanda 
              FROM dbo.DOCS_VIZA dv 
              WHERE dv.VizaDocId=@vizaDocId 
                 AND dv.VizaFromWorkflow in (1,4) 
				 AND dv.VizaConfirmed=0
				 AND dv.IsDeleted=0)
  END


   SELECT @execCount=count(0) FROM @otherExecutors;  

   WHILE(@execCount>0)
   BEGIN

   SELECT @orderIndex=o.OrderIndex, 
     @vizaWorkPlaceId = o.WorkPlaceId ,
     @vizaConfirmed = o.VizaConfirmed, 
     @vizaSenderWorkPlaceId = o.VizaSenderWorkPlaceId
   FROM 
     (SELECT oe.OrderIndex,
       oe.WorkPlaceId , 
       oe.VizaConfirmed, 
       oe.VizaSenderWorkPlaceId, 
       row_number() OVER (ORDER BY oe.OrderIndex) AS r from @otherExecutors oe) AS o
   WHERE o.r = @execCount;

   INSERT INTO dbo.DOCS_VIZA
   (
       --VizaId - column value is auto-generated
       VizaDocId,
	   VizaFileId,
       VizaWorkPlaceId,
	   VizaReplyDate,
       VizaOrderindex,
       VizaSenderWorkPlaceId,
	   VizaSenddate,
       VizaConfirmed,
	   IsDeleted,
       VizaAgreementTypeId,
	   VizaFromWorkflow,
       VizaAnswerDocId,
	   VizaPersonnelId
   )
   VALUES
   (
       -- VizaId - int
       @vizaDocId, -- VizaDocId - int
       @fileId, -- VizaFileId - int
       @vizaWorkPlaceId, -- VizaWorkPlaceId - int
       NULL, -- VizaReplyDate - datetime
       @orderIndex, -- VizaOrderindex - int
       @vizaSenderWorkPlaceId, -- VizaSenderWorkPlaceId - int
       NULL, -- VizaSenddate - datetime
       @vizaConfirmed, -- VizaConfirmed - tinyint
       0, -- IsDeleted - bit
       1, -- VizaAgreementTypeId - int
       4, -- VizaFromWorkflow - int
	   @answerDocId,
	   0
   )

   set @execCount=@execCount-1;
   
   END;

END;
      
   	  SET @result=1;
	  RETURN @result;
     END;
  END TRY
  BEGIN CATCH
 
   DECLARE @errorMessage nvarchar(max),
     @errorLine nvarchar(max);

   SELECT @errorMessage = error_message();
   SELECT @errorLine='Error Line: ' + cast(ERROR_LINE() AS nvarchar(max));

   SELECT @errorMessage += @errorLine;

   THROW 51000, @errorMessage, 1;

  END CATCH
    END;

