using AppCore.Interfaces;
using DocFileHelper.Modifier.Models.Interfaces;
using DocFileHelper.QrCreator.Models;
using Microsoft.Office.Interop.Word;
using System.IO;
using System.Reflection;

namespace DocFileHelper.Modifier.Services.DocX
{
    public class InteropService : BaseDocFileService, IModifiedDoc
    {
        public InteropService(IServerPath serverPath, string fileName) : base(serverPath, fileName)
        {
        }

        public void ModifyDoc(QrData qrData)
        {
            object miss = Missing.Value;

            Application app = new Application();
            object refTemp = FileLocation;

            var doc = app.Documents.Add(ref refTemp,
                ref miss,
                ref miss,
                ref miss);

            PageSetup page = doc.PageSetup;

            var height = page.PageHeight - 180;

            var imgLocation = SaveImage(qrData.ImageData);

            doc.Shapes.AddPicture(imgLocation,
                ref miss,
                true,
                0,
                height,
                65,
                65);

            doc.Saved = true;
            File.Delete((string)refTemp);
            doc.SaveAs2(refTemp);

            app.Quit();
        }

    }
}

