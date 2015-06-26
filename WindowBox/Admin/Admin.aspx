<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Admin.aspx.cs" Inherits="WindowBox_Admin_Admin" %>

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
            <uc:TopSidebar runat="server" Name="Admin" ID="TopSidebar" />
            <div class="divtable">
                <table class="table table-hover" cellspacing="0" rules="all" border="1" id="MainContent_UserAccounts" style="border-collapse: collapse;">
                    <tbody>
                        <tr >
                            <th scope="col">ID #</th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Username
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Full Name
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Team
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Status
                            </th>
                            <th scope="col" style="white-space: nowrap;">
                                <div class="vertical-line"></div>
                                Last Login 
                            </th>

                            <th scope="col">
                                <div class="vertical-line">Delete</div>
                            </th>
                        </tr>
                        <tr>
                            <td style="width: 16%;"></td>
                            <td style="width: 20%;"></td>
                            <td style="width: 20%;"></td>
                            <td style="width: 10%;"></td>
                            <td style="width: 10%;"></td>

                            <td style="width: 20%;"></td>
                            <td style="width: 12%;">
                                <a class="delete-link"></a>
                            </td>
                        </tr>

                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr class="pager">
                            <td colspan="7">
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
