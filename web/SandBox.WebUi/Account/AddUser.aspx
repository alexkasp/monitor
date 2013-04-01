<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="AddUser.aspx.cs" Inherits="SandBox.WebUi.Account.AddUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  <script type="text/javascript">
    // <![CDATA[
      function OnPasswdValidation(s, e) {
          var pass2 = e.value;
          var pass1 = tbPassword.GetValue();
          if (pass2 == null && pass1 == null) {
              e.isValid = true;
              return;
          }
          if (pass1 != pass2)
              e.isValid = false;
      }
    // ]]>
  </script>
     <div id="content-top">
        <div id="pagename">
            Добавление нового пользователя <a href="/Pages/Settings/Users.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
<table>
			<tbody>
                <tr>
                  <td><div class="simple_text">Имя пользователя:</div></td>
                  <td>
                       <dx:ASPxTextBox ID="tbUserName" runat="server" Width="200px">
                         <ValidationSettings SetFocusOnError="True" ValidationGroup="AddResearchValidationGroup">
	                      <RequiredField ErrorText="Введите имя пользователя" IsRequired="true" />
	                     </ValidationSettings>
                       </dx:ASPxTextBox>
                  </td>
                </tr>
                <tr>
                  <td><div class="simple_text">Логин:</div></td>
                  <td>
                       <dx:ASPxTextBox ID="tbLogin" runat="server" Width="200px" AutoCompleteType="Disabled" >
                         <ValidationSettings SetFocusOnError="True" ErrorText="Такой логин уже существует"  ValidationGroup="AddResearchValidationGroup">
	                      <RequiredField ErrorText="Введите логин" IsRequired="true" />
	                     </ValidationSettings>
                       </dx:ASPxTextBox>
                  </td>
                </tr>
                <tr>
                  <td><div class="simple_text">Пароль:</div></td>
                  <td>
                       <dx:ASPxTextBox ID="tbPassword" runat="server" Width="200px" Password="True" ClientInstanceName="tbPassword" AutoCompleteType="Disabled" >
                         <ValidationSettings SetFocusOnError="True" ValidationGroup="AddResearchValidationGroup">
	                      <RequiredField ErrorText="Введите пароль" IsRequired="true" />
	                     </ValidationSettings>
                       </dx:ASPxTextBox>
                  </td>
                </tr>
                <tr>
                  <td><div class="simple_text">Подтверждение пароля:</div></td>
                  <td>
                       <dx:ASPxTextBox ID="tbPasswordConfirm" runat="server" Width="200px" 
                           Password="True" ClientInstanceName="tbPasswordConfirm" 
                           AutoCompleteType="Disabled">
                         <ValidationSettings SetFocusOnError="True" ValidationGroup="AddResearchValidationGroup" ErrorText="Пароли не совпадают">
	                      <RequiredField ErrorText="Пароли не совпадают" IsRequired="true" />
	                     </ValidationSettings>
                         <ClientSideEvents Validation="OnPasswdValidation" />
                       </dx:ASPxTextBox>
                  </td>
                </tr>
                <tr>
                  <td><div class="simple_text">Роль:</div></td>
                  <td>
                       <dx:ASPxComboBox ID="cbRole" runat="server" ValueType="System.String" Width="200px">
                        <ValidationSettings SetFocusOnError="True" ValidationGroup="AddResearchValidationGroup" ErrorText="Выберите роль">
	                      <RequiredField ErrorText="Выберите роль" IsRequired="true" />
	                    </ValidationSettings>
                       </dx:ASPxComboBox>
                  </td>
                </tr>
                <tr>
                  <td>
                  </td>
                  <td>
                  <br />
                     <div style="width:200px;">
                     <div style="float:right;padding-left:10px;">
                      <dx:ASPxButton ID="btnCancel" runat="server" Text="Отменить" 
                             AutoPostBack = "False" CssClass="button" EnableDefaultAppearance="False" 
                             EnableTheming="False" Width="90px">
                          <ClientSideEvents Click="function(s, e) {
	document.location.href = '/Pages/Settings/Users.aspx';
}" />
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                      </dx:ASPxButton>
                      </div>
                     <div style="float:right">
                      <dx:ASPxButton ID="btnCreate" runat="server" Text="Добавить" 
                             ValidationGroup="AddResearchValidationGroup" onclick="BtnCreateClick" 
                             AutoPostBack = "false" CssClass="button" EnableDefaultAppearance="False" 
                             EnableTheming="False" Width="90px">
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                      </dx:ASPxButton>
                      </div>
                      </div>
                  </td>
                </tr>
			</tbody>
</table> 
</div>



</asp:Content>
