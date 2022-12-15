using AutoMapper;
using BLL.Models.Direction;
using BLL.Models.Direction.Direction;
using DMSModel;

namespace AzDoc
{
    public class MapperConfig
    {
        public static void Register()
        {
            Mapper.Initialize(config => {
                config.ValidateInlineMaps = false;
                config.AllowNullDestinationValues = true;
                config.CreateMissingTypeMaps = true;
                config.CreateMap<DOCS_EXECUTOR, ExecutorModel>().ReverseMap();
                config.CreateMap<DOCS_DIRECTIONS, DirectionModel>().ReverseMap();
                config.CreateMap<Journal.Model.EntityModel.DocumentModel, Journal.Model.EntityModel.DocumentModelDto>()
                .ForMember(ds=> ds.DocEnterInfo,opt=>opt.MapFrom(map=>$"{map.DocEnterNo}<br/>{map.DocEnterDate}"))
                .ForMember(ds => ds.Whom, opt => opt.MapFrom(map => $"{map.WhomAdressed}<br/>{map.SenderTo}"))
                .ForMember(ds => ds.NoteInfo, opt => opt.MapFrom(map => $"<ins><b>{map.UserName}</b></ins> &nbsp;{map.Note}<br/><b>{map.CreateDate}</b><br/><ins><b>{map.DeleteNote}</b></ins>"))
                .ForMember(ds => ds.EditNote, opt => opt.MapFrom(map => $"{map.DocId};{map.Note};{map.BlankNumber}"))
                .ReverseMap();
                config.CreateMap<Journal.Model.EntityModel.GridModel, Journal.Model.EntityModel.GridModelDto>()
                .ForMember(ds => ds.DocumentDateNumber, opt => opt.MapFrom(map => $"{map.DocumentNumber}<br/>{map.DocumentDate}"))
                .ForMember(ds => ds.DocEnterInfo, opt => opt.MapFrom(map => $"{map.DocEnterno}<br/>{map.DocEnterdate}"))
                .ForMember(ds => ds.EntryFromWho, opt => opt.MapFrom(map => $"{map.WhomAddress}<br/>{map.Sender}"))
                .ForMember(ds => ds.NoteInfo, opt => opt.MapFrom(map => $"<ins><b>{map.UserName}</b></ins> &nbsp;{map.Note}<br/><b>{map.CreateDate}"))
                .ForMember(ds => ds.EditNote, opt => opt.MapFrom(map => $"{map.DocId};{map.Note}"))
                .ForMember(ds => ds.DocDescription, opt => opt.MapFrom(map => $"{map.DocDescription1}<br/>{map.DocDescription2}"))
                .ForMember(ds => ds.Icra_haqqda_qeydN, opt => opt.MapFrom(map => $"{map.Icra_haqqda_qeyd}<br/>{map.Note1}"))
                .ReverseMap();

            });
        }
    }
}