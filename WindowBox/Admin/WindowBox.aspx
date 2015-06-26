<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WindowBox.aspx.cs" Inherits="WindowBox_Admin_WindowBox" %>

<%@ Register Src="~/WindowBox/Admin/Controls/LeftSidebar.ascx" TagPrefix="uc" TagName="LeftSidebar" %>
<%@ Register Src="~/WindowBox/Admin/Controls/TopSidebar.ascx" TagPrefix="uc" TagName="TopSidebar" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <div class="col_left">
            <uc:LeftSidebar runat="server" ID="LeftSidebar" />
        </div>

        <div class="col_main">
            <uc:TopSidebar runat="server" Name="Window Boxes" ID="TopSidebar" />
            <div class="divtable">
                <table class="table table-hover" cellspacing="0" rules="all" border="1" id="MainContent_UserAccounts" style="border-collapse: collapse;">
                    <tbody>
                         <tr >
                            <th scope="col" style="white-space: nowrap">Window Box ID #</th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                User ID
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Status
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Display Name
                            </th>
                            <th scope="col" style="white-space: nowrap;">
                                <div class="vertical-line"></div>
                                Eco Region
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Zip
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                URL
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Image
                            </th>

                            <th scope="col">
                                <div class="vertical-line">Delete</div>
                            </th>
                        </tr>
                        <tr>
                            <td style="width: 10%;">
                                <span class="wrap">W0001</span>
                            </td>
                            <td style="width: 10%;">
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td style="width: 10%;">
                                <span class="wrap">Published </span>
                            </td>
                            <td style="width: 20%;">That Dudes Window Box
                            </td>
                            <td style="width: 8%;">0001
                            </td>
                            <td style="width: 10%;">94110
                            </td>
                            <td style="width: 12%;"><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td style="width: 10%;"><a class="link">Image</a>
                            </td>
                            <td style="width: 10%;">
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>


                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">W0001</span>
                            </td>
                            <td>
                                <span class="wrap"><a class="link">ID#</a></span>
                            </td>
                            <td>
                                <span class="wrap">Published </span>
                            </td>
                            <td>That Dudes Window Box
                            </td>
                            <td>0001
                            </td>
                            <td>94110
                            </td>
                            <td><a class="link" target="_blank" href="www.windowbox.com">www.windowbox.com</a>
                            </td>
                            <td><a class="link">Image</a>
                            </td>
                            <td>
                                <a class="delete-link">DELETE</a>
                            </td>
                        </tr>


                        <tr class="pager">
                            <td colspan="10">
                                <div style="float: left">
                                    <label>
                                        <select>
                                            <option value="10" selected>10</option>
                                            <option value="25">25</option>
                                            <option value="50">50</option>
                                            <option value="100">100</option>
                                        </select>
                                        Per Page</label>
                                </div>
                                <div style="float: right">
                                    <ul class="pagination">
                                        <li class="paginate_button previous" aria-controls="datatablesUserList" tabindex="0"
                                            id="datatablesUserList_previous"><a href="#">Previous</a></li>
                                        <li class="paginate_button active" aria-controls="datatablesUserList" tabindex="0"><a href="#">1</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0">
                                            <a href="#">2</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0"><a href="#">3</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0"><a href="#">4</a></li>
                                        <li class="paginate_button " aria-controls="datatablesUserList" tabindex="0"><a href="#">5</a></li>
                                        <li class="paginate_button next disabled" aria-controls="datatablesUserList" tabindex="0" id="datatablesUserList_next"><a href="#">Next</a></li>

                                    </ul>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </form>
</body>
</html>
