using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Admin_EditSponsor : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // If querystring value is missing, send the user to SponsorList
            string sQuery = Request.QueryString["id"];
            if (string.IsNullOrEmpty(sQuery))
                Response.Redirect("SponsorList");

            int iQuery;
            if (!Int32.TryParse(sQuery, out iQuery))
                return;
            SponsorID = iQuery;

            this.dontDeletePreImage.Value = "0";

            if (SponsorID > 0)
            {
                var sponsor = GetSponsor();

                if (sponsor == null)
                    Response.Redirect("SponsorList");

                this.txtName.Text = sponsor.Name;
                this.txtWebsite.Text = sponsor.Website;
                this.txtPhotoUrl.Text = sponsor.PhotoUrl;
                this.chkIsActive.Checked = sponsor.IsActive;
             
                string photoUrl = Utility.ValidateImage(sponsor.PhotoUrl);
                imgPhoto.ImageUrl = photoUrl;

                if (!string.IsNullOrEmpty(photoUrl))
                {
                    this.linAddPhoto.InnerText = "Change photo";
                    this.dontDeletePreImage.Value = "1";
                }
                else
                {
                    this.txtPhotoUrl.Text = photoUrl;
                }
            }
            else
                this.txtName.Focus();

        }

    }


    protected void btnDelete_Click(object sender, EventArgs e)
    {
        var sponsor = GetSponsor();
        if (sponsor != null)
        {
            mydb.Sponsors.Remove(sponsor);
            if (!string.IsNullOrEmpty(sponsor.PhotoUrl))
            {
                string sFilePath = Request.MapPath("~/" + sponsor.PhotoUrl);
                if (File.Exists(sFilePath)) {
                    var path = Path.GetDirectoryName(sFilePath);
                    Directory.Delete(path, true);
                }
            }
            mydb.SaveChanges();
        }


        Response.Redirect("SponsorList");
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            Sponsor sponsor;
            if (SponsorID > 0)
            {
                sponsor = GetSponsor();

                GetValueFromControl(sponsor);

                mydb.Sponsors.Where(c => c.ID != sponsor.ID).ToList()
                    .ForEach(c => { c.IsActive = false; });

                mydb.SaveChanges();

                this.linAddPhoto.InnerText = "Change photo";
                this.dontDeletePreImage.Value = "1";
                string photoUrl = Utility.ValidateImage(sponsor.PhotoUrl);
                imgPhoto.ImageUrl = photoUrl;

                GoToAlertMessage(panelSuccessMessage);

            }
            else//Add new
            {
                mydb.Sponsors.ToList()
                .ForEach(c => { c.IsActive = false; });
                sponsor = new Sponsor();
                GetValueFromControl(sponsor);
                mydb.Sponsors.Add(sponsor);
                mydb.SaveChanges();
                GoToAlertMessage(panelSuccessMessage);
                Response.Redirect("SponsorList");

            }

        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_EditSponsor).Name + ".btnUpdate_Click().", ex);
            GoToAlertMessage(panelErrorMessage);
        }
    }

    private Sponsor GetSponsor()
    {
        var sponsor = (from ud in mydb.Sponsors
                       where ud.ID == SponsorID
                       select ud).FirstOrDefault();
        return sponsor;
    }

    private void GetValueFromControl(Sponsor sponsor)
    {
        sponsor.Name = txtName.Text;
        sponsor.Website = txtWebsite.Text;
        sponsor.PhotoUrl = txtPhotoUrl.Text;
        sponsor.IsActive = chkIsActive.Checked;
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
    #region Properties

    protected int SponsorID
    {
        get
        {
            return (int)ViewState["SponsorID"];

        }
        set
        {
            ViewState["SponsorID"] = value;
        }
    }


    #endregion
}