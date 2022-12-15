using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace BLL.CoreInterfaces.Document
{
    public interface IRecognizableDoc
    {
        ActionResult RecognizedDocument(string description);
    }
}
