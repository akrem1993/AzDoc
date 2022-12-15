using AppCore.Interfaces;
using DocFileHelper.Modifier.Models.Interfaces;
using DocFileHelper.QrCreator.Models;
using Spire.Doc;
using Spire.Doc.Documents;
using Spire.Doc.Fields;

namespace DocFileHelper.Modifier.Services.DocX
{
    public class SpireService : BaseDocFileService, IModifiedDoc
    {
        public SpireService(IServerPath serverPath, string fileName) : base(serverPath, fileName) { }

        public void ModifyDoc(QrData qrData)
        {
            Document document = new Document(FileLocation);
            using (document)
            {
                DocPicture pic = document.Sections[0].Paragraphs[0].AppendPicture(qrData.ImageData);

                pic.Width = pic.Height = 65;
                pic.HorizontalPosition = 0f;

                pic.TextWrappingStyle = TextWrappingStyle.TopAndBottom;

                pic.HorizontalOrigin = HorizontalOrigin.Margin;
                pic.HorizontalAlignment = ShapeHorizontalAlignment.Left;

                pic.VerticalOrigin = VerticalOrigin.Margin;
                pic.VerticalAlignment = ShapeVerticalAlignment.Bottom;

                pic.TextWrappingStyle = TextWrappingStyle.Through;

                document.SaveToFile(FileLocation, FileFormat.Docx);

                document.Close();
            }
        }
    }
}
