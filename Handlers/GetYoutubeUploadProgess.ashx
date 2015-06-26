<%@ WebHandler Language="C#" Class="GetYoutubeUploadProgess" %>

using System;
using System.Web;
using System.Web.Script.Serialization;

public class GetYoutubeUploadProgess : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            if (context.Request.QueryString["uploadId"] == null)
                return;

            var id = context.Request.QueryString["uploadId"].ToString();
           
                       
            context.Response.Write(UploadingDispatcher.GetProgress(id));
            
        }
        catch (Exception ex)
        {
            context.Response.Write(ex.InnerException.ToString());
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