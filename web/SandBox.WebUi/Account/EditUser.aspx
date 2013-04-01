<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="EditUser.aspx.cs" Inherits="SandBox.WebUi.Account.EditUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function IsOldIE() {
            return ASPxClientUtils.ie && (ASPxClientUtils.browserMajorVersion < 9);
        }

        function SetInputType(input, newTypeValue) {
            if (IsOldIE())
            //Only for IE 8
                input.attributes("type").nodeValue = newTypeValue;
            else
                input.type = newTypeValue;
        }

        function txtPassword_Init(s, e) {
            if (s.GetText() != "")
                SetInputType(s.GetInputElement(), "password");
        }

        function txtPassword_GotFocus(s, e) {
            SetInputType(s.GetInputElement(), "password");
        }

        function txtPassword_LostFocus(s, e) {
            if (s.GetText() == "")
                SetInputType(s.GetInputElement(), "");
        }
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
    </script>
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
                    <td>
                        <div class="simple_text">
                            Имя пользователя:</div>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbUserName" runat="server" Width="200px">
                            <ValidationSettings ValidationGroup="AddResearchValidationGroup">
                                <RequiredField ErrorText=" " IsRequired="true" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="simple_text">
                            Логин:</div>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbLogin" runat="server" Width="200px" 
                            AutoCompleteType="Disabled">
                            <ValidationSettings ValidationGroup="AddResearchValidationGroup">
                                <RequiredField ErrorText=" " IsRequired="true" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="simple_text">
                            Пароль:</div>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbPassword" runat="server" Width="200px" 
                            NullText="[Старый пароль]" ClientInstanceName="tbPassword" 
                            AutoCompleteType="Disabled">
                            <ClientSideEvents Init="txtPassword_Init" GotFocus="txtPassword_GotFocus" LostFocus="txtPassword_LostFocus" />
                            <ValidationSettings ValidationGroup="AddResearchValidationGroup">
                                <RequiredField ErrorText=" " IsRequired="false" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="simple_text">
                            Подтверждение пароля:</div>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbPasswordConfirm" runat="server" Width="200px" 
                            NullText="[Старый пароль]" ClientInstanceName="tbPasswordConfirm" 
                            AutoCompleteType="Disabled">
                            <ClientSideEvents Init="txtPassword_Init" GotFocus="txtPassword_GotFocus" LostFocus="txtPassword_LostFocus"/>
                            <ValidationSettings ValidationGroup="AddResearchValidationGroup"  ErrorText="Пароли не совпадают">
                                <RequiredField IsRequired="false" ErrorText="Пароли не совпадают"/>
                            </ValidationSettings>
                         <ClientSideEvents Validation="OnPasswdValidation" />
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="simple_text">
                            Роль:</div>
                    </td>
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
                        <br />
                        <div style="width: 200px;">
                            <div style="float: right; padding-left: 10px;">
                                <dx:ASPxButton ID="btnCancel" runat="server" Text="Отменить" AutoPostBack="False"
                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="90px">
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
                            <div style="float: right">
                                <dx:ASPxButton ID="btnEdit" runat="server" Text="Сохранить" ValidationGroup="AddResearchValidationGroup"
                                    OnClick="BtnEditClick" AutoPostBack="false" CssClass="button" EnableDefaultAppearance="False"
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
