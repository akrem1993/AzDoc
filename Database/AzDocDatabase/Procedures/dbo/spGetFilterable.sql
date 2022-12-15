CREATE PROCEDURE [dbo].[spGetFilterable]
@docTypeId int=NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT 1 FormTypeId, 
               dtt.TopicTypeId AS value, 
               dtt.TopicTypeName AS text
        FROM dbo.DOC_TOPIC_TYPE dtt WHERE 
		dtt.TopicTypeStatus = 1 and 
		( dtt.TopicTypeId BETWEEN 88 AND 134
                                   OR dtt.TopicTypeId = 69)
        UNION
        SELECT 2 FormTypeId, 
               drf.ReceivedFormId AS value, 
               drf.ReceivedFormName AS text
        FROM dbo.DOC_RECEIVED_FORM drf
        UNION
        SELECT 3 FormTypeId, 
               df.FormId AS value, 
               df.FormName AS text
        FROM dbo.DOC_FORM df
        UNION
        SELECT 4 FormTypeId, 
               dd.DocumentstatusId AS value, 
               dd.DocumentstatusName AS text
        FROM dbo.DOC_DOCUMENTSTATUS dd
		WHERE dd.DocumentstatusId in (1,8,12,14,15,33,34,35)
        UNION
		 SELECT 5 FormTypeId, 
               dd.DocumentstatusId AS value, 
               dd.DocumentstatusName AS text
        FROM dbo.DOC_DOCUMENTSTATUS dd
        UNION
        SELECT 5 FormTypeId, 
               da.ApplytypeId AS value, 
               da.ApplytypeName AS text
        FROM dbo.DOC_APPLYTYPE da
		UNION
        SELECT 6 FormTypeId, 
               dd.DocumentstatusId AS value, 
               dd.DocumentstatusName AS text
        FROM dbo.DOC_DOCUMENTSTATUS dd
		WHERE dd.DocumentstatusId in (1,8,12,14,15,33,34,35)
		UNION
        SELECT 7 FormTypeId, 
               dd.DocumentstatusId AS value, 
               dd.DocumentstatusName AS text
        FROM dbo.DOC_DOCUMENTSTATUS dd
		WHERE dd.DocumentstatusId in (1,8,12,14,28,27,29,30,31,33,34,35,36)
		UNION
        SELECT 8 FormTypeId, 
               dd.DocumentstatusId AS value, 
               dd.DocumentstatusName AS text
        FROM dbo.DOC_DOCUMENTSTATUS dd
		WHERE dd.DocumentstatusId in (1,8,12,15,14,16,25,28,29,30,31,33,34,35)
		UNION
        SELECT 9 FormTypeId, 
               dd.DocumentstatusId AS value, 
               dd.DocumentstatusName AS text
        FROM dbo.DOC_DOCUMENTSTATUS dd
		WHERE dd.DocumentstatusId in (1,8,12,14,16,25,28,29,30,31,33,34,35)
		UNION
		    SELECT 10 FormTypeId, 
               dtt.TopicTypeId AS value, 
               dtt.TopicTypeName AS text
        FROM dbo.DOC_TOPIC_TYPE dtt WHERE  
		dtt.TopicTypeStatus = 1 and
		  (dtt.TopicTypeId BETWEEN 0 AND 88
                                   OR dtt.TopicTypeId IN(134, 135, 136))
    END;

