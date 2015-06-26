using System;
using System.Linq;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.DataAccess;

public partial class Account_PasswordRecovery : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            TextBox tb = (TextBox)PasswordRecovery1.UserNameTemplateContainer.FindControl("UserName");
            Page.SetFocus(tb);

        }
    }
    protected void PasswordRecovery1_SendingMail(object sender, MailMessageEventArgs e)
    {
        MembershipUser mu = System.Web.Security.Membership.GetUser(PasswordRecovery1.UserName);
        if (mu != null) // The username exists
        {
            var userID = (Guid)mu.ProviderUserKey;
            PollinatorEntities mydb = new PollinatorEntities();
            var userDetail = (from ud in mydb.UserDetails
                              where ud.UserId == userID
                              select ud).FirstOrDefault();

            string name = PasswordRecovery1.UserName;

            if (userDetail != null)
            {
                name = userDetail.FirstName;                         
            }
			string logoPath = Request.Url.Authority + Request.ApplicationPath + "/Images/logo/Bee-Friendly-Farmer-Logo1.png";
			if (!logoPath.StartsWith("http://"))
				logoPath = "http://" + logoPath;

			e.Message.Body = e.Message.Body.Replace("{Logo}", logoPath);
			e.Message.Body = e.Message.Body.Replace("{FirstName}", name);
        }
		   
    }
}