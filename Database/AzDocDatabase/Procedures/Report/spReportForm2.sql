CREATE PROCEDURE [report].[spReportForm2] @workPlaceId INT, 
                                      @beginDate   DATETIME = NULL, 
                                      @endDate     DATETIME = NULL
AS
    BEGIN
	SET NOCOUNT on;
	DECLARE @organizationId int;
	SELECT @organizationId=dw.WorkplaceOrganizationId FROM dbo.DC_WORKPLACE dw WHERE dw.WorkplaceId=@workPlaceId;
	SELECT * FROM (
	SELECT 1 AS orderIndex, N'I' AS Line, N'Daxil olan müraciətlər, o cümlədən:' Name,
				NULL Total1,
				NULL Total2,
				NULL Total3,
				NULL Total4,
				NULL Total5,
				NULL Total6,
				NULL Total7,																													
				NULL Total8,														-- ilkin
				NULL Total9,													-- təkrar
				NULL Total10,													-- təkrar (müxtəlif mövzuda)
				NULL Total11,													-- dublikat
				NULL Total12	
	union
		SELECT 1.1 AS orderIndex, N'-'  AS Line, N'təşkilatın aparatına' Name,  
				SUM(1) Total1,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total6,
				0 Total7,																													
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=0 THEN 1 ELSE 0 END) Total8,														-- ilkin
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=1 THEN 1 ELSE 0 END)  Total9,													-- təkrar
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=2 THEN 1 ELSE 0 END)  Total10,													-- təkrar (müxtəlif mövzuda)
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=3 THEN 1 ELSE 0 END)  Total11,													-- dublikat
				SUM(CASE WHEN isnull(doc.DocAppliertypeId,0) in (3,4) THEN 1 ELSE 0 END) Total12											-- kollektiv
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
	--		and isnull(DocResultId,0) not in (24)
	
	union
		SELECT 1.2 AS orderIndex, N'-' AS Line, N'tabe qurumlara' Name,
		NULL Total1,
				NULL Total2,
				NULL Total3,
				NULL Total4,
				NULL Total5,
				NULL Total6,
				NULL Total7,																													
				NULL Total8,														-- ilkin
				NULL  Total9,													-- təkrar
				NULL  Total10,													-- təkrar (müxtəlif mövzuda)
				NULL  Total11,													-- dublikat
				NULL Total12	
		union
	-- müraciətin forması (line = 2)
		SELECT 2 AS orderIndex,  N'II' AS Line, N'Müraciətlərin forması' Name,
		NULL Total1,
				NULL Total2,
				NULL Total3,
				NULL Total4,
				NULL Total5,
				NULL Total6,
				NULL Total7,																													
				NULL Total8,														-- ilkin
				NULL  Total9,													-- təkrar
				NULL  Total10,													-- təkrar (müxtəlif mövzuda)
				NULL  Total11,													-- dublikat
				NULL Total12	
		union

		SELECT 2.1 AS orderIndex, '-' as Line, (select FormName from DOC_FORM WHERE FormId=doc.DocFormId) Name, 
				SUM(1) Total1,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total6,
				0 Total7,																													
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=0 THEN 1 ELSE 0 END) Total8,														-- ilkin
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=1 THEN 1 ELSE 0 END)  Total9,													-- təkrar
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=2 THEN 1 ELSE 0 END)  Total10,													-- təkrar (müxtəlif mövzuda)
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=3 THEN 1 ELSE 0 END)  Total11,													-- dublikat
				SUM(CASE WHEN isnull(doc.DocAppliertypeId,0) in (3,4) THEN 1 ELSE 0 END) Total12											-- kollektiv
		FROM docs doc
			left join DOC_FORM on FormId = DocFormId
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
	--		and isnull(DocResultId,0) not in (24)
		GROUP BY doc.DocFormId
		union
	------------------------------------------------------------------------------------------------------------------------------------------------
		SELECT 3 AS orderIndex, N'III' AS  Line, N'Daxil olan müraciətlərin mövzuları:' Name,
		NULL Total1,
				NULL Total2,
				NULL Total3,
				NULL Total4,
				NULL Total5,
				NULL Total6,
				NULL Total7,																													
				NULL Total8,														-- ilkin
				NULL  Total9,													-- təkrar
				NULL  Total10,													-- təkrar (müxtəlif mövzuda)
				NULL  Total11,													-- dublikat
				NULL Total12	
		union

			SELECT 3.1 AS orderIndex, '' as Line, 
			(select TopicTypeName from DOC_TOPIC_TYPE WHERE TopicTypeId=doc.DocTopicType) Name, 
				SUM(1) Total1,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total6,
				0 Total7,																													
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=0 THEN 1 ELSE 0 END) Total8,														-- ilkin
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=1 THEN 1 ELSE 0 END)  Total9,													-- təkrar
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=2 THEN 1 ELSE 0 END)  Total10,													-- təkrar (müxtəlif mövzuda)
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=3 THEN 1 ELSE 0 END)  Total11,													-- dublikat
				SUM(CASE WHEN isnull(doc.DocAppliertypeId,0) in (3,4) THEN 1 ELSE 0 END) Total12											-- kollektiv
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
	--		and isnull(DocResultId,0) not in (24)
		GROUP BY doc.DocTopicType
		union
	------------------------------------------------------------------------------------------------------------------------------------------------
		SELECT 4 AS orderIndex,N'IV' AS Line,  N'Müraciətlərə baxılmasının vəziyyəti:' Name,
		NULL Total1,
				NULL Total2,
				NULL Total3,
				NULL Total4,
				NULL Total5,
				NULL Total6,
				NULL Total7,																													
				NULL Total8,														-- ilkin
				NULL  Total9,													-- təkrar
				NULL  Total10,													-- təkrar (müxtəlif mövzuda)
				NULL  Total11,													-- dublikat
				NULL Total12	
		union
		SELECT 4.1 AS orderIndex,'-' AS  Line 
				, (select ResultName from DOC_RESULT WHERE DOC_RESULT.Id = CASE WHEN doc.DocResultId<>25 THEN doc.DocResultId ELSE 2 END) Name, 
				SUM(1) Total1,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total6,
				0 Total7,																													
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=0 THEN 1 ELSE 0 END) Total8,														-- ilkin
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=1 THEN 1 ELSE 0 END)  Total9,													-- təkrar
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=2 THEN 1 ELSE 0 END)  Total10,													-- təkrar (müxtəlif mövzuda)
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=3 THEN 1 ELSE 0 END)  Total11,													-- dublikat
				SUM(CASE WHEN isnull(doc.DocAppliertypeId,0) in (3,4) THEN 1 ELSE 0 END) Total12											-- kollektiv
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and DocDocumentstatusId=12 				
	--		and isnull(DocResultId,0) not in (24)
		GROUP BY CASE WHEN doc.DocResultId<>25 THEN doc.DocResultId ELSE 2 END
		union
		SELECT 4.2 AS orderIndex, '-' as Line , N'icradadır' Name, 			
				SUM(1) Total1,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3,
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5,
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total6,
				0 Total7,																													
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=0 THEN 1 ELSE 0 END) Total8,														-- ilkin
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=1 THEN 1 ELSE 0 END)  Total9,													-- təkrar
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=2 THEN 1 ELSE 0 END)  Total10,													-- təkrar (müxtəlif mövzuda)
				SUM(CASE WHEN isnull(doc.DocDuplicateId,0)=3 THEN 1 ELSE 0 END)  Total11,													-- dublikat
				SUM(CASE WHEN isnull(doc.DocAppliertypeId,0) in (3,4) THEN 1 ELSE 0 END) Total12											-- kollektiv
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and DocDocumentstatusId<>12 
			)s ORDER BY s.orderIndex asc
    END;

