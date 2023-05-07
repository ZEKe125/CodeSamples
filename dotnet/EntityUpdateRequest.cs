using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Models.Requests.Entities
{
    public class EntityUpdateRequest : EntityAddRequest, IModelIdentifier
    {
        [Required]
        public int Id { get; set; }
    }
}
