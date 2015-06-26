<%@ WebHandler Language="C#" Class="FileTransferHandler" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Text.RegularExpressions;
using System.Net;
using Pollinator.Common;

public class FileTransferHandler : IHttpHandler
{
    List<string> videoIds = new List<string>();
    YouTubeUltility youtube = new YouTubeUltility();
    private readonly JavaScriptSerializer js = new JavaScriptSerializer();
    private string UploadFolder = ConfigurationManager.AppSettings["FolderPath"];
    private string userFolder;

    public string StorageRoot
    {
        get
        {
            string fileFolder = UploadFolder + @"\" + userFolder + @"\";

            string sDirPath = HttpContext.Current.Request.PhysicalApplicationPath + fileFolder;
            sDirPath = sDirPath.Replace(@"\\", @"\");

            if (!Directory.Exists(sDirPath))
                Directory.CreateDirectory(sDirPath);

            return sDirPath;
        }
    }


    public bool IsReusable { get { return false; } }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.AddHeader("Pragma", "no-cache");
        context.Response.AddHeader("Cache-Control", "private, no-cache");

        HandleMethod(context);
    }

    // Handle request based on method
    private void HandleMethod(HttpContext context)
    {
        userFolder = context.Request["userFolder"];

        switch (context.Request.HttpMethod)
        {
            case "HEAD":
            case "GET":
                if (GivenFilename(context))
                    DeliverFile(context);
                else
                {
                    if (GivenVideoUrl(context))
                        AddVideoUrl(context);
                    else if (GivenPhotoUrl(context))
                        AddPhotoUrl(context);
                    else
                        ListCurrentFiles(context);
                }
                break;

            case "POST":
            case "PUT":
                if (context.Request["delete"] != null)
                    DeleteFile(context);
                else
                    UploadFile(context);
                break;

            case "DELETE":
                DeleteFile(context);
                break;

            case "OPTIONS":
                ReturnOptions(context);
                break;

            default:
                context.Response.ClearHeaders();
                context.Response.StatusCode = 405;
                break;
        }
    }

    private static void ReturnOptions(HttpContext context)
    {
        context.Response.AddHeader("Allow", "DELETE,GET,HEAD,POST,PUT,OPTIONS");
        context.Response.StatusCode = 200;
    }

    // Delete file from the server
    private void DeleteFile(HttpContext context)
    {
        string videoId = context.Request["v"];
        if (!string.IsNullOrEmpty(videoId))
            youtube.DeleleVideoYouTube(videoId);
        else
        {
            var filename = context.Request["f"];
            var physicalPath = context.Server.MapPath("~/" + filename).Replace(@"//", @"/");
            if (File.Exists(physicalPath))
            {
                File.Delete(physicalPath);
            }
        }
    }

    private void AddVideoUrl(HttpContext context)
    {
        var statuses = new List<FilesStatus>();
        AddVideoUrlToListStatus(context, statuses, context.Request["addVideoUrl"]);

        WriteJsonIframeSafe(context, statuses);
    }

    private void AddPhotoUrl(HttpContext context)
    {
        var statuses = new List<FilesStatus>();
        AddPhotoUrlToListStatus(context, statuses, context.Request["addPhotoUrl"]);

        WriteJsonIframeSafe(context, statuses);
    }

    // Upload file to the server
    private void UploadFile(HttpContext context)
    {
        if (string.IsNullOrEmpty(userFolder))
        {
            return;
        }
        var statuses = new List<FilesStatus>();
        var headers = context.Request.Headers;

        if (string.IsNullOrEmpty(headers["X-File-Name"]))
        {
            UploadWholeFile(context, statuses);
        }
        else
        {
            UploadPartialFile(headers["X-File-Name"], context, statuses);
        }

        WriteJsonIframeSafe(context, statuses);
    }

    // Upload partial file
    private void UploadPartialFile(string fileName, HttpContext context, List<FilesStatus> statuses)
    {
        if (context.Request.Files.Count != 1) throw new HttpRequestValidationException("Attempt to upload chunked file containing more than one fragment per request");

        if (userFolder.Contains("video"))
        {
            var file = context.Request.Files[0];
            youtube.UploadToYouTube(file, Path.GetFileNameWithoutExtension(file.FileName)).Wait();
            while (string.IsNullOrEmpty(youtube.videoId))
            {
                System.Threading.Thread.Sleep(500);
            }
            statuses.Add(new FilesStatus(youtube.videoId, context, Path.GetFileNameWithoutExtension(file.FileName), file.ContentLength));

        }
        else
        {
            var inputStream = context.Request.Files[0].InputStream;
            var fullName = StorageRoot + Path.GetFileName(fileName);

            using (var fs = new FileStream(fullName, FileMode.Append, FileAccess.Write))
            {
                var buffer = new byte[1024];

                var l = inputStream.Read(buffer, 0, 1024);
                while (l > 0)
                {
                    fs.Write(buffer, 0, l);
                    l = inputStream.Read(buffer, 0, 1024);
                }
                fs.Flush();
                fs.Close();
            }
            var relativeFolder = UploadFolder + userFolder;
            statuses.Add(new FilesStatus(context, relativeFolder, new FileInfo(fullName)));
        }
    }


