using DMSModel;
using InsDoc.Common.Enums;
using InsDoc.Model.EntityModel;
using Model.DB_Views;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Custom = CustomHelpers;
using LogHelpers;

namespace InsDoc.Adapters
{
    public class FileAdapter : IDisposable
    {
        private readonly IUnitOfWork _unitOfWork;

        public FileAdapter(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
            Log.AddInfo("Init FileAdapter", $"unitOfWork:{unitOfWork}", "InsDoc.Adapters.FileAdapter.FileAdapter");
        }

        public List<VW_DOC_FILES> GetByDocId(int? docId)
        {
            Log.AddInfo("GetByDocId", $"docId:{docId}", "InsDoc.Adapters.FileAdapter.GetByDocId");
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetByDocId);

                return _unitOfWork.ExecuteProcedure<VW_DOC_FILES>("" +
                                                                  "[dbo].[spFileOperations]", parameters).ToList();
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.FileAdapter.GetByDocId");
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        public DOCS_FILEINFO GetFileInfoById(int fileInfoId)
        {
            Log.AddInfo("GetFileInfoById", $"fileInfoId:{fileInfoId}", "InsDoc.Adapters.FileAdapter.GetFileInfoById");
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetFileInfoById);

                return _unitOfWork.ExecuteProcedure<DOCS_FILEINFO>("" +
                                                                   "[dbo].[spFileOperations]", parameters).FirstOrDefault();
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.FileAdapter.GetFileInfoById");
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        public bool ChangeFile(DOCS_FILEINFO fileInfo, int oldFileInfoId, ref bool isMain, ref int oldFileId)
        {
            Log.AddInfo("ChangeFile", $"fileInfo:{fileInfo},oldFileInfoId:{oldFileInfoId},isMain:{isMain},oldFileId:{oldFileId}",
                                                                                           "InsDoc.Adapters.FileAdapter.ChangeFile");
            try
            {

                bool result = false;
                DOCS_FILEINFO oldFileInfo = _unitOfWork.GetRepository<DOCS_FILEINFO>().GetById(oldFileInfoId);

                DOCS_FILE oldDocsFile = oldFileInfo.DOCS_FILE.FirstOrDefault();
                oldFileId = oldDocsFile.FileId;

                fileInfo.FileInfoParentId = oldFileInfoId;
                fileInfo.FileInfoVersion = (byte)(oldFileInfo.FileInfoVersion + 1);
                fileInfo.FileInfoCopiesCount = oldFileInfo.FileInfoCopiesCount;
                fileInfo.FileInfoPageCount = oldFileInfo.FileInfoPageCount;
                fileInfo.FileInfoAttachmentCount = oldFileInfo.FileInfoAttachmentCount;
                isMain = oldFileInfo.DOCS_FILE.FirstOrDefault().FileIsMain;

                ChangeFileInfo(fileInfo, ref result);

                return result;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.FileAdapter.ChangeFile");
                throw ex;
            }
        }

