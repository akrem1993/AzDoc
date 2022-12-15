using System;
using System.Collections.Generic;
using System.DirectoryServices.AccountManagement;
using System.DirectoryServices.Protocols;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using AzDoc.App_LocalResources;
using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using AzDoc.Models.Account;
using BLL.Adapters;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using BLL.Models.Account;
using BLL.Models.Direction.Direction;
using CustomHelpers;
using Model.DB_Views;
using Repository.Infrastructure;

namespace AzDoc.Controllers
{
    
    public class AccountController : BaseController
    {
        public AccountController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        [HttpGet]
        [IgnoreSessionExpire]
        [OutputCache(VaryByParam = "*", Duration = 0, NoStore = true)]
        public ActionResult Login()
        {
            if (SessionHelper.UserId != -1)
            {
                if (SessionHelper.WorkPlaceId != -1)
                    return RedirectToDefault();

                return RedirectToAction(nameof(Schema));
            }

            return View("~/Views/Account/Login.cshtml");
        }

        [HttpPost]
        [IgnoreSessionExpire]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginViewModel loginViewModel)
        {
            if (SessionHelper.UserId != -1)
                SessionAbandon();

            if (ModelState.IsValid)
            {
                // LdapConnection ldapConnection= new LdapConnection("ldap://10.0.239.1:389");
                // NetworkCredential credential = new NetworkCredential("azdoc_ldap", "WyMcDjg2IfMn", "MHMSYS");
                // ldapConnection.Credential = credential; 
                // ldapConnection.Bind();
                //
                // PrincipalContext ctx =
                //     new PrincipalContext(ContextType.Machine, "ldap://10.0.239.1:389", "azdoc_ldap", "WyMcDjg2IfMn");
                //
                // bool isValid = ctx.ValidateCredentials(loginViewModel.UserName, loginViewModel.Password);
                //
                // UserPrincipal principalUser = isValid ? UserPrincipal.FindByIdentity(ctx, "SomeUserName") : null;
                //

                using (AccountAdapter adapter = new AccountAdapter(unitOfWork))
                {
                    UserModel user = adapter.Login(loginViewModel.UserName, loginViewModel.Password);
                    if (user != null)
                    {
                        if (user.UserStatus)
                        {
                            //int? result = GetAuthorityStatus(user.WorkPlaceId);

                            //if(result.HasValue && !(user.WorkPlacesCount > 1))
                            //{
                            //    ModelState.AddModelError("ErrorMessage", RLang.AuthorityLoginFail);
                            //    return View("~/Views/Account/Login.cshtml", loginViewModel);
                            //}

                            if (user.IsPasswordExpire)
                            {
                                SessionHelper.SetTempSessions(user);
                                return View("~/Views/Account/ChangeExpirePassword.cshtml");
                            }
                            else
                            {
                                SessionHelper.SetSessions(user);
                                if (user.WorkPlacesCount > 1)
                                    return RedirectToAction(nameof(Schema));

                                SessionHelper.WorkPlaceId = user.WorkPlaceId;
                                SessionHelper.AdminPermission = user.AdminPermissionCount;
                                SessionHelper.SuperAdminPermission = user.SuperAdminPermissionCount;
                                SessionHelper.SessionId = Session.SessionID;
                                SessionHelper.SetOrganizationInfo(user);

                                SetRoles(user.WorkPlaceId);

                                return RedirectToDefault();
                            }
                        }

                        ModelState.AddModelError("ErrorMessage", RLang.LoginActiveStatus);
                    }
                    else
                    {
                        ModelState.AddModelError("ErrorMessage", RLang.LoginFailed);
                    }
                }
            }
            else
            {
                ModelState.AddModelError("ErrorMessage", RLang.LoginFailed);
            }

            return View("~/Views/Account/Login.cshtml", loginViewModel);
        }


        [HttpPost]
        [IgnoreSessionExpire]
        [ValidateAntiForgeryToken]
        public ActionResult ChangeExpirePassword(ChangeExpirePasswordViewModel changeExpirePassword)
        {

            ViewBag.NotSecurePassword = false;
            if (SessionHelper.TempUserName == null || SessionHelper.TempUserPassword == null)
                return View("~/Views/Account/Login.cshtml");
           
            if (changeExpirePassword.PasswordNew != changeExpirePassword.PasswordConfirm)
                ModelState.AddModelError("ErrorMessage", RLang.ConfirmPasswordCompare);
            
            else
            if (CustomHelpers.CustomHelper.Encrypt(changeExpirePassword.PasswordNew) == SessionHelper.TempUserPassword)
                ModelState.AddModelError("ErrorMessage", RLang.MustNotUseOldPassword);
            
            else
            if (!PassworHelper.CheckPasswordSecure(changeExpirePassword.PasswordNew))
            {
                ModelState.AddModelError("ErrorMessage", RLang.PasswordIsNotSecure);
                ViewBag.NotSecurePassword = true;
            }
                
                

            if (ModelState.IsValid)
            {
                using (AccountAdapter adapter = new AccountAdapter(unitOfWork))
                {
                    UserModel user = adapter.ChangeExpirePassword(SessionHelper.TempUserName,SessionHelper.TempUserPassword,changeExpirePassword.PasswordNew);
                 
                    if (user != null)
                    {
                        if (user.UserStatus)
                        {
                            SessionHelper.SetSessions(user);
                            if (user.WorkPlacesCount > 1)
                                return RedirectToAction(nameof(Schema));

                            SessionHelper.WorkPlaceId = user.WorkPlaceId;
                            SessionHelper.AdminPermission = user.AdminPermissionCount;
                            SessionHelper.SuperAdminPermission = user.SuperAdminPermissionCount;
                            SessionHelper.SessionId = Session.SessionID;
                            SessionHelper.SetOrganizationInfo(user);

                            SetRoles(user.WorkPlaceId);

                            return RedirectToDefault();
                        }

                        ModelState.AddModelError("ErrorMessage", RLang.LoginActiveStatus);
                    }
                    else
                    {
                        ModelState.AddModelError("ErrorMessage", RLang.LoginFailed);
                    }
                }
            }
            else
            {
                ModelState.AddModelError("ErrorMessage", RLang.LoginFailed);
            }

            return View("~/Views/Account/ChangeExpirePassword.cshtml", changeExpirePassword);
        }

        [HttpGet]
        [UserAuthorize]
        [IgnoreSessionExpire]
        public ActionResult Schema()
        {
            if (SessionHelper.WorkPlaceId != -1)
                return RedirectToDefault();
            var workPlaces = GetWorkPlaces();

            return View("~/Views/Account/Schema.cshtml", workPlaces);
        }


        private void SetRoles(int workPlaceId)
        {
            int? result = GetAuthorityStatus(workPlaceId);

            SessionHelper.Roles = unitOfWork.GetRepository<VW_ROLES>()
                .GetAll(x => x.WorkplaceId == workPlaceId && x.RightTypeId != (result.HasValue ? 2 : -1))
                .ToList();
        }

        [HttpPost]
        [UserAuthorize]
        [IgnoreSessionExpire]
        public ActionResult Schema(LoginViewModel model)
        {
            int workPlaceId = TokenHelper.EncryptValue(model.WorkPlaceValue).ToInt();

            if (workPlaceId == -1)
            {
                ModelState.AddModelError("ErrorMessage", RLang.SchemaFailed);

                return View("~/Views/Account/Schema.cshtml", model);
            }

            var workPlaceInfo = unitOfWork.GetWorkplaceFullInfo<WorkplaceModel>(workPlaceId).FirstOrDefault();

            if (workPlaceInfo == null)
            {
                ModelState.AddModelError("ErrorMessage", RLang.SchemaFailed);

                return View("~/Views/Account/Schema.cshtml", GetWorkPlaces());
            }

            SessionHelper.WorkPlaceId = workPlaceId;
            SessionHelper.DepartmentPositionName = workPlaceInfo.DepartmentPositionName;
            SessionHelper.SetOrganizationInfo(workPlaceInfo);

            SetRoles(workPlaceId);

            return RedirectToDefault();
        }

        public int? GetAuthorityStatus(int workPlaceId)
        {
            return new AccountAdapter(unitOfWork).GetAuthorityStatus(workPlaceId);
        }


        public LoginViewModel GetWorkPlaces()
        {
            using (AccountAdapter adapter = new AccountAdapter(unitOfWork))
            {
                List<WorkPlaceModel> workPlace = adapter.GetDcWorkPlace(SessionHelper.UserId);

                if (workPlace.Count != 0)
                {
                    LoginViewModel model = new LoginViewModel
                    {
                        WorkPlaces = workPlace.Select(x => new SelectListItem
                        {
                            Text = x.WorkPlaceName,
                            Value = TokenHelper.CryptValue(x.WorkplaceId.ToString())
                        }).ToList()
                    };

                    return model;
                }
            }

            return new LoginViewModel();
        }


        [IgnoreSessionExpire]
        public RedirectToRouteResult LogOut()
        {
            if (Request.Cookies["AzDocSessionId"] != null)
            {
                HttpCookie userCookie = new HttpCookie("AzDocSessionId")
                {
                    Expires = DateTime.Now.AddDays(-1)
                };

                Response.Cookies.Add(userCookie);
            }

            Session.Clear();
            SessionAbandon();
            return RedirectToRoute("Login");
        }

        private RedirectToRouteResult RedirectToDefault()
        {
            var values = new System.Web.Routing.RouteValueDictionary();
            values.Add("lang", "az");
            values.Add("docType", SessionHelper.DefaultPage);

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                SessionHelper.Period = adapter.GetPeriod().ToList();
            }

            DocType docType = (DocType) SessionHelper.DefaultPage;

            switch (docType)
            {
                case DocType.OrgRequests:
                    return RedirectToRoute("OrgRequests");

                case DocType.CitizenRequests:
                    return RedirectToRoute("CitizenRequests");

                case DocType.InsDoc:
                    return RedirectToRoute("InsDoc");

                case DocType.OutGoing:
                    return RedirectToRoute("OutgoingDoc_default", values);

                case DocType.ServiceLetters:
                    return RedirectToRoute("ServiceLetters");

                default:
                    return RedirectToRoute("UnreadDocuments");
            }
        }

        [IgnoreSessionExpire]
        public ActionResult TimeoutRedirect()
        {
            return View("~/Views/Account/TimeoutRedirect.cshtml");
        }

        private void SessionAbandon() => Session.Abandon();
    }
}