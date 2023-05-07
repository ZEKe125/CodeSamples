using Project.Models;
using Project.Models.Domain.Entities;
using Project.Models.Requests.Entities;

namespace Project.Services.Interfaces
{
    public interface IEntityService
    {
        int Add(EntityAddRequest model, int userId);
        void Update(EntityUpdateRequest model, int userId);
        Paged<Entity> Pagination(int page, int pageSize);
        Paged<Entity> SearchPagination(int page, int pageSize, string query);
        void Delete(int id);
       
    }
}