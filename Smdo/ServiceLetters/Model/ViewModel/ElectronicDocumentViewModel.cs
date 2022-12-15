using System;
using System.Collections.Generic;
using BLL.Models.Document;
using ServiceLetters.Model.EntityModel;

namespace ServiceLetters.Model.ViewModel
{
    public class ElectronicDocumentViewModel
    {
        public string DocTypeName { get; set; }
        public string DocEnterNo { get; set; }
        public DateTime? DocEnterDate { get; set; }
        public string DocDocNo { get; set; }
        public DateTime? DocDocDate { get; set; }
        public string Description { get; set; }
        public int DocDocumentStatusId { get; set; }
        public int FileInfoId { get; set; }
        public int DirectionTypeId { get; set; }
        public FileInfoModel FileInfoModel { get; set; }
        public IEnumerable<FileInfoModel> JsonFileInfoSelected { get; set; }
        public IEnumerable<FileInfoModel> JsonFileInfos { get; set; }
        public IEnumerable<OperationalHistory> JsonOperationHistory { get; set; }
        public IEnumerable<ChooseModel> JsonActionName { get; set; }

    }
}