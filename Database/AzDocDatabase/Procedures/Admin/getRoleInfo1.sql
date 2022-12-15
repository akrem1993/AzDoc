CREATE procedure [admin].[getRoleInfo1]  @roleId INT


AS 
BEGIN


if(@roleId <> 0)
BEGIN

DECLARE @Json nvarchar(max) = 
	(
    SELECT
	JSON_QUERY((
		    SELECT dro.RoleOperationId,
			    dRight.RightId,dRight.RightName, 
				drt.RightTypeId, drt.RightTypeName,
				do.OperationId, do.OperationName


			 FROM dbo.DC_ROLE_OPERATION dro 
			 JOIN  dbo.DC_ROLE dr ON dro.RoleId = dr.RoleId
			 JOIN dbo.DC_OPERATION do ON do.OperationId = dro.OperationId
			 JOIN dbo.DC_RIGHT dRight ON dRight.RightId = dro.RightId
			 JOIN dbo.DC_RIGHT_TYPE drt ON dro.RightTypeId = drt.RightTypeId
			   WHERE dr.RoleId=@roleId 
		   FOR JSON PATH
		  , INCLUDE_NULL_VALUES
		 )) AS RoleOperations,
		 JSON_QUERY((
		   SELECT do.OperationId,do.OperationName
		   FROM DC_OPERATION do
		   FOR JSON PATH
		  , INCLUDE_NULL_VALUES
		 )) AS AllOperations,

		 JSON_QUERY((
		   SELECT dright.RightId,dright.RightName
		   FROM DC_RIGHT dright
		   FOR JSON PATH
		  , INCLUDE_NULL_VALUES
		 )) AS AllRights,
		 JSON_QUERY((
		   SELECT drightType.RightTypeId,drightType.RightTypeName
		   FROM DC_RIGHT_TYPE drightType
		   FOR JSON PATH
		  , INCLUDE_NULL_VALUES
		 )) AS AllRightTypes


		 FOR JSON PATH,WITHOUT_ARRAY_WRAPPER
	);

	SELECT @Json;
			
  END

  ELSE
  BEGIN 

  DECLARE @Json1 nvarchar(max) = 
	(
    SELECT
	
		 JSON_QUERY((
		   SELECT do.OperationId,do.OperationName
		   FROM DC_OPERATION do
		   FOR JSON PATH
		  , INCLUDE_NULL_VALUES
		 )) AS AllOperations,

		 JSON_QUERY((
		   SELECT dright.RightId,dright.RightName
		   FROM DC_RIGHT dright
		   FOR JSON PATH
		  , INCLUDE_NULL_VALUES
		 )) AS AllRights,
		 JSON_QUERY((
		   SELECT drightType.RightTypeId,drightType.RightTypeName
		   FROM DC_RIGHT_TYPE drightType
		   FOR JSON PATH
		  , INCLUDE_NULL_VALUES
		 )) AS AllRightTypes


		 FOR JSON PATH,WITHOUT_ARRAY_WRAPPER
	);

	SELECT @Json1;


  END


END

