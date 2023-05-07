using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Models.Requests.Entiys
{
    public class EntiyAddRequest
    {
        [Required]
        [StringLength(50, MinimumLength = 2)] 
        public string Title { get; set; }
        [Required]
        [StringLength(200, MinimumLength = 2)] 
        public string Description { get; set; }
        [Required]
        [StringLength(200, MinimumLength = 2)] 
        public string Url { get; set; }
        [Required]
        [Range(1, Int32.MaxValue)] 
        public int EntiyTypeId { get; set; }
        [Required]
        [StringLength(200, MinimumLength = 2)] 
        public string CoverImageUrl { get; set;}
     
    }
}