    // Upload entire file
    private void UploadWholeFile(HttpContext context, List<FilesStatus> statuses)
    {
        if (userFolder.Contains("video"))
        {
            var uploadId = context.Request["uploadId"];
            int numFile = context.Request.Files.Count;
            for (int i = 0; i < numFile; i++)
            {
                var file = context.Request.Files[i];
                youtube.uploadId = uploadId;
                youtube.videoId = string.Empty;
                UploadingDispatcher.Add(uploadId);
                youtube.UploadToYouTube(file, Path.GetFileNameWithoutExtension(file.FileName)).Wait();
                while (string.IsNullOrEmpty(youtube.videoId))
                {
                    System.Threading.Thread.Sleep(500);
                }
                statuses.Add(new FilesStatus(youtube.videoId, context, Path.GetFileNameWithoutExtension(file.FileName), file.ContentLength));
            }
        }
        else
        {
            var relativeFolder = UploadFolder + userFolder;
            for (int i = 0; i < context.Request.Files.Count; i++)
            {
                var file = context.Request.Files[i];
                file.SaveAs(StorageRoot + Path.GetFileName(file.FileName));

                string fullName = Path.GetFileName(file.FileName);
                statuses.Add(new FilesStatus(context, relativeFolder, fullName, file.ContentLength));
            }
        }
    }

    private void WriteJsonIframeSafe(HttpContext context, List<FilesStatus> statuses)
    {
        context.Response.AddHeader("Vary", "Accept");
        try
        {
            if (context.Request["HTTP_ACCEPT"].Contains("application/json"))
                context.Response.ContentType = "application/json";
            else
                context.Response.ContentType = "text/plain";
        }
        catch
        {
            context.Response.ContentType = "text/plain";
        }

        var jsonObj = js.Serialize(statuses.ToArray());
        context.Response.Write(jsonObj);
    }

    private static bool GivenVideoUrl(HttpContext context)
    {
        return !string.IsNullOrEmpty(context.Request["addVideoUrl"]);
    }

    private static bool GivenPhotoUrl(HttpContext context)
    {
        return !string.IsNullOrEmpty(context.Request["addPhotoUrl"]);
    }

    private static bool GivenFilename(HttpContext context)
    {
        return !string.IsNullOrEmpty(context.Request["f"]);
    }

    private void DeliverFile(HttpContext context)
    {
        var filename = context.Request["f"];
        if (filename.StartsWith(ConfigurationManager.AppSettings["FolderPath"]))
        {
            var physicalPath = context.Server.MapPath("~/" + filename).Replace(@"//", @"/");

            if (File.Exists(physicalPath))
            {
                context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                context.Response.ContentType = "application/octet-stream";
                context.Response.ClearContent();
                context.Response.WriteFile(physicalPath);
                context.Response.Write(physicalPath);
            }
            else
                context.Response.StatusCode = 404;
        }
        else
        {
            context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
            context.Response.ContentType = "application/octet-stream";
            context.Response.ClearContent();
            context.Response.Write(filename);
        }
    }

    private void ListCurrentFiles(HttpContext context)
    {
        string jsonObj = "";
        if (string.IsNullOrEmpty(userFolder))
            return;

        if (userFolder.Contains("video"))
        {
            List<FilesStatus> list = new List<FilesStatus>();
            var videoUrls = context.Request["youtubeUrl"];
            if (!string.IsNullOrEmpty(videoUrls))
            {
                string[] videoUrlArray = videoUrls.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);

                for (int i = 0; i < videoUrlArray.Length; i++)
                {
                    AddVideoUrlToListStatus(context, list, videoUrlArray[i]);
                }
            }

            jsonObj = js.Serialize(list);
        }
        else
        {
            List<FilesStatus> list = new List<FilesStatus>();
            var physicalFolder = StorageRoot;
            var relativeFolder = UploadFolder + userFolder;
            if (Directory.Exists(physicalFolder))
            {
                var files =
                    new DirectoryInfo(physicalFolder)
                        .GetFiles("*", SearchOption.TopDirectoryOnly)
                        .Where(f => !f.Attributes.HasFlag(FileAttributes.Hidden))
                        .Select(f => new FilesStatus(context, relativeFolder, f))
                        .ToArray();

                list.AddRange(files);
            }

            var photoUrls = context.Request["photoUrl"];
            if (!string.IsNullOrEmpty(photoUrls))
            {
                string[] photoUrlArray = photoUrls.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);

                for (int i = 0; i < photoUrlArray.Length; i++)
                {
                    var url = photoUrlArray[i].Trim();
                    if (!url.StartsWith(UploadFolder.Replace("\\", "")))
                    {
                        AddPhotoUrlToListStatus(context, list, url);
                    }
                }
            }

            jsonObj = js.Serialize(list);
        }

        context.Response.AddHeader("Content-Disposition", "inline; filename=\"files.json\"");
        context.Response.Write(jsonObj);
        context.Response.ContentType = "application/json";
    }

    private void AddVideoUrlToListStatus(HttpContext context, List<FilesStatus> list, string videoUrl)
    {
        string videoId = string.Empty;
        Match regexMatch = Regex.Match(videoUrl.Trim(), "^[^v]+v[=/](.{11}).*", RegexOptions.IgnoreCase);
        if (regexMatch.Success)
        {
            videoId = regexMatch.Groups[1].Value;
        }

        if (!string.IsNullOrEmpty(videoId))
        {
            Google.YouTube.YouTubeRequest request;
            Google.YouTube.Video video = youtube.RetrieveVideo(videoId, out request);
            if (video != null)
            {
                list.Add(new FilesStatus(videoId, context, video.Title));
            }
        }
    }

    private void AddPhotoUrlToListStatus(HttpContext context, List<FilesStatus> list, string photoUrl)
    {
        if (photoUrl.EndsWith("/"))
            photoUrl = photoUrl.Substring(0, photoUrl.Length - 1);

        if (!photoUrl.StartsWith("http://") && !photoUrl.StartsWith("https://"))
            photoUrl = "http://" + photoUrl;
        try
        {
            if (Utility.RemoteImageExists(photoUrl))
            {
                var listUrls = list.Select(item => item.url).ToList();
                if (!listUrls.Contains(photoUrl))
                {
                    list.Add(new FilesStatus(context, photoUrl));
                }
            }
            else
                Logger.Error("AddPhotoUrlToListStatus: check RemoteImageExists fail:" + photoUrl);    
        }
        catch (Exception ex) { }
    }
}


public class FilesStatus
{
    public string group { get; set; }
    public string name { get; set; }
    public string type { get; set; }
    public int size { get; set; }
    public string progress { get; set; }
    public string url { get; set; }
    public string thumbnail_url { get; set; }
    public string delete_url { get; set; }
    public string upload_url { get; set; }
    public string delete_type { get; set; }
    public string error { get; set; }
    public string videoId { get; set; }

    public FilesStatus() { }
    public FilesStatus(string videoId, HttpContext context, string fileName, int fileLength)
    {
        name = fileName;
        type = "video";
        size = fileLength;
        progress = "1.0";
        thumbnail_url = string.Format("http://img.youtube.com/vi/{0}/0.jpg", videoId);

        string HandlerPath = context.Request.ApplicationPath + "/Modules/Upload/";
        HandlerPath = HandlerPath.Replace(@"//", "/");
        delete_url = HandlerPath + "FileTransferHandler.ashx?delete=true&v=" + videoId;
        delete_type = "POST";
        this.videoId = videoId;
    }

    public FilesStatus(string videoId, HttpContext context, string title)
    {
        name = title;
        type = "video";
        progress = "1.0";

        string HandlerPath = context.Request.ApplicationPath + "/Modules/Upload/";
        HandlerPath = HandlerPath.Replace(@"//", "/");
        delete_url = HandlerPath + "FileTransferHandler.ashx?delete=true&v=" + videoId;
        delete_type = "POST";
        this.videoId = videoId;
    }

    public FilesStatus(HttpContext context, string photoUrl)
    {

        int index = photoUrl.LastIndexOf("/");
        if (index > -1)
        {
            name = photoUrl.Substring(index + 1);
        }
        else
        {
            name = photoUrl;
        }
        type = "image/png";

        progress = "1.0";

        string HandlerPath = context.Request.ApplicationPath + "/Modules/Upload/";
        HandlerPath = HandlerPath.Replace(@"//", "/");
        url = HandlerPath + "FileTransferHandler.ashx?f=" + photoUrl;
        thumbnail_url = photoUrl;
        upload_url = photoUrl;
        delete_url = "";
        delete_type = "POST";
    }

    public FilesStatus(HttpContext context, string folderPath, FileInfo fileInfo)
    {
        SetValues(context, folderPath, fileInfo.Name, (int)fileInfo.Length);
    }

    public FilesStatus(HttpContext context, string folderPath, string fileName, int fileLength)
    {
        SetValues(context, folderPath, fileName, fileLength); 
    }

    private void SetValues(HttpContext context, string folderPath, string fileName, int fileLength)
    {
        string HandlerPath = context.Request.ApplicationPath + "/Modules/Upload/";
        HandlerPath = HandlerPath.Replace(@"//", "/");
        if (fileName.Length > 32)
        {
            string sub1 = fileName.Substring(0, 19);
            string sub2 = fileName.Substring(fileName.Length - 10);
            name = sub1 + "..." + sub2;
        }
        else
            name = fileName;// fileName;

        type = "image/png";
        size = fileLength;
        progress = "1.0";

        upload_url = folderPath + "\\" + fileName;

        string f = HttpUtility.UrlEncode(folderPath + "\\" + fileName);
        url = HandlerPath + "FileTransferHandler.ashx?f=" + f;
        thumbnail_url = HandlerPath + "Thumbnail.ashx?f=" + f;
        delete_url = HandlerPath + "FileTransferHandler.ashx?delete=true&f=" + f;
        delete_type = "POST";
    }
}
