<%@ WebHandler Language="C#" Class="DownloadFile" %>

using System;
using System.Web;
using System.IO;

public class DownloadFile : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{   
    public void ProcessRequest(HttpContext context)
    {
        if (context.Request["fileName"] != null)
        {
            string fileName = context.Request["fileName"].ToString();
            context.Response.Clear();
            context.Response.ContentType = @"application\octet-stream";
            System.IO.FileInfo file = new System.IO.FileInfo(context.Request.MapPath("~/"+ fileName));
            context.Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
            context.Response.AddHeader("Content-Length", file.Length.ToString());
            context.Response.ContentType = ReturnExtension(file.Extension);
            context.Response.WriteFile(file.FullName);
            context.Response.Flush();
        }
    }

    private string ReturnExtension(string fileExtension)
    {
        switch (fileExtension)
        {
            case ".htm":
            case ".html":
            case ".log":
                return "text/HTML";
            case ".txt":
                return "text/plain";
            case ".csv":
            case ".xls":
                return "application/vnd.ms-excel";
            default:
                return "application/octet-stream";
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