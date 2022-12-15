CREATE procedure [admin].[getRoleInfo]  @roleId INT


AS 
BEGIN


if(@roleId <> 0)

BEGIN

SELECT * FROM 
			(
				SELECT 
				dr.RoleId,
				dr.RoleComment AS RoleName,
				(	
				SELECT dro.RoleOperationId,
			    dRight.RightId,dRight.RightName, 
				drt.RightTypeId, drt.RightTypeName,
				do.OperationId, do.OperationName


			 FROM dbo.DC_ROLE_OPERATION dro 
			 JOIN  dbo.DC_ROLE dr ON dro.RoleId = dr.RoleId
			 JOIN dbo.DC_OPERATION do ON do.OperationId = dro.OperationId
			 JOIN dbo.DC_RIGHT dRight ON dRight.RightId = dro.RightId
			 JOIN dbo.DC_RIGHT_TYPE drt ON dro.RightTypeId = drt.RightTypeId
			   WHERE dr.RoleId=@roleId ORDER BY dro.RoleOperationId desc FOR JSON PATH, INCLUDE_NULL_VALUES				

					
			   ) AS RoleOperations,
			   
			   (					
						SELECT 
						do.OperationId,
						do.OperationName

						FROM DC_OPERATION do FOR JSON AUTO					

					
			   ) AS AllOperations,
			   (					
						SELECT 
						dright.RightId,
						dright.RightName

						FROM DC_RIGHT dright FOR JSON AUTO					

					
			   ) AS AllRights,
			   (					
						SELECT 
						drightType.RightTypeId,
						drightType.RightTypeName

						FROM DC_RIGHT_TYPE drightType FOR JSON AUTO					

					
			   ) AS AllRightTypes
			    
			 

			 FROM dbo.DC_ROLE dr 
			 WHERE dr.RoleId=@roleId 
			) AS roleDetails FOR JSON AUTO


			END

ELSE
	BEGIN
	DECLARE @Json nvarchar(max) = 
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

	SELECT @Json;
	END


END

