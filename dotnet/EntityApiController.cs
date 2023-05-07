using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Project.Services;
using Project.Services.Interfaces;
using Project.Web.Controllers;
using Project.Web.Models.Responses;
using System.Data.SqlClient;
using System;
using Project.Models.Requests.Entities;
using Project.Models;
using Project.Models.Domain.Entities;

namespace Project.Web.Api.Controllers
{
    [Route("api/entities")]
    [ApiController]
    public class EntitiesApiController : BaseApiController
    {
        private IPodcastService _service = null;
        private IAuthenticationService<int> _authService = null;
        public EntitiesApiController(IPodcastService service,
            ILogger<EntitiesApiController> logger,
            IAuthenticationService<int> authService) : base(logger)
        {
            _service = service;
            _authService = authService;
        }

        [HttpPost("")]
        public ActionResult<ItemResponse<int>> Create(PodcastAddRequest model)
        {          
            ObjectResult result = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                
                int id = _service.Add(model, userId);
                ItemResponse<int> response = new ItemResponse<int>() { Item = id };
                result = Created201(response);
               
            }
            catch (Exception ex)
            {

                ErrorResponse response = new ErrorResponse($"Exception Error: {ex.Message}");
                base.Logger.LogError(ex.ToString());
                result = StatusCode(500, response);
            }

            return result;
        }

        [HttpPut("{id:int}")]
        public ActionResult<SuccessResponse> Update(PodcastUpdateRequest model)
        {

            int sCode = 200;
            BaseResponse response = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                _service.Update(model, userId);
                response = new SuccessResponse();
               
            }
            catch (Exception ex)
            {
                sCode = 500;
                response = new ErrorResponse($"Exception Error: {ex.Message}");
                base.Logger.LogError(ex.ToString());
            }

            return StatusCode(sCode, response);
        }

        [HttpGet("paginate")]
        public ActionResult<ItemResponse<Paged<Entity>>> GetPaginated(int pageIndex, int pageSize)
        {

            int sCode = 200;
            BaseResponse response = null;

            try
            {
                Paged<Entity> paged = _service.Pagination(pageIndex, pageSize);
                if (paged == null)
                {
                    sCode = 404;
                    response = new ErrorResponse("App Resource not Found.");
                }
                else
                {
                    response = new ItemResponse<Paged<Entity>>() { Item = paged };
                }
            }
            catch (Exception ex)
            {

                sCode = 500;
                response = new ErrorResponse($"Exception Error: {ex.Message}");
                base.Logger.LogError(ex.ToString());

            }

            return StatusCode(sCode, response);

        }

        [HttpGet("search")]
        public ActionResult<ItemResponse<Paged<Entity>>> SearchPaginated(int pageIndex, int pageSize, string query)
        {

            int sCode = 200;
            BaseResponse response = null;

            try
            {
                Paged<Entity> paged = _service.SearchPagination(pageIndex, pageSize, query);
                if (paged == null)
                {
                    sCode = 404;
                    response = new ErrorResponse("App Resource not Found.");
                }
                else
                {
                    response = new ItemResponse<Paged<Entity>>() { Item = paged };
                }
            }
            catch (Exception ex)
            {

                sCode = 500;
                response = new ErrorResponse($"Exception Error: {ex.Message}");
                base.Logger.LogError(ex.ToString());

            }

            return StatusCode(sCode, response);
        }

        [HttpDelete("{id:int}")]
        public ActionResult<SuccessResponse> DeleteById(int id)
        {
            int sCode = 200;
            BaseResponse response = null;

            try
            {
                _service.Delete(id);
                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                sCode = 500;
                response = new ErrorResponse($"Exception Error: {ex.Message}");
                base.Logger.LogError(ex.ToString());

            }

            return StatusCode(sCode, response);
        }
    }
}