        public bool Add(int docId, int parentId, DOCS_FILEINFO fileInfo)
        {
            Log.AddInfo("Add", $"docId:{docId},parentId:{parentId},fileInfo:{fileInfo}", "InsDoc.Adapters.FileAdapter.Add");
            try
            {
                bool result;
                int oldFileId = 0;
                bool isMain = false;

                if (parentId != -1)
                {
                    result = ChangeFile(fileInfo, parentId, ref isMain, ref oldFileId);
                }
                else
                {
                    result = AddFileInfo(fileInfo); // melumatlari DOCS_FILEINFO cedveline insert edirik
                }

                DOCS_FILE newDocsFile;

                if (result)
                {
                    newDocsFile = new DOCS_FILE
                    {
                        IsReject = false,
                        IsDeleted = false,
                        FileName = fileInfo.FileInfoName,
                        FileDocId = docId,
                        FileIsMain = isMain,
                        FileCurrentVisaGroup = 1,
                        FileInfoId = fileInfo.FileInfoId,
                        FileVisaStatus = (byte)Custom.VizaStatus.NotViza,
                        SignatureStatusId = (int)Custom.SignatureStatus.NotSigned
                    };

                    AddDocsFile(newDocsFile, parentId, out result);

                    //if (parentId != -1)
                    //{
                    //    //Fayli deyisende kohne senedin vizalari yeni senede elave olunur ve vizanin neticeleri sifirlanir
                    //    VizaAdapter vizaAdapter = new VizaAdapter(_unitOfWork);

                    //    using (vizaAdapter)
                    //    {
                    //        var _viza = vizaAdapter.Get(t => t.VizaDocId == docId && t.VizaFileId == oldFileId).OrderBy(t => t.VizaOrderindex).ToList();

                    //        //En kicik qrup nomresi tapilir
                    //        var minVizaOrderIndex = _viza.Min(t => t.VizaOrderindex);

                    //        for (int i = 0; i < _viza.Count; i++)
                    //        {
                    //            int vizaID = _viza[i].VizaId;

                    //            var newViza = _viza[i];
                    //            //newViza.VizaFileId = newDocsFile.FileId;
                    //            newViza.VizaSenddate = DateTime.Now;
                    //            newViza.VizaConfirmed = (int)Custom.VizaConfirmed.IsViza;
                    //            vizaAdapter.Add(newViza);

                    //            using (DirectionAdapter directionAdapter = new DirectionAdapter(_unitOfWork))
                    //            {
                    //                var _directions = directionAdapter.GetAll(x => x.DirectionVizaId == vizaID && x.DirectionTypeId == (int)Custom.DirectionType.Viza).ToList();

                    //                //En kicik qrup nomresi olanlar direction cedveline insert edilir
                    //                if (_viza[i].VizaOrderindex == minVizaOrderIndex)
                    //                {
                    //                    //Fayli deyisende kohne faylin Derkanar ve Icracilari yeni fayla elave edilir
                    //                    _directions.ForEach(x =>
                    //                    {
                    //                        x.DirectionVizaId = newViza.VizaId;
                    //                        x.DirectionInsertedDate = DateTime.Now;
                    //                        var exec = x.DOCS_EXECUTOR.ToList();
                    //                        x.DirectionId = 0;
                    //                        directionAdapter.Add(x);
                    //                    });
                    //                }

                    //                var olderDirections = directionAdapter.GetAll(x => x.DirectionVizaId == vizaID && x.DirectionTypeId == (int)Custom.DirectionType.Viza).ToList();

                    //                //Kohne fayla aid olan derkenar ve icracilar silinir
                    //                olderDirections.ForEach(x => { directionAdapter.Delete(x, x.DOCS_EXECUTOR.ToList()); });
                    //            }
                    //        }
                    //    }
                    //}
                    //else
                    //{
                    //    using (VizaAdapter vizaAdapter = new VizaAdapter(_unitOfWork))
                    //    {
                    //        var viza = vizaAdapter.Get(t => t.VizaDocId == docId && t.VizaAgreementTypeId == (int)Custom.VizaAgreementType.Agreement)
                    //            .OrderByDescending(t => t.VizaId)
                    //            .FirstOrDefault();

                    //        if (viza != null)
                    //        {
                    //            viza.VizaFileId = newDocsFile.FileId;
                    //            _unitOfWork.GetRepository<DOCS_VIZA>().Update(viza);
                    //        }
                    //    }
                    //}
                }

                return result;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.FileAdapter.Add");
                throw ex;
            }
        }

        private bool AddFileInfo(DOCS_FILEINFO fileInfo)
        {
            Log.AddInfo("AddFileInfo", $"fileInfo:{fileInfo}", "InsDoc.Adapters.FileAdapter.AddFileInfo");
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoGuId", fileInfo.FileInfoGuId)
                    .Add("@fileInfoName", fileInfo.FileInfoName)
                    .Add("@fileInfoPath", fileInfo.FileInfoPath)
                    .Add("@fileInfoVersion", fileInfo.FileInfoVersion)
                    .Add("@fileInfoInsertdate", fileInfo.FileInfoInsertdate)
                    .Add("@fileInfoWorkplaceId", fileInfo.FileInfoWorkplaceId)
                    .Add("@fileInfoId", 0, ParameterDirection.InputOutput)
                    .Add("@fileInfoExtention", fileInfo.FileInfoExtention)
                    .Add("@fileInfoCapacity", fileInfo.FileInfoCapacity ?? 0)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spAddFileInfo]", parameters);

