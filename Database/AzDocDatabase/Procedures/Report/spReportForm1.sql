CREATE PROCEDURE [report].[spReportForm1]
										  @workPlaceId       INT, 
                                          @beginDate         DATETIME = NULL, 
                                          @endDate           DATETIME = NULL
AS
BEGIN
	SET NOCOUNT on;
	DECLARE @organizationId int;
	SELECT @organizationId=dw.WorkplaceOrganizationId FROM dbo.DC_WORKPLACE dw WHERE dw.WorkplaceId=@workPlaceId
	SELECT  N'I' AS Line, N'Dövlət orqanlarından və digər qurumlardan baxılmaq üçün daxil olan müraciətlər, o cümlədən:' Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,		-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12  THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and exists(select AdrDocId from DOCS_ADDRESSINFO where AdrDocId=doc.DocId and AdrTypeId=3)
	UNION 
	SELECT  N'-' AS Line, N'Azərbaycan Respublikasının Prezidentinin Administrasiyasından' Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,				-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12 THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and exists(select AdrDocId from DOCS_ADDRESSINFO where AdrTypeId=3 and AdrDocId=doc.DocId 
					and exists(select OrganizationId from DC_ORGANIZATION where OrganizationId=ISNULL(AdrOrganizationId,0) and ISNULL(OrganizationTypeId,0) in (1))
			)
	UNION
	SELECT  N'-' AS Line,  N'	o cümlədən nəzarətlə' Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,				-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12 THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and exists(select AdrDocId from DOCS_ADDRESSINFO where AdrTypeId=3 and AdrDocId=doc.DocId 
					and exists(select OrganizationId from DC_ORGANIZATION where OrganizationId=ISNULL(AdrOrganizationId,0) and ISNULL(OrganizationTypeId,0) in (1))
			)
			and ISNULL(DocUndercontrolStatusId,0)=1
	 UNION
	 SELECT N'-' AS Line,  N'Milli Məclisdən' Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,				-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12 THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and exists(select AdrDocId from DOCS_ADDRESSINFO where AdrTypeId=3 and AdrDocId=doc.DocId 
					and exists(select OrganizationId from DC_ORGANIZATION where OrganizationId=ISNULL(AdrOrganizationId,0) and ISNULL(OrganizationTypeId,0) in (2))
			)
		UNION
		SELECT N'-' AS Line,  N'Nazirlər Kabinetindən' Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,				-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12 THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and exists(select AdrDocId from DOCS_ADDRESSINFO where AdrTypeId=3 and AdrDocId=doc.DocId 
					and exists(select OrganizationId from DC_ORGANIZATION where OrganizationId=ISNULL(AdrOrganizationId,0) and ISNULL(OrganizationTypeId,0) in (3))
			)
		UNION
		SELECT N'-' AS Line,  N'Digər təşkilatlardan' Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,				-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12 THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and exists(select AdrDocId from DOCS_ADDRESSINFO where AdrTypeId=3 and AdrDocId=doc.DocId 
					and exists(select OrganizationId from DC_ORGANIZATION where OrganizationId=ISNULL(AdrOrganizationId,0) and ISNULL(OrganizationTypeId,0) not in (1,2,3))
			)
		UNION
		SELECT  N'II' AS Line, N'Vətəndaşlardan bilavasitə təşkilata ünvanlanan müraciətlər' Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,				-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12 THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
			and not exists(select AdrDocId from DOCS_ADDRESSINFO where AdrTypeId=3 and AdrDocId=doc.DocId)
		UNION
		SELECT '' AS Line , N'Yekun'  Name, 
				SUM(1) Total1, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=1 THEN 1 ELSE 0 END) Total2, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=2 THEN 1 ELSE 0 END) Total3, 
				SUM(CASE WHEN isnull(doc.DocApplytypeId,0)=3 THEN 1 ELSE 0 END) Total4, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=1 or isnull(doc.DocControlStatusId,0)=1 THEN 1 ELSE 0 END) Total5, 
				SUM(CASE WHEN isnull(doc.DocUndercontrolStatusId,0)=0 and isnull(doc.DocControlStatusId,0)=0 THEN 1 ELSE 0 END) Total6, 
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and (isnull(doc.DocResultId,0)=2 or isnull(doc.DocResultId,0)=25) THEN 1 ELSE 0 END) Total7,				-- müsbət
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=3 THEN 1 ELSE 0 END) Total8,				-- qismən
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=5 THEN 1 ELSE 0 END) Total9,				-- əsassız
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=4 THEN 1 ELSE 0 END) Total10,				-- müvafiq
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=22 THEN 1 ELSE 0 END) Total11,				-- nəzərdə tutulub
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)<>12  THEN 1 ELSE 0 END) Total12,			-- icraatda
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=8 THEN 1 ELSE 0 END) Total13,				-- aidiyyəti üzrə göndərilib
				SUM(CASE WHEN isnull(doc.DocDocumentstatusId,0)=12 and isnull(doc.DocResultId,0)=23 THEN 1 ELSE 0 END) Total14				-- baxılmamış saxlanılıb
		FROM docs doc
		WHERE doc.DocDeleted=0 and doc.DocOrganizationId=@organizationId and doc.DocDoctypeId=2 and (doc.DocEnterdate > @beginDate and doc.DocEnterdate < @endDate)
end

