using System;

namespace Model.DTO
{
    public class DocInitParameters
    {
        public int DocId { get; set; }

        public int DocOrganizationId { get; set; }

        public int DocTopDepartmentId { get; set; }

        public int DocDoctypeId { get; set; }

        public int DocInsertedById { get; set; }

        public int DocPeriodId { get; set; }

        public DateTime DocEnterdate { get; set; } = DateTime.Now;

        public int WorkplaceId { get; set; }

        public string PersonnelFullname { get; set; }

        public int DepartmentTopDepartmentId { get; set; }

        public int DepartmentId { get; set; }

        public int DepartmentSectionId { get; set; }

        public int DepartmentSubSectionId { get; set; }

        public int DirectionType { get; set; }
    }
}