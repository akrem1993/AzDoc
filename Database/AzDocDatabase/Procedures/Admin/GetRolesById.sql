CREATE procedure [admin].[GetRolesById] @roleId INT
AS
    BEGIN
        SET NOCOUNT ON;

		if(@roleId <> 0)
		BEGIN
		SELECT dr.RoleId, dr.RoleComment AS [RoleName] FROM [dbo].[DC_ROLE] dr  WHERE dr.RoleStatus = 1 AND dr.RoleId = @roleId FOR JSON AUTO 
	    END

		ELSE
		BEGIN
		SELECT dr.RoleId, dr.RoleComment AS [RoleName] FROM [dbo].[DC_ROLE] dr  WHERE dr.RoleStatus = 1 FOR JSON AUTO 

		END


		 
    END;

