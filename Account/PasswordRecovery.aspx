<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PasswordRecovery.aspx.cs" Inherits="Account_PasswordRecovery" %>


<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
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
    <asp:PlaceHolder ID="PlaceHolder3" runat="server">

        <%=Scripts.Render("~/js/skel.min.js") %>     
    </asp:PlaceHolder>


    <noscript>
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/skel-noscript.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style-wide.css")%>" />

    </noscript>
    <div id="outer">
        <div id="inner" >
            <asp:PasswordRecovery ID="PasswordRecovery1" runat="server"
                MailDefinition-BodyFileName="~/EmailTemplates/forgotpassword.html"
                MailDefinition-Subject="New password on S.H.A.R.E!"
                MailDefinition-IsBodyHtml="true"
                SuccessText="Your password was successfully reset and emailed to you."
                onsendingmail ="PasswordRecovery1_SendingMail"
                SubmitButtonType="Link"
                BackColor="#EFF3FB" BorderColor="#B5C7DE" BorderPadding="10" BorderStyle="Solid" BorderWidth="1px">
                <SubmitButtonStyle CssClass="submit button btn12" />
                <FailureTextStyle  Font-Italic="True" ForeColor="Black" />
                <InstructionTextStyle Font-Italic="True" ForeColor="Black" />
                <SuccessTextStyle Font-Bold="True" ForeColor="#507CD1" />
                <TextBoxStyle Font-Size="0.8em" />
                <TitleTextStyle BackColor="#507CD1" Font-Bold="True" Font-Size="0.9em" ForeColor="White" />

                <UserNameTemplate>

                    <div style="margin-left: 30px;margin-right: 30px;margin-top:15px">
                         <div class="row">
                            <div class="12u">
                                 <h2>Forgot Your Password?</h2>
                        </div>

                            <div class="12u" style="margin-top:15px">
                                Enter your username and we'll send an email to reset your password to the address associated with your account.
                             </div>

                            <div class="12u">
                              
                                <asp:TextBox ID="UserName" runat="server" CssClass="text" placeholder="Username" ToolTip="Username"></asp:TextBox>
                                <asp:RequiredFieldValidator ValidationGroup="PasswordRecovery1" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="Username is required." ToolTip="Username is required."></asp:RequiredFieldValidator>
                                <br/>
                                <asp:Label id="FailureText" Font-Size="14px"  EnableViewState="false" CssClass="message-error" Runat="server" />
                            </div>

                            <div class="12u" style="margin-top: 20px; margin-bottom: 20px;">

                            <asp:LinkButton  ID="SubmitButton" CssClass="submit button btn12" Font-Names="Verdana" ForeColor="White" Font-Size="14px"
                                runat="server" CommandName="Submit" Text="Submit" ValidationGroup="PasswordRecovery1" />
                        </div>
                        </div>

                    </div>
                </UserNameTemplate>
                  <SuccessTemplate>

                    <div style="margin-left: 30px;margin-right: 30px;margin-top:10px;margin-bottom:10px">
                         <div class="row">
                            <div class="12u"  style="font-size:14px">
                                <strong>Your password was successfully reset and emailed to you.</strong>
                             </div>
                        </div>

                    </div>
                </SuccessTemplate>
                
            </asp:PasswordRecovery>
        </div>
    </div>
    <script>

        $("#MainContent_PasswordRecovery1_UserNameContainerID_UserName").keypress(function (event) {
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if (keycode == '13') {
                userName = $(this).val();
                if (userName != "") {
                    // $("#MainContent_PasswordRecovery1_UserNameContainerID_SubmitButton").focus();
                    event.preventDefault();
                    // $(".btn12").trigger("click");
                    WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions("ctl00$MainContent$PasswordRecovery1$UserNameContainerID$SubmitButton", "", true, "PasswordRecovery1", "", false, true));

                }
            }
        });
    </script>
    <style>
        #outer
        {
            width: 100%;
            text-align: center;
        }

        #inner
        {
            display: inline-block;
            width: 48%;
        }
    </style>
</asp:Content>

