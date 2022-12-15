namespace DocFileHelper.QrCreator.Models
{
    public class DocFile
    {
        public string FileName => FileGuid + FileExtension;
        public string FileExtension { get; set; }
        public string FileGuid { get; set; }
    }
}
