<%@ Page Title="" ValidateRequest="false" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Admin_Users" %>

<%@ Register Src="../Controls/ZoomInThumbnail.ascx" TagName="ZoomInThumbnail" TagPrefix="uc" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
       <style type="text/css">
        /*Draw the inset vertical line between grid columns*/
        .vertical-line
        {
            float: left;
            width: 0px;
            margin-top: -10px;
            height: 35px;
            /*Draw inset separator*/
            border-right: 1px solid rgba(0,0,0,0.15);
            -webkit-box-shadow: 0px 0px 0px 1px #f5f5f5;
            -moz-box-shadow: 0px 0px 0px 1px #f5f5f5;
            box-shadow: 0px 0px 0px 1px #f5f5f5;
        }

        .approve-link, .approve-link:link
        {
            color: blue;
        }

        .approve-link:visited
        {
            color: gray;
        }

        .table-hover
        {
            border: solid 1px #ddd;
        }

        .table-hover > tbody > tr > th
        {
            background-image: linear-gradient(to bottom,#f5f5f5 0,#e8e8e8 100%);
            pointer-events: none;
            padding: 15px 8px 8px 8px;
        }

        /* Remove border lines around pager */
        .table-hover > tbody > tr.pager
        {
            border: solid 1px transparent;
        }

        /* align left pager*/
        .table-hover > tbody > tr.pager > td
        {
            padding-left: 0px;
        }

        .pager table tr td
        {
            border: solid 1px #D5D5D5;
            width: 25px;
            height: 25px;
            font-family: Verdana;
            padding: 8px 9px 6px 9px; /*Note: Cannot set width, nor height for pager. Instead, use padding to adjust size.*/
        }

        .pager:before, .pager:after
        {
            content: none;
        }

        .right-inner-addon
        {
            position: relative;
        }

        .right-inner-addon input
        {
            padding-right: 30px;
        }

        .right-inner-addon i
        {
            position: absolute;
            right: 5px;
            padding: 10px 12px;
            pointer-events: none;
        }

        .row
        {
            margin-left: 0px;
            margin-right: 2px;
        }
         .wrap
        {
            display:block;      
            word-wrap:break-word;
            max-width:100px;
        }
    </style>

    <script type="text/javascript">
        $(function () {
            //Show different background for current page number
            $('.pager table tr td:has(span)').css({ 'background-image': 'linear-gradient(to bottom,#f5f5f5 0,#e8e8e8 100%)' });
        });
    </script>
    <div class="admincontainer">

   
    <h2 >Manage Users</h2>
    <p>

        <asp:Repeater ID="FilteringUI" runat="server"
            OnItemCommand="FilteringUI_ItemCommand">
            <ItemTemplate>
                <asp:LinkButton runat="server" ID="lnkFilter"
                    Text='<%# Container.DataItem %>'
                    CommandName='<%# Container.DataItem %>'></asp:LinkButton>
            </ItemTemplate>

            <SeparatorTemplate>|</SeparatorTemplate>
        </asp:Repeater>
    </p>

    <!--This control is used to preview thumbnail image on hover using bootstrap style-->
    <uc:ZoomInThumbnail ID="ZoomInThumbnail" runat="server" />

    <div >

        <div class="row">
            <div style="float: left; display: table-cell;">
                <asp:Label Style="vertical-align: -33px" ID="lblSummary" runat="server" Font-Size="11" Font-Bold="true"></asp:Label>

                <asp:LinkButton ID="lnkBFF" OnClick="lnkBFF_Click"  ToolTip="Click to view BFF users only" runat="server" Style="vertical-align: -33px"  Font-Underline="true" Font-Size="11pt" Font-Bold="True"  ><font color='violet'>BFF</font></asp:LinkButton>
                <asp:Label Style="vertical-align: -33px" ID="Label1" Text=" users)" runat="server" Font-Size="11" Font-Bold="true"></asp:Label>

            </div>
            <div style="float: right;">


                <div class="right-inner-addon">
                    <i class="glyphicon glyphicon-search"></i>
                    <asp:TextBox Width="350px" CssClass="form-control" type="search" ID="txtSearch" placeholder="Type to search for name, organization, address" runat="server" MaxLength="60"></asp:TextBox>

                </div>

                <button type="button" id="btnSearch" runat="server"   onserverclick="btnSearch_Click" style="display: none">
                </button>
            </div>

        </div>

        <div class="row">
            <asp:GridView ID="UserAccounts" runat="server" PagerStyle-CssClass="approve-link" HeaderStyle-Font-Size="11px" CssClass="table table-hover" GridLines="Both" AutoGenerateColumns="false" OnRowDataBound="UserAccounts_RowDataBound" AllowPaging="True" OnPageIndexChanging="UserAccounts_PageIndexChanging" PageSize="10" EmptyDataText="No users match search criteria.">
                <PagerStyle CssClass="pager" />
                <Columns>

                    <asp:TemplateField HeaderText="Name" ItemStyle-Width="16%">
                        <ItemTemplate>
                            <span class="wrap"><%#Server.HtmlEncode(String.Format("{0} {1}", Eval("FirstName"), Eval("LastName"))) %> </span>
                            <asp:Image ImageUrl="~/Images/new-gif.gif" Visible='<%#Convert.ToBoolean(Eval("IsNew"))  && DateTime.Now.Subtract(Convert.ToDateTime(Eval("LastUpdated"))).Days < 1 %>' runat="server" Width="25" Height="25" />
                        </ItemTemplate>

                        <ItemStyle Width="16%"></ItemStyle>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="true">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkenbl" runat="server" CssClass="flat-checkbox" Style="pointer-events: none;"
                                Checked='<%# Convert.ToByte(Eval("MembershipLevel")) > 0 %>' />
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                            &nbsp;BFF users?
                        </HeaderTemplate>

                        <HeaderStyle Wrap="True"></HeaderStyle>

                        <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="" ItemStyle-Width="19%">
                        <ItemTemplate>
                          <span class="wrap"><%# Server.HtmlEncode((string)Eval("OrganizationName")) %>  </span>
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                          &nbsp;Organization Name
                        </HeaderTemplate>

                        <ItemStyle Width="19%" > </ItemStyle>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="19%">
                        <ItemTemplate>
                            <span class="wrap"><%#GetAddress(Eval("LandscapeStreet").ToString(), Eval("LandscapeCity").ToString(), Eval("LandscapeState").ToString()) %> </span>
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                            &nbsp;Address
                        </HeaderTemplate>

                        <ItemStyle Width="19%"></ItemStyle>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="10%">
                        <ItemTemplate>
                            <asp:HyperLink runat="server" ID="linkPhoto" CssClass="hover-image">
                                <asp:Image ID="imgPhoto" ImageUrl="#" runat="server" CssClass="thumbnail1 " />
                            </asp:HyperLink>

                            <asp:HiddenField ID="hdnPhotoUrl" runat="server" Value='<%#Eval("PhotoUrl") %>' />
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                            &nbsp;Photo
                        </HeaderTemplate>

                        <ItemStyle Width="10%"></ItemStyle>
                    </asp:TemplateField>

                    <asp:TemplateField ItemStyle-Width="8%" HeaderStyle-Wrap="False">
                        <ItemTemplate>
                            <%# Eval("LastUpdated", "{0:MM/dd/yyyy}")%>
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                            &nbsp;Last Updated 
                        </HeaderTemplate>

                        <HeaderStyle Wrap="False"></HeaderStyle>

                        <ItemStyle Width="8%"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Approved?" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:CheckBox ID="cbApproved" runat="server" Style="pointer-events: none;" CssClass="flat-checkbox"
                                Checked='<%# Convert.ToBoolean(Eval("IsApproved"))%>' />
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                            &nbsp;Approved?
                        </HeaderTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="" ItemStyle-Width="8%">
                        <ItemTemplate>
                            <asp:HyperLink runat="server" CssClass="approve-link" Text='<%# Convert.ToBoolean(Eval("IsApproved"))? "Modify":"Approve" %>'
                                NavigateUrl='<%# String.Format("PollinatorInformation?user={0} ", Eval("UserId")) %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                        </HeaderTemplate>
                        <ItemStyle Width="8%"></ItemStyle>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataRowStyle Font-Bold="True" ForeColor="#FF3300" />

                <HeaderStyle Font-Size="11px"></HeaderStyle>

                <PagerSettings Mode="NumericFirstLast" />
            </asp:GridView>
        </div>

        <div class="panel panel-default" style="margin-right: 2px">
            <div class="panel-heading">
                <h3 class="panel-title" style="text-align: left">Notes</h3>
            </div>
            <div class="panel-body" style="text-align: left">
                <ul>
                    <li>
                        <asp:Image ID="Image2" ImageUrl="~/Images/new-gif.gif" Visible='<%#!Convert.ToBoolean(Eval("IsApproved"))%>' runat="server" Width="25" Height="25" />: New registers.
                    </li>
                    <li>After pollinator information is approved, the location will be shown public on map.</li>
                    <li>Unapproved registers will be shown on top.</li>
                </ul>
            </div>
        </div>

        <script language="javascript">
            var TextToMatch = "<%=UsernameToMatch%>";
            if (TextToMatch == "")
                TextToMatch = "All";
            var usernameToMatchLink = $('a').filter(function (index) { return $(this).text() === TextToMatch; });
            if ("<%=OnlyShowBFF%>" != "True") {
                $(usernameToMatchLink).removeAttr("href");
                $(usernameToMatchLink).addClass("selectedLink");
            }

            var txtSearch = '#<%=txtSearch.ClientID%>';

            $(txtSearch).keypress(function (event) {

                var keycode = (event.keyCode ? event.keyCode : event.which);
                if (keycode == '13') {
                    event.preventDefault();
                    var btnSearch = '#<%=btnSearch.ClientID%>';
                    $(btnSearch).click();

                }
            })
        </script>

    </div>
     </div>
</asp:Content>