using System;

using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.DataAccess;

public partial class Controls_MapViewControl : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {

                PollinatorEntities mydb = new PollinatorEntities();


                var orglist = (from sp in mydb.Organizations
                               select new {
                                       sp.ID,
                                       sp.SortOder,
                                       sp.Name,
                                   }).OrderBy(o => o.SortOder).ToList();
           
                this.OrgListJson = new JavaScriptSerializer().Serialize(orglist);

                var list = (from sp in mydb.Sponsors.Where(s => s.IsActive == true)
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
            }
            catch (global::System.Exception ex)
            {
                Response.Write(ex.Message);
                //write log
                Pollinator.Common.Logger.Error("Occured in function: " + typeof(Controls_MapViewControl).Name + ".Page_Load()", ex);
            }

        }
    }

    protected string PageURL
    {
        get { return HttpContext.Current.Request.Url.AbsoluteUri; }
    }

    public string OrgListJson
    {
        get
        {
            string text = (string)ViewState["OrgListJson"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["OrgListJson"] = value;
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