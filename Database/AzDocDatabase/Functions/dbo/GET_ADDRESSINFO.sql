CREATE FUNCTION [dbo].[GET_ADDRESSINFO] (@docId int, @adrType  tinyint, @viewType tinyint)
  RETURNS NVARCHAR(4000)
  AS
  BEGIN
  DECLARE @personFullName nvarchar(1000)
  DECLARE @persons  nvarchar(4000) =''
  DECLARE cr_persons cursor for
 
 SELECT  CASE 
      WHEN @adrType=3 and @viewType=1 THEN  CONCAT(RTRIM(adr.FullName), ', ',
      org.OrganizationName,  ' ',
      adr.AdrAuthorDepartmentName, ' ', 
      pos.PositionName)
      WHEN  @adrType=3 and @viewType=2 THEN org.OrganizationName
      WHEN  @adrType=3 and @viewType=3 THEN CONCAT(RTRIM(adr.FullName), ',',
      adr.AdrAuthorDepartmentName, ' ', 
      pos.PositionName)
      WHEN  @viewType=4 THEN 
   (
    select TOP 1   -----------------------ARAŞDIRMAQ-------------------------------------------------- birdən artıq sətir qaytardığına görə səhv verirdi (Dəyişdi: Dilarə Cəlilova)  
    CASE  WHEN AdrTypeId=2 THEN LTRIM( REPLACE(FullName,AdrAuthorDepartmentName,'')) 
    ELSE FullName 
    END
   as x 
   from DOCS_ADDRESSINFO AS adr where AdrDocId=@docId and AdrTypeId= @adrType
   )

   ELSE FullName END    
            FROM DOCS_ADDRESSINFO adr
         LEFT JOIN DC_POSITION pos on adr.AdrPositionId=pos.PositionId
         LEFT JOIN DC_ORGANIZATION org on adr.AdrOrganizationId=org.OrganizationId
         WHERE adr.AdrTypeId=@adrType and adr.AdrDocId=@docId
  --SELECT FullName FROM DOCS_ADDRESSINFO WHERE AdrTypeId=@adrType and AdrDocId=@docId

  open cr_persons
 
  fetch next from  cr_persons into @personFullName
 
  while @@FETCH_STATUS=0
  BEGIN
  SET  @persons+=', '+@personFullName
  
  fetch next from  cr_persons into @personFullName
  END
  close cr_persons
 
  DEALLOCATE cr_persons
 
  return STUFF(@persons, 1, 2, '');  
 
  END

