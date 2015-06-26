<%@ WebHandler Language="C#" Class="UpdateUrlsToDB" %>

using System;
using System.Web;
using System.Linq;
using Pollinator.DataAccess;

public class UpdateUrlsToDB : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request["userFolder"] == null || context.Request["userID"] == null)
            return;
        if (context.Request["photoUrl"] == null && context.Request["youtubeUrl"] == null)
            return;
        
        var userFolder = context.Request["userFolder"];
        var userID = context.Request["userID"].ToString();

        PollinatorEntities mydb = new PollinatorEntities();
        Guid userGuiId = new Guid(userID);
        var polinatorInformation = (from pi in mydb.PolinatorInformations
                                    where pi.UserId == userGuiId
                                    select pi).FirstOrDefault();
        if (polinatorInformation != null)
        {
            if (context.Request["photoUrl"] != null)
            {
                polinatorInformation.PhotoUrl = context.Request["photoUrl"].ToString();
            }

            if (context.Request["youtubeUrl"] != null)
            {
                polinatorInformation.YoutubeUrl = context.Request["youtubeUrl"].ToString();
            }
            mydb.SaveChanges();   
        }             
    }

   

    public bool IsReusable { get { return false; } }
}