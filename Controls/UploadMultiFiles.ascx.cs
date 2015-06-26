using System;
using System.IO;
using System.Web.UI;
public partial class Controls_UploadMultiFiles : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (FileType == "image")
                uploadiframe.Src = ResolveUrl("~/Modules/Upload/ImageIndex?userFolder=" + UserFolder + "&photoUrl=" + PhotoUrl);
            else if (FileType == "video")
                uploadiframe.Src = ResolveUrl("~/Modules/Upload/VideoIndex?userFolder=" + UserFolder + "&youtubeUrl=" + YoutubeUrl);

            uploadiframe.ID = "uploadiframe" + FileType;

            //This script will set user folder
            string setUserFloder = @"
            setTimeout(function () {
                var el = document.getElementById('userFolder{0}');
                if (el)
                    el.value='{1}';
            }, 20);        
            ";
            setUserFloder = setUserFloder.Replace("{0}", FileType);
            setUserFloder = setUserFloder.Replace("{1}", UserFolder);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "setUserFloder_script" + FileType, setUserFloder, true);
        }
    }
   
    public string UserFolder
    {
        get
        {
            string text = (string)ViewState["UserFolder"];
            if (text != null)
                return text;
            else
            {
                string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
                Random random = new Random();
                string RanNumber = DateTime.Now.Ticks + Convert.ToString(random.Next(1, 1000000000));
                if (FileType == "video")
                {
                    RanNumber += "video"; 
                }
                string sDirPath = Request.PhysicalApplicationPath + uploadFolder + RanNumber;
               

                if (!Directory.Exists(sDirPath))
                    Directory.CreateDirectory(sDirPath);
                return RanNumber;
            }
        }
        set
        {           
            ViewState["UserFolder"] = value;
        }
    }

    public string FileType
    {
        get
        {
            string text = (string)ViewState["FileType"];
            if (text != null)
                return text;
            else
                return "image";
        }
        set
        {
            ViewState["FileType"] = value;
        }
    }

    public Guid UserID
    {
        get
        {
            if (ViewState["UserID"]!=null)
                return (Guid)ViewState["UserID"];
            return new Guid();

        }
        set
        {
            ViewState["UserID"] = value;
        }
      }

    public string YoutubeUrl
    {
        get
        {
            if (ViewState["YoutubeUrl"] != null)
                return (string)ViewState["YoutubeUrl"];
            return string.Empty;

        }
        set
        {
            ViewState["YoutubeUrl"] = value;
        }
    }

    public string PhotoUrl
    {
        get
        {
            if (ViewState["PhotoUrl"] != null)
                return (string)ViewState["PhotoUrl"];
            return string.Empty;

        }
        set
        {
            ViewState["PhotoUrl"] = value;
        }
    }
    
}