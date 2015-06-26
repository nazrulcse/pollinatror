<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="SponsorList.aspx.cs" Inherits="Admin_SponsorList" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
     <style type="text/css">
       /*Draw the inset vertical line between grid columns*/
        .vertical-line {
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

        .table-hover {
            border: solid 1px #ddd;            
        }
        
        .table-hover > tbody > tr > th
        {
            background-image: linear-gradient(to bottom,#f5f5f5 0,#e8e8e8 100%);
            pointer-events: none;
            padding: 15px 8px 8px 8px;
        }

        /* Remove border lines around pager */
        .table-hover > tbody > tr.pager {
            border: solid 1px transparent;
        }
        
          /* align left pager*/
        .table-hover > tbody > tr.pager >td
        {
            padding-left:0px;
        }

        .pager table tr td {
	        border:solid 1px #D5D5D5;
            width: 25px;
            height: 25px;
	        font-family:Verdana;
	        padding: 8px 9px 6px 9px; /*Note: Cannot set width, nor height for pager. Instead, use padding to adjust size.*/		            
        }


        .pager:before, .pager:after
        {
            content: none;
        }
        .row
        {
            margin-left: 0px;
            margin-right: 2px;
        }
    </style>

     <script type="text/javascript">
         $(function () {
             //Show different background for current page number
             $('.pager table tr td:has(span)').css({ 'background-image': 'linear-gradient(to bottom,#f5f5f5 0,#e8e8e8 100%)' });
         });
    </script>

    <div class="admincontainer">
    <h2 >Sponsor List</h2>
   
    <div class="row">

         <asp:GridView ID="Sponsor" runat="server" HeaderStyle-Font-Size="11px" CssClass="table table-hover" GridLines="Both" AutoGenerateColumns="false" AllowPaging="True" OnPageIndexChanging="Sponsor_PageIndexChanging" ShowHeaderWhenEmpty="True" OnRowDataBound="Sponsor_RowDataBound">
                <PagerStyle CssClass="pager" />
                <Columns>

                    <asp:TemplateField HeaderText="Name" HeaderStyle-Width="25%">
                        <ItemTemplate>
                            <%# Eval("Name") %>
                        </ItemTemplate>

                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Website" HeaderStyle-Width="25%">
                        <ItemTemplate>
                            <asp:HyperLink ID="Website" runat="server" CssClass="approve-link" Text='<%# Eval("Website") %>'
                                NavigateUrl='<%# Eval("Website") %>' Target="_blank">
                            </asp:HyperLink>
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>&nbsp;Website
                        </HeaderTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderStyle-Width="30%">
                        <ItemTemplate>
                            <asp:Image ID="imgPhoto" ImageUrl="#" runat="server" CssClass="thumbnail1 " />
                            <asp:HiddenField ID="hdnPhotoUrl" runat="server" Value='<%#Eval("PhotoUrl") %>' />
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>&nbsp;Photo
                        </HeaderTemplate>


                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Default?" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:CheckBox ID="cbActive" runat="server" Style="pointer-events: none;" CssClass="flat-checkbox"
                                Checked='<%# Convert.ToBoolean(Eval("IsActive"))%>' />
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>
                            &nbsp;Default?
                        </HeaderTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="" ItemStyle-Width="10%">
                        <ItemTemplate>
                            <asp:HyperLink ID="HyperLink1" runat="server" CssClass="approve-link" Text='<%# "Modify" %>'
                                NavigateUrl='<%# String.Format("EditSponsor?id={0} ", Eval("Id")) %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                        <HeaderTemplate>
                            <div class="vertical-line"></div>&nbsp;
                        </HeaderTemplate>

                        <ItemStyle Width="10%"></ItemStyle>
                    </asp:TemplateField>



                </Columns>

                <HeaderStyle Font-Size="11px"></HeaderStyle>

                <PagerSettings Mode="NumericFirstLast" />
            </asp:GridView>
        
         <button type="button" id="btnAdd" class="btn btn-success" onserverclick="btnAdd_Click" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
            runat="server" >
            <i class="glyphicon glyphicon-plus"></i>
            <span>Add</span>
        </button>

    </div>

        </div>

</asp:Content>