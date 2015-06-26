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
        int premium = (context.Request.QueryString["premium"] != null) ? int.Parse(context.Request.QueryString["premium"]) : -1;
        string ptype = (context.Request.QueryString["type"] != null) ? context.Request.QueryString["type"] : "";
        string keyword = (context.Request.QueryString["keyword"] != null) ? context.Request.QueryString["keyword"] : "";

        if (premium != 1) premium = -1;

        PollinatorEntities mydb = new PollinatorEntities();
        
        int[] PollinatorTypeArray;

        if (!string.IsNullOrEmpty(ptype))
        {
            string[] tokens = ptype.Split(',');
            PollinatorTypeArray = Array.ConvertAll<string, int>(tokens, int.Parse);
        }
        else
        {
            if (premium != 1)
            {
                var typelist = (from sp in mydb.PollinatorTypes select new { sp.ID }).ToList();
                List<int> list = new List<int>();
                foreach (var row in typelist)
                {
                    list.Add(row.ID);
                }
                PollinatorTypeArray = list.ToArray();
            }
            else
            {
                PollinatorTypeArray = new int[0] { };
            }

        }


        var data = (from ud in mydb.UserDetails
                    from pi in mydb.PolinatorInformations
                    where ud.UserId == pi.UserId && (
                          (keyword == string.Empty ||
                           pi.OrganizationName.ToLower().IndexOf(keyword) >= 0 ||
                           pi.LandscapeStreet.ToLower().IndexOf(keyword) >= 0 ||
                           pi.LandscapeCity.ToLower().IndexOf(keyword) >= 0 ||
                           pi.LandscapeState.ToLower().IndexOf(keyword) >= 0
                          ) && (PollinatorTypeArray.Contains(pi.PollinatorType)
                          || (int)ud.MembershipLevel == premium)
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
                        pi.PhotoUrl,
                        pi.YoutubeUrl,
                        pi.Latitude,
                        pi.Longitude,
                        pi.UserId,
                        pi.Website,
                        pi.Description,
                        ud.MembershipLevel
                    }).ToList();
        
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