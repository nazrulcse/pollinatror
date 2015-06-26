using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.Common;
using Pollinator.DataAccess;
using System.Web.UI.HtmlControls;

public partial class SiteMaster : MasterPage
{
    private const string AntiXsrfTokenKey = "__AntiXsrfToken";
    private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
    private string _antiXsrfTokenValue;

    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            // The code below helps to protect against XSRF attacks
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;
        }
        catch (Exception ex)
        {
            //write log
            Pollinator.Common.Logger.Error("Occured in function: " + typeof(SiteMap).Name + ".Page_Init()", ex);
        }
    }

    void master_Page_PreLoad(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Set Anti-XSRF token
            ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
            ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
        }
        else
        {
            // Validate the Anti-XSRF token
            if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
            {
                //throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
            }
        }

        var webAppPath = WebHelper.FullyQualifiedApplicationPath;
        var url = WebHelper.FullyQualifiedApplicationPath+"ShareMap.aspx";
        var urlReferrer = Request.UrlReferrer;
        if (urlReferrer != null)
        {
            url = urlReferrer.Authority;
        }      


        megaTags.Controls.Add(new LiteralControl("<link href='" + webAppPath + "Images/favicon.gif' rel='shortcut icon' type='image/x-icon' />"));
        megaTags.Controls.Add(new LiteralControl("<meta property='og:image' content='" + webAppPath + "Images/SHARE_Program_Logo_new.jpg' />"));       
        megaTags.Controls.Add(new LiteralControl("<meta property='og:title' content='S.H.A.R.E - Get on the Map Today!' />"));
        megaTags.Controls.Add(new LiteralControl("<meta property='og:description' content='Register your pollinator habitat below. It is free and easy! You can also explore other pollinator friendly S.H.A.R.E. landscapes map from all over the globe!' />"));     
    }
            
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            SetMessageAfterLogin();
    }
    /// <summary>
    /// Custom display at top of site
    /// (1)Set logonName display FirstName
    /// (2)Set Premium Since MMM, yyyy
    /// </summary>
    private void SetMessageAfterLogin()
    {
        try
        {
            //if (Context.User.Identity.IsAuthenticated)
            //{
            //    string test = HttpUtility.HtmlEncode(@"<newuser2>?:!@#%^&*()_+""'.,/\[]|\!@#$%^&*()_+");
            //    //test = "&lt;newuser2&gt;?:{}|\\!@#$%^&amp;*()_+";
            //    LoginName loginName1 = (LoginName)LoginView2.FindControl("loginName");
            //    loginName1.FormatString = test;
            //}

            if (Context.User.Identity.IsAuthenticated && Roles.IsUserInRole(Utility.RoleName.Members.ToString()))
            {
                string sesloginName = "loginName" + Context.User.Identity.Name;
                string sesPreSince = "aPreSince" + Context.User.Identity.Name;

                LoginName loginName = (LoginName)LoginView2.FindControl("loginName");
                if (Session[sesloginName] != null)
                    loginName.FormatString = Session[sesloginName].ToString();

                HtmlAnchor aPreSince = (HtmlAnchor)LoginView2.FindControl("aPreSince");
                if (Session[sesPreSince] != null)
                    aPreSince.InnerText = Session[sesPreSince].ToString();
                else
                {
                    Guid userID = (Guid)System.Web.Security.Membership.GetUser(Context.User.Identity.Name).ProviderUserKey;
                    PollinatorEntities mydb = new PollinatorEntities();
                    UserDetail userDetail = new UserDetail();

                    var selectedUserDetail = (from user in mydb.UserDetails
                                              where user.UserId == userID
                                              select user).FirstOrDefault();

                    if (selectedUserDetail != null)
                    {
                        //set loginName
                        Session[sesloginName] = selectedUserDetail.FirstName;
                        loginName.FormatString = HttpUtility.HtmlEncode(Session[sesloginName].ToString());


                        if (selectedUserDetail.MembershipLevel == 0)
                            aPreSince.Visible = false;
                        else if (selectedUserDetail.MembershipLevel > 0)
                        {
                            var pollinatorInfomation = (from poll in mydb.PolinatorInformations
                                                        where poll.UserId == userID
                                                        select poll).FirstOrDefault();
                            DateTime paidDate = pollinatorInfomation.PaidDate == null ? DateTime.MinValue : (DateTime)pollinatorInfomation.PaidDate;
                            if (paidDate > DateTime.MinValue)
                            {
                                aPreSince.Visible = true;
                                Session[sesPreSince] = string.Format("Premium since {0}", String.Format("{0:MMM, yyyy}", paidDate));
                                aPreSince.InnerText = Session[sesPreSince].ToString();
                            }
                        }
                    }
                }
            }
            else if (Context.User.Identity.IsAuthenticated)
            {
                string sesloginName = "loginName" + Context.User.Identity.Name;
                string sesPreSince = "aPreSince" + Context.User.Identity.Name;

                HtmlAnchor aPreSince = (HtmlAnchor)LoginView2.FindControl("aPreSince");
                aPreSince.Visible = false;

                LoginName loginName = (LoginName)LoginView2.FindControl("loginName");
                if (Session[sesloginName] != null)
                    loginName.FormatString = Session[sesloginName].ToString();
                else
                {
                    Guid userID = (Guid)System.Web.Security.Membership.GetUser(Context.User.Identity.Name).ProviderUserKey;
                    PollinatorEntities mydb = new PollinatorEntities();
                    UserDetail userDetail = new UserDetail();

                    var selectedUserDetail = (from user in mydb.UserDetails
                                              where user.UserId == userID
                                              select user).FirstOrDefault();

                    if (selectedUserDetail != null)
                    {
                        //set loginName
                        Session[sesloginName] = selectedUserDetail.FirstName;
                        loginName.FormatString = Session[sesloginName].ToString();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            //write log
            Pollinator.Common.Logger.Error("Occured in function: " + typeof(SiteMap).Name + ".SetMessageAfterLogin()", ex);
        }
    }
    
    protected void MenuMain1_MenuItemDataBound(object sender, MenuEventArgs args)
    {
        args.Item.ImageUrl = ((SiteMapNode)args.Item.DataItem)["imageUrl"];
    }
}