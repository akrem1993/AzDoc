using System;
using System.Collections.Generic;
using System.Web.Mvc;
using CustomHelpers.Attributes;
using Model.DB_Tables;

namespace BLL.Models.Direction.Direction
{
    public class DirectionModel
    {
        public int DirectionId { get; set; }
        public int DirectionDocId { get; set; }
        public DateTime DirectionDate { get; set; }
        public int DirectionWorkplaceId { get; set; }
        public string DirectionPersonFullName { get; set; }
        public int DirectionTemplateId { get; set; }
        public int DirectionTypeId { get; set; }
        public bool DirectionControlStatus { get; set; }
        public DateTime? DirectionPlanneddate { get; set; }

        public int DirectionVizaId { get; set; }
        public byte DirectionConfirmed { get; set; }
        public bool DirectionSendStatus { get; set; }
        public int? DirectionCreatorWorkplaceId { get; set; }
        public DateTime DirectionInsertedDate { get; set; }
        public int DirectionPersonId { get; set; }
        public System.Int64 DirectionUnixTime { get; set; }

        public DocumentModel DOC { get; set; }
        public List<ExecutorModel> Executors { get; set; }
        public List<ExecutorModel> AvailableExecutors { get; set; }
        public List<SelectListItem> Authors { get; set; }

        public int DirectionInfoChangesType { get; set; }
        public bool[] ExecutionTypes { get; set; }
        public int AuthorPositionGroupId { get; set; }
        public string ExecutorGroupId { get; set; }
  
        public string TabId { get; set; }



    }

    public class DocumentModel
    {
        public int DocId { get; set; }
        public string DocEnterno { get; set; }
        public DateTime? DocEnterdate { get; set; }
       
        public string DocInfo { get; set; }
        public int DirectionWorkplaceId { get; set; }

        public int DocTypeId { get; set; }
        public string DocTypeName { get; set; }
        public string DocEnterdateFormat { get; set; }
        public string DocDescription { get; set; }
        public int? DocDocumentstatusId { get; set; }

        public Int32? DocControlStatusId { get; set; }
        public int? DocUndercontrolStatusId { get; set; }        

        public DOC DOC { get; set; }

        public DateTime? DocPlanneddate { get; set; }
        public List<DirectionModel> Directions { get; set; }

        public bool Visible { get; set; }
        public string Position { get; set; }
        public int? DocSendStatus { get; set; }
        public int? DocConfirmed { get; set; }
        public int DirectionTypeId { get; set; }
        public int? DocExecutionStatusId { get; set; }
        public int? DocExecutionStatus { get; set; }

        //public int DirectionConfirmed { get; set; }
    }
    public class ExecutorModel
    {
        public int ExecutorId { get; set; }
        [NoUddtColumn]
        public int? PositionIndicator { get; set; }

        public int ExecutorDirectionId { get; set; }

        public int ExecutorDocId { get; set; }

        public int ExecutorWorkplaceId { get; set; }

        public string ExecutorFullName { get; set; }

        public byte ExecutorMain { get; set; }

        public int DirectionTypeId { get; set; }

        public int? ExecutorOrganizationId { get; set; }

        public int? ExecutorTopDepartment { get; set; }

        public int? ExecutorDepartment { get; set; }

        public int? ExecutorSection { get; set; }

        public int? ExecutorSubsection { get; set; }

        public int? ExecutorStepId { get; set; }

        public int? ExecutionstatusId { get; set; }

        public string ExecutorNote { get; set; }

        public bool ExecutorReadStatus { get; set; }

        public string ExecutorResolutionNote { get; set; }

        public int? SendStatusId { get; set; }


        public int ExecutorPositionGroupId { get; set; }

        public string DepartmentPositionName { get; set; }

        public int UserId { get; set; }
        public string UserName { get; set; }
        public int PersonelId { get; set; }
        public string PersonnelName { get; set; }
        public string PersonnelSurname { get; set; }
        public string PersonnelLastname { get; set; }

        public string DepartmentName { get; set; }

        public string OrganizationName { get; set; }
        public int? PositionGroupLevel { get; set; }
        public string SendStatusName { get; set; }
        public bool ExecutorControlStatus { get; set; }

        //public string FullName => PersonnelName + " " + PersonnelSurname;

        public override int GetHashCode()
        {
            return ExecutorWorkplaceId;
        }

        public override bool Equals(object obj)
        {
            return obj is ExecutorModel && Equals((ExecutorModel)obj);
        }

        public bool Equals(ExecutorModel p)
        {
            return ExecutorWorkplaceId == p.ExecutorWorkplaceId;
        }
    }
    public class AuthorModel
    {
        public int Id { get; set; }
     
        public int WorkplaceId { get; set; }

        public string FullName { get; set; }

     
    }
    public class DirectionPersonViewModel
    {
        public int ExecutorId { get; set; }
        public int WorkPlaceId { get; set; }
        public string PersonFullName { get; set; }
        public byte MainExecutor { get; set; }
        public int PositionGroupId { get; set; }
        public string DepartmentPositionName { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int PersonelId { get; set; }
        public string PersonnelName { get; set; }
        public string PersonnelSurname { get; set; }
        public string PersonnelLastname { get; set; }
        public int? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public int? OrganizationId { get; set; }
        public string OrganizationName { get; set; }
        public int? ExecutorTopDepartment { get; set; }
        public int? ExecutorSection { get; set; }
        public int? ExecutorSubSection { get; set; }
        public string ExecutorNote { get; set; }
        public string ExecutorResolutionNote { get; set; }
        public bool ExecutorReadStatus { get; set; }
        public int? PositionGroupLevel { get; set; }
        public int? SendStatusId { get; set; }
        public string SendStatusName { get; set; }
        public string FullName
        {
            get
            {
                return PersonnelName + " " + PersonnelSurname;
            }
        }
        public override int GetHashCode()
        {
            return WorkPlaceId;
        }

        public override bool Equals(object obj)
        {
            return obj is DirectionPersonViewModel && Equals((DirectionPersonViewModel)obj);
        }

        public bool Equals(DirectionPersonViewModel p)
        {
            return WorkPlaceId == p.WorkPlaceId;
        }
    }
    public class WorkplaceModel
    {
        public int WorkplaceId { get; set; }
        public string PersonnelName { get; set; }
        public string PersonnelSurname { get; set; }
        public string PersonnelLastname { get; set; }
        public string PersonnelFullname { get; set; }
        public int WorkplaceOrganizationId { get; set; }
        public int? DepartmentTopDepartmentId { get; set; }
        public int WorkplaceDepartmentId { get; set; }
        public int? DepartmentSectionId { get; set; }
        public int? DepartmentSubSectionId { get; set; }
        public string DepartmentPositionName { get; set; }
        public int PositionGroupLevel { get; set; }
        public int? DepartmentCode { get; set; }

    }
    public class DirAddRangeParameters
    {
        public List<DirectionPersonViewModel> PersonList { get; set; }
        public string Description { get; set; }
        public int DirectionTypeId { get; set; }
        public int DocId { get; set; }
        public int DirectionId { get; set; }
        public int AuthorId { get; set; }
        public DateTime ResolutionDate { get; set; }
        public int? ExecutionDay { get; set; }
        public bool ControlStatus { get; set; }
        public DateTime? ExecutionDate { get; set; }
        public Nullable<int> WorkplaceId { get; set; }
        public int SendStatusId { get; set; }
        public int? DirectionVizaId { get; set; }
    }
    public class PushNotify
    {
        public string NotifyId { get; set; }
        public int SendToUserId { get; set; }
        public int? SendFromUserId { get; set; }
        public string Data { get; set; }
        public int? NotificationTypeId { get; set; }
        public int? NotificationParentId { get; set; }
        public int? DocTypeId { get; set; }
    }

    public class AddressInfo
    {
        public int DocId { get; set; }
        public int DocDocumentstatusId { get; set; }
        public int DocDoctypeId { get; set; }
        public DateTime DocEnterdate { get; set; }
        public string DocEnterno { get; set; }
        public string DocTypeName { get; set; }
        public string OrganizationName { get; set; }
        public string AuthorName { get; set; }
        public string  PostionName { get; set; }
        public string DocDescription { get; set; }
        public byte DocUndercontrolStatusId { get; set; }
        public string SendToWhere { get; set; }
        public int DocExecutionStatusId { get; set; }



    }
    public class DirectionInfo
    {

        public string OldExecutor { get; set; }
        public string NewExecutor { get; set; }

        public DateTime? OldPlannedDate { get; set; }
        public DateTime NewPlannedDate { get; set; }
        public string ExecutorNote { get; set; }
        public int? SenderWorkplaceId { get; set; }
 

    }
}
