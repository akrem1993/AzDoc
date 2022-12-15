-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 19.09.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LogRequests]
@LogType nvarchar(max) =null,
@Url nvarchar(max)= null,
@DocId nvarchar(100)= null,
@Controller nvarchar(max)= null,
@ControllerAction nvarchar(max) =null,
@RequestData nvarchar(max)= null,
@RequestParams nvarchar(max)= null,
@Message nvarchar(max)= null,
@UserName nvarchar(max)= null,
@WorkPlace nvarchar(max)= null,
@UserIp nvarchar(50)= null
AS
BEGIN
	INSERT dbo.LogApp
	(
	    --Id - column value is auto-generated
	    LogType,
	    Url,
	    DocId,
	    Controller,
	    ControllerAction,
	    RequestData,
	    RequestParams,
	    Message,
	    UserName,
	    WorkPlace,
	    UserIp
	)
	VALUES
	(
	    -- Id - int
	  @LogType ,
@Url,
@DocId, 
@Controller, 
@ControllerAction,
@RequestData ,
@RequestParams ,
@Message, 
@UserName ,
@WorkPlace, 
@UserIp
	)
END

