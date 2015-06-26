using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.UI;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Admin_CleanUnusedFolders : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
    }


    protected void btnDeleteJunkyUploadFolder_Click(object sender, EventArgs e)
    {
        try
        {
            PollinatorEntities mydb = new PollinatorEntities();

            var listSponsorPhoto = mydb.Sponsors.Select(pi => pi.PhotoUrl).ToList();
            List<string> folderList = new List<string>();
            string folderName;
            int firstIndex;
            int lastIndex;

            foreach (var url in listSponsorPhoto)
            {
                firstIndex = url.IndexOf("/") + 1;
                lastIndex = url.LastIndexOf("/");
                if (firstIndex != -1)
                {
                    folderName = url.Substring(firstIndex, lastIndex - firstIndex);
                    folderList.Add(folderName);
                }
            }

            var listPolinatorPhoto = mydb.PolinatorInformations.Select(pi => pi.PhotoUrl).ToList();
            foreach (var url in listPolinatorPhoto)
            {

                folderName = Utility.GetUserFolder(url);
                if (!string.IsNullOrEmpty(folderName))
                    folderList.Add(folderName);
            }
            folderList.Add("Admin");

            string uploadFolder = Request.MapPath("~/" + ConfigurationManager.AppSettings["FolderPath"]).Replace(@"//", "/");
            DirectoryInfo dInfo = new DirectoryInfo(uploadFolder);
            DirectoryInfo[] subdirs = dInfo.GetDirectories();

            for (int i = 0; i < subdirs.Length; i++)
            {
                if (!folderList.Contains(subdirs[i].Name))
                {
                    Directory.Delete(subdirs[i].FullName, true);
                }
            }

            GoToAlertMessage(panelSuccessMessage);

        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_CleanUnusedFolders).Name + "btnDeleteJunkyUploadFolder_Click(). ", ex);
            GoToAlertMessage(panelErrorMessage);
        }
    }

    private void GoToAlertMessage(Control alert)
    {
        alert.Visible = true;

        //This script will scroll page to the location of message
        string scrollIntoView = @"
             $(document).ready(function () {
                //The element doesn't show up immediately, must set latency for it to bring up
                setTimeout(goToAlertMessage, 10);
            });

            function goToAlertMessage()
            {
                var el = document.getElementById('" + alert.ClientID + @"');
                el.scrollIntoView(true);
            }
        ";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "scrollIntoView_script", scrollIntoView, true);
    }
}