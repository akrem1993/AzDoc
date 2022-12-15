using Admin.Model.ViewModel;
using DMSModel;
using LinqKit;
using Model.DB_Tables;
using Repository.Infrastructure;
using Repository.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Admin.Adapters
{
    public static class RegionAdapter
    {
        #region dc_country

        public static async Task<IQueryable<CountryViewModel>> GetCountriesAsync(this IUnitOfWork unit, Dictionary<string, object> keyValues)
        {
            var predicate = FilterCountry(keyValues);
            var query = await unit.GetRepository<DC_COUNTRY>().GetAllAsync(predicate);

            return query.Select(c => new CountryViewModel
            {
                CountryId = c.CountryId,
                CountryName = c.CountryName,
                CountryCode = (int)c.Code,
                CountryStatus = c.CountryStatus
            });
        }

        public static Expression<Func<DC_COUNTRY, bool>> FilterCountry(Dictionary<string, object> keyValues)
        {
            var predicate = PredicateBuilder.New<DC_COUNTRY>();

            predicate = predicate.Or(a => a.Code != null);

            if (keyValues.Count == 0)
                return predicate;

            foreach (var item in keyValues)
            {
                if (item.Key == "CountryName")
                {
                    predicate = predicate.And(a => a.CountryName.ToUpper().Contains(item.Value.ToString().ToUpper()));
                }

                if (item.Key == "CountryCode")
                {
                    int value = Convert.ToInt32(item.Value);
                    predicate = predicate.And(a => a.Code == value);
                }

                if (item.Key == "CountryStatus")
                {
                    byte value = Convert.ToByte(item.Value);
                    predicate = predicate.And(a => a.CountryStatus == value);
                }
            }

            return predicate;
        }

        public static void CheckName<T>(this IQueryable<T> query, string name) where T : class
        {
            if (query.ToList().Any())
                throw new ArgumentException($"Daxil etdiyiniz məlumat({name}) artıq mövcuddur");
        }

        public static async Task AddCountryAsync(this IUnitOfWork unit, CountryViewModel model)
        {
            if (string.IsNullOrWhiteSpace(model.CountryName))
                throw new ArgumentException("Model is null");

            var country = await unit.GetRepository<DC_COUNTRY>().GetAllAsync(c => c.CountryName.ToUpper() == model.CountryName.ToUpper() && c.CountryStatus == 1);

            country.CheckName(model.CountryName);

            var maxCountryCode = unit.GetRepository<DC_COUNTRY>().GetAllAsync().Result.Select(x => x.Code).Max();

            var newCountry = new DC_COUNTRY
            {
                CountryName = model.CountryName,
                CountryName2 = model.CountryName,
                Code = maxCountryCode + 1,
                CountryStatus = model.CountryStatus
            };

            unit.GetRepository<DC_COUNTRY>().Add(newCountry);
            await unit.SaveChangesAsync();
        }

        public static async Task<CountryViewModel> GetCountryAsync(this IUnitOfWork unit, int countryId)
        {
            var country = await unit.GetRepository<DC_COUNTRY>().GetByIdAsync(countryId);

            var viewModel = new CountryViewModel
            {
                CountryId = country.CountryId,
                CountryName = country.CountryName,
                CountryStatus = country.CountryStatus
            };

            return viewModel;
        }

        public static async Task SaveEditCountryAsync(this IUnitOfWork unit, CountryViewModel model)
        {
            if (model.CountryId == 0 || string.IsNullOrWhiteSpace(model.CountryName))
                throw new ArgumentException("Model is null");

            var country = await unit.GetRepository<DC_COUNTRY>().GetByIdAsync((int)model.CountryId);

            country.CountryName = model.CountryName;
            country.CountryName2 = model.CountryName;
            country.CountryStatus = model.CountryStatus;

            unit.GetRepository<DC_COUNTRY>().Update(country);
            await unit.SaveChangesAsync();
        }

        #endregion dc_country

        #region dc_region

        public static async Task<IQueryable<RegionViewModel>> GetRegionsAsync(this IUnitOfWork unit, Dictionary<string, object> keyValues)
        {
            var predicate = FilterRegion(keyValues);
            var query = await unit.GetRepository<DC_REGION>().GetAllAsync(predicate);

            return query.Select(r => new RegionViewModel
            {
                RegionId = r.RegionId,
                RegionName = r.RegionName,
                RegionCode = (int)r.RegionCode,
                RegionCountryCode = (int)r.RegionCountryCode,
                RegionStatus = r.RegionStatus
            });
        }

        public static Expression<Func<DC_REGION, bool>> FilterRegion(Dictionary<string, object> keyValues)
        {
            var predicate = PredicateBuilder.New<DC_REGION>();

            predicate = predicate.Or(a => a.RegionCountryCode != null);

            if (keyValues.Count == 0)
                return predicate;

            foreach (var item in keyValues)
            {
                if (item.Key == "RegionName")
                {
                    predicate = predicate.And(a => a.RegionName.ToUpper().Contains(item.Value.ToString().ToUpper()));
                }

                if (item.Key == "RegionCountryCode")
                {
                    int value = Convert.ToInt32(item.Value);
                    predicate = predicate.And(a => a.RegionCountryCode == value);
                }

                if (item.Key == "RegionStatus")
                {
                    byte value = Convert.ToByte(item.Value);
                    predicate = predicate.And(a => a.RegionStatus == value);
                }
            }

            return predicate;
        }

        public static async Task AddRegionAsync(this IUnitOfWork unit, RegionViewModel model)
        {
            if (model.RegionCountryCode == 0 || string.IsNullOrWhiteSpace(model.RegionName))
                throw new ArgumentException("Model is null");

            var country = await unit.GetRepository<DC_REGION>().GetAllAsync(c => c.RegionName.ToUpper() == model.RegionName.ToUpper() && c.RegionStatus == 1);

            country.CheckName(model.RegionName);

            var regionObject = unit.GetRepository<DC_REGION>().GetAllAsync().Result.Select(x => new { x.RegionId, x.RegionCode });
            var maxRegionId = regionObject.Max(x => x.RegionId);
            var maxRegionCode = regionObject.Max(x => x.RegionCode);

            var region = new DC_REGION
            {
                RegionId = maxRegionId + 1,
                RegionName = model.RegionName,
                RegionCode = maxRegionCode + 1,
                RegionCountryCode = model.RegionCountryCode,
                RegionStatus = model.RegionStatus
            };

            unit.GetRepository<DC_REGION>().Add(region);
            await unit.SaveChangesAsync();
        }

        public static async Task<RegionViewModel> GetRegionAsync(this IUnitOfWork unit, int regionId)
        {
            try
            {
                var region = await unit.GetRepository<DC_REGION>().GetByIdAsync(regionId);

                var viewModel = new RegionViewModel
                {
                    RegionId = region.RegionId,
                    RegionName = region.RegionName,
                    RegionCountryCode = (int)region.RegionCountryCode,
                    RegionStatus = region.RegionStatus
                };

                return viewModel;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        public static async Task SaveEditRegionAsync(this IUnitOfWork unit, RegionViewModel model)
        {
            if (model.RegionCountryCode == 0 || string.IsNullOrWhiteSpace(model.RegionName))
                throw new ArgumentException("Model is null");

            var region = await unit.GetRepository<DC_REGION>().GetByIdAsync((int)model.RegionId);

            region.RegionName = model.RegionName;
            region.RegionStatus = model.RegionStatus;
            region.RegionCountryCode = model.RegionCountryCode;

            unit.GetRepository<DC_REGION>().Update(region);
            await unit.SaveChangesAsync();
        }

        #endregion dc_region

        //public static object GetPropertyDynamic<Tobj>(this Tobj self, string propertyName) where Tobj : class
        //{
        //    var param = Expression.Parameter(typeof(Tobj), "value");
        //    var getter = Expression.Property(param, propertyName);
        //    var boxer = Expression.TypeAs(getter, typeof(object));
        //    var getPropValue = Expression.Lambda<Func<Tobj, object>>(boxer, param).Compile();

        //    return getPropValue(self);
        //}

        //private static Expression<Func<T, bool>> FilterCountry<T>(Dictionary<string, object> searchParams) where T : class
        //{
        //    var predicate = PredicateBuilder.New<T>();

        //    if (searchParams.Count == 0)
        //        return predicate = predicate.Or(x => 1 == 1);

        //    var props = GetClassProperties<T>();

        //    foreach (var prop in props)
        //    {
        //        if (searchParams.TryGetValue(prop, out var outResult))
        //        {
        //            predicate = predicate.Or(c => c.GetPropertyDynamic(prop) == outResult);
        //        }
        //    }

        //    return predicate = predicate.Or(x => 1 == 1);
        //}

        //public static List<string> GetClassProperties<T>() where T : class
        //{
        //    Type type = typeof(T);
        //    PropertyInfo[] props = type.GetProperties();
        //    var propList = new List<string>();

        //    foreach (var prop in props)
        //    {
        //        propList.Add(prop.Name);
        //    }

        //    return propList;
        //}

        #region Village

        public static async Task<IQueryable<VillageViewModel>> GetVillagesAsync(this IUnitOfWork unit, Dictionary<string, object> keyValues)
        {
            var villageRep = new EFRepository<Village>(unit.Context);
            var regionRep = new EFRepository<DC_REGION>(unit.Context);

            var villageRegion = (await villageRep.GetAllAsync()).Join(await regionRep.GetAllAsync(),
                village => village.RegionCode,
                region => region.RegionCode,
                (village, region) => new VillageViewModel
                {
                    VillageId = village.VillageId,
                    VillageCode = village.VillageCode,
                    VillageName = village.VillageName,
                    RegionCode = village.RegionCode,
                    RegionName = region.RegionName,
                    VillageStatus = village.VillageStatus
                });

            var predicate = FilterVillage(keyValues);
            villageRegion = villageRegion.Where(predicate);
            return villageRegion;
        }

        public static Expression<Func<VillageViewModel, bool>> FilterVillage(Dictionary<string, object> keyValues)
        {
            var predicate = PredicateBuilder.New<VillageViewModel>();

            predicate = predicate.Or(a => a.RegionCode != 0);

            if (keyValues.Count == 0)
                return predicate;

            foreach (var item in keyValues)
            {
                if (item.Key == "VillageName")
                {
                    predicate = predicate.And(a => a.VillageName.ToUpper().Contains(item.Value.ToString().ToUpper()));
                }

                if (item.Key == "VillageCode")
                {
                    int value = Convert.ToInt32(item.Value);
                    predicate = predicate.And(a => a.VillageCode == value);
                }

                if (item.Key == "RegionName")
                {
                    predicate = predicate.And(a => a.RegionName.ToUpper().ToString() == item.Value.ToString().ToUpper());
                }

                if (item.Key == "VillageStatus")
                {
                    bool value = Convert.ToInt32(item.Value) == 0 ? false : true;
                    predicate = predicate.And(a => a.VillageStatus == value);
                }
            }

            return predicate;
        }

        public static async Task AddVillageAsync(this IUnitOfWork unit, VillageViewModel model)
        {
            if (model.RegionCode == 0 || string.IsNullOrWhiteSpace(model.VillageName))
                throw new ArgumentException("Model is null");

            var villages = await unit.GetRepository<Village>()
                .GetAllAsync(c => c.VillageName.ToUpper() == model.VillageName.ToUpper() && c.VillageStatus == true && c.RegionCode == model.RegionCode);

            villages.CheckName(model.VillageName);

            var maxVillageCode = unit.GetRepository<Village>()
                .GetAllAsync()
                .Result
                .Select(x => x.VillageCode).Max();

            var village = new Village
            {
                VillageName = model.VillageName,
                VillageCode = maxVillageCode + 1,
                RegionCode = model.RegionCode,
                VillageStatus = model.VillageStatus
            };

            unit.GetRepository<Village>().Add(village);
            await unit.SaveChangesAsync();
        }

        public static async Task<VillageViewModel> GetVillageAsync(this IUnitOfWork unit, int villageId)
        {
            try
            {
                var village = await unit.GetRepository<Village>().GetByIdAsync(villageId);

                var viewModel = new VillageViewModel
                {
                    VillageId = village.VillageId,
                    VillageName = village.VillageName,
                    RegionCode = village.RegionCode,
                    VillageStatus = village.VillageStatus,
                    CountryCode = await unit.GetCountryCodeAsync(village.RegionCode)
                };

                return viewModel;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        public static async Task<int> GetCountryCodeAsync(this IUnitOfWork unit, int regionCode)
        {
            var query = await unit.GetRepository<DC_REGION>().GetAllAsync(c => c.RegionCode == regionCode);

            return (int)query.Select(c => c.RegionCountryCode).FirstOrDefault();
        }

        public static async Task SaveEditVillageAsync(this IUnitOfWork unit, VillageViewModel model)
        {
            if (model.RegionCode == 0 || string.IsNullOrWhiteSpace(model.VillageName))
                throw new ArgumentException("Model is null");

            var village = await unit.GetRepository<Village>().GetByIdAsync((int)model.VillageId);

            village.VillageName = model.VillageName;
            village.VillageStatus = model.VillageStatus;
            village.RegionCode = model.RegionCode;

            unit.GetRepository<Village>().Update(village);
            await unit.SaveChangesAsync();
        }

        public static async Task<IEnumerable<RegionViewModel>> GetRegionsForVillage(this IUnitOfWork unit, int countryCode)
        {
            var query = await unit.GetRepository<DC_REGION>().GetAllAsync(r => r.RegionCode != null && r.RegionCountryCode == countryCode);

            return query.Select(r => new RegionViewModel
            {
                RegionName = r.RegionName,
                RegionCode = (int)r.RegionCode
            }).ToList();
        }

        #endregion Village

    }
}