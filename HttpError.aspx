<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HttpError.aspx.cs" Inherits="SmartWeb.UI.HttpError" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
       <div class="sectiontitle">HTTP Error occurred!</div>
       <p></p>
        <asp:Label Runat="server" SkinID="FeedbackKO" ID="lbl404" Text="Error 404: The requested page or resource was not found." />
	    <asp:Label Runat="server" SkinID="FeedbackKO" ID="lbl408" Text="Error 408: The request timed out. This may be caused by a too high traffic. Please try again later." />
	    <asp:Label Runat="server" SkinID="FeedbackKO" ID="lbl505" Text="Error 505: The server encountered an unexpected condition which prevented it from fulfilling the request. Please try again later." />
	    <br/><br/>    
        <asp:Label runat="server" SkinID="FeedbackKO" ID="lblError" Visible="false" 
	       Text="There was some problems processing your request. An e-mail with details about this error has already been sent to the administrator." />
	    <p></p>
	    If you want to contact the webmaster to report the problem with more details, 
        please use the <asp:HyperLink runat="server" ID="lnkContact" Text="Contact Us" NavigateUrl="~/Contact.aspx" /> 
        page.<br/>
        <img src="Images/HttpError.jpg"/>
</asp:Content>