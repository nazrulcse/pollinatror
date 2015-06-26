using Pollinator.DataAccess;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Paypal : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();
    protected void Page_Load(object sender, EventArgs e)
    {
        Pollinator.Common.Logger.Information("Paypal Vinh test external: 0 " + typeof(Paypal).Name + ".Page_Load().");

        if (!IsPostBack)
        {
            try
            {
                Pollinator.Common.Logger.Information("Paypal Vinh test external: 1 " + typeof(Paypal).Name + ".Page_Load().");
                if (Request.Params["userID"] != null)
                {
                    //load info from temp table to re-insert main tables(UserDetail, PollinatorInformation
                    Guid userID = new Guid(Request.Params["userID"].ToString());
                    Pollinator.Common.Logger.Information("Paypal Vinh test external: userID= " + userID);

                    var tempUserPayment = (from tempUP in mydb.TempUserPayments
                                           where tempUP.UserId == userID
                                           select tempUP).FirstOrDefault();
                    if (tempUserPayment == null)
                        return;

                    string PaypalFormHtmlStr = tempUserPayment.PaypalFormHtmlStr;

                    Pollinator.Common.Logger.Information("Paypal Vinh test external: PaypalFormHtmlStr= " + PaypalFormHtmlStr);

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "paypal", "document.getElementById('paypal_container').innerHTML = \"" + PaypalFormHtmlStr + "\"  ; document.getElementById('paypal_btn').click() ;", true);
                    Pollinator.Common.Logger.Information("Paypal Vinh test external: 2");
                }
            }
            catch (Exception ex)
            {
                Pollinator.Common.Logger.Error("Error occured at " + typeof(Paypal).Name + ".Page_Load(). Exception:" + ex.Message);
            }
        }
    }
}