using System;
using System.ComponentModel.DataAnnotations;

namespace Model.WorkSpace
{
    public class AuthorNote
    {
        public int AuthorNoteId { get; set; }

        [Required]
        public string AuthorNoteText { get; set; }

        public DateTime? AuthorNoteCreationDate { get; set; }
        public int DocId { get; set; }
        public int AuthorWorkPlaceId { get; set; }
        public bool IsShared { get; set; }
    }
}