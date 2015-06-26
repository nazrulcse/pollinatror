using System;
using System.Web;
using System.Web.UI;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Controls_RegisterUser : System.Web.UI.UserControl
{
    //role name
    PollinatorEntities mydb = new PollinatorEntities();
    string roleMembersName = Utility.RoleName.Members.ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                //login after paypal return 
                if (!Context.User.Identity.IsAuthenticated)
                {
                    if (Request.Params["payer"] != null)
                    {
                        Guid payUserID = new Guid(Request.Params["payer"].ToString());
                        if (Session[payUserID.ToString() + "password"] != null)
                        {
                            string pwd = HttpUtility.HtmlDecode(Session[payUserID.ToString() + "password"].ToString());
                            var userCurrent = System.Web.Security.Membership.GetUser(payUserID);
                            if (userCurrent != null)
                            {
                                string uid = userCurrent.UserName;
                                bool checkValidateUser = System.Web.Security.Membership.ValidateUser(uid, pwd);
                                if (checkValidateUser)
                                {
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "showBFFConfirm", "showBFFConfirm()", true);
                                }
                            }
                        }
                                                 
                    }
                    else if (Request.Params["payc"] != null)
                    {
                        //load info user typed on form
                       /* Guid payUserID = new Guid(Request.Params["payc"].ToString());

                        //1. Delete user if created(auto because use winzard control)
                        var userRM = System.Web.Security.Membership.GetUser(payUserID);
                        var userDetailRemoved = (from ud in mydb.UserDetails
                                                 where ud.UserId == payUserID
                                                 select ud).FirstOrDefault();
                        if (userDetailRemoved == null && userRM != null)//void case user paste url into address bar of browser
                            System.Web.Security.Membership.DeleteUser(userRM.UserName, true);

                        //2. log out new user if loged
                        FormsAuthentication.SignOut();

                        //3. load info user typed on form(thinking needed ??)*/

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "popupCancel", "alert('Payment is cancel, please view message and retry!');", true);
                    }
                }

                
            }
            catch (Exception ex)
            {
                //write log
                Pollinator.Common.Logger.Error("Occured in function: " + typeof(Controls_RegisterUser).Name + ".Page_Load()", ex);
            }
           
        }
    }
}