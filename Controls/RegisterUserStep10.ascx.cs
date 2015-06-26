using System;
using System.Linq;
using System.Web.UI.WebControls;
using Pollinator.DataAccess;

public partial class Controls_RegisterUserStep9 : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PollinatorEntities mydb = new PollinatorEntities();
        
        }
    }
   
}
