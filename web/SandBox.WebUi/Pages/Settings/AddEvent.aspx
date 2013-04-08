<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="AddEvent.aspx.cs" Inherits="SandBox.WebUi.Account.AddEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div id="content-top">
        <div id="pagename">
            Добавление события <a href="/Pages/Settings/Main.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
        <table>
            <tbody>
                <tr>
                    <td style="width: 150px">
                        <div class="table_text">
                            Модуль</div>
                    </td>
                    <td>
                        <dx:ASPxComboBox ID="cbModule" runat="server" Width="200px" DropDownStyle="DropDownList"
                            IncrementalFilteringMode="StartsWith" EnableSynchronization="False" EnableIncrementalFiltering="True"
                            ShowLoadingPanel="False" ClientInstanceName="cbModule">
                            <ClientSideEvents SelectedIndexChanged="function(s, e) { cbEvent.PerformCallback(s.GetValue().toString()); }" />
                        </dx:ASPxComboBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px">
                        <div class="table_text">
                            Событие</div>
                    </td>
                    <td>
                        <dx:ASPxComboBox ID="cbEvent" runat="server" Width="200px" ClientInstanceName="cbEvent"
                            ShowLoadingPanel="False" TextField="EventsEventDescription" EnableIncrementalFiltering="True"
                            EnableSynchronization="False" ValueField="EventID" IncrementalFilteringMode="StartsWith"
                            OnCallback="cbEvent_Callback" AutoResizeWithContainer="True">
                            <ClientSideEvents EndCallback="function(s, e) { s.SetSelectedIndex(0); }" />
                        </dx:ASPxComboBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px">
                        Объект
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbWho" runat="server" Width="200px" ClientInstanceName="tbWho"
                            NullText="[Имя образа]">
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px">
                        Цель
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbDest" runat="server" Width="200px" ClientInstanceName="tbDest"
                            NullText="[Параметр]">
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px">
                        Важность
                    </td>
                    <td>
                        <dx:ASPxComboBox ID="cbSign" runat="server" ShowLoadingPanel="False" IncrementalFilteringMode="StartsWith"
                            Width="200px" SelectedIndex="0" EnableIncrementalFiltering="True" EnableSynchronization="False">
                            <Items>
                                <dx:ListEditItem Text="Важное" Value="0" Selected="True" />
                                <dx:ListEditItem Text="Критическое" Value="1" />
                            </Items>
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
	document.location.href = '/Pages/Settings/Main.aspx';
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
                                <dx:ASPxButton ID="btnCreate" runat="server" Text="Добавить" ValidationGroup="AddResearchValidationGroup"
                                    OnClick="BtnCreateClick" AutoPostBack="false" CssClass="button" EnableDefaultAppearance="False"
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
                <tr>
                    <td style="width: 150px">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 150px" valign="top">
                    <strong>Справка</strong>
                    </td>
                    <td>
                    % - Любая строка из нуля или более символов.<br />
                    _ - Любой единичный символ.<br />
                    [ ] - Любой символ из указанного диапазона (например [a-f]) или набора символов (например [abcdef]).<br />
                    [^] - Любой символ, не входящий в заданный диапазон (например [^a-f]) или набор символов (например [^abcdef]).<br />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
