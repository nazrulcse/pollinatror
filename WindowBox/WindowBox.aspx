<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WindowBox.aspx.cs" Inherits="WindowBox_WindowBox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <asp:PlaceHolder ID="PlaceHolder1" runat="server">
        <%=Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/css" />
    
</head>
<body>
    <form id="form1" runat="server">
        
    <style type="text/css">
        .dropdownlist {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;   
        }

        .large-checkbox input {
            width: 1.1em;
            height: 1.1em;
            margin-right: 10px;
            float: left;
        }

        .blue-link {
            color: blue!important;
        }

        .blue-link:hover
        {
            color: orange!important;
        }
    </style>

                
    <div style="margin: auto;width: 60%;">
        <h1 style="text-align: center">Welcome to the Window Box!</h1>
        <h3 style="text-align: center">Create a New Window Box</h3>
        
        <br/><br/>
        <p>
            <p>
               The Pollinator Window Box is a virtual space where you can learn about what plants are native to your ecoregion, what plants support pollinators, why pollinators are important, and share your PWB with others.
            </p>

            <p>What are the parts required of a pollinator window box? These principles will help pollinators in any landscape!</p>
            
            <ul>
                <li>Continuous bloom</li>
                <li>Sun</li>
                <li>No Wind</li>
                <li>Water</li>
                <li>The Right Plants</li>
            </ul>

            <p>Pollinators are vital to our ecosystems and are responsible for 1 out of 3 bites of foot we eat. 
                
                <a href="#learn_more_popup" class="blue-link">Learn more</a></p>            
        </p>
        
        <a href="#x" class="overlay" id="learn_more_popup"></a>
        <div class="popup" style="width: 600px; height: 300px">
            <strong>
               What is the Window Box?
            </strong>

            <p>
                The Pollinator Window Box is a virtual space where you can learn about what plants are native to your ecoregion, what plants support pollinators, why pollinators are important, and share your PWB with others.
            </p>
            
            <p>
                The entire application will be a widget that can be installed in a number of different websites and will be able to generate a dynamic page for each user that creates a window box so that it can be shared on social media on the primary site 
            </p>
            <a href="#close" class="popup-close" onclick="setFocusByControl('');"></a>
        </div>

        
        <p>
            <asp:TextBox MaxLength="100" Width="100%" Height="54" ID="txtFullName" runat="server" class="text" ToolTip="Full Name" placeholder="Full Name" required></asp:TextBox>
        </p>
        <p>
            <asp:TextBox MaxLength="100" Width="100%" ID="txtEmailAddress" runat="server" class="text" ToolTip="Email Address" placeholder="Email Address" required></asp:TextBox>
        </p>
        <p>
            <asp:DropDownList ID="ddlCountry" Width="100%" runat="server" CssClass="registerSelect dropdownlist" placeholder="Country">
            </asp:DropDownList>
        </p>
        <p>
            <asp:TextBox MaxLength="100" Width="100%" ID="txtZipCode" runat="server" class="text" ToolTip="Zip Code" placeholder="Zip Code" required></asp:TextBox>
        </p>
        
        <p>
            <asp:CheckBox runat="server" ID="chkAuthorize" CssClass="large-checkbox" Text="I authorize Pollinator Partnership to send me stuff via email"/>
            <asp:CheckBox runat="server" ID="chkUnderstandTOS" CssClass="large-checkbox" Text="I understand the TOS of this service"/>
        </p>
        
        <p style="text-align: center;margin-bottom: 100px;">
            <a type="button" class="submit button btn12" style="margin:auto; min-width: 300px; color: white; font-size: 21px;" href="CreateWindowBox.aspx">Get Started</a>
        </p>
    </div>
    </form>
</body>
</html>
