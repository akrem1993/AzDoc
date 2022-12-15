namespace Model.DB_Views
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class VW_DOCS_VIZA
    {
        [Key]
        [Column(Order = 0)]
        public int VizaId { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int VizaDocId { get; set; }

        [Key]
        [Column(Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int VizaFileId { get; set; }

        public int? VizaOrderindex { get; set; }

        [StringLength(250)]
        public string PersonFullName { get; set; }

        public byte? VizaConfirmed { get; set; }
        public DateTime? VizaSenddate { get; set; }
        public string VizaNotes { get; set; }

        [Key]
        [Column(Order = 3)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int VizaSenderWorkPlaceId { get; set; }

        public byte FileCurrentVisaGroup { get; set; }

        public int? VizaAgreementTypeId { get; set; }

        public int? VizaFromWorkflow { get; set; }
    }
}