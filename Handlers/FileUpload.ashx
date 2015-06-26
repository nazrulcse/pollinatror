<%@ WebHandler Language="C#" Class="FileUpload" %>

using System;
using System.Web;
using System.IO;
using Pollinator.Common;

public class FileUpload : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    YouTubeUltility youtube = new YouTubeUltility();
    string uploadId;
    
    public void ProcessRequest(HttpContext context)
    {
        try
        {

            if (context.Request.QueryString["path"] != null && context.Request.QueryString["file"] != null)
            {
                //for deleting existing File by file name
                string Serverpath = context.Request.QueryString["path"].ToString();
                string filename = context.Request.QueryString["file"].ToString();
                Serverpath = Serverpath + "\\" + filename;

                if (File.Exists(Serverpath))
                {
                    File.Delete(Serverpath);
                }
            }
            else if (context.Request.QueryString["filepath"] != null && context.Request.QueryString["file"] != null)
            {
                //for downloading existing File
                string filepath = context.Request.QueryString["filepath"].ToString();
                string file = context.Request.QueryString["file"].ToString();

                if (File.Exists(filepath + "\\" + file))
                {
                    context.Response.Clear();
                    context.Response.ContentType = "application/octet-stream";
                    context.Response.AddHeader("Content-Disposition", string.Format("attachment; filename=\"{0}\"", file));
                    context.Response.WriteFile(filepath + "\\" + file);
                    context.Response.Flush();
                }

            }
            else
            {
                //for uploading new File          
                var postedFile = context.Request.Files[0];
                string filesize = System.Configuration.ConfigurationManager.AppSettings["FileSize"];
                int mFileSize = postedFile.ContentLength / 1048576;
                if (mFileSize > Convert.ToInt32(filesize))
                {
                    string msg = "{";
                    msg += string.Format("error:'{0}'\n","Uploaded bytes exceed file size");
                    msg += "}";
                    context.Response.Write(msg);
                    return;
                }
                
                string fileName = GetFileName(postedFile);

                if (postedFile.ContentType.Contains("video") || fileName.EndsWith(".flv"))
                {                  
                    uploadId = context.Request.QueryString["uploadId"];
                    youtube.uploadId = uploadId;
                    youtube.videoId=string.Empty;
                    UploadingDispatcher.Add(uploadId);
                    youtube.UploadToYouTube(postedFile, Path.GetFileNameWithoutExtension(fileName)).Wait();   
                    while(string.IsNullOrEmpty( youtube.videoId)){
                        System.Threading.Thread.Sleep(2000);
                    }    
                    string msg = "{";
                    msg += string.Format("error:'{0}',\n", string.Empty);                    
                    msg += string.Format("upfile:'{0}'\n", youtube.videoId);
                    msg += "}";
                    context.Response.Write(msg);
                 
                }
                else
                {
                    string userFolder;
                    if (context.Request["userFolder"] == null)
                    {
                        Random random = new Random();
                        string RanNumber = DateTime.Now.Ticks + Convert.ToString(random.Next(1, 1000000000));
                        userFolder = RanNumber;
                    }
                    else
                    {
                        userFolder = context.Request["userFolder"].ToString();
                    }

                    string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
                    
                    //remove old user folder then re-create 
                    try
                    {
                        var oldPath = context.Request.QueryString["oldPath"];
                        if (!string.IsNullOrEmpty(oldPath))
                        {
                            string oldPhysiacalFile = context.Request.MapPath("~/" + oldPath);
                            if (File.Exists(oldPhysiacalFile))
                            {
                                var path = Path.GetDirectoryName(oldPhysiacalFile);
                                Directory.Delete(path, true);
                            }
                        }
                    }
                    catch (Exception ex)
                    {}

                    //upload new file to new dir
                    string sDirPath = HttpContext.Current.Request.PhysicalApplicationPath + uploadFolder + userFolder;                                     

                    if (!Directory.Exists(sDirPath))
                        Directory.CreateDirectory(sDirPath);

                    string fileDirectory = sDirPath + "\\" + fileName;
                    postedFile.SaveAs(fileDirectory);

                    //Set response message
                    string msg = "{";
                    msg += string.Format("error:'{0}',\n", string.Empty);
                    msg += string.Format("upfile:'{0}',\n", fileName);
                    msg += string.Format("serverpath:'{0}'\n", uploadFolder.Replace(@"\", "") + "/" + userFolder);
                    msg += "}";
                    context.Response.Write(msg);
                }
            }            
        }
        catch (Exception ex)
        {
            Logger.Error("FileUpload ProcessRequest method line 118", ex);
            string msg = "{";
            msg += string.Format("error:'{0}'\n", ex.Message);
          
            msg += "}";
            context.Response.Write(msg);      
        }
    }

    private static string GetFileName(HttpPostedFile postedFile)
    {
        string fileName;

        //For IE to get file name
        if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE")
        {
            string[] files = postedFile.FileName.Split(new char[] { '\\' });
            fileName = files[files.Length - 1];

        }
        //For Other Browser to get file name
        else
        {
            fileName = postedFile.FileName;
        }
        return fileName;
    }


    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}