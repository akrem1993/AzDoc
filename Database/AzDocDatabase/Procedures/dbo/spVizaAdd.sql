/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spVizaAdd]
@isDeleted bit=0, 
@vizaDocId int,
@vizaFileId int,
@vizaConfirmed tinyint=0,
@vizaOrderIndex int,
@vizaSendDate datetime,
@vizaWorkPlaceId int,
@vizaAgreementTypeId int =1,
@vizaSenderWorkPlaceId int,
@vizaFromWorkFlow int,
@result int OUTPUT

WITH EXEC AS CALLER
AS

DECLARE @vizaPersonelId int --Shahriyar elave etdi;
SELECT @vizaPersonelId=dp.PersonnelId
FROM dbo.DC_WORKPLACE dw
     JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
     JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
WHERE dw.WorkplaceId = @vizaWorkPlaceId;

declare @viza int; 
declare @fileId int;
declare @vizaId int;
declare @docDocumentOldStatusId int=null;
declare @Row table(VizaWorkPlaceId int not null, IsDeleted bit not null);
declare @File table(FileCurrentVisaGroup int not null, FileVisaStatus int not null);

    insert @Row -- Fayla aid bütün vizaların siyahısı
    select dv.VizaWorkPlaceId, dv.IsDeleted from DOCS_VIZA dv
    where dv.VizaFileId = @vizaFileId AND dv.IsDeleted=0 AND dv.VizaFromWorkflow!=2;
   
    select 
  @viza = count(0) 
 from 
  @Row r 
 where r.VizaWorkPlaceId=@vizaWorkPlaceId and 
    r.IsDeleted = 0 -- Fayl üzərində daxil edilən şəxsin daha öncə vizaya qoyulduqu yoxlanılır
    
    if ((select count(0) from @Row) = 0 and @vizaOrderIndex!=1)
    BEGIN
        set @result = -1; --Qrup nömrəsini düzgün daxil edin
	--THROW 51000, 'Qrup nömrəsini düzgün daxil edin', 1;
    end;
    
    if (@viza = 0)  -- Əgər sənədin heç bir vizası yoxdursa və ya şəxs əlavə edilməyibsə daha öncə
        begin 

            insert @File -- Viza qoyulan fayl
            select 
    df.FileCurrentVisaGroup, 
    df.FileVisaStatus 
      from 
    docs_file df
            where 
    df.FileId = @vizaFileId
            
            if  (select FileCurrentVisaGroup from @File) <= @vizaOrderIndex or @vizaOrderIndex = 0 -- Daxil edilən qrup nömrəsi ya cari qrupa bərabər yada ondan böyük olmalıdır
              begin 
                if((select FileVisaStatus from @File)=0) -- Faylın statusunu vizadadır deyə dəyişdiririk
                  begin 
                    update docs_file 
                    set FileVisaStatus = 1
                    where FileId = @vizaFileId;
                    
                    if ((select d.DocDocumentstatusId from docs d where d.DocId = @vizaDocId) <> 28)
                      begin 
                        set @docDocumentOldStatusId = (select d.DocDocumentstatusId from docs d where d.DocId = @vizaDocId)
                      end;
                      
                   -- update DOCS
                   -- set DocDocumentOldStatusId = @docDocumentOldStatusId, DocDocumentstatusId = 28
                   -- where DocId = @vizaDocId
                  end;
              end;
            
            insert into docs_viza (             
                    IsDeleted,
                    VizaDocId,
                    VizaFileId,
                    VizaSenddate,
                    VizaConfirmed,
                    VizaOrderindex,
                    VizaWorkPlaceId,
                    VizaFromWorkflow,
                    VizaAgreementTypeId,
                    VizaSenderWorkPlaceId,
					VizaPersonnelId--Shahriyar elave etdi
					)
            values(
                    @isDeleted, 
                    @vizaDocId,
                    @vizaFileId, 
                    @vizaSendDate, 
                    @vizaConfirmed,
                    @vizaOrderIndex, 
                    @vizaWorkPlaceId,  
                    @vizaFromWorkFlow,
                    @vizaAgreementTypeId, 
                    @vizaSenderWorkPlaceId,
					@vizaPersonelId --Shahriyar elave etdi
					)
            set @vizaId = scope_identity();   
            
           --exec dbo.spSendViza
           --  @fileId=@vizaFileId, 
           --  @vizaId=@vizaId, 
           --  @workPlaceId=@vizaSenderWorkPlaceId,
           --  @result=@result out;
             
           set @result = 1;
        end;
    else 
      begin 
        set @result = 0; -- Bu şəxs artıq mövcutdur
  --THROW 51000, 'Bu şəxs artıq mövcutdur', 1;
      end;