                fileInfo.FileInfoId = Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@fileInfoId")?.Value);
                return Convert.ToInt16(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value) == 1;
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.FileAdapter.AddFileInfo");
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        private void ChangeFileInfo(DOCS_FILEINFO fileInfo, ref bool result)
        {
            Log.AddInfo("ChangeFileInfo", $"fileInfo:{fileInfo}", "InsDoc.Adapters.FileAdapter.ChangeFileInfo");
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoGuId", fileInfo.FileInfoGuId)
                    .Add("@fileInfoName", fileInfo.FileInfoName)
                    .Add("@fileInfoPath", fileInfo.FileInfoPath)
                    .Add("@fileInfoVersion", fileInfo.FileInfoVersion)
                    .Add("@fileInfoParentId", fileInfo.FileInfoParentId)
                    .Add("@fileInfoPageCount", fileInfo.FileInfoPageCount)
                    .Add("@fileInfoInsertdate", fileInfo.FileInfoInsertdate)
                    .Add("@fileInfoWorkplaceId", fileInfo.FileInfoWorkplaceId)
                    .Add("@fileInfoCopiesCount", fileInfo.FileInfoCopiesCount)
                    .Add("@fileInfoExtention", fileInfo.FileInfoExtention)
                    .Add("@fileInfoCapacity", fileInfo.FileInfoCapacity)
                    .Add("@fileInfoId", 0, ParameterDirection.InputOutput)
                    .Add("@fileInfoAttachmentCount", fileInfo.FileInfoAttachmentCount)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spChangeFileInfo]", parameters);

                fileInfo.FileInfoId = Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@fileInfoId")?.Value);
                result = Convert.ToInt16(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value) == 1;
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.FileAdapter.ChangeFileInfo");
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        private void AddDocsFile(DOCS_FILE docsFile, int parentId, out bool result)
        {
            Log.AddInfo("AddDocsFile", $"docsFile:{docsFile},parentId:{parentId}", "InsDoc.Adapters.FileAdapter.AddDocsFile");
            try
            {
                var parameters = Extension.Init()
                    .Add("@isReject", docsFile.IsReject)
                    .Add("@isDeleted", docsFile.IsDeleted)
                    .Add("@fileDocId", docsFile.FileDocId)
                    .Add("@fileIsMain", docsFile.FileIsMain)
                    .Add("@fileInfoId", docsFile.FileInfoId)
                    .Add("@fileVisaStatus", docsFile.FileVisaStatus)
                    .Add("@signatureStatusId", docsFile.SignatureStatusId)
                    .Add("@fileCurrentVisaGroup", docsFile.FileCurrentVisaGroup)
                    .Add("@parentId", parentId)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spAddDocsFile]", parameters);

                result = Convert.ToInt16(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value) == 1;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.FileAdapter.AddDocsFile");
                throw new Exception(ex.InnerException?.ToString());
            }
        }

        public bool FileInfoUpdate(int fileInfoId, int page, int copy)
        {
            Log.AddInfo("FileInfoUpdate", $"fileInfoId:{fileInfoId},page:{page},copy:{copy}", 
                                                 "InsDoc.Adapters.FileAdapter.FileInfoUpdate");
            try
            {
                var parameters = Extension.Init()
                    .Add("@page", page)
                    .Add("@copy", copy)
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spFileInfoUpdate]", parameters);

                return Convert.ToInt16(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value) == 1;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.FileAdapter.FileInfoUpdate");
                throw new Exception(ex.InnerException?.ToString());
            }
        }

        public bool DefaultAgreementScheme(int fileInfoId, int workPlaceId, int currentDocId, int docTypeId)
        {
            Log.AddInfo("DefaultAgreementScheme", $"fileInfoId:{fileInfoId},workPlaceId:{workPlaceId},currentDocId:{currentDocId},docTypeId:{docTypeId}", 
                                                                                                   "InsDoc.Adapters.FileAdapter.DefaultAgreementScheme");
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@currentDocId", currentDocId)
                    .Add("@docTypeId", 3)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spDefaultAgreementScheme]", parameters);
                int a = Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value);
                return true; //Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.FileAdapter.DefaultAgreementScheme");
                throw new Exception(ex.InnerException?.ToString());
            }
        }

        public bool DeleteFile(int fileInfoId)
        {
            Log.AddInfo("DeleteFile", $"fileInfoId:{fileInfoId}", "InsDoc.Adapters.FileAdapter.DeleteFile");
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spDeleteDocFile]", parameters);

                return Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value) == 1;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.FileAdapter.DeleteFile");
                throw new Exception(ex.InnerException?.ToString());
            }
        }

        public List<ChooseModel> GetResPersonByOrgId(int? workPlaceId)
        {
            Log.AddError("GetResPersonByOrgId", $"workPlaceId:{workPlaceId}", "InsDoc.Adapters.FileAdapter.GetResPersonByOrgId");
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetResPersonByOrgId);

                return _unitOfWork.ExecuteProcedure<ChooseModel>("" +
                                                                  "[dbo].[spFileOperations]", parameters).ToList();
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.FileAdapter.GetResPersonByOrgId");
                throw new Exception(exception.InnerException?.ToString());
            }
        }
        public void Dispose()
        {
                _unitOfWork?.Dispose();
        }
    }
}