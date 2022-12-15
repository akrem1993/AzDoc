using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DOCS_APPLICATION : BaseEntity
    {
        public DOCS_APPLICATION()
        {
            this.DOCS_ApplicantDoc = new List<DOCS_APPLICANTDOC>();
        }

        [Key]
        public int AppId { get; set; }

        public int AppDocId { get; set; }

        public int? AppApplierTypeId { get; set; }

        [StringLength(100)]
        public string AppName { get; set; }

        [StringLength(100)]
        public string AppFirstname { get; set; }

        [StringLength(100)]
        public string AppSurname { get; set; }

        [StringLength(100)]
        public string AppLastName { get; set; }

        [StringLength(10)]
        public string AppVoin { get; set; }

        public int? AppYuridicalFormId { get; set; }

        [Column(TypeName = "date")]
        public DateTime? AppBirthdate { get; set; }

        public int? AppBirthCountryId { get; set; }

        public int? AppBirthRegionId { get; set; }

        public int? AppBirthDistrictId { get; set; }

        public int? AppSexId { get; set; }

        public int? AppFamilyStatusId { get; set; }

        public byte? AppIsCitizen { get; set; }

        public int? AppNationId { get; set; }

        public int? AppSosialStatusId { get; set; }

        public int? AppEducationLevelId { get; set; }

        [StringLength(200)]
        public string AppWorkingPlace { get; set; }

        [StringLength(200)]
        public string AppPosition { get; set; }

        [StringLength(50)]
        public string AppDocumentId { get; set; }

        public int? AppDocumentTypeId { get; set; }

        [StringLength(10)]
        public string AppDocumentSerie { get; set; }

        [StringLength(20)]
        public string AppDocumentNumber { get; set; }

        public int? AppDocumentCountryId { get; set; }

        [StringLength(200)]
        public string AppDocumentBy { get; set; }

        [Column(TypeName = "date")]
        public DateTime? AppDocumentDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? AppDocumentValidity { get; set; }

        public int? AppPhoneTypeId { get; set; }

        [StringLength(100)]
        public string AppPhonenumber { get; set; }

        [StringLength(100)]
        public string AppEmail { get; set; }

        [StringLength(10)]
        public string AppZip1 { get; set; }

        public int? AppCountry1Id { get; set; }

        public int? AppRegion1Id { get; set; }

        public int? AppDistrict1Id { get; set; }

        public string AppAddress1 { get; set; }

        [StringLength(10)]
        public string AppZip2 { get; set; }

        public int? AppCountry2Id { get; set; }

        public int? AppRegion2Id { get; set; }

        public int? AppDistrict2Id { get; set; }

        public string AppAddress2 { get; set; }

        [StringLength(10)]
        public string AppZip3 { get; set; }

        public int? AppCountry3Id { get; set; }

        public int? AppRegion3Id { get; set; }

        public int? AppDistrict3Id { get; set; }

        public string AppAddress3 { get; set; }

        public int? AppCitizenshipId { get; set; }

        public int? AppRepresenterId { get; set; }

        [StringLength(200)]
        public string AppRepresenterDocument { get; set; }

        public int? AppCezacekmeOrganizationId { get; set; }

        public byte? AppAnonymId { get; set; }

        [StringLength(100)]
        public string AppPhone1 { get; set; }

        [StringLength(100)]
        public string AppPhone2 { get; set; }

        [StringLength(100)]
        public string AppPhone3 { get; set; }

        [StringLength(100)]
        public string AppPhone4 { get; set; }

        [StringLength(100)]
        public string AppEmail1 { get; set; }

        [StringLength(100)]
        public string AppEmail2 { get; set; }

        public virtual DC_COUNTRY DC_COUNTRY { get; set; }

        public virtual DC_DOCUMENTTYPE DC_DOCUMENTTYPE { get; set; }

        public virtual DC_EDUCATIONLEVEL DC_EDUCATIONLEVEL { get; set; }

        public virtual DC_FAMILYSTATUS DC_FAMILYSTATUS { get; set; }

        public virtual DC_NATION DC_NATION { get; set; }

        public virtual DC_PHONETYPE DC_PHONETYPE { get; set; }

        public virtual DC_REGION DC_REGION { get; set; }

        public virtual DC_REGION DC_REGION1 { get; set; }

        public virtual DC_REGION DC_REGION2 { get; set; }

        public virtual DC_REPRESENTER DC_REPRESENTER { get; set; }

        public virtual DC_SEX DC_SEX { get; set; }

        public virtual DC_SOCIALSTATUS DC_SOCIALSTATUS { get; set; }

        public virtual DC_YURIDICALFORM DC_YURIDICALFORM { get; set; }

        public virtual DOC DOC { get; set; }

        public virtual VW_DOCUMENTS VW_DOCUMENTS { get; set; }
        public virtual ICollection<DOCS_APPLICANTDOC> DOCS_ApplicantDoc { get; set; }
    }
}