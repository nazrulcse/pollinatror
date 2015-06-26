using System;
using System.Linq;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.DataAccess;

public partial class PollinatorInfo : System.Web.UI.Page
{

    PollinatorEntities mydb = new PollinatorEntities();

    #region Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

            // If querystring value is missing, send the user to ManageUsers.aspx
            string sQuery = Request.QueryString["user"];
            if (string.IsNullOrEmpty(sQuery))
                Response.Redirect("ShareMap");
            UserID = new Guid(sQuery);

            // Get information about this user
            MembershipUser usr = System.Web.Security.Membership.GetUser(UserID);

            if (usr != null)
                UserName = usr.UserName;

            var userDetail = GetUser();

            if (userDetail == null)
                Response.Redirect("ShareMap");

            var polinatorInformation = GetPolinatorInfo();

            if (polinatorInformation == null)
                Response.Redirect("ShareMap");


            string sAddress = string.Empty;
            if (!string.IsNullOrEmpty(polinatorInformation.LandscapeStreet))
                sAddress+= ", "+ polinatorInformation.LandscapeStreet ;
            if (!string.IsNullOrEmpty(polinatorInformation.LandscapeCity))
                sAddress += ", " + polinatorInformation.LandscapeCity;
            if (!string.IsNullOrEmpty(polinatorInformation.LandscapeState))
                sAddress += ", " + polinatorInformation.LandscapeState;
            if (!string.IsNullOrEmpty(polinatorInformation.LandscapeZipcode))
                sAddress += ", " + polinatorInformation.LandscapeZipcode;



            if (!string.IsNullOrEmpty(polinatorInformation.LandscapeCountry))
            {
                var countrylist = (from sp in mydb.Countries
                                   where sp.ID == polinatorInformation.LandscapeCountry
                                   select new
                                   {
                                       sp.ID,
                                       sp.Name,
                                       sp.SortOder,
                                   }).OrderBy(o => o.SortOder).ToList();
                if (countrylist.Count > 0)
                {
                    sAddress += ", " + countrylist[0].Name.ToString();
                }
                else
                {
                    sAddress += ", " + polinatorInformation.LandscapeCountry;
                }
            }

            if (sAddress.Length > 2)
            {
                sAddress = sAddress.Substring(2);
            }




            LandspaceAddress.Text = Server.HtmlEncode(sAddress);
            Organization.Text = Server.HtmlEncode(polinatorInformation.OrganizationName);
            Description.Text = Server.HtmlEncode(polinatorInformation.Description);
            this.Photos = polinatorInformation.PhotoUrl;
            this.PollinatorName = Server.HtmlEncode(userDetail.FirstName);

        }
    }

    #endregion

    #region Private methods

    private void BindPollinatorSize(DropDownList control)
    {
        var pollinatorSizes = (from ps in mydb.PollinatorSizes
                               select new { ps.ID, ps.Name }).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorSizes;
        control.DataBind();
    }

    private void BindPollinatorType(DropDownList control)
    {
        var pollinatorTypes = (from ps in mydb.PollinatorTypes
                               select new { ps.ID, ps.Name }).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorTypes;
        control.DataBind();
    }

    private PolinatorInformation GetPolinatorInfo()
    {
        var polinatorInformation = (from pi in mydb.PolinatorInformations
                                    where pi.UserId == UserID
                                    select pi).FirstOrDefault();
        return polinatorInformation;
    }

    private UserDetail GetUser()
    {
        var userDetail = (from ud in mydb.UserDetails
                          where ud.UserId == UserID
                          select ud).FirstOrDefault();
        return userDetail;
    }
    #endregion

    #region Properties

    private string UserName
    {
        get
        {
            string text = (string)ViewState["UserName"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["UserName"] = value;
        }
    }

    private Guid UserID
    {
        get
        {
            return (Guid)ViewState["UserID"];

        }
        set
        {
            ViewState["UserID"] = value;
        }
    }

    public string Address
    {
        get
        {
            string text = (string)ViewState["Address"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["Address"] = value;
        }
    }

    public string PollinatorName
    {
        get
        {
            string text = (string)ViewState["PollinatorName"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["PollinatorName"] = value;
        }
    }


    public string Photos
    {
        get
        {
            string text = (string)ViewState["Photos"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["Photos"] = value;
        }
    }
    #endregion
}