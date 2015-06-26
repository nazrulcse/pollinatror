using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Test_Required : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        btnSave.Click += btnSave_Click;
    }

    void btnSave_Click(object sender, EventArgs e)
    {
        
    }
}