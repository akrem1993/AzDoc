using BLL.BaseAdapter;
using BLL.Common.Enums;
using BLL.Models.Document;
using LogHelpers;
using Model.DB_Views;
using Model.Models.File;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace BLL.CoreAdapters
{
    public class FileAdapter : AdapterBase
    {
        public FileAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public List<VW_DOC_FILES> GetByDocId(int? docId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetByDocId);

                return UnitOfWork.ExecuteProcedure<VW_DOC_FILES>("" +
                                                                  "[dbo].[spFileOperations]", parameters).Distinct().ToList();
            }
            catch(Exception)
            {
                throw;
            }
        }

        public DocsFileInfoModel GetFileInfoById(int fileInfoId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetFileInfoById);

                return UnitOfWork.ExecuteProcedure<DocsFileInfoModel>("[dbo].[spFileOperations]", parameters).FirstOrDefault();
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        public DocsFileInfoModel GetMainFileByDocId(int docId)
        {
            Log.AddInfo("GetFileInfoById", $"docId:{docId}", "BLL.FileAdapter.GetMainFileByDocId");
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetMainFileByDocId);

                return UnitOfWork.ExecuteProcedure<DocsFileInfoModel>("[dbo].[spFileOperations]", parameters).FirstOrDefault();
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FileAdapter.GetMainFileByDocId");
                throw;
            }
        }

        public DocsFileInfoModel GetSignedFileByDocId(int docId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetSignedFileByDocId);

                return UnitOfWork.ExecuteProcedure<DocsFileInfoModel>("[dbo].[spFileOperations]", parameters).FirstOrDefault();
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FileAdapter.GetSignedFileByDocId");
                throw;
            }
        }

        public int CreateOrChangeFile(DocsFileInfoModel docFileInfo, int parentFileInfoId, int docId, int workPlaceId, int docTypeId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId, ParameterDirection.InputOutput)
                    .Add("@docTypeId", docTypeId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@parentFileInfoId", parentFileInfoId)
                    .Add("@fileInfoPath", docFileInfo.FileInfoPath)
                    .Add("@fileInfoName", docFileInfo.FileInfoName)
                    .Add("@fileInfoGuId", docFileInfo.FileInfoGuId)
                    .Add("@fileInfoCapacity", docFileInfo.FileInfoCapacity)
                    .Add("@fileExtractedText", docFileInfo.FileExtractedText)
                    .Add("@result", 0, ParameterDirection.InputOutput)
                    .Add("@fileInfoExtention", docFileInfo.FileInfoExtention);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[CreateOrChangeFile]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@docId")?.Value);
            }
            catch(Exception tr)
            {
                throw;
            }
        }

        public bool FileInfoUpdate(int fileInfoId, int page, int copy)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@page", page)
                    .Add("@copy", copy)
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spFileInfoUpdate]", parameters);

                return Convert.ToInt16(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value) == 1;
            }
            catch(Exception)
            {
                throw;
            }
        }

        public bool DefaultAgreementScheme(int fileInfoId, string answerDocIds, int relatedDocId, int? signerWorkPlaceId, int workPlaceId, int docTypeId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@answerDocIds", answerDocIds)
                    .Add("@relatedDocId", relatedDocId)
                    .Add("@signerWorkPlaceId", signerWorkPlaceId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docTypeId", docTypeId)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spDefaultAgreementScheme]", parameters);

                return Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value) == 1;
            }
            catch(Exception)
            {
                throw;
            }
        }

        public int AddSignedFilesInfo(int docId, int workPlaceId, int userId, int signatureTypeId, string eDocFilePath, string signatureNote)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@userId", userId)
                    .Add("@signatureTypeId", signatureTypeId)
                    .Add("@eDocFilePath", eDocFilePath)
                    .Add("@signatureNote", signatureNote)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[AddSignedFilesInfo]", parameters);

                return Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value);
            }
            catch(Exception)
            {
                throw;
            }
        }

        public bool DeleteFile(int fileInfoId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spDeleteDocFile]", parameters);

                return Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value) == 1;
            }
            catch(Exception)
            {
                throw;
            }
        }

        public int GetFileInfoIdByDocId(int fileInfoId)
        {
            try
            {
                return UnitOfWork.ExecuteScalar<int>("select [dbo].[fnGetDocIdByFileInfoId] (@fileInfoId)",
                    Extension.Init().Add("@fileInfoId", fileInfoId));
            }
            catch
            {
                throw;
            }
        }
    }
}