<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Configuration;
//using System.Web.Security;
public class Handler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        var userName = context.User.Identity.Name;//context.Request.QueryString["UserName"].ToString();
        context.Response.ContentType = "text/plain";//"application/json";
        var r = new System.Collections.Generic.List<ViewDataUploadFilesResult>();
        JavaScriptSerializer js = new JavaScriptSerializer();
        foreach (string file in context.Request.Files)
        {
            HttpPostedFile hpf = context.Request.Files[file] as HttpPostedFile;
            string FileName = string.Empty;
            if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE")
            {
                string[] files = hpf.FileName.Split(new char[] { '\\' });
                FileName = files[files.Length - 1];
            }
            else
            {
                FileName = hpf.FileName;
            }
            if (hpf.ContentLength == 0)
                continue;
            string savedFileName = GetUploadFolderPath(userName) + FileName;
            hpf.SaveAs(savedFileName);
            //"c:\\tmp\\" + FileName;
            r.Add(new ViewDataUploadFilesResult()
            {
                //Thumbnail_url = savedFileName,
                Name = FileName,
                Length = hpf.ContentLength,
                Type = hpf.ContentType
                
            });
            var uploadedFiles = new
            {
                files = r.ToArray()
            };
            var jsonObj = js.Serialize(uploadedFiles);
            //jsonObj.ContentEncoding = System.Text.Encoding.UTF8;
            //jsonObj.ContentType = "application/json;";
            context.Response.Write(jsonObj.ToString());
        }
    }

    private string GetUploadFolderPath(string userName)
    {
        string uploadFolder = ConfigurationManager.AppSettings["FolderPath"];
        string sDirPath = HttpContext.Current.Request.PhysicalApplicationPath + uploadFolder + userName;
        DirectoryInfo ObjSearchDir = new DirectoryInfo(sDirPath);
        if (!ObjSearchDir.Exists)
        {
            ObjSearchDir.Create();
        }
        return sDirPath +"\\";
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}

public class ViewDataUploadFilesResult
{
    public string Thumbnail_url { get; set; }
    public string Name { get; set; }
    public int Length { get; set; }
    public string Type { get; set; }
}