using Pollinator.Common;
using Pollinator.DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Members_UserUpdate : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "document.getElementById('confirm_pop').click();", true);
                if (!Context.User.Identity.IsAuthenticated || !Roles.IsUserInRole(Utility.RoleName.Members.ToString()))
                {
                    Response.Redirect("~/ShareMap.aspx");
                }

                //var fn = GetUserFirstName();

                MembershipUser usr = Membership.GetUser(UserID);
                var userDetail = GetUser();
                if (userDetail == null)
                    userDetail = new UserDetail();

                var polinatorInformation = GetPolinatorInfo();
                if (polinatorInformation == null)
                    polinatorInformation = new PolinatorInformation();

                SetValueToControlPremium(usr, userDetail, polinatorInformation);
            }
            catch (Exception ex)
            {
                Pollinator.Common.Logger.Error("Error occured at " + typeof(Members_UserUpdate).Name + ".Page_Load(). Exception:" + ex.Message);
            }
        }
    }

    protected string GetUserFirstName()
    {
        try
        {
            var userID = (Guid)Membership.GetUser(Context.User.Identity.Name).ProviderUserKey;
            PollinatorEntities mydb = new PollinatorEntities();
            var userDetail = (from ud in mydb.UserDetails
                              where ud.UserId == userID
                              select ud).FirstOrDefault();

            return userDetail.FirstName;
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex);
            return "";
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            MembershipUser usr = Membership.GetUser(UserID);
            
            var userDetail = GetUser();
            if (userDetail==null)
                userDetail = new UserDetail();

            var polinatorInformation = GetPolinatorInfo();
            if (polinatorInformation == null)
                polinatorInformation = new PolinatorInformation();

            //status
            polinatorInformation.IsApproved = false;//reset IsApproved = 0
            polinatorInformation.IsNew = false;
            polinatorInformation.LastUpdated = DateTime.Now;

            //get new values from form and set to object to update
            GetValueFromControlPrenium(usr, userDetail, polinatorInformation);

            if (usr != null)
                Membership.UpdateUser(usr);

            mydb.SaveChanges();
            //StatusMessage.Text = "<strong>Update successful!</strong>";
            //GoToAlertMessage(panelSuccessMessage);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "document.getElementById('confirm_pop').click();", true);

            //Response.Redirect("~/ShareMap.aspx");
        }
        catch (Exception ex)
        {
            Response.Write(ex.ToString());
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Members_UserUpdate).Name + ".btnUpdate_Click(). Exception:" + ex.Message);
            GoToAlertMessage(panelErrorMessage);
        }
    }

    private void SetValueToControlPremium(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        if (usr != null)
        {
            //txtUserName.Text = usr.UserName;
            txtEmail.Text = usr.Email;
        }

        //Table 1 :user detail
        //HiddenPremiumLevel.Value = userDetail.MembershipLevel.ToString();
        txtFirstName.Text = userDetail.FirstName;
        txtLastName.Text = userDetail.LastName;
        txtPhoneNumber.Text = userDetail.PhoneNumber;
        txtOrganizationName.Text = userDetail.OrganizationName;


        //Table 2: polinatorInformation
        txtOrganizationName.Text = polinatorInformation.OrganizationName;
        txtLandscapeStreet.Text = polinatorInformation.LandscapeStreet;
        txtLandscapeCity.Text = polinatorInformation.LandscapeCity;
        txtLandscapeState.Text = polinatorInformation.LandscapeState;
        txtLandscapeZipcode.Text = polinatorInformation.LandscapeZipcode;
        txtPhotoUrl.Text = polinatorInformation.PhotoUrl;
        txtYoutubeUrl.Text = polinatorInformation.YoutubeUrl;

        //premium info
        txtWebsite.Text = polinatorInformation.Website;

        try
        {
            BindPollinatorSize(ddlPollinatorSize);
            ddlPollinatorSize.SelectedValue = polinatorInformation.PollinatorSize.ToString();
        }
        catch (Exception) { }
        try
        {
            BindPollinatorType(ddlPollinatorType);
            ddlPollinatorType.SelectedValue = polinatorInformation.PollinatorType.ToString();
        }
        catch (Exception){}

        

        txtDescription.Text = polinatorInformation.Description;
        txtBillingAddress.Text = polinatorInformation.BillingAddress;
        txtBillingCity.Text = polinatorInformation.BillingCity;
        txtBillingState.Text = polinatorInformation.BillingState;
        txtBillingZipcode.Text = polinatorInformation.BillingZipcode;

        txtPaymentFullName.Text = polinatorInformation.PaymentFullName;
        txtPaymentAddress.Text = polinatorInformation.PaymentAddress;
        txtPaymentState.Text = polinatorInformation.PaymentState;
        txtPaymentCardNumber.Text = polinatorInformation.PaymentCardNumber;

        string photoUrl = Utility.ValidateImage(polinatorInformation.PhotoUrl);
        imgPhotoP.ImageUrl = photoUrl;
        //if (String.IsNullOrEmpty(photoUrl))
        // imgPhoto.Visible = false;

    }

    private void GetValueFromControlPrenium(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        if (usr != null)
            usr.Email = txtEmail.Text;

        //Table 1 :user detail
        userDetail.MembershipLevel = 1;//premium
        userDetail.FirstName = txtFirstName.Text;
        userDetail.LastName = txtLastName.Text;
        userDetail.PhoneNumber = txtPhoneNumber.Text;
        userDetail.OrganizationName = txtOrganizationName.Text;


        //Table 2: polinatorInformation
        polinatorInformation.OrganizationName = txtOrganizationName.Text;
        polinatorInformation.PollinatorSize = Int32.Parse(ddlPollinatorSize.SelectedValue);
        polinatorInformation.LandscapeStreet = txtLandscapeStreet.Text;
        polinatorInformation.LandscapeCity = txtLandscapeCity.Text;
        polinatorInformation.LandscapeState = txtLandscapeState.Text;
        polinatorInformation.LandscapeZipcode = txtLandscapeZipcode.Text;
        polinatorInformation.PhotoUrl = txtPhotoUrl.Text;
        polinatorInformation.YoutubeUrl = txtYoutubeUrl.Text;


        //premium info
        polinatorInformation.Website = txtWebsite.Text;
        polinatorInformation.PollinatorType = Int32.Parse(ddlPollinatorType.SelectedValue);
        polinatorInformation.Description = txtDescription.Text;
        polinatorInformation.BillingAddress = txtBillingAddress.Text;
        polinatorInformation.BillingCity = txtBillingCity.Text;
        polinatorInformation.BillingState = txtBillingState.Text;
        polinatorInformation.BillingZipcode = txtBillingZipcode.Text;

        polinatorInformation.PaymentFullName = txtPaymentFullName.Text;
        polinatorInformation.PaymentAddress = txtPaymentAddress.Text;
        polinatorInformation.PaymentState = txtPaymentState.Text;
        polinatorInformation.PaymentCardNumber = txtPaymentCardNumber.Text;

    }

    private void BindPollinatorSize(DropDownList control)
    {
        var pollinatorSizes = (from ps in mydb.PollinatorSizes
                               select new { ps.ID, ps.Name }).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorSizes;
        control.DataBind();
    }

    private void BindPollinatorType(DropDownList control)
    {
        var pollinatorTypes = (from ps in mydb.PollinatorTypes
                               select new { ps.ID, ps.Name }).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorTypes;
        control.DataBind();
    }

    private PolinatorInformation GetPolinatorInfo()
    {
        var polinatorInformation = (from pi in mydb.PolinatorInformations
                                    where pi.UserId == UserID
                                    select pi).FirstOrDefault();
        return polinatorInformation;
    }

    private UserDetail GetUser()
    {
        var userDetail = (from ud in mydb.UserDetails
                          where ud.UserId == UserID
                          select ud).FirstOrDefault();

        return userDetail;
    }

    private void GoToAlertMessage(Control alert)
    {
        alert.Visible = true;

        //This script will scroll page to the location of message
        string scrollIntoView = @"
             $(document).ready(function () {
                //The element doesn't show up immediately, must set latency for it to bring up
                setTimeout(goToAlertMessage, 10);
            });

            function goToAlertMessage()
            {
                var el = document.getElementById('" + alert.ClientID + @"');
                el.scrollIntoView(true);
            }
        ";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "scrollIntoView_script", scrollIntoView, true);
    }

    #region Properties
    private Guid UserID
    {
        get
        {
            return (Guid)Membership.GetUser(Context.User.Identity.Name).ProviderUserKey;

        }
        set
        {
            ViewState["UserID"] = value;
        }
        
    }

    #endregion
}