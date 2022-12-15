using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using CustomHelpers;
using Repository.Infrastructure;


namespace AzDoc.Areas.AdminPanel.Models
{
    public class IsUnique : ValidationAttribute

    {
        //public IsUnique(string propertyNames)
        //{
        //    this.PropertyNames = propertyNames;
        //}

        //public string PropertyNames { get; private set; }

        //protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        //{
        //    var db = validationContext;
        //    var className = validationContext.ObjectType.Name.Split('.').Last();
        //    var propertyName = validationContext.MemberName;
        //    var parameterName = string.Format("@{0}", propertyName);
        //    //var result = db.Database.SqlQuery<int>(
        //        string.Format("SELECT COUNT(*) FROM {0} WHERE {1}={2}", className, propertyName, parameterName),
        //        new System.Data.SqlClient.SqlParameter(parameterName, value));
        //    //if (result.ToList()[0] > 0)
        //    {
        //        return new ValidationResult(string.Format("The '{0}' already exist", propertyName),
        //            new List<string>() { propertyName });
        //    }
        //    return null;
        //}
    }




   
}