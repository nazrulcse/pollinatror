<%@ WebHandler Language="C#" Class="CheckImageUrl" %>

using System;
using System.Web;
using System.IO;

public class CheckImageUrl : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{   
    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.QueryString["Url"] == null)
            return;
      
        var url = context.Request.QueryString["Url"].ToString();
     
        
        try
        {
            url=Pollinator.Common.Utility.ValidateImage(url);
            context.Response.Write(url);
           
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error when validate url.GetFullImage_ProcessRequest", ex);
             context.Response.Write("false");
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