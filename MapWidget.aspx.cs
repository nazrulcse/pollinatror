using System;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using Pollinator.DataAccess;
using System.Web.UI.HtmlControls;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using Pollinator.Common;


public partial class MapWidget : System.Web.UI.Page
{
    protected string PageURL
    {
        get { return HttpContext.Current.Request.Url.AbsoluteUri; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        PollinatorEntities mydb = new PollinatorEntities();
        var list = (from sp in mydb.Sponsors
                    select new
                    {
                        sp.Name,
                        sp.PhotoUrl,
                        sp.Website,
                    }).ToList();

        var typelist = (from sp in mydb.PollinatorTypes
                        select new
                        {
                            sp.ID,
                            sp.Name,
                        }).OrderBy(o => o.Name).ToList();

        var sizelist = (from sp in mydb.PollinatorSizes
                        select new
                        {
                            sp.ID,
                            sp.Name,
                        }).OrderBy(o => o.Name).ToList();

        var countrylist = (from sp in mydb.Countries
                           select new
                           {
                               sp.ID,
                               sp.Name,
                               sp.SortOder,
                           }).OrderBy(o => o.SortOder).ToList();

        this.SponsorJson = new JavaScriptSerializer().Serialize(list);
        this.PollinatorTypeJson = new JavaScriptSerializer().Serialize(typelist);
        this.PollinatorSizeJson = new JavaScriptSerializer().Serialize(sizelist);
        this.CountryJson = new JavaScriptSerializer().Serialize(countrylist);
        

        if (!IsPostBack )
        {
            //System.Web.UI.WebControls.LoginView LoginView2 = ((System.Web.UI.WebControls.LoginView)Master.FindControl("LoginView2"));
            //var texssst = LoginView2.ClientID;
            //ControlCollection controls= LoginView2.Controls;
            //HtmlAnchor aPreSince = (HtmlAnchor)LoginView2.FindControl("aPreSince");
            //var text = aPreSince.InnerText;
        }
    }

    public string SponsorJson
    {
        get
        {
            string text = (string)ViewState["SponsorJson"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["SponsorJson"] = value;
        }
    }
    public string PollinatorTypeJson
    {
        get
        {
            string text = (string)ViewState["PollinatorTypeJson"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["PollinatorTypeJson"] = value;
        }
    }
    public string PollinatorSizeJson
    {
        get
        {
            string text = (string)ViewState["PollinatorSizeJson"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["PollinatorSizeJson"] = value;
        }
    }
    public string CountryJson
    {
        get
        {
            string text = (string)ViewState["CountryJson"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["CountryJson"] = value;
        }
    }
}