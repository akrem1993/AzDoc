using Admin.Adapters;
using Admin.Model.ViewModel;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using Newtonsoft.Json;
using Repository.Infrastructure;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using Widgets.Helpers;

namespace AzDoc.Areas.AdminPanel.Controllers
{
    public class RegionController : BaseController
    {
        public RegionController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        // GET: AdminPanel/Region
        public async Task<ActionResult> Index()
        {
            return View();
        }

        public async Task<JsonResult> GetCountries(int? pageIndex = 1, int pageSize = 35)
        {
            var countriesQuery = await unitOfWork.GetCountriesAsync(Request.ToFields());
            var totalCount = await countriesQuery.CountAsync();

            var countries = await countriesQuery
                .OrderBy(c => c.CountryName)
                .Skip(((int)pageIndex - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var model = new GenericGridViewModel<CountryViewModel>
            {
                Items = countries,
                TotalCount = totalCount
            };

            return Json(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> AddCountryAsync(CountryViewModel model)
        {
            if (ModelState.IsValid)
            {
                await unitOfWork.AddCountryAsync(model);
            }

            return Json(true);
        }

        [HttpGet]
        public async Task<JsonResult> EditCountryAsync(int countryId)
        {
            var country = await unitOfWork.GetCountryAsync(countryId);

            return Json(country, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> EditCountryAsync(CountryViewModel model)
        {
            await unitOfWork.SaveEditCountryAsync(model);

            return Json(true);
        }

        public async Task<JsonResult> GetRegions(int? pageIndex = 1, int pageSize = 35)
        {
            var regionQuery = await unitOfWork.GetRegionsAsync(Request.ToFields());
            var totalCount = await regionQuery.CountAsync();

            var regions = await regionQuery
                .OrderBy(c => c.RegionName)
                .Skip(((int)pageIndex - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var model = new GenericGridViewModel<RegionViewModel>
            {
                Items = regions,
                TotalCount = totalCount
            };

            return Json(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> AddRegionAsync(RegionViewModel model)
        {
            if (ModelState.IsValid)
            {
                await unitOfWork.AddRegionAsync(model);
            }

            return Json(true);
        }

        [HttpGet]
        public async Task<JsonResult> EditRegionAsync(int regionId)
        {
            var region = await unitOfWork.GetRegionAsync(regionId);

            return Json(region, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> EditRegionAsync(RegionViewModel model)
        {
            await unitOfWork.SaveEditRegionAsync(model);

            return Json(true);
        }


        public async Task<JsonResult> GetVillages(int? pageIndex = 1, int pageSize = 35)
        {
            var villageQuery = await unitOfWork.GetVillagesAsync(Request.ToFields());
            var totalCount = await villageQuery.CountAsync();

            var villages = await villageQuery
                .OrderBy(c => c.VillageName)
                .Skip(((int)pageIndex - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var model = new GenericGridViewModel<VillageViewModel>
            {
                Items = villages,
                TotalCount = totalCount
            };

            return Json(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> AddVillageAsync(VillageViewModel model)
        {
            if (ModelState.IsValid)
            {
                await unitOfWork.AddVillageAsync(model);
            }

            return Json(true);
        }

        [HttpGet]
        public async Task<JsonResult> EditVillageAsync(int villageId)
        {
            var village = await unitOfWork.GetVillageAsync(villageId);

            return Json(village, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> EditVillageAsync(VillageViewModel model)
        {
            await unitOfWork.SaveEditVillageAsync(model);

            return Json(true);
        }

        [HttpGet]
        public async Task<JsonResult> GetRegionsForVillage(int countryCode)
        {
            var regionQuery = await unitOfWork.GetRegionsForVillage(countryCode);

            return new JsonResult()
            {
                Data = regionQuery,
                MaxJsonLength = int.MaxValue,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
        }
    }
}