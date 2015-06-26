<%@ WebHandler Language="C#" Class="SignIn" %>

using System;
using System.IO;
using System.Web;
using System.Web.Security;

public class SignIn : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.QueryString["UserName"] == null)
            return;

        if (context.Request.QueryString["Password"] == null)
            return;
        
        var userName = context.Request.QueryString["UserName"].ToString();
        var password = context.Request.QueryString["Password"].ToString();
        bool rememberMe = false;
        if (context.Request.QueryString["IsRemember"] != null &&
            context.Request.QueryString["IsRemember"].ToString().Equals("true"))
        {
            rememberMe = true;
        }

        try
        {
            if (Membership.ValidateUser(userName, password))
            {
                if (rememberMe)
                {
                    FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(userName, true, 12 * 60);
                    string encryptedTicket = FormsAuthentication.Encrypt(authTicket);
                    HttpCookie cookie = new HttpCookie(System.Web.Security.FormsAuthentication.FormsCookieName, encryptedTicket);
                    cookie.Expires = authTicket.Expiration;
                    HttpContext.Current.Response.Cookies.Set(cookie);
                }
                else
                {
                   FormsAuthentication.SetAuthCookie(userName, false);
                }

                var roles = System.Web.Security.Roles.GetRolesForUser(userName);

                if (roles.Length > 0 && roles[0].Equals(Pollinator.Common.Utility.RoleName.Administrator.ToString()))
                    context.Response.Write("Admin/Users");
                else
                    context.Response.Write("ShareMap");

            }
            else
            {
                context.Response.Write("false");
            }
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error when login", ex);
            context.Response.Write("error");
        }
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}