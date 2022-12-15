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
-- Author:  Kamran A-eff
-- Create date: 13.12.2018
-- Description: Entity Builder
-- =============================================
CREATE PROCEDURE [dbo].[spBuildEntity] 
    @tableName sysname--='dbo.Department'
AS
BEGIN
set nocount on;
declare @entityName nvarchar(100)
select @entityName=[name] from sys.tables where object_id=object_id(@tableName,'U')

print formatmessage('[Table("%s")]%spublic class %s : BaseEntity %s{',@tableName,char(10),@entityName,char(10))


declare @propertyName sysname,@dataType nvarchar(100),@isNullable varchar(10),@length int
declare crs cursor for
select 
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE,
[CHARACTER_MAXIMUM_LENGTH]
from INFORMATION_SCHEMA.COLUMNS
where concat(TABLE_SCHEMA,'.',TABLE_NAME)=@tableName
order by ORDINAL_POSITION

open crs
fetch next from crs into @propertyName,@dataType,@isNullable,@length
while @@fetch_status=0
begin
if @isNullable='NO'
print case @propertyName when 'Id' then '[Key]' else '[Required]' end
if @length is not null
print formatmessage('[StringLength(%i)]',@length)

if @propertyName in ('CUserId','CDate','EUserId','EDate','RUserId','RDate')
print formatmessage('[Column("%s")]',@propertyName)

print formatmessage('public %s %s{get;set;}',
case  
when @dataType in ('varchar','nvarchar')              then 'string'
when @dataType='bit'                                  then 'bool'+case @isNullable when 'YES' then '?' else '' end
when @dataType='tinyint'                              then 'byte'+case @isNullable when 'YES' then '?' else '' end
when @dataType='int'                                  then 'int'+case @isNullable when 'YES' then '?' else '' end
when @dataType='bigint'                               then 'long'+case @isNullable when 'YES' then '?' else '' end
when @dataType in ('datetime','smalldatetime','date') then 'DateTime'+case @isNullable when 'YES' then '?' else '' end
when @dataType in ('float','decimal','numeric')       then 'decimal'+case @isNullable when 'YES' then '?' else '' end
end,
case @propertyName 
when 'CUserId' then 'CreatedUserId'
when 'CDate'   then 'CreateDate'
when 'EUserId' then 'EditedUserId'
when 'EDate'   then 'EditDate'
when 'RUserId' then 'RemovedUserId'
when 'RDate'   then 'RemoveDate'
else @propertyName
end)

fetch next from crs into @propertyName,@dataType,@isNullable,@length
end
close crs
deallocate crs
print '}'
END

