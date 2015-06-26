<%@ WebHandler Language="C#" Class="CheckYoutubeStatus" %>

using System;
using System.Web;
using System.Web.Script.Serialization;

public class CheckYoutubeStatus : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    YouTubeUltility youtube = new YouTubeUltility();
    private readonly JavaScriptSerializer js = new JavaScriptSerializer();

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            if (context.Request.QueryString["v"] == null)
                return;

            var videoId = context.Request.QueryString["v"].ToString();
            string uploadStatusName = string.Empty;
            string uploadStatusValue = string.Empty;
        
            if (youtube.CheckStatus(videoId))//Draft
            {
                if (youtube.videoStatus != null)
                {
                    uploadStatusName = youtube.videoStatus.Name;
                    uploadStatusValue = youtube.videoStatus.Value;
                    if (!string.IsNullOrEmpty(uploadStatusValue))
                        uploadStatusValue = uploadStatusValue.ToLower();
                }               
            }
            else
            {
                uploadStatusName = "processed";                           
            }

            string jsonObj = js.Serialize(new
            {
                uploadStatusName = uploadStatusName,
                uploadStatusValue = uploadStatusValue,
            });
            context.Response.Write(jsonObj);
            
        }
        catch (Exception ex)
        {
            string jsonObj = js.Serialize(new
            {
                error = ex.Message
            });
            context.Response.Write(jsonObj);
            context.Response.ContentType = "application/json";
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