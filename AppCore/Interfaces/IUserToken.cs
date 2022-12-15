namespace AppCore.Interfaces
{
    public interface IUserToken
    {
        string RequestToken { get; set; }
        int WorkPlaceId { get; set; }
        int DocId { get; set; }
    }
}
