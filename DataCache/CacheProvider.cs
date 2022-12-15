namespace DataCache.Core
{
    public abstract class CacheProvider
    {
        public static int CacheDuration = 999999999;
        public static CacheProvider Instance { get; set; }

        public abstract object Get(CacheKey key);

        public abstract void Set(CacheKey key, object value);

        public abstract bool IsExist(CacheKey key);

        public abstract void Remove(CacheKey key);

        public abstract void Clear();
    }
}