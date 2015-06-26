using System;
using System.Web;
using System.Web.UI;
using System.Web.Security;
public partial class ShareMap : Page
{    

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.QueryString["action"] == "register")
            {
                Session.Clear();
                Session.Abandon();
                FormsAuthentication.SignOut();
                Response.Redirect(Request.Url.GetLeftPart(UriPartial.Authority) + "/ShareMap#register-form");
            }           
        }
        catch (global::System.Exception ex)
        {
            Response.Write(ex.Message);
            //write log
            Pollinator.Common.Logger.Error("Occured in function: " + typeof(ShareMap).Name + ".Page_Load()", ex);
        }
    }    
}