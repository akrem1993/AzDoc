namespace BLL.Models.Document.QrDocModel
{
    public interface IQrDocument : IDocumentBase
    {
        string Base64QrCode { get; set; }
    }
}
