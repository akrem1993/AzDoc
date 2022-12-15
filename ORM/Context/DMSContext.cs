using DMSModel;
using Model;
using Model.DB_Tables;
using Model.DB_Views;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace ORM.Context
{
    public class DMSContext : DbContext
    {
        public DMSContext()
        {
            Database.Connection.ConnectionString = ContextProfiles.ConnectionString;

            Configuration.EnsureTransactionsForFunctionsAndCommands = false;
            Configuration.LazyLoadingEnabled = false;

            Database.SetInitializer<DMSContext>(null);
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

        public virtual DbSet<ServiceLettersDocs> ServiceLettersDocs { get; set; }

        public virtual DbSet<CitizenRequestsDocs> CitizenRequestsDocs { get; set; }

        public virtual DbSet<OrgRequestsDocs> OrgRequestsDocs { get; set; }

        public virtual DbSet<OutGoingDocs> OutGoingDocs { get; set; }

        public virtual DbSet<VW_ROLES> Roles { get; set; }
        public virtual DbSet<DC_ORGANIZATION> Organ { get; set; }
        public virtual DbSet<DC_DEPARTMENT> Departments { get; set; }
        public virtual DbSet<DC_DEPARTMENTTYPE> DepartmentTypes { get; set; }
        public virtual DbSet<DC_DEPARTMENT_POSITION> DepartmentPositions { get; set; }
        public virtual DbSet<DC_POSITION_GROUP> PositionGroups { get; set; }
        public virtual DbSet<DC_ROLE> DcRoles { get; set; }

        //public virtual DbSet<DC_REGION> Regions { get; set; }
        public virtual DbSet<DC_ROLE_OPERATION> RoleOperations { get; set; }
        public virtual DbSet<DC_USER> Users { get; set; }
        public virtual DbSet<DOC_TOPIC_TYPE> TOPIC_TYPEs { get; set; }
        public virtual DbSet<DOC_TOPIC> DOC_TOPICs { get; set; }
        public virtual DbSet<RelationalOrganisations> Relationals { get; set; }
        public virtual DbSet<AuthorityTransfer> TransferAuthorities { get; set; }
        public virtual DbSet<TransferReasons> TransferReasonses { get; set; }
        public virtual DbSet<DC_PERSONNEL> Personnels { get; set; }
        public virtual DbSet<UserLimitOrganizations> UserLimitOrganizationses { get; set; }
        public virtual DbSet<DOC_DOCUMENTSTATUS> DocumentStatus { get; set; }
        public virtual DbSet<DOC> Docs { get; set; }
        public virtual DbSet<DOC_UNDERCONTROLSTATUS> DOC_UNDERCONTROLSTATUS { get; set; }
        public virtual DbSet<Village> Villages { get; set; }
        public virtual DbSet<DC_REGION> Regions { get; set; }
        //public virtual DbSet<DC_COUNTRY> Countries { get; set; }
    }
}