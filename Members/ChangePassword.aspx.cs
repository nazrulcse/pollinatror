using Pollinator.Common;
using Pollinator.DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Configuration;

public partial class Members_ChangePassword : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                ViewState["RefUrl"] = Request.UrlReferrer.ToString();
            }
            catch (Exception ex)
            {
                Pollinator.Common.Logger.Error("Error occured at " + typeof(Members_ChangePassword).Name + ".Page_Load(). Exception:" + ex.Message);
            }
        }
    }
    public string UrlReferrer
    {
        get
        {
            string text = (string)ViewState["RefUrl"];
            if (text != null)
                return text;
            else
                return "Manage";
        }
        set
        {
            ViewState["RefUrl"] = value;
        }
    }
    protected void ChangePassword1_SendingMail(object sender, MailMessageEventArgs e)
    {
        //var userDetail = (from ud in mydb.UserDetails
        //                  where ud.UserId == (Guid)Membership.GetUser(Context.User.Identity.Name).ProviderUserKey
        //                  select ud).FirstOrDefault();
        
        // Set mail message fields.
        e.Message.Subject = "Changed Your Password on S.H.A.R.E!";
        String content = e.Message.Body;
        content = content.Replace("{ChangedDate}", DateTime.Now.ToString());
        content = content.Replace("{FirstName}", User.Identity.Name);
        content = content.Replace("{UserName}", User.Identity.Name);
        content = content.Replace("{Password}", ChangePassword1.NewPassword);

        var webAppPath = WebHelper.FullyQualifiedApplicationPath;
        content = content.Replace("{SiteLogo}", webAppPath + WebHelper.SiteLogo);

        e.Message.Body = content;
        //send for New User
        //myMail.From = new MailAddress(Utility.EmailConfiguration.WebMasterEmail, "Pollinator - Share Map");
    }
    protected void CancelPushButton_Click(object sender, EventArgs e)
    {
        object refUrl = ViewState["RefUrl"];
        if (refUrl != null)
            Response.Redirect((string)refUrl);
        else
            Response.Redirect("Manage");
    }
}

