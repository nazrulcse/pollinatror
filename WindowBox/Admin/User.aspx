<%@ Page Language="C#" AutoEventWireup="true" CodeFile="User.aspx.cs" Inherits="WindowBox_Admin_User" %>

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
            <uc:TopSidebar runat="server" Name="Users" ID="TopSidebar" />
            <div class="divtable">
                <table class="table table-hover" cellspacing="0" rules="all" border="1" id="MainContent_UserAccounts" style="border-collapse: collapse;">
                    <tbody>
                       <tr >
                            <th scope="col">User #</th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                User Status
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Display Name
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Email
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Password
                            </th>
                            <th scope="col" style="white-space: nowrap;">
                                <div class="vertical-line"></div>
                                Country
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                City
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                State
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Zip Code
                            </th>
                            <th scope="col">
                                <div class="vertical-line"></div>
                                Window Link
                            </th>
                            <th scope="col">
                                <div class="vertical-line">Delete</div>
                            </th>
                        </tr>
                        <tr>
                            <td style="width: 10%;">
                                <span class="wrap">00001</span>
                            </td>
                            <td style="width: 10%;">
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td style="width: 10%;">
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td style="width: 10%;">test@test.com
                            </td>
                            <td style="width: 8%;">123456
                            </td>
                            <td style="width: 10%;">USA
                            </td>
                            <td style="width: 10%;">San Francisco
                            </td>
                            <td style="width: 10%;">CA
                            </td>
                            <td style="width: 10%;">94110
                            </td>
                            <td style="width: 8%;">&ltURL&gt
                            </td>
                            <td style="width: 10%;">
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td class="wrap" style="white-space: nowrap">
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="wrap">00001</span>
                            </td>
                            <td>
                                <span class="wrap">Incomplete</span>
                            </td>
                            <td>
                                <span class="wrap">Flower123 </span>
                            </td>
                            <td>test@test.com
                            </td>
                            <td>123456
                            </td>
                            <td>USA
                            </td>
                            <td>San Francisco
                            </td>
                            <td>CA
                            </td>
                            <td>94110
                            </td>
                            <td>&ltURL&gt
                            </td>
                            <td>
                                <a class="delete-link">&ltclick here&gt</a>
                            </td>
                        </tr>
                        <tr class="pager">
                            <td colspan="11">
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
