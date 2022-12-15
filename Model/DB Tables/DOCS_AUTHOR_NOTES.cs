using Model.Entity;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DMSModel
{
    public class DOCS_AUTHOR_NOTES : BaseEntity
    {
        [Key]
        public int AuthorNoteId { get; set; }

        public string AuthorNoteText { get; set; }

        [Column(TypeName = "date")]
        public DateTime? AuthorNoteCreationDate { get; set; }

        public int AuthorNoteDocId { get; set; }
        public int AuthorWorkplaceId { get; set; }
        public bool AuthorNoteIsShared { get; set; }
    }
}