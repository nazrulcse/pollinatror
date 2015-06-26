using System;
using System.Linq;
using System.Web.UI.WebControls;
using Pollinator.DataAccess;

public partial class Controls_RegisterUserStep2 : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PollinatorEntities mydb = new PollinatorEntities();
            var countryList = (from ct in mydb.Countries orderby ct.SortOder, ct.Name
                               select new { ct.ID, ct.Name, ct.SortOder }).ToList();

            
            DropDownList ddlCountry = this.ddlCountry;
            if (ddlCountry != null)
            {
                ddlCountry.DataSource = countryList;
                ddlCountry.DataValueField = "ID";
                ddlCountry.DataTextField = "Name";
                ddlCountry.DataBind();
            }

            var pollinatorSizeList = (from ps in mydb.PollinatorSizes
                                      select new { ps.ID, ps.Name }).OrderBy(o => o.ID).ToList();

            var pollinatorTypeList = (from pt in mydb.PollinatorTypes
                                      select new { pt.ID, pt.Name }).OrderBy(o => o.Name).ToList();

            DropDownList ddlPollinatorSize = this.ddlPollinatorSize;
            if (ddlPollinatorSize != null)
            {
                ddlPollinatorSize.DataSource = pollinatorSizeList;
                ddlPollinatorSize.DataValueField = "ID";
                ddlPollinatorSize.DataTextField = "Name";
                ddlPollinatorSize.DataBind();
            }
            DropDownList ddlPollinatorType = this.ddlPollinatorType;
            if (ddlPollinatorType != null)
            {
                ddlPollinatorType.DataSource = pollinatorTypeList;
                ddlPollinatorType.DataValueField = "ID";
                ddlPollinatorType.DataTextField = "Name";
                ddlPollinatorType.DataBind();
            }


            var organizationList = (from ct in mydb.Organizations
                               orderby ct.SortOder, ct.Name
                                    select new { ct.ID, ct.SortOder, ct.Name}).ToList();


            DropDownList ddlFindOut = this.ddlFindOut;
            if (ddlCountry != null)
            {
                ddlFindOut.DataSource = organizationList;
                ddlFindOut.DataValueField = "ID";
                ddlFindOut.DataTextField = "Name";
                ddlFindOut.DataBind();
            }

        }
    }
}
