

-- =============================================
-- Author:  Ruslan Suleymanov
-- Create date: 30.10.2019
-- Description: Reports new icrada olan senedleri getirmek
-- =============================================
Create PROCEDURE [report].[spReportNew]   @workPlaceId int,
										 @docType int = NULL,
										 @executorOrganizationId int,
										 @executorOrganizationType int,
										 @organizationDepartmentOrOrganizations int =null,
										 @remaningDay int = null,	
										 @beginDate date = null,
										 @endDate date = null,
										 @topicType int=null,
										 @topic int= null

AS

SET NOCOUNT ON;

DECLARE @workPlaceIds TABLE (workplaceID int)

IF @workPlaceId=24 OR @workPlaceId=23 OR @workPlaceId=430 OR @workPlaceId=431 -- Gulten Miraliyeva
 INSERT @workPlaceIds
 (
     workplaceID
 )
 VALUES
   --(24),-- Gultan
   (23),
   (430),
   (431);
ELSE
INSERT @workPlaceIds
(
    workplaceID
)
VALUES
(
   @workPlaceId
)


--declare  @positionGroup int, @workplaceDepartmentId int ;

--SELECT @positionGroup=dpg.PositionGroupId,@workplaceDepartmentId=dw.WorkplaceDepartmentId FROM dbo.DC_WORKPLACE dw 
--JOIN dbo.DC_DEPARTMENT_POSITION ddpr ON ddpr.DepartmentPositionId = dw.WorkplaceDepartmentPositionId
--JOIN dbo.DC_POSITION_GROUP dpg ON dpg.PositionGroupId = ddpr.PositionGroupId
--WHERE dw.WorkplaceId=@workPlaceId;

--DECLARE @workplaceDepartments TABLE (departmentId int);


--WITH cte_deps AS (

--    SELECT dd.DepartmentId AS DepartmentId,1 AS Level,dd.DepartmentOrganization,dd.DepartmentTopId FROM dbo.DC_DEPARTMENT dd WHERE dd.DepartmentId=@workplaceDepartmentId
--    UNION ALL
--    SELECT d.DepartmentId,ds.Level+1 AS Level,d.DepartmentOrganization,d.DepartmentTopId FROM dbo.DC_DEPARTMENT d JOIN cte_deps ds ON ds.DepartmentId=d.DepartmentTopId 
--)
--INSERT @workplaceDepartments
--(
--    departmentId
--)SELECT cd.DepartmentId FROM cte_deps cd OPTION (MAXRECURSION 0)
	


--CASE WHEN @executorOrganizationType = -1      -- umumi
--WHEN @executorOrganizationType = 1          -- nazirlik daxili shobeler  
--WHEN @executorOrganizationType = 0		 -- nazirliye tabe qurumlar 

-- umumidise hech ne eleme
-- nazirlik daxili shobelerde departmente gore filter 
-- Nazirliye tabe qurumlarda qurumlara gore filter 

DECLARE @docs TABLE(docId int)

INSERT @docs
(
    docId
)
SELECT DISTINCT d.DocId
FROM VW_DOC_INFO d
JOIN dbo.DOCS_DIRECTIONS dd ON d.DocId= dd.DirectionDocId
JOIN dbo.DOCS_EXECUTOR de ON dd.DirectionId = de.ExecutorDirectionId 
		AND de.ExecutorDocId=d.DocId 
		AND de.ExecutorDirectionId IN 
					(SELECT dd.DirectionId FROM dbo.DOCS_DIRECTIONS dd 
					   WHERE dd.DirectionWorkplaceId in (SELECT wpi.* FROM @workPlaceIds wpi) --WHERE dd.DirectionWorkplaceId=@workplaceId 
					   AND dd.DirectionDocId=d.DocId) 
						AND  de.ExecutorMain=1
						AND de.ExecutorDocId=d.DocId 
						AND de.DirectionTypeId in (1,17,18) 
						AND  de.ExecutionstatusId IS NULL
JOIN dbo.DC_WORKPLACE dw ON de.ExecutorWorkplaceId = dw.WorkplaceId --AND dw.WorkplaceDepartmentId=1064
JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId

WHERE    d.DocDeleted NOT IN (3,4) 
		 AND d.DocDocumentstatusId=1
		 AND ((@docType=-1  AND d.DocDoctypeId IN (1,2,18)) OR d.DocDoctypeId=@docType)
		 --AND de.ExecutorDepartment IN ( SELECT wd.departmentId FROM @workplaceDepartments wd)
		 AND (@beginDate IS NULL OR d.DocEnterdate>=@beginDate)
		 AND (@endDate IS NULL OR d.DocEnterdate<=@endDate)
		 --AND ((@executorOrganizationId in (1,2) AND d.DocOrganizationId=1) OR ( @executorOrganizationId not in (1,2) AND d.DocOrganizationId NOT IN (-1)))
		 AND isnull(d.DocSendTypeId,0) NOT IN (3)   
		 AND (nullif(@topicType,-1) IS NULL  OR d.DocTopicType=@topicType) 
		 AND (nullif(@topic,-1)     IS NULL OR d.DocTopicId=@topic)
		 AND((@executorOrganizationType=-1 AND de.ExecutorOrganizationId NOT IN (-1) )
			OR (nullif(@organizationDepartmentOrOrganizations,0) IS NULL AND (@executorOrganizationType=0  AND de.ExecutorOrganizationId NOT IN (1)))
			OR (nullif(@organizationDepartmentOrOrganizations,0)IS NOT NULL AND (de.ExecutorOrganizationId=@organizationDepartmentOrOrganizations))
			OR (nullif(@organizationDepartmentOrOrganizations,0)IS NULL AND (@executorOrganizationType=1  AND  de.ExecutorOrganizationId  IN (1)))
			OR (nullif(@organizationDepartmentOrOrganizations,0)IS NOT NULL AND (de.ExecutorDepartment=@organizationDepartmentOrOrganizations)))

SELECT allDocs.* FROM
(SELECT f.docId FROM @docs f) AS df
CROSS APPLY
(    
SELECT TOP 1 * FROM  (

SELECT  d5.*,
				case when nullif(d5.PlannedDate,'00010101') is NULL  
				then null 
				ELSE DATEDIFF(day,GetDate(),d5.[PlannedDate]) END AS [RemainingDay]
		FROM (

SELECT  d4.*,

			STUFF(
			(
			SELECT ',' + isnull(d.DocEnterno,d.DocDocno)
			FROM dbo.DOCS d
			WHERE d.DocId IN (SELECT [value] FROM STRING_SPLIT(d4.[ReplyDocIds], ',')) FOR XML PATH('')  -- cavab senedlerinin nomreleri
			),1,1,'') AS [ReplyDocNumbers]
		FROM (

SELECT  d3.*,
				STUFF((
				SELECT ',' + convert(varchar(50),s.RelatedDocId) FROM (	
				SELECT DISTINCT dr.RelatedDocId FROM DOCS_RELATED dr WHERE dr.RelatedTypeId=2 and dr.RelatedDocumentId in(d3.DocId)
				) s FOR XML PATH('')			-- cavab senedlerinin doc idleri
				), 1, 1, '') AS [ReplyDocIds],

				STUFF((
				SELECT ', ' + convert(nvarchar(100),notExecutedExecutors.notExecutedExecutorDepartment) FROM  ( 

				SELECT dd.DepartmentName AS notExecutedExecutorDepartment FROM dbo.DOCS_EXECUTOR de 
				LEFT JOIN dbo.DC_DEPARTMENT dd ON de.ExecutorDepartment = dd.DepartmentId
				WHERE de.ExecutorDocId=d3.DocId 
				AND de.ExecutorDirectionId  IN (
				SELECT dd.DirectionId FROM dbo.DOCS_DIRECTIONS dd 
				WHERE dd.DirectionWorkplaceId in (SELECT wpi.* FROM @workPlaceIds wpi) --WHERE dd.DirectionWorkplaceId=@workplaceId 
				AND dd.DirectionDocId=d3.DocId) 
				AND  de.ExecutorMain=1 AND de.ExecutorDocId=d3.DocId 
				and de.DirectionTypeId in (1,17,18) 
				--AND de.ExecutorReadStatus=0
				AND  de.ExecutionstatusId IS NULL

				) notExecutedExecutors FOR XML PATH('')
				),1,1,'') as [NotExecutedExecutorsDepartment],
				
				
				STUFF((
				SELECT ', ' + convert(nvarchar(100),notExecutedExecutors.notExecutedExecutor) FROM  ( 
				SELECT dbo.fnGetPersonnelbyWorkPlaceId(de.ExecutorWorkplaceId,106) AS notExecutedExecutor FROM dbo.DOCS_EXECUTOR de WHERE de.ExecutorDocId=d3.DocId AND de.ExecutorDirectionId  IN (
				SELECT dd.DirectionId FROM dbo.DOCS_DIRECTIONS dd 
				WHERE dd.DirectionWorkplaceId in (SELECT wpi.* FROM @workPlaceIds wpi)--WHERE dd.DirectionWorkplaceId=@workplaceId 
				AND dd.DirectionDocId=d3.DocId) AND  de.ExecutorMain=1 AND de.ExecutorDocId=d3.DocId 
				and de.DirectionTypeId in (1,17,18) 
				--AND de.ExecutorReadStatus=0
				AND  de.ExecutionstatusId IS null
				) notExecutedExecutors FOR XML PATH('')
				),1,1,'') as [NotExecutedExecutorsName]

FROM (      SELECT d2.*,
			nullif(CASE WHEN d2.DirectionChangedID IS NOT NULL
			THEN ddc.NewDirectionPlannedDate
			ELSE d2.DocPlannedDate
			end,'00010101') as [PlannedDate]

FROM (
				SELECT  d.DocId,
						d.DocEnterdate,
						d.DocEnterno,
						d.DocDescription,
						d.DocPlannedDate,
						ds.SendStatusName,
						de.SendStatusId,
						 (
						    SELECT STUFF(
						    (
						        SELECT ' ' + OrganizationName
						        FROM DC_ORGANIZATION o
						        WHERE o.OrganizationId IN
						        (
						            SELECT af.AdrOrganizationId
						            FROM DOCS_ADDRESSINFO af
						            WHERE af.AdrDocId = d.DocId
						                  AND af.AdrTypeId = 3
						                  AND af.AdrAuthorId IS NOT NULL
						        ) FOR XML PATH('')
						    ), 1, 1, '')
						) AS EntryFromWhere,
						 (SELECT STUFF((
						   SELECT ' ' + da.AppFirstname +' '+ da.AppSurname +' '+ CASE WHEN (da.AppLastName) IS NULL THEN ' ' ELSE  da.AppLastName END
						   FROM dbo.DOCS_APPLICATION da
							             LEFT JOIN dbo.DC_SOCIALSTATUS ds ON da.AppSosialStatusId = ds.SocialId
							             LEFT JOIN dbo.DC_REPRESENTER dr ON da.AppRepresenterId = dr.RepresenterId
							             LEFT JOIN dbo.DC_COUNTRY dc ON da.AppCountry1Id = dc.CountryId
							             LEFT JOIN dbo.DC_REGION dr2 ON da.AppRegion1Id = dr2.RegionId
						   WHERE da.AppDocId = d.DocId FOR XML PATH('')
						 ),1,1,'')) AS EntryFromWho,
						(SELECT max(dd.DirectionChangeId) FROM dbo.DOCS_DIRECTIONCHANGE dd WHERE dd.ChangeType=2 AND dd.DirectionChangeStatus=1 AND dd.DocId=d.DocId) as DirectionChangedID
						    FROM VW_DOC_INFO d
							JOIN dbo.DOCS_DIRECTIONS dd ON d.DocId= dd.DirectionDocId
							JOIN dbo.DOCS_EXECUTOR de ON dd.DirectionId = de.ExecutorDirectionId 
							JOIN dbo.DC_WORKPLACE dw ON de.ExecutorWorkplaceId = dw.WorkplaceId  and  de.ExecutorWorkplaceId!=d.DocInsertedById 
							JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
							LEFT JOIN dbo.DOC_TYPE dt ON dt.DocTypeId=d.DocDoctypeId
							LEFT JOIN dbo.DOC_SENDSTATUS ds ON ds.SendStatusId=de.SendStatusId
							LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd2 ON dd2.DocumentstatusId=d.DocDocumentstatusId
							LEFT JOIN dbo.DC_ORGANIZATION dd3 ON dd3.OrganizationId=d.DocOrganizationId

							WHERE d.DocId=df.docId
						 )d2
					        LEFT JOIN dbo.DOCS_DIRECTIONCHANGE ddc ON ddc.DirectionChangeId=d2.DirectionChangedID
				  ) d3
			 )d4
		) d5
	) d6  
) AS allDocs
	WHERE  (@remaningDay=-1
		OR (@remaningDay=1 AND allDocs.RemainingDay  BETWEEN 0 AND 1) 
		OR (@remaningDay=3 AND allDocs.RemainingDay  BETWEEN 0 AND 3) 
		OR (@remaningDay=5 AND allDocs.RemainingDay  BETWEEN 0 AND 5) 
		OR (@remaningDay=0 AND allDocs.RemainingDay<0)) 
		ORDER BY allDocs.RemainingDay asc
