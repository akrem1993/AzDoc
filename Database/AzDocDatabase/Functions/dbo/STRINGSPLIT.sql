/*
Migrated by Kamran A-eff 07.09.2019
*/

/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE FUNCTION [dbo].[STRINGSPLIT] ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] nvarchar (500),[Id] int)
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT
 DECLARE @index INT
 set @index=0
 WHILE CHARINDEX('|', @stringToSplit) > 0
 BEGIN
 SET @index=@index+1
  SELECT @pos  = CHARINDEX('|', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name,@index

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit,@index

 RETURN
END

