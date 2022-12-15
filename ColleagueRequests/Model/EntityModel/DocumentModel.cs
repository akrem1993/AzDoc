using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ColleagueRequests.Model.EntityModel
{
    public class DocumentModel
    {
        public int? DocId { get; set; }

        private DateTime? docEnterDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? DocEnterDate
        {
            get { return docEnterDate; }
            set { docEnterDate = value ?? DateTime.Now; }
        }

        public string DocNo { get; set; }

        public string VillageId { get; set; }

        private DateTime? docDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? DocDate
        {
            get { return docDate; }
            set { docDate = value ?? DateTime.Now; }
        }

        private DateTime? plannedDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? PlannedDate
        {
            get { return plannedDate; }
            set
            {
                plannedDate = (value == DateTime.MinValue ? null : value);
            }
        }

        private int? topicTypeId;

        public int? TopicTypeId
        {
            get => topicTypeId ?? -1;
            set => topicTypeId = value;
        }

        private int? whomAddressId;

        public int? WhomAddressId
        {
            get => whomAddressId ?? -1;
            set => whomAddressId = value;
        }

        private int? receivedFormId;

        public int? ReceivedFormId
        {
            get => receivedFormId ?? -1;
            set => receivedFormId = value;
        }

        private int? typeOfDocumentId;

        public int? TypeOfDocumentId
        {
            get => typeOfDocumentId ?? -1;
            set => typeOfDocumentId = value;
        }

        private int? executionStatusId;

        public int? ExecutionStatusId
        {
            get => executionStatusId ?? -1;
            set => executionStatusId = value;
        }

        private int? applytypeId;

        public int? ApplytypeId
        {
            get => applytypeId ?? -1;
            set => applytypeId = value;
        }
        private float? organizationId;

        public float? OrganizationId
        {
            get => organizationId ?? -1;
            set => organizationId = value;
        }

        private float? subordinateId;

        public float? SubordinateId
        {
            get => subordinateId ?? -1;
            set => subordinateId = value;
        }

        private int? subtitleId;

        public int? SubtitleId
        {
            get => subtitleId ?? -1;
            set => subtitleId = value;
        }


        private int? countryId;

        public int? CountryId
        {
            get => countryId ?? -1;
            set => countryId = value;
        }

        private int? regionId;

        public int? RegionId
        {
            get => regionId ?? -1;
            set => regionId = value;
        }

        public string SocialsId { get; set; }

        private int? representerId;

        public int? RepresenterId
        {
            get => representerId ?? -1;
            set => representerId = value;
        }



        private int colleaguesCount = 1;

        public int ColleaguesCount
        {
            get => colleaguesCount;
            set => colleaguesCount = value;
        }

        public string FirstName { get; set; }
        public string SurName { get; set; } 
        public string FatherName { get; set; }
        public string MobilePhone { get; set; }
        public string HomePhone { get; set; }

        public string Email { get; set; }
        public string Address { get; set; }

        public bool Corruption { get; set; }
        public bool Supervision { get; set; }
        public string ShortContent { get; set; }
        public int ColleagueTypeId { get; set; }

        public IEnumerable<AuthorModel> AuthorModels { get; set; }
        public IEnumerable<RelatedDocModel> RelatedDocModels { get; set; }
        public IEnumerable<Application> ApplicationModels { get; set; }
    }

    public class Application
    {
        public int? AppId { get; set; }
        public string DocEnterno { get; set; }
        public string AppFirstname { get; set; }
        public string AppSurname { get; set; }
        public string AppLastName { get; set; }
        public int AppCountryId { get; set; }
        public int AppRegionId { get; set; }
        public string CountryName { get; set; }
        public string RegionName { get; set; }

        public int VillageId { get; set; }

        public string VillageName { get; set; }
        public int? AppSosialStatusId { get; set; }
        public string SocialName { get; set; }
        public int AppRepresenterId { get; set; }
        public string RepresenterName { get; set; }
        public string AppAddress { get; set; }
        public string AppPhone { get; set; }
        public string AppEmail { get; set; }
        public int? AppFormType { get; set; }
        public string SosialStatus { get; set; }
        public int ColleagueType { get; set; }
    }
}