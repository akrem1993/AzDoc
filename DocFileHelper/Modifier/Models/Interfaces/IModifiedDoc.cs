using DocFileHelper.QrCreator.Models;

namespace DocFileHelper.Modifier.Models.Interfaces
{
    public interface IModifiedDoc
    {
        void ModifyDoc(QrData qrData);
    }
}
