<%@ WebHandler Language="C#" Class="Map" %>


using System;

using System.Web.Security;
using System.Web.UI;
using System.Linq;
using System.Web.UI.WebControls;
using System.IO;
using System.Collections.Generic;

using System.Web;
using System.Web.Script.Serialization;
using Pollinator.Common;
using Pollinator.DataAccess;

public class Map : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string keyword = (context.Request.QueryString["keyword"] != null) ? context.Request.QueryString["keyword"] : "";
        string userType = (context.Request.QueryString["userType"] != null) ? context.Request.QueryString["userType"] : "";
        string findOutFilter = (context.Request.QueryString["findOutFilter"] != null) ? context.Request.QueryString["findOutFilter"] : "";
        string pollinatorType = (context.Request.QueryString["pollinatorType"] != null) ? context.Request.QueryString["pollinatorType"] : "";
       
        PollinatorEntities mydb = new PollinatorEntities();

        int[] MembershipLevelArray;
        if (string.IsNullOrEmpty(userType))
        {
            MembershipLevelArray = new int[4] { 0, 1,2,3 };
        }
        else
        {
            string[] tokens = userType.Split(',');
            MembershipLevelArray = Array.ConvertAll<string, int>(tokens, int.Parse);
        }

        int[] FindOutFilterArray;
        if (!string.IsNullOrEmpty(findOutFilter))
        {
            string[] tokens = findOutFilter.Split(',');
            FindOutFilterArray = Array.ConvertAll<string, int>(tokens, int.Parse);           
        }
        else
        {
            var orglist = (from sp in mydb.Organizations select new { sp.ID }).ToList();
            List<int> list = new List<int>();
            foreach (var row in orglist)
            {
                list.Add(row.ID);
            }
            list.Add(0);
            FindOutFilterArray = list.ToArray();  
        }     
        
        int[] PollinatorTypeArray;
        if (!string.IsNullOrEmpty(pollinatorType))
        {
            string[] tokens = pollinatorType.Split(',');
            PollinatorTypeArray = Array.ConvertAll<string, int>(tokens, int.Parse);
        }
        else
        {
            var typelist = (from sp in mydb.PollinatorTypes select new { sp.ID }).ToList();
            List<int> list = new List<int>();
            foreach (var row in typelist)
            {
                list.Add(row.ID);
            }
            list.Add(0);
            PollinatorTypeArray = list.ToArray();                       
        }
               
        var data = (from ud in mydb.UserDetails
                    from pi in mydb.PolinatorInformations
                    where ud.UserId == pi.UserId && (
                          (keyword == string.Empty ||
                           pi.OrganizationName.ToLower().IndexOf(keyword) >= 0 ||                        
                           pi.LandscapeCity.ToLower().IndexOf(keyword) >= 0 ||
                           pi.LandscapeZipcode.ToLower().IndexOf(keyword) >= 0
                          )
                          && (FindOutFilterArray.Contains(pi.OrganizationFindOut.Value))
                          && (PollinatorTypeArray.Contains(pi.PollinatorType)
                          && MembershipLevelArray.Contains((int)ud.MembershipLevel))
                          ) && pi.IsApproved == true
                    orderby pi.OrganizationName ascending
                    select new
                    {
                        pi.OrganizationName,
                        pi.PollinatorSize,
                        pi.PollinatorType,
                        pi.LandscapeStreet,
                        pi.LandscapeCity,
                        pi.LandscapeState,
                        pi.LandscapeZipcode,
                        pi.LandscapeCountry,
                        pi.PhotoUrl,
                        pi.YoutubeUrl,
                        pi.Latitude,
                        pi.Longitude,
                        pi.UserId,
                        pi.Website,
                        pi.Description,
                        ud.MembershipLevel
                    }).ToList();
      //  System.Threading.Thread.Sleep(5000);
        JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
        string items = javaScriptSerializer.Serialize(data);
        context.Response.ContentType = "application/json";
        context.Response.Write(items);        

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}