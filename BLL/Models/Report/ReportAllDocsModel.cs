using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportAllDocsModel
    {
        public int DocId { get; set; }   //Sənədin id-si
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime DocEnterDate { get; set; }  //Sənədin sistemdə qeydiyyat tarixi
        public string DocEnterno { get; set; }  //Sənədin sistemdə qeydiyyat nömrəsi
        public string DocumentStatusName { get; set; } // sənədin statusu
        public string DocResultName { get; set; } // muracietlere baxis veziyyeti
        public string EntryFromWhere { get; set; } //Sənəd hardan daxil olub qurumun adı
        public string EntryFromWho { get; set; } //Sənəd kimdən daxil olub
        public int?  ExecutionDays { get; set; }// icra muddeti teqvim gunu
        public string EntryFromWhoCitizenName { get; set; } //Sənəd hardan daxil olub vetendashin adı soyadi ata adi
        public string SocialName { get; set; }//Sənəd hardan daxil olub vetendashin sosial statusu
        public string TopicTypeName { get; set; } // Movzu 
        public string TopicName { get; set; } //Alt movzu
        public string FormName { get; set; } //Müraciətin daxil olma forması 
        public string ApplyTypeName { get; set; } //Müraciətin daxil olma forması
        public string ExecutorsName { get; set; }
        public string ExecutorsDepartments { get; set; }
        public string DocDescription { get; set; } //Sənədin qısa nəzmunu 
        public string RelationDocsJson { get; set; } //elaqeli senedler json
        public string IncomingDocsJson { get; set; } //elaqeli senedler json
        public RelationDocs Relationdocs { get; set; }
        public string VillageName { get; set; } //kend
        public string RegionName { get; set; } //sheher
        [NotMapped]
        public string TokenForDocId { get; set; }
       

        //yeni elave edilen properties

        public string DocDocno { get; set; }   //Sənədin nömrəsi
        public DateTime? DocDocDate { get; set; }   //Senedin tarixi
        public string ComplainedOfDocStructure { get; set; } //Shikayet olunan qurum
        public string ComplainedOfDocSubStructure { get; set; } //Shikayet olunan alt qurum
        public string ExecutorDepartment { get; set; }  //Sənədi icraci  struktur bölmə
        public string NotExecutedExecutorsName { get; set; } //senedin icracisi
        public string LastExecutorName { get; set; } //Sənədin icraçısı (şöbənin əməkdaşı)
        
        public string WhomAdressedCompany  { get; set; } //Gonderilen Teskilat
        
        public string WhomAdressedPerson  { get; set; } //Gonderilen sexs

        public string WhomAdress  { get; set; } //Kime unvanlanib
        
        public string Signer  { get; set; } //imzalayam shexs

        
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? PlannedDate { get; set; }  //Sənədin icra olunmalı olduğu tarix

        public string DirectionChangeNote { get; set; } // Uzadılma barədə qeyd

        public int? RemainingDay { get; set; }  //Sənədin icrasına qalan müddət 
        public byte? DocUndercontrolStatusId { get; set; } //Nəzarət
        public string DocUnderControlStatusValue { get; set; } 
        public string ReplyDocIds { get; set; }     //Cavab sənədlərinin id-si [ReplyDocIds]
        public string ReplyDocNumbers { get; set; } //Cavab sənədlərinin nömrəsi [ReplyDocNumbers]
                
        public string IncomingDocNumbers { get; set; } //Daxil olan sənədlərinin nömrəsi [ReplyDocNumbers]
        
        public string IncomingDocDates  { get; set; } //Daxil olan senedin tarixi
        public DateTime? ReplyDocDate { get; set; } //Cavab senedin tarixi
        public string ReplyDocStatus { get; set; } //cavab senedin statusu
        public int? LatelyExecutedDays { get; set; } // nece gun gecikme ile icra olunub
        public string RelationDocNumbers { get; set; }

        [NotMapped]
        public Dictionary<string, string> ReplyDocNumbersForView { get; set; }     // Cavab sənədlərinin tokenlə link şəkildə göstərilməsi
        public Dictionary<string, string> IncomingDocNumbersForView { get; set; }     // daxil olan sənədlərinin tokenlə link şəkildə göstərilməsi
        public Dictionary<string, string> IncomingDocDatesForView { get; set; }     // daxil olan sənədlərinin tokenlə link şəkildə göstərilməsi

        public Dictionary<string, string> RelationDocNumbersForView { get; set; }     // elaqeli sənədlərinin tokenlə link şəkildə göstərilməsi

        public ReportAllDocsModel()
        {
            ReplyDocNumbersForView = new Dictionary<string, string>();
            IncomingDocNumbersForView = new Dictionary<string, string>();
            IncomingDocDatesForView = new Dictionary<string, string>();

            RelationDocNumbersForView = new Dictionary<string, string>();
        }

        //public List<Application> Applications { get; set; }
        //Applications = new List<Application>();
        //public string NotExecutedExecutorsDepartment { get; set; }  //Sənədi icra etməyən struktur bölmə
        //public string NotExecutedExecutorsName { get; set; }  //Sənədi icra etməyən strukutru bölmədəki icraçının adı
        //public string ReplyDocIds { get; set; }     //Cavab sənədlərinin id-si
        //public string ReplyDocNumbers { get; set; }  //Cavab sənədlərinin nömrəsi
        //public string ReplyDocStatus { get; set; }

        //[NotMapped]
        //public Dictionary<string, string> ReplyDocNumbersForView { get; set; }     // Cavab sənədlərinin tokenlə link şəkildə göstərilməsi
        //public int? ReplyDocId { get; set; }

        //public string ReplyDocNumber { get; set; }

        //[Column(TypeName = "date")]
        //[DisplayFormat(DataFormatString = "d")]
        //public DateTime? PlannedDate { get; set; }  //Sənədin icra olunmalı olduğu tarix
        ////public int? RemainingDay { get; set; }  //Sənədin icrasına qalan müddət


        //public byte? DocControlStatusId { get; set; }
        //public byte? DocUndercontrolStatusId { get; set; }


        //public ReportInExecutionDocsModel()
        //{
        //    ReplyDocNumbersForView = new Dictionary<string, string>();
        //}

        //public int DocId { get; set; }   //Sənədin id-si
        //[Column(TypeName = "date")]
        //[DisplayFormat(DataFormatString = "d")]
        //public DateTime DocEnterDate { get; set; }  //Sənədin sistemdə qeydiyyat tarixi
        //public string DocEnterno { get; set; }  //Sənədin sistemdə qeydiyyat nömrəsi
        //public string DocDocno { get; set; }   //Sənədin özünün nömrəsi
        //public DateTime? DocDocDate { get; set; }   //Senedin öz tarixi
        //public string EntryFromWhere { get; set; } //Sənəd hardan daxil olub qurumun adı
        //public string EntryFromWho { get; set; } //Sənəd hardan daxil olub vetendashin adı soyadi ata adi
        //public string DocDescription { get; set; } //Sənədin qısa nəzmunu 
        //public string NotExecutedExecutorsDepartment { get; set; }  //Sənədi icra etməyən struktur bölmə
        //public string NotExecutedExecutorsName { get; set; }  //Sənədi icra etməyən strukutru bölmədəki icraçının adı
        //public string ReplyDocIds { get; set; }     //Cavab sənədlərinin id-si
        //public string ReplyDocNumbers { get; set; }  //Cavab sənədlərinin nömrəsi
        //public string ExecutorDepartment { get; set; }  //Sənədi icraci  struktur bölmə
        //public string ReplyDocStatus { get; set; }
        //public DateTime? ReplyDocDate { get; set; }
        //public int? LatelyExecutedDays { get; set; }

        //[NotMapped]
        //public Dictionary<string, string> ReplyDocNumbersForView { get; set; }     // Cavab sənədlərinin tokenlə link şəkildə göstərilməsi
        ////public int? ReplyDocId { get; set; }

        ////public string ReplyDocNumber { get; set; }

        //[Column(TypeName = "date")]
        //[DisplayFormat(DataFormatString = "d")]
        //public DateTime? PlannedDate { get; set; }  //Sənədin icra olunmalı olduğu tarix
        //public int? RemainingDay { get; set; }  //Sənədin icrasına qalan müddət
        //[NotMapped]
        //public string TokenForDocId { get; set; }


        //public byte? DocControlStatusId { get; set; }
        //public byte? DocUndercontrolStatusId { get; set; }

        //public string EntryFromWhoCitizenName { get; set; }  //Sənəd hardan daxil olub vetendashin adı soyadi ata adi
        //public string TopicTypeName { get; set; } // Movzu 
        //public string TopicName { get; set; } //Alt movzu
        //public string DocResultName { get; set; } //Müraciətlərə baxılmasının vəziyyəti
        //public string ComplainedOfDocStructure { get; set; } //Shikayet olunan qurum
        //public string ComplainedOfDocSubStructure { get; set; } //Shikayet olunan alt qurum
        ////public ReportAllDocsModel()
        ////{
        ////    ReplyDocNumbersForView = new Dictionary<string, string>();
        ////}

    }
}
