<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test_SendEmail.aspx.cs" Inherits="Test_SendEmail" MasterPageFile="~/Site.Master"  %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <asp:Button runat="server" ID="btnRegister" Text="Register"></asp:Button>

    <asp:UpdatePanel ID="upEmailProgress" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
                <iframe src="AsyncSendEmail.aspx" id="AsyncSendEmails" scrolling="no"></iframe>
                <asp:Label runat="server" ID="lblThankYouMessage"></asp:Label>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnRegister" EventName="Click" />
        </Triggers>    
    </asp:UpdatePanel>
</asp:Content>