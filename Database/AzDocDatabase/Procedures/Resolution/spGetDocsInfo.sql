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
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [resolution].[spGetDocsInfo] 
@docId int
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET 
  NOCOUNT ON;
select 
  DocId, 
  DocEnterdate, 
  DocEnterno, 
  DocTypeName, 
  DocTypeId, 
  DocPlannedDate, 
  DocDocumentstatusId 
from 
  DOCS dc 
  left join DOC_TYPE dt on dt.DocTypeId = dc.DocDoctypeId 
  left join DC_TREE dr on dr.TreeDocTypeId = dc.DocDoctypeId 
where 
  DocId = @docId

END

