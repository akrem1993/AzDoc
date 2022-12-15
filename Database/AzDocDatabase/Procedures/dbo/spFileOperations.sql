/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spFileOperations]
@fileInfoId int=0,
@docId int=0,
@workPlaceId int=0,
@operType int, --Select-1, Insert -2,  Update-3, Delete-4, Other-5
@selectType int=0, -- 1 - GetFileInfoById(), 2 - GetByDocId(), 3-GetResponsePersonByOrgId(), 4 - GetVizaByFileInfoId(), 5 - GetById() , 6 - GetMainFileByDocId(), 7-GetSignedFileByDocId()
@insertType int=0,
@updateType int=0,
@deleteType int=0,
@otherType int=0,
@result int=0 output
as
begin
        if(@operType=1) --Butun select elemilyyatlari bunun icinde gedecek
        begin -- Main
            if(@selectType=1) --Select name - GetFileInfoById()
                begin
                    SELECT FileInfoId, FileInfoWorkplaceId, FileInfoParentId, FileInfoVersion, FileInfoType, FileInfoCapacity, FileInfoExtention, FileInfoInsertdate, FileInfoPath, FileInfoName, FileInfoGuId, FileInfoStatus, FileInfoBinary, FileInfoContent, FileInfoAttachmentCount, FileInfoCopiesCount, FileInfoPageCount 
                    FROM dbo.DOCS_FILEINFO Where FileInfoId=@fileInfoId;
                end
            
            if(@selectType=2) --Select name - GetByDocId()
                begin
                  SELECT DF.FileId, 
						DF.FileDocId, 
						FI.FileInfoId,
						CASE WHEN DF.FileIsMain=1 THEN DF.FileVisaStatus ELSE null END FileVisaStatus, 
						DF.SignatureStatusId, 
						DF.FileCurrentVisaGroup, 
						FI.FileInfoName, 
						FI.FileInfoParentId, 
						FI.FileInfoInsertdate, 
						FI.FileInfoVersion, 
						dbo.GET_PERSON(1, FI.FileInfoWorkplaceId) AS PersonFullName, 
						DV.VizaConfirmed, 
						DF.FileIsMain, 
						dbo.GET_MAIN_EXECUTOR_WORKPLACEID(DF.FileDocId) AS MainExecutorsWorkplaceId, 
						FI.FileInfoWorkplaceId AS InsertedUserWorkplaceId,
						dbo.DOCS.DocInsertedById ,
						dbo.DOCS.DocDoctypeId,
						FI.FileInfoAttachmentCount,
						FI.FileInfoCopiesCount,
						FI.FileInfoPageCount ,
						0 as DirectionConfirmed,
						DV.VizaId
				FROM dbo.DOCS_FILE  AS DF 
						INNER JOIN dbo.DOCS_FILEINFO AS FI ON DF.FileInfoId = FI.FileInfoId 
						LEFT OUTER JOIN dbo.DOCS ON DF.FileDocId = dbo.DOCS.DocId 
						LEFT OUTER JOIN dbo.DOCS_VIZA AS DV ON DF.FileId = DV.VizaFileId  AND (DV.VizaWorkPlaceId = dbo.GET_SESSION(2)  AND DBO.GET_LAST_VIZA(DV.VizaId,DV.VizaFileId,dbo.GET_SESSION(2))=DV.VizaId)
						--LEFT OUTER JOIN  dbo.DOCS_DIRECTIONS dir ON DV.VizaId = dir.DirectionVizaId 
				Where (DF.IsDeleted=0 or df.IsDeleted is null) 
						AND  NOT EXISTS(select FileInfoParentId from DOCS_FILEINFO where FileInfoParentId = FI.FileInfoId) 
						and (DF.IsReject=0 or DF.IsReject is null) and DF.FileDocId=@docId;
		end
            if(@selectType=3) --Select name - GetResponsePersonByOrgId() - Razilasma sxeminde 'Mesul sexs' - i qaytarir
                begin
                  SELECT   WP.WorkplaceId AS Id, ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '') + ISNULL(' ' + DO.DepartmentPositionName, '') /*+ ISNULL(' ' + DP.DepartmentName,'')*/ AS Name    
                  FROM DC_WORKPLACE AS WP   
                  INNER JOIN                           
                      DC_USER AS DU ON WP.WorkplaceUserId = DU.UserId   
                  INNER JOIN             
                      DC_PERSONNEL AS PE ON DU.UserPersonnelId = PE.PersonnelId   
                  INNER JOIN         
                    DC_DEPARTMENT AS DP ON WP.WorkplaceDepartmentId = DP.DepartmentId   
                  INNER JOIN    
                    DC_DEPARTMENT_POSITION AS DO ON WP.WorkplaceDepartmentPositionId = DO.DepartmentPositionId  
                  INNER JOIN DC_POSITION_GROUP pgroup ON pgroup.[PositionGroupId]=DO.PositionGroupId
                  WHERE  (    
                            (WP.WorkplaceOrganizationId=(select dbo.fnPropertyByWorkPlaceId(@workPlaceId,12))   AND DO.PositionGroupId in (1,7,2,3,33,34,35,36,5,6,9,10,13,14,26,17,25, 37, 38)) 
                  or 
                            (Exists(select * from DC_ORGANIZATION where  OrganizationTopId=1) AND DO.PositionGroupId in (1,7,2,3,33,34,35,36,5,26,6,9,37,38))          
                  or 
                            (EXISTS(select OrganizationId from DC_ORGANIZATION where OrganizationId=(select dbo.fnPropertyByWorkPlaceId(@workPlaceId,12)) AND (OrganizationTopId=WP.WorkplaceOrganizationId)) AND DO.PositionGroupId in (1,2,3,33,34,35,36,5,6,9,26,10,13,14,17,25)))  
                  AND 
                            PE.PersonnelStatus=1 order by pgroup.PositionGroupLevel
                end
            if(@selectType=4) --Select name - GetVizaByFileInfoId() - Razilasma sxeminde faylin viza ucun gonderildiyi sexsleri qaytarir
                begin
                  SELECT 
                         DV.VizaId,
                         DV.VizaDocId,
                         DV.VizaFileId,
                         DV.VizaOrderindex,
                         DBO.GET_PERSON(1,VizaWorkPlaceId) AS PersonFullName,
                         DV.VizaConfirmed,
                         DV.VizaSenderWorkPlaceId,
                         DF.FileCurrentVisaGroup,
                         dv.VizaNotes,
                         DV.VizaSenddate,
                         DV.VizaAgreementTypeId,
                         DV.VizaFromWorkflow
                  FROM DOCS_VIZA DV 
                  INNER JOIN
                        VW_DOC_FILES DF ON DV.VizaFileId=DF.FileId
                  where 
                        (DV.IsDeleted is null or DV.IsDeleted=0) and (DV.VizaFileId=(select FileId from DOCS_FILE where FileInfoId = @fileInfoId) and DV.VizaAgreementTypeId=1) 
						AND DV.VizaFromWorkflow!=2
                        order by DV.VizaOrderindex ,DV.VizaSenddate;
                end
            if(@selectType=5) --Select name - GetById() 
                begin
                   SELECT d.FileInfoId, 
                         d.FileInfoWorkplaceId, 
                         d.FileInfoParentId, 
                         d.FileInfoVersion, 
                         d.FileInfoType, 
                         d.FileInfoCapacity, 
                         d.FileInfoExtention, 
                         d.FileInfoInsertdate, 
                         d.FileInfoPath, 
                         d.FileInfoName, 
                         d.FileInfoGuId, 
                         d.FileInfoStatus, 
                         d.FileInfoBinary, 
                         d.FileInfoContent, 
                         d.FileInfoAttachmentCount, 
                         d.FileInfoCopiesCount, 
                         d.FileInfoPageCount ,
                         df.FileId,
                         df.FileIsMain
                   FROM dbo.DOCS_FILEINFO d
                   join docs_file df on df.FileInfoId  = d.FileInfoId
                   where d.FileInfoId = @fileInfoId
                END
	   IF (@selectType = 6)--Select name - GetMainFileByDocId()
	   BEGIN
		SELECT df2.FileInfoPath, df2.FileInfoName FROM dbo.DOCS_FILE df
		INNER JOIN dbo.DOCS_FILEINFO df2 ON df.FileInfoId = df2.FileInfoId
		WHERE df.FileIsMain = 1 AND df.IsDeleted=0 AND df.FileDocId = @docId;
	   END;
	   IF (@selectType = 7)--Select name - GetSignedFileByDocId()
	   BEGIN
			SELECT df3.EdocPath AS FileInfoPath, df2.FileInfoName FROM dbo.DOCS_FILE df
				INNER JOIN dbo.DOCS_FILEINFO df2 ON df.FileInfoId = df2.FileInfoId
				INNER JOIN	dbo.DOCS_FILESIGN df3 ON df2.FileInfoId = df3.FileInfoId	
			WHERE df.FileIsMain = 1 AND df.IsDeleted=0 AND df.FileDocId = @docId AND df.IsReject=0;
	   END;
   end -- Main
end

