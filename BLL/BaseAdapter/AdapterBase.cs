using BLL.Common.Enums;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using BLL.Models.Document;

namespace BLL.BaseAdapter
{

    public abstract class AdapterBase : IDisposable
    {
        protected readonly IUnitOfWork UnitOfWork;
        protected AdapterBase(IUnitOfWork unitOfWork) => UnitOfWork = unitOfWork;

        public void ExecuteDbActionsAsync(params Action[] actions)
        {
            UnitOfWork.ExecuteAllCommandTasks(actions);
        }
        
        protected static List<DocumentGroupModel> DocumentGroupModels = new List<DocumentGroupModel>()
        {
            new DocumentGroupModel {DocTypeGroupName = "Daxil olan", TreeName = "Təşkilat müraciətləri", DocTypeId = 1},
            new DocumentGroupModel {DocTypeGroupName = "Daxil olan", TreeName = "Vətəndaş müraciətləri", DocTypeId = 2},
            new DocumentGroupModel {DocTypeGroupName = "Göndərilən", TreeName = "Xaric olan sənədlər", DocTypeId = 12},
            new DocumentGroupModel
                {DocTypeGroupName = "Struktur daxili", TreeName = "Sərəncamverici sənədlər", DocTypeId = 3},
            new DocumentGroupModel
                {DocTypeGroupName = "Struktur daxili", TreeName = "Xidməti məktublar", DocTypeId = 18},
            new DocumentGroupModel {DocTypeGroupName = "Struktur daxili", TreeName = "Tapşırıqlar", DocTypeId = 7},
            new DocumentGroupModel
                {DocTypeGroupName = "Struktur daxili", TreeName = "Təşkilati sənədlər", DocTypeId = 23},
            new DocumentGroupModel
                {DocTypeGroupName = "Struktur daxili", TreeName = "Məlumat-arayış sənədləri", DocTypeId = 22},
            new DocumentGroupModel {DocTypeGroupName = "Struktur daxili", TreeName = "Ərizələr", DocTypeId = 24},
            new DocumentGroupModel {DocTypeGroupName = "Daxil olan", TreeName = "Əməkdaş müraciətləri", DocTypeId = 27},
            new DocumentGroupModel {DocTypeGroupName = "Sənəd növləri", TreeName = "Oxunmamış sənədlər", DocTypeId = -1}
        };

        public string GetDocSchema(int docType)
        {
            switch (docType)
            {
                case 2: return "citizenrequests";
                case 1: return "orgrequests";
                case 3: return "dms_insdoc";
                case 12: return "outgoingdoc";
                case 18: return "serviceletters";
                case 27: return "colleaguerequests";

                default: return string.Empty;
            }
        }

        public string GetDocSchema(DocType docType) => GetDocSchema((int)docType);

        public virtual void Dispose() => GC.SuppressFinalize(this);
    }
}
