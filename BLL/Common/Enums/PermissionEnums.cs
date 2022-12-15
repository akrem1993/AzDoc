using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Common.Enums
{
    public enum RightType
    {
        None = -1,
        View = 1,
        CreateDoc = 2,
        EditDoc = 3,
        RegistrationPaper = 4,
        Answer = 5,
        EDocument = 6,
        Resolution = 7,
        SendToPerson = 8,
        ExecutionStatus = 9,
        MenuDocument = 10,
        MenuAdminPanel = 11,
        MenuService = 12,
        DocumentNumberEdit = 13,
        Reserve = 14,
        MistakenDocument = 15,
        Mailed = 16,
        ReturnDocument = 17,
        PrintDoc = 18,
        SendForResolution = 19,
        ControlledDocument = 20,
        SignerNotEImza = 21,
        VizaNotRequired = 22,
        ReceiveMail = 23,
        GeneralDepartment = 24,
        AddDocumentCustom = 25,
        Moderator=26,
        //
        //
        UnConfirmedresolution=29,
        DisposeDocument=30,
        CallCenter=31,
        //
        //
        //
        //
        InfoAndExecution=35,
        Info = 36,
        InfoAndTrack = 37,
        SignDocument = 38,
        ConfirmResolution = 38,
        ChangeExecutionTime =39,
        ChangeExecutor=40,

        
        ConfirmDocument = 25,
        Execute = 25,

        AcceptViza = 23,

        
        Confirm = 43,
        Execution = 44,
        CreateDirection = 45,

    }

    public enum Right
    {
        Yes = 0,
        CreatePersonelDocument = 1,
        SendToPerson = 2,
        CreateSector = 3,
        SendSector = 4,
        CreateSection = 5,
        SendSection = 6,
        CreateDepartament = 8,
        SendDepartament = 9,
        CreateTopDepartament = 10,
        SendTopDepartament = 11,
        ViewControl = 28,
        AllDocument = 32,
        AllDocumentOrganization = 32
    }

    public enum OperationType
    {
        CaseMenu = 1,
        Document = 2,
        ControlWindow = 3,
        TopMenu = 4,
        Handbook = 5,
        Other = 6,
        Report = 7
    }
}
