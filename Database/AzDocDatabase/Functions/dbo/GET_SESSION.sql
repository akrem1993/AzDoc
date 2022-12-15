
CREATE FUNCTION [dbo].[GET_SESSION](@SessionIndex int)
RETURNS VARCHAR(50)
AS
BEGIN
DECLARE @SessionValue VARCHAR(128),@RetVal VARCHAR(128)
SELECT  @SessionValue =CAST(CONTEXT_INFO() AS VARCHAR);
SELECT  @RetVal = part from  SPLITSTRING(@SessionValue,'|') WHERE id=@SessionIndex;
RETURN  @RetVal
END

