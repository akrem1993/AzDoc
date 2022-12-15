using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppCore.Interfaces
{
    public interface IServerPath
    {
        string AppData { get; }

        string UploadTemp { get; }

        string QrImages { get; }

        string ServerPath { get; }

        string QrService { get; }
    }
}
