using System;

public partial class Controls_RegisterUserProgress : System.Web.UI.UserControl
{
    
    protected void Page_Load(object sender, EventArgs e)
    {     
    }

    public int Step
    {
        get
        {
            if (ViewState["Step"] == null)
                return 1;

            return (int)ViewState["Step"];

        }
        set
        {
            ViewState["Step"] = value;
        }
    }

    public int Percent
    {
        get
        {
            if (ViewState["Percent"] == null)
                return 15;

            return (int)ViewState["Percent"];
           
        }
        set
        {
            ViewState["Percent"] = value;
        }
    }
}