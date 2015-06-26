using System;
using System.Linq;
using System.Web;
using Pollinator.DataAccess;

public partial class Admin_ExportData : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {
        try
        {
            byte? membeshipLevel = null;
            string filename = "AllUsers";
            if (drMemberShip.SelectedValue == "0")//Share User
            {
                membeshipLevel = 0;
                filename = "ShareUsers";
            }
            else if (drMemberShip.SelectedValue == "1")//BFF User
            {
                membeshipLevel = 1;
                filename = "BffUsers";
            }

            //Query data
            PollinatorEntities mydb = new PollinatorEntities();
            var listData = (from ud in mydb.UserDetails.Where(ud => !membeshipLevel.HasValue || ud.MembershipLevel == membeshipLevel || (ud.MembershipLevel > membeshipLevel && membeshipLevel == 1))
                            join user in mydb.Memberships
                            on ud.UserId equals user.UserId
                            into group1
                            from ui in group1.DefaultIfEmpty()
                            join pi in mydb.PolinatorInformations
                            on ud.UserId equals pi.UserId
                            join py in mydb.PollinatorTypes
                            on pi.PollinatorType equals py.ID
                            into group2
                            from uit in group2.DefaultIfEmpty()
                            join ps in mydb.PollinatorSizes
                            on pi.PollinatorSize equals ps.ID
                            join c in mydb.Countries
                            on pi.LandscapeCountry equals c.ID
                            into group3
                            from ex in group3.DefaultIfEmpty()
                            orderby pi.IsApproved, pi.LastUpdated descending
                            select new ImportExportFields
                            {
                                UserId = ud.UserId,
                                FirstName = ud.FirstName,
                                LastName = ud.LastName,
                                OrganizationName = pi.OrganizationName != null ? pi.OrganizationName : string.Empty,
                                Website = pi.Website != null ? pi.Website : string.Empty,
                                PhoneNumber = ud.PhoneNumber != null ? ud.PhoneNumber : string.Empty,
                                Email = (ui != null && ui.Email != null) ? ui.Email : string.Empty,
                                PollinatorTypeName = (uit != null && uit.Name != null) ? uit.Name : (ud.MembershipLevel == 0) ? string.Empty : "Bee Friendly Farmers",
                                OrganizationDescription = pi.Description != null ? pi.Description : string.Empty,
                                PollinatorSizeName = ps.Name,
                                LandscapeStreet = pi.LandscapeStreet != null ? pi.LandscapeStreet : string.Empty,
                                LandscapeCity = pi.LandscapeCity != null ? pi.LandscapeCity : string.Empty,
                                LandscapeState = pi.LandscapeState != null ? pi.LandscapeState : string.Empty,
                                LandscapeZipcode = pi.LandscapeZipcode != null ? pi.LandscapeZipcode : string.Empty,
                                LandscapeCountryName = (ex != null && ex.Name != null) ? ex.Name : string.Empty,
                                Latitude = pi.Latitude,
                                Longitude = pi.Longitude,
                            }).ToList();

            this.EnableViewState = false;
            if (drExportFormat.SelectedValue == "Excel")
            {
                filename = filename + System.DateTime.Now.ToString("_MMddyyyy_HHmm") + ".xlsx";
                ImportExportUltility.ExportExcel(Response, filename, listData);
            }
            else
            {
                filename = filename + System.DateTime.Now.ToString("_MMddyyyy_HHmm") + ".csv";
                ImportExportUltility.ExportCSV(Response, filename, listData);
            }

        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_ExportData).Name + "btnExport_Click(). Exception:", ex);          
        }
    }    

}