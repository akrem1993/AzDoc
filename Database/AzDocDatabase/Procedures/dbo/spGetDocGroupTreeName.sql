/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetDocGroupTreeName] 
@docTypeId INT
AS
    BEGIN
        IF(@docTypeId <> -1)
            BEGIN
                SELECT g.DocTypeGroupName, 
                       t.TreeTreeName AS TreeName
                FROM dbo.DC_TREE t
                     INNER JOIN dbo.DOC_TYPE_GROUP g ON t.TreeDocTypeGroupId = g.DocTypeGroupId
                WHERE t.TreeDocTypeId = @docTypeId
                      AND g.DocTypeGroupStatus = 1;
        END;
  ELSE
  BEGIN
   SELECT N'Sənəd növləri' AS DocTypeGroupName, N'Oxunmamış sənədlər' AS TreeName;
  end
    END;

