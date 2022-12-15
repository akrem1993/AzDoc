
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Smdo.Enums
{
    public enum MailType
    {
        Mail,
        Kvitansiya
    }

    public enum AttachType
    {
        Xml,
        Other
    }

    
    public enum DocReceived
    {
        Sended = 0,
        Received =1
    }


    public enum DocStatus
    {
        Draft = 1,
        Signed,
        Sended,
        Received,
        ConfirmedDts
    }


    public enum DtsStep
    {
        Initialize=1,
        UploadSignedFile,
        UploadDataFile,
        DownloadDvc,
        ParseDvc
    }


}
