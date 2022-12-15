using System;
using System.ComponentModel.DataAnnotations;
using Model.Entity;

namespace Model.DB_Tables
{
    public partial class DOCS_ADDITION : BaseEntity
    {
        [Key]
        public int DocsAdditionId { get; set; }

        public int DocumentId { get; set; }

        public double? Field1 { get; set; }

        public double? Field2 { get; set; }

        public double? Field3 { get; set; }

        public double? Field4 { get; set; }

        public double? Field5 { get; set; }

        public string Field6 { get; set; }

        public string Field7 { get; set; }

        public string Field8 { get; set; }

        public string Field9 { get; set; }

        public string Field10 { get; set; }

        public DateTime? Field11 { get; set; }

        public DateTime? Field12 { get; set; }

        public DateTime? Field13 { get; set; }

        public DateTime? Field14 { get; set; }

        public DateTime? Field15 { get; set; }

        public bool? Field16 { get; set; }

        public bool? Field17 { get; set; }

        public double? Field18 { get; set; }

        public virtual DOC DOC { get; set; }
    }
}