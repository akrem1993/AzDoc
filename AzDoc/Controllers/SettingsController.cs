using AzDoc.App_LocalResources;
using AzDoc.Helpers;
using AzDoc.Models.Account;
using AzDoc.Models.Common;
using BLL.Models.Account;
using CustomHelpers;
using Repository.Infrastructure;
using System.Web.Mvc;
using AzDoc.BaseControllers;
using BLL.Adapters;
using BLL.Common.Enums;
using AppCore.Interfaces;

namespace AzDoc.Controllers
{
    public class SettingsController : BaseController
    {
        public SettingsController(IUnitOfWork unitOfWork) : base(unitOfWork) { }


        [HttpGet]
        public ActionResult Index()
        {
            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                SettingModel settingModel = settingAdapter.Settings(SessionHelper.UserId);
                return View(settingModel);
            }
        }


        [HttpGet]
        public JsonResult ChangeDefaultPage()
        {
            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                return Json(settingAdapter.GetChangeDefaultPage(), JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult ChangeDefaultPage(int treeId)
        {
            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                settingAdapter.ChangeDefaultPage(SessionHelper.UserId, treeId, out int result);

                if (result == (int)(DBResultOutputParameter.Success))
                {
                    SessionHelper.DefaultPage = treeId;
                    return Json(new { result = true });
                }

                return Json(new { result = false });
            }
        }

        [HttpGet]
        public JsonResult NotifySettingPartial()
        {
            if (SessionHelper.WorkPlaceId == -1)
                return null;

            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                var result = settingAdapter.GetNotifications(SessionHelper.UserId);

                return Json(result, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult NotifySettingPartial(bool notifications)
        {
            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                settingAdapter.NotifySettingPartial(SessionHelper.UserId, notifications, out int result);
                if (result == (int)(DBResultOutputParameter.Success))
                {
                    SessionHelper.IsNotifications = notifications;
                    return Json(notifications);
                }

                return Json(notifications);
            }
        }


        [HttpGet]
        public ActionResult ChangePassword()
        {
            //if (SessionHelper.UserId == -1)
            //    return RedirectToDefault();

            return View(new SettingModel());
        }

        [HttpPost]
        public JsonResult ChangePassword(ChangePasswordViewModel changePasswordViewModel)
        {
            if (SessionHelper.UserId == -1)
            {
                Item data = new Item()
                {
                    Id = (int)(DBResultOutputParameter.NoPermissionUser),
                    Text = RLang.LoginFailed
                };
            }
            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                if (changePasswordViewModel.PasswordNew.Length == changePasswordViewModel.PasswordConfirm.Length)
                {
                    if (changePasswordViewModel.PasswordNew.Equals(changePasswordViewModel.PasswordConfirm))
                    {
                        if (PassworHelper.CheckPasswordSecure(changePasswordViewModel.PasswordNew))
                        {
                            if (changePasswordViewModel.Password!= changePasswordViewModel.PasswordNew)
                            {
                                if (settingAdapter.ChangePassword(SessionHelper.UserId, changePasswordViewModel.Password, changePasswordViewModel.PasswordNew))
                                {
                                    return Json(true);
                                }
                            }
                            else return Json(new
                            {
                                status = false,
                                text = "Yeni şifrə və köhnə şifrə fərqli olmalıdırlar "
                            });

                        }
                        else
                        return Json(new {
                            status=false,
                            text="Şifrə siyasətinə uyğun deyil "
                        });
                    }
                    else
                        return Json(new
                        {
                            status = false,
                            text = "Yeni şifrə və təsdiq şifrə eyni olmalıdır"
                        });
                }

                return Json(false);
            }
        }

        [HttpGet]
        public JsonResult ChangeDefaultLanguage()
        {
            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                return Json(settingAdapter.GetDefaultLanguage(SessionHelper.UserId), JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult ChangeDefaultLanguage(int langId)
        {
            using (SettingAdapter settingAdapter = new SettingAdapter(unitOfWork))
            {
                settingAdapter.AddDefaultLanguage(SessionHelper.UserId, langId, out int result);
                if (result == (int)DBResultOutputParameter.Success)
                {
                    SessionHelper.DefaultLang = langId.ToString();
                }

                return Json(result, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public JsonResult SetVariable(bool value)
        {
            SessionHelper.DefaultLeftMenu = value;
            return Json(true, JsonRequestBehavior.AllowGet);
        }
    }
}