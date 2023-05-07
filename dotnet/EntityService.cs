using Project.Data.Providers;
using Stripe;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Project.Data;
using Project.Models;
using Project.Models.Domain.Entities;
using Project.Models.Requests.Entities;
using Project.Services.Interfaces;
using Project.Models.Domain;


namespace Project.Services
{
    public class EntityService : IEntityService
    {

        IDataProvider _data = null;
        IBaseUserMapper _userMapper = null;
        public EntityService(IDataProvider data, IBaseUserMapper userMapper)
        {
            _data = data;
            _userMapper = userMapper;   
        }

        //public methods
        public int Add(EntityAddRequest model, int userId)
        {
            int id = 0;
            string procName = "[dbo].[Entities_Insert]";

            _data.ExecuteNonQuery(procName,
                inputParamMapper: delegate (SqlParameterCollection coll)
                {
                    AddCommonParams(model, coll);
                    coll.AddWithValue("@CreatedBy", userId);

                    //output parameter
                    SqlParameter idOut = new SqlParameter("@Id", SqlDbType.Int);
                    idOut.Direction = ParameterDirection.Output;
                    coll.Add(idOut);
                },
                returnParameters: delegate (SqlParameterCollection returnColl)
                {
                    object oId = returnColl[0].Value;
                    Int32.TryParse(oId.ToString(), out id);
                });

            return id;
        }

        public void Update(EntityUpdateRequest model, int userId)
        {
            string procName = "[dbo].[Entities_update]";
            _data.ExecuteNonQuery(procName,
                inputParamMapper: delegate (SqlParameterCollection coll)
                {
                    AddCommonParams(model, coll);
                    coll.AddWithValue("@ModifiedBy", userId);
                    coll.AddWithValue("@Id", model.Id);
                },
                returnParameters: null);

        }

        public void Delete(int id)
        {

            string procName = "[dbo].[Entities_Delete_ById]";
            _data.ExecuteNonQuery(procName,
                inputParamMapper: delegate (SqlParameterCollection paramCollection)
                {
                    paramCollection.AddWithValue("@Id", id);

                }, returnParameters: null);

        }
        public Paged<Entity> Pagination(int page, int pageSize)
        {
            Paged<Entity> pagedList = null;
            List<Entity> list = null;
            int totalCount = 0;

            string procName = "[dbo].[Entities_SelectAll]";

            _data.ExecuteCmd(procName,
                (param) =>
                {
                    param.AddWithValue("@PageIndex", page);
                    param.AddWithValue("@PageSize", pageSize);

                }, (reader, recordSetIndex) =>
                {
                    int index = 0;

                    Entity entity = MapEntity(reader, ref index);

                    totalCount = reader.GetSafeInt32(index);

                    if (list == null)
                    {
                        list = new List<Entity>();
                    }
                    list.Add(entity);
                });

            if (list != null)
            {
                pagedList = new Paged<Entity>(list, page, pageSize, totalCount);
            }

            return pagedList;
        }


        public Paged<Entity> SearchPagination(int page, int pageSize, string query)
        {
            Paged<Entity> pagedList = null;
            List<Entity> list = null;
            int totalCount = 0;

            string procName = "[dbo].[Entities_Search_Paginated]";

            _data.ExecuteCmd(procName,
                (param) =>
                {
                    param.AddWithValue("@PageIndex", page);
                    param.AddWithValue("@PageSize", pageSize);
                    param.AddWithValue("@Query", query);


                }, (reader, recordSetIndex) =>
                {
                    int index = 0;
                    Entity entity = MapEntity(reader, ref index);

                    totalCount = reader.GetSafeInt32(index);

                    if (list == null)
                    {
                        list = new List<Entity>();
                    }
                    list.Add(entity);
                });

            if (list != null)
            {
                pagedList = new Paged<Entity>(list, page, pageSize, totalCount);
            }



            return pagedList;
        }


        //private methods
        private static void AddCommonParams(EntityAddRequest model, SqlParameterCollection coll)
        {
            coll.AddWithValue("@Title", model.Title);
            coll.AddWithValue("@Description", model.Description);
            coll.AddWithValue("@Url", model.Url);
            coll.AddWithValue("@EntityTypeId", model.EntityTypeId);
            coll.AddWithValue("@CoverImageUrl", model.CoverImageUrl);
        }
        public Entity MapEntity(IDataReader reader, ref int index)
        {
            Entity entity = new Entity();

            entity.Id = reader.GetSafeInt32(index++);
            entity.Title = reader.GetSafeString(index++);
            entity.Description = reader.GetSafeString(index++);
            entity.Url = reader.GetSafeString(index++);

            entity.EntityType = new LookUp();
            entity.EntityType.Id = reader.GetSafeInt32(index++);
            entity.EntityType.Name = reader.GetSafeString(index++);

            entity.CoverImageUrl = reader.GetSafeString(index++);
            entity.DateCreated = reader.GetSafeDateTime(index++);
            entity.DateModified = reader.GetSafeDateTime(index++);
            entity.CreatedBy = _userMapper.MapUser(reader, ref index);
            entity.ModifiedBy = _userMapper.MapUser(reader, ref index);

            return entity;
        }

       
    }
}
