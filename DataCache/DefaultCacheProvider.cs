using DataCache.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;

namespace DataCache.Cache
{
    public class DefaultCacheProvider : CacheProvider
    {
        private ObjectCache _cache = null;
        private CacheItemPolicy _policy = null;

        public DefaultCacheProvider()
        {
            _cache = MemoryCache.Default;

            _policy = new CacheItemPolicy
            {
                AbsoluteExpiration = DateTime.Now.AddSeconds(CacheDuration),
                RemovedCallback = new CacheEntryRemovedCallback(CacheRemovedCallback)
            };
        }

        private static void CacheRemovedCallback(CacheEntryRemovedArguments arguments)
        {
        }

        public override object Get(CacheKey key)
        {
            object retVal = null;

            try
            {
                retVal = _cache.Get(key.ToString());
            }
            catch (Exception e)
            {
                throw new Exception("Cache xeta!", e);
            }

            return retVal;
        }

        public override void Set(CacheKey key, object value)
        {
            try
            {
                _cache.Set(key.ToString(), value, _policy);
            }
            catch (Exception e)
            {
                throw new Exception("Cache xeta!", e);
            }
        }

        public override bool IsExist(CacheKey key)
        {
            return _cache.Any(q => q.Key == key.ToString());
        }

        public override void Clear()
        {
            List<string> cacheKeys = _cache.Select(kvp => kvp.Key).ToList();
            foreach (string cacheKey in cacheKeys)
            {
                _cache.Remove(cacheKey);
            }
        }

        public override void Remove(CacheKey key)
        {
            _cache.Remove(key.ToString());
        }
    }
}