<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="AddUser.aspx.cs" Inherits="SandBox.WebUi.Account.AddUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Добавление нового пользователя <a href="/Pages/Settings/Users.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
<table class='form'>
			<tbody>
                <tr>
                  <td><div class="simple_text">Имя пользователя:</div></td>
                  <td>
                       <dx:ASPxTextBox ID="tbUserName" runat="server" Width="200px">
                         <ValidationSettings ValidationGroup="AddResearchValidationGroup">
	                      <RequiredField ErrorText=" " IsRequired="true" />
	                     </ValidationSettings>
                       </dx:ASPxTextBox>
                  </td>
                </tr>
                <tr>
                  <td><div class="simple_text">Пароль:</div></td>
                  <td>
                       <dx:ASPxTextBox ID="tbPassword" runat="server" Width="200px" Password="True">
                         <ValidationSettings ValidationGroup="AddResearchValidationGroup">
	                      <RequiredField ErrorText=" " IsRequired="true" />
	                     </ValidationSettings>
                       </dx:ASPxTextBox>
                  </td>
                </tr>
                <tr>
                  <td><div class="simple_text">Подтверждение пароля:</div></td>
                  <td>
                       <dx:ASPxTextBox ID="tbPasswordConfirm" runat="server" Width="200px" 
                           Password="True">
                         <ValidationSettings ValidationGroup="AddResearchValidationGroup">
	                      <RequiredField ErrorText=" " IsRequired="true" />
	                     </ValidationSettings>
                       </dx:ASPxTextBox>
                  </td>
                </tr>
                <tr>
                  <td><div class="simple_text">Роль:</div></td>
                  <td>
                       <dx:ASPxComboBox ID="cbRole" runat="server" ValueType="System.String" Width="200px">
                        <ValidationSettings ValidationGroup="AddResearchValidationGroup">
	                      <RequiredField ErrorText=" " IsRequired="true" />
	                    </ValidationSettings>
                       </dx:ASPxComboBox>
                  </td>
                </tr>
                <tr>
                  <td>
                  </td>
                  <td>
                      <dx:ASPxButton ID="btnCreate" runat="server" Text="Добавить" ValidationGroup="AddResearchValidationGroup" onclick="BtnCreateClick" AutoPostBack = "false">
                      </dx:ASPxButton>
                  </td>
                </tr>
			</tbody>
</table> 
</div>



</asp:Content>
