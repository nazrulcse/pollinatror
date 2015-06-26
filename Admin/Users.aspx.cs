using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Admin_Users : System.Web.UI.Page
{
    #region Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["SearchUseKeyWork"] != null && Request.QueryString["ShowLastestKeyword"] != null)
            {
                string sSearch = Session["SearchUseKeyWork"].ToString();
                if (!string.IsNullOrEmpty(sSearch))
                    txtSearch.Text = sSearch;
            }

            BindUserAccounts(true);

            BindFilteringUI();
        }
    }
    protected void FilteringUI_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "All")
            this.UsernameToMatch = string.Empty;
        else
            this.UsernameToMatch = e.CommandName;

        this.OnlyShowBFF = false;
        BindUserAccounts(true);
    }

    protected void UserAccounts_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Image img = (Image)e.Row.FindControl("imgPhoto");
            HyperLink linkPhoto = (HyperLink)e.Row.FindControl("linkPhoto");

            img.ImageUrl = "";
            img.Visible = false;

            string photoUrl = ((HiddenField)e.Row.FindControl("hdnPhotoUrl")).Value;
            if (!string.IsNullOrEmpty(photoUrl))
            {
                string firstPhotoUrl;
                string[] photoUrls = photoUrl.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
                if (photoUrls.Length > 0)
                    firstPhotoUrl = photoUrls[0];
                else
                    firstPhotoUrl = photoUrl;

                firstPhotoUrl = Utility.ValidateImage(firstPhotoUrl);

                if (!string.IsNullOrEmpty(firstPhotoUrl))
                {
                    img.ImageUrl = firstPhotoUrl;
                    img.Visible = true;
                }
            }

            linkPhoto.Attributes["href"] = img.ImageUrl;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        this.OnlyShowBFF = false;
        BindUserAccounts(true);
    }

    protected void lnkBFF_Click(object sender, EventArgs e)
    {
        this.lnkBFF.ToolTip = "";
        this.OnlyShowBFF = true;
        BindUserAccounts(false);
    }

    protected void UserAccounts_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        UserAccounts.PageIndex = e.NewPageIndex;
        BindUserAccounts(false);
    }


    #endregion

    #region Private methods
    private void BindFilteringUI()
    {
        string[] filterOptions = { "All", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
        FilteringUI.DataSource = filterOptions;
        FilteringUI.DataBind();
    }

    private void BindUserAccounts(bool refreshTotal)
    {
        var sSearch = txtSearch.Text.Trim().ToLower();
        Session["SearchUseKeyWork"] = sSearch;

        PollinatorEntities mydb = new PollinatorEntities();
        var users = (from ud in mydb.UserDetails
                     from pi in mydb.PolinatorInformations
                     where ud.UserId == pi.UserId &&
                        (!this.OnlyShowBFF || (this.OnlyShowBFF && ud.MembershipLevel >= 1)) &&
                        ((this.UsernameToMatch == string.Empty) ||
                            ud.FirstName.StartsWith(this.UsernameToMatch))
                            && (sSearch == string.Empty ||
                            ud.FirstName.ToLower().IndexOf(sSearch) >= 0 ||
                            ud.LastName.ToLower().IndexOf(sSearch) >= 0 ||
                            pi.OrganizationName.ToLower().IndexOf(sSearch) >= 0 ||
                            pi.LandscapeStreet.ToLower().IndexOf(sSearch) >= 0 ||
                            pi.LandscapeCity.ToLower().IndexOf(sSearch) >= 0 ||
                            pi.LandscapeState.ToLower().IndexOf(sSearch) >= 0
                           )
                     orderby pi.IsApproved, pi.LastUpdated descending
                     select new
                     {
                         ud.UserId,
                         ud.FirstName,
                         ud.LastName,
                         ud.MembershipLevel,
                         pi.PhotoUrl,
                         pi.OrganizationName,
                         pi.LandscapeStreet,
                         pi.LandscapeCity,
                         pi.LandscapeState,
                         pi.IsApproved,
                         pi.IsNew,
                         pi.LastUpdated
                     }).ToList();


        UserAccounts.DataSource = users;
        UserAccounts.DataBind();

        if (refreshTotal)
        {
            var totalUser = users.Count;
            var totalPremium = users.Where(u => u.MembershipLevel > 0).Count();
            lblSummary.Text = String.Format("Total: {0} users ({1} ", totalUser, totalPremium);
           // lblSummary.Text = String.Format("Total: {0} users ({1} <font color='violet'>BFF </font> users)", totalUser, totalPremium);
        }

    }
    #endregion

    protected string GetAddress(string landscapeStreet, string landscapeCity, string landscapeState)
    {
        string sAddress = string.Empty;
        if (!string.IsNullOrEmpty(landscapeStreet))
            sAddress += ", " + landscapeStreet;
        if (!string.IsNullOrEmpty(landscapeCity))
            sAddress += ", " + landscapeCity;
        if (!string.IsNullOrEmpty(landscapeState))
            sAddress += ", " + landscapeState;
        // if (!string.IsNullOrEmpty(landscapeZipcode))
        //  sAddress += ", " +landscapeZipcode;
        if (sAddress.Length > 2)
        {
            sAddress = sAddress.Substring(2);
        }
        return Server.HtmlEncode(sAddress);
    }

    #region Properties
    public string UsernameToMatch
    {
        get
        {
            object o = ViewState["UsernameToMatch"];
            if (o == null)
                return string.Empty;
            else
                return (string)o;
        }
        set
        {
            ViewState["UsernameToMatch"] = value;
        }
    }

    public bool OnlyShowBFF
    {
        get
        {
            object o = ViewState["OnlyShowBFF"];
            if (o == null)
                return false;
            else
                return (bool)o;
        }
        set
        {
            ViewState["OnlyShowBFF"] = value;
        }
    }

    #endregion
}