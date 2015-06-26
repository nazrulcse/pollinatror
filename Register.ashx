<%@ WebHandler Language="C#" Class="Register" %>

using System;
using System.Web;
using System.IO;
using System.Web.Services;
using System.Web.Security;
public class Register : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        var userName = context.Request.QueryString["UserName"].ToString();
        MembershipUser mu = System.Web.Security.Membership.GetUser(userName);
        if (mu != null)
        {
            context.Response.Write("true");
        }
        else
        {
            context.Response.Write("false");
        }
    }
    //[WebMethod]
    //public static string CheckExistUser(string UserName)
    //{
    //    if (Membership.GetUser(UserName) != null)
    //        return "true";
    //    else
    //        return "false";
    //}
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    
    
}