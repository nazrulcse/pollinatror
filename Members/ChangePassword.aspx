<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="Members_ChangePassword" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>

    <script type="text/javascript">
        window._skel_config = {
            prefix: '../css/style',
            preloadStyleSheets: true,
            resetCSS: true,
            boxModel: 'border',
            grid: { gutters: 30 },
            breakpoints: {
                wide: { range: '1200-', containers: 1140, grid: { gutters: 50 } },
                narrow: { range: '481-1199', containers: 960 },
                mobile: { range: '-480', containers: 960 }
            }
        };
    </script>

    <script src="../Scripts/common.js" type="text/javascript"></script>
    <noscript>
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/skel-noscript.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/Content/Site.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style-wide.css")%>" />
    </noscript>
    <asp:PlaceHolder ID="PlaceHolder1" runat="server">
        <%=Scripts.Render("~/js/skel.min.js")%>
    </asp:PlaceHolder>

    <div id="main-wrapper" style="margin-top: -42px;">
        <div class="container" style="width: 1050px;">
     <input runat="server" id="HiddenFirstName" value="" type="hidden" /> 
            <fieldset style="border: 1px #ccc solid; width:60%; padding-bottom:0">
                        <legend>Change Password</legend>
               
    <asp:ChangePassword ID="ChangePassword1" runat="server" ContinueDestinationPageUrl="~/Members/Manage" OnSendingMail="ChangePassword1_SendingMail" ChangePasswordFailureText="Password incorrect or New Password invalid. ">
        <CancelButtonStyle CssClass="button btn36"/>
        <ChangePasswordButtonStyle CssClass="submit button btn12 buttonCreateUser" />
        <ChangePasswordTemplate>
            <table cellpadding="1" cellspacing="0" style="border-collapse:collapse; margin-bottom:0">
                <tr>
                    <td>
                        <table cellpadding="0">
                           <%-- <tr>
                                <td align="center" colspan="2">Change Your Password</td>
                            </tr>--%>
                            <tr>
                                <td style="vertical-align: middle; padding: 5px;text-align: left;">
                                    <asp:Label ID="CurrentPasswordLabel" runat="server" AssociatedControlID="CurrentPassword">Password:</asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="CurrentPassword" CssClass="text" MaxLength="128" runat="server" TextMode="Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true"  ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="ChangePassword1">Password is required.</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="CurrentPassword" ID="RegularExpressionValidator1" ValidationExpression="^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required." ValidationGroup="ChangePassword1"></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: middle; padding: 5px;text-align: left;">
                                    <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword">New Password:</asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="NewPassword" CssClass="text" MaxLength="128" runat="server" TextMode="Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword" ErrorMessage="New Password is required." ToolTip="New Password is required." ValidationGroup="ChangePassword1">New Password is required.</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ControlToValidate="NewPassword" ID="revPassword" ValidationExpression="^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required." ValidationGroup="ChangePassword1"></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: middle; padding: 5px;text-align: left;">
                                    <asp:Label ID="ConfirmNewPasswordLabel" runat="server"  AssociatedControlID="ConfirmNewPassword">Confirm New Password:</asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="ConfirmNewPassword" CssClass="text" MaxLength="128" runat="server" TextMode="Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" ErrorMessage="Confirm New Password is required." ToolTip="Confirm New Password is required." ValidationGroup="ChangePassword1">Confirm New Password is required.</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                </td>
                                <td>
                                    <asp:CompareValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" ErrorMessage="The Confirm New Password must match the New Password entry." ValidationGroup="ChangePassword1"></asp:CompareValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                </td>
                                <td class="message-error">
                                    <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                </td>
                                <td align="left" style="padding-top:20px">
                                    <asp:Button ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" CssClass="submit button btn12 buttonCreateUser" style="height:45px; min-width: 150px; width:180px;border: none; background-color: #66cd00; color: white; font-size: 19px;" Text="Change Password" ValidationGroup="ChangePassword1" />
                                    <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="button btn36" style="height:45px; min-width: 150px; width:180px;border: none; color: black; font-size: 19px;font-weight:bold;" Text="Cancel" OnClick="CancelPushButton_Click" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </ChangePasswordTemplate>
        <ContinueButtonStyle CssClass="submit button btn12"/>
        <SuccessTemplate>
            <table cellpadding="0" style="margin-bottom:0">
                <tr>
                    <td align="left" colspan="2" style="font-weight: bold">Your password has been reset successfully!</td>
                </tr>
                <tr>
                    <td align="left" colspan="2">New password has been sent to your primary email address.</td>
                </tr>
                <tr>
                    <td align="left" colspan="2" style="padding-top: 20px" ><a id="lnkReturn"  href="Manage" style="cursor: pointer;color: #436A1B;">Click here to return to your information</a></td>
                </tr>
            </table>
        </SuccessTemplate>
        <MailDefinition Subject="Change Your Password on S.H.A.R.E!" BodyFileName="~/EmailTemplates/ChangePassword.html" IsBodyHtml="True">
        </MailDefinition>
    </asp:ChangePassword>
                 </fieldset>
        </div>
    </div>
</asp:Content>


