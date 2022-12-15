CREATE procedure [admin].[GetOrganisationsById] @orgId INT
AS
    BEGIN
        SET NOCOUNT ON;

		

		if(@orgId <> 0)
		BEGIN
		SELECT o.OrganizationId AS Id, o.OrganizationShortname AS [Name] FROM [dbo].[DC_ORGANIZATION] o WHERE OrganizationStatus = 1 AND o.OrganizationId = @orgId FOR JSON AUTO 
	    END

		ELSE
		BEGIN
		SELECT o.OrganizationId AS Id, o.OrganizationShortname AS [Name] FROM [dbo].[DC_ORGANIZATION] o WHERE OrganizationStatus = 1 FOR JSON AUTO 

		END


		 
    END;

