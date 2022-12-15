CREATE PROCEDURE [report].[spGetDasboard]  @docType     INT = NULL, 
                                         @workPlaceId INT = NULL
										 
AS
    BEGIN
        SET NOCOUNT ON;

		----------Muveqqeti----------------------
		--	 if @workPlaceId not in (2, 23, 430, 431, 24, 480, 270,5017)
		--		throw 500001,N'Hazırda hesabat sistemi aktiv deyil',11;
		--------------------------------

        IF(@workPlaceId IS NOT NULL)
            BEGIN
                DECLARE @defaultPage INT;
                SELECT @defaultPage = du.DefaultPage
                FROM dbo.DC_USER du
                     JOIN dbo.DC_WORKPLACE dw ON du.UserId = dw.WorkplaceUserId
                WHERE dw.WorkplaceId = @workPlaceId;
        END;
        SELECT 1 FormTypeId, 
               am.DocTypeId AS Id, 
               am.Caption AS Name
        FROM dbo.AC_MENU am
        WHERE am.DocTypeId = (CASE
                                  WHEN @docType IS NULL
                                  THEN @defaultPage
                                  ELSE @docType
                              END)
        UNION
        SELECT 2 FormTypeId, 
               am.DocTypeId AS Id, 
               am.Caption AS Name
        FROM dbo.AC_MENU am
        WHERE am.DocTypeId IS NOT NULL
        UNION
        SELECT 3 FormTypeId, 
               s.DocCount AS Id, 
               s.DocumentstatusName AS Name
        FROM
        (
            SELECT COUNT(0) AS DocCount, 
                   dd.DocumentstatusName, 
                   dd.DocumentstatusId, 
                   d.DocDoctypeId
            FROM dbo.DOCS d
                 JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
            GROUP BY dd.DocumentstatusName, 
                     dd.DocumentstatusId, 
                     d.DocDoctypeId
        ) s
        WHERE s.DocDoctypeId = (CASE
                                    WHEN @docType IS NULL
                                    THEN @defaultPage
                                    ELSE @docType
                                END)
        UNION
        SELECT 4 FormTypeId, 
               s.DocCount AS Id, 
               s.Caption AS Name
        FROM
        (
            SELECT COUNT(0) AS DocCount, 
                   am.Caption
            FROM dbo.DOCS d
                 JOIN dbo.AC_MENU am ON d.DocDoctypeId = am.DocTypeId
            GROUP BY d.DocDoctypeId, 
                     am.Caption
        ) s;
    END;

