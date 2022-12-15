using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Document
{
    public interface IDocument
    {
        string DocEnterNo { get; set; }

        DateTime? DocEnterDate { get; set; }
    }

    public interface IDocumentBase
    {
        int FileSignatureStatus { get; set; }

        int DocDocumentStatusId { get; set; }

        string SignerPerson { get; set; }

        string ConfirmPerson { get; set; }

        int FileInfoId { get; set; }

        DateTime? SignTime { get; set; }
    }
}
