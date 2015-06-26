using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using Pollinator.DataAccess;

public partial class WindowBox_WindowBox : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        BindDataDropdownlist();
    }

    private void BindDataDropdownlist()
    {
        var countryList = (from ct in mydb.Countries
                           select new { ct.ID, ct.Name, ct.SortOder }).OrderBy(o => o.SortOder).ToList();

        if (ddlCountry != null)
        {
            ddlCountry.DataSource = countryList;
            ddlCountry.DataValueField = "ID";
            ddlCountry.DataTextField = "Name";
            ddlCountry.DataBind();
        }
    }
}