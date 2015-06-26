using System;
using System.Linq;
using System.Web.UI.WebControls;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Admin_SponsorList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        BindSponsors();
    }

    protected void Sponsor_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Sponsor.PageIndex = e.NewPageIndex;
        BindSponsors();
    }

    private void BindSponsors()
    {
        PollinatorEntities mydb = new PollinatorEntities();
        var list = (from sp in mydb.Sponsors
                    select new
                    {
                        sp.ID,
                        sp.Name,
                        sp.PhotoUrl,
                        sp.Website,
                        sp.IsActive,
                    }).ToList();

        Sponsor.DataSource = list;
        Sponsor.DataBind();
    }



    protected void Sponsor_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Image img = (Image)e.Row.FindControl("imgPhoto");
            string photoUrl = ((HiddenField)e.Row.FindControl("hdnPhotoUrl")).Value;
            photoUrl = Utility.ValidateImage(photoUrl);
            if (!string.IsNullOrEmpty(photoUrl))
                img.ImageUrl = photoUrl;
            else
                img.Visible = false;

        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        Response.Redirect("EditSponsor?id=0");
    }
}