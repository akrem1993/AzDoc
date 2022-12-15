using System.Web.Mvc;

namespace BLL.CoreInterfaces.Document
{
    public interface IReturnedDoc
    {
        ActionResult ReturnDocument(string description);
    }
}
