<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestRegisterPremium.aspx.cs" Inherits="TestRegisterPremium" MasterPageFile="~/Site.Master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <asp:Button runat="server" ID="btnRegister" Text="Register" CausesValidation="False"></asp:Button>    
    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="http://demo.evizi.com:8088/Paypal.aspx">HyperLink</asp:HyperLink>
    <asp:PlaceHolder runat="server" ID="phFrameHolder"></asp:PlaceHolder>
</asp:Content>
