using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportForInformationDocsModel
    {
        public int DocId { get; set; } //Sənədin id-si

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime DocEnterDate { get; set; } //Sənədin sistemdə qeydiyyat tarixi

        public string DocEnterno { get; set; } //Sənədin sistemdə qeydiyyat nömrəsi
        public string DocumentStatusName { get; set; } // sənədin statusu
        public string EntryFromWhere { get; set; } //Sənəd hardan daxil olub qurumun adı
        public string EntryFromWhoCitizenName { get; set; } //Sənəd hardan daxil olub vetendashin adı soyadi ata adi
        public string SocialName { get; set; } //Sənəd hardan daxil olub vetendashin sosial statusu
        public string TopicTypeName { get; set; } // Movzu 
        public string TopicName { get; set; } //Alt movzu
        public string FormName { get; set; } //Müraciətin daxil olma forması 
        public string ApplyTypeName { get; set; } //Müraciətin daxil olma forması
        public string ExecutorsName { get; set; }
        public string ExecutorsDepartments { get; set; }
        public string DocDescription { get; set; } //Sənədin qısa nəzmunu 
        public string RelationDocsJson { get; set; } //elaqeli senedler json
        public RelationDocs Relationdocs { get; set; }
        public string VillageName { get; set; } //kend
        public string RegionName { get; set; } //sheher
        [NotMapped] public string TokenForDocId { get; set; }


        //yeni elave edilen properties

        public string DocDocno { get; set; } //Sənədin nömrəsi
        public DateTime? DocDocDate { get; set; } //Senedin tarixi
        public string ComplainedOfDocStructure { get; set; } //Shikayet olunan qurum
        public byte? DocUndercontrolStatusId { get; set; } //Nəzarət
        public string DocUnderControlStatusValue { get; set; }
        public string ComplainedOfDocSubStructure { get; set; } //Shikayet olunan alt qurum
        public string ExecutorDepartment { get; set; } //Sənədi icraci  struktur bölmə
        public string NotExecutedExecutorsName { get; set; } //senedin icracisi
        public string LastExecutorName { get; set; } //Sənədin icraçısı (şöbənin əməkdaşı)
        public string RelationDocNumbers { get; set; }
        public Dictionary<string, string>
            RelationDocNumbersForView
        { get; set; } // elaqeli sənədlərinin tokenlə link şəkildə göstərilməsi

        public ReportForInformationDocsModel()
        {
            RelationDocNumbersForView = new Dictionary<string, string>();
        }
    }
}