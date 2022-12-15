using System.Web.Mvc;

namespace BLL.CoreInterfaces.Document
{
    public interface ICanceledDoc
    {
        ActionResult CancelDocument(string description);
    }
}
