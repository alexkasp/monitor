<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="Main.aspx.cs" Inherits="SandBox.WebUi.Pages.Settings.Main" %>

<%@ Register TagPrefix="dxwgv" Namespace="DevExpress.Web.ASPxGridView" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Настройки
        </div>
    </div>
    <div id="content-main">
        <dx:ASPxPopupControl ID="popup_refrvpo" ClientInstanceName="popup_refrvpo" runat="server"
            ShowCloseButton="False" PopupHorizontalAlign="WindowCenter" ShowHeader="False" 
            ShowLoadingPanelImage="False" PopupVerticalAlign="WindowCenter" 
            Modal="True" ShowLoadingPanel="False" Width="300px">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                    Запущено обновление классификации ВПО.<br />
                    Это может занять некоторое время...
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPageControl ID="pcSettings" runat="server" ActiveTabIndex="0" Width="100%"
            SaveStateToCookies="True">
            <TabPages>
                <dx:TabPage Text="Управление пользователями" Name="UserTab">
                    <ContentCollection>
                        <dx:ContentControl ID="ContentControl1" runat="server" SupportsDisabledAttribute="True">
                            <div style="padding-bottom: 10px;">
                                <dx:ASPxButton ID="btnNewUser" AutoPostBack="False" runat="server" Text="Добавить пользователя"
                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="200px">
                                    <ClientSideEvents Click="function(s, e) { document.location.href = '/Account/AddUser.aspx'; }" />
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                                </dx:ASPxButton>
                            </div>
                            <div>
                                <asp:UpdatePanel ID="UsersUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <dx:ASPxGridView ID="gridViewUsers" runat="server" AutoGenerateColumns="False" KeyFieldName="UserId"
                                            OnCustomCallback="gridViewUsers_CustomCallback" EnableTheming="True" Theme="SandboxTheme"
                                            ClientInstanceName="gridViewUsers" Width="100%">
                                            <ClientSideEvents CustomButtonClick="function(s, e) {
	                                        if (e.buttonID == 'cbDelete') {
                                                if (!confirm('Вы уверены, что хотите удалить пользователя?')) { return;}
                                                gridViewUsers.PerformCallback(e.buttonID+','+ s.GetRowKey(e.visibleIndex));
                                                }
	                                        if (e.buttonID == 'cbEdit') {
                                                document.location.href = '/Account/EditUser.aspx?userId=' + s.GetRowKey(e.visibleIndex);
                                                }
                                            }" RowClick="function(s, e) {
	                                            document.location.href = '/Account/EditUser.aspx?userId=' + s.GetRowKey(e.visibleIndex);
                                            }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="id" FieldName="UserId" VisibleIndex="1" Visible="False">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="имя пользователя" FieldName="UserName" VisibleIndex="0">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Login" ShowInCustomizationForm="True" Caption="логин"
                                                    VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="дата создания" FieldName="CreatedDate" VisibleIndex="2"
                                                    Width="130px">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="дата последнего входа" FieldName="LastLoginDate"
                                                    VisibleIndex="3" Width="180px">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Роль" FieldName="Name" VisibleIndex="4" Width="100px">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewCommandColumn VisibleIndex="5" ButtonType="Image" Width="50px" Caption="Редактировать">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="cbEdit">
                                                            <Image ToolTip="Редактировать" Url="../../Content/Images/Icons/edit2.png" />
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <CellStyle HorizontalAlign="Center">
                                                    </CellStyle>
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewCommandColumn VisibleIndex="6" ButtonType="Image" Width="50px" Caption="Удалить">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="cbDelete">
                                                            <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png" />
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <CellStyle HorizontalAlign="Center">
                                                    </CellStyle>
                                                </dx:GridViewCommandColumn>
                                            </Columns>
                                            <SettingsBehavior AllowFocusedRow="True" EnableRowHotTrack="True" ColumnResizeMode="Control" />
                                            <SettingsLoadingPanel Mode="Disabled" />
                                            <SettingsCookies CookiesID="UserGrid" Enabled="True" />
                                            <Styles>
                                                <Header Font-Bold="True">
                                                </Header>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="Классификация событий">
                    <ContentCollection>
                        <dx:ContentControl ID="ContentControl2" runat="server" SupportsDisabledAttribute="True">
                            <div style="padding-bottom: 10px;">
                                <dx:ASPxButton ID="btnNewEvent" AutoPostBack="False" runat="server" Text="Добавить событие"
                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="200px">
                                    <ClientSideEvents Click="function(s, e) { document.location.href = '/Pages/Settings/AddEvent.aspx'; }" />
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                                </dx:ASPxButton>
                            </div>
                            <div>
                                <asp:UpdatePanel ID="EventsUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <dx:ASPxGridView ID="gridClEvView" runat="server" AutoGenerateColumns="False" Width="100%"
                                            KeyFieldName="Id" Theme="Default" ClientInstanceName="gridClEvView" EnableCallBacks="False"
                                            EnableTheming="True" OnCustomCallback="gridClEvView_CustomCallback">
                                            <ClientSideEvents CustomButtonClick="function(s, e) {
	                                        if (e.buttonID == 'cbEvDelete') {
                                                if (!confirm('Вы уверены, что хотите удалить событие?')) { return;}
                                                gridClEvView.PerformCallback(e.buttonID+','+ s.GetRowKey(e.visibleIndex));
                                                }
	                                        if (e.buttonID == 'cbEvEdit') {
                                                document.location.href = '/Pages/Settings/EditEvent.aspx?dofid=' + s.GetRowKey(e.visibleIndex);
                                                }
                                            }" RowClick="function(s, e) {
	                                            if (!gridClEvView.IsGroupRow(e.visibleIndex))
    	                                            document.location.href = '/Pages/Settings/EditEvent.aspx?dofid=' + s.GetRowKey(e.visibleIndex);
                                            }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="Модуль" VisibleIndex="2" FieldName="module" SortIndex="1"
                                                    SortOrder="Ascending">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Объект" FieldName="who" VisibleIndex="4">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Событие" VisibleIndex="3" FieldName="event">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Цель" VisibleIndex="5" FieldName="dest">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Id" FieldName="Id" Name="Id" VisibleIndex="0" Visible="False">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Важность" FieldName="signdesc" GroupIndex="0"
                                                    SortIndex="0" SortOrder="Ascending" VisibleIndex="1">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewCommandColumn VisibleIndex="6" ButtonType="Image" Width="50px" Caption="Редактировать">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="cbEvEdit">
                                                            <Image ToolTip="Редактировать" Url="../../Content/Images/Icons/edit2.png" />
                                                            <Image ToolTip="Редактировать" Url="../../Content/Images/Icons/edit2.png">
                                                            </Image>
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <CellStyle HorizontalAlign="Center">
                                                    </CellStyle>
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewCommandColumn VisibleIndex="7" ButtonType="Image" Width="50px" Caption="Удалить">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="cbEvDelete">
                                                            <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png" />
                                                            <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png">
                                                            </Image>
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <CellStyle HorizontalAlign="Center">
                                                    </CellStyle>
                                                </dx:GridViewCommandColumn>
                                            </Columns>
                                            <SettingsBehavior AllowFocusedRow="True" AutoExpandAllGroups="True" EnableRowHotTrack="True"
                                                ColumnResizeMode="Control" />
                                            <SettingsPager AlwaysShowPager="True" PageSize="100">
                                            </SettingsPager>
                                            <SettingsLoadingPanel Mode="Disabled" />
                                            <SettingsCookies CookiesID="ClEvGrid" Enabled="True" StoreFiltering="True" StoreGroupingAndSorting="True" />
                                            <Styles>
                                                <Header Font-Bold="True">
                                                </Header>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="Классификация ВПО">
                    <ContentCollection>
                        <dx:ContentControl ID="ContentControl3" runat="server" SupportsDisabledAttribute="True">
                            <div style="padding-bottom: 10px;">
                                <div style="float: left">
                                    <dx:ASPxButton ID="btnNewVPOClass" AutoPostBack="False" runat="server" Text="Добавить класс ВПО"
                                        CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="200px">
                                        <ClientSideEvents Click="function(s, e) { document.location.href = '/Pages/Settings/AddClass.aspx'; }" />
                                        <PressedStyle CssClass="buttonHover">
                                        </PressedStyle>
                                        <HoverStyle CssClass="buttonHover">
                                        </HoverStyle>
                                        <DisabledStyle CssClass="buttonDisable">
                                        </DisabledStyle>
                                    </dx:ASPxButton>
                                </div>
                                <div style="float: left; padding-left: 10px;">
                                                <dx:ASPxButton ID="btnRefreshVPO" AutoPostBack="False" runat="server" Text="Обновить классификацию ВПО"
                                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" 
                                                    Width="250px" OnClick="btnRefreshVPO_Click" >
                                                    <ClientSideEvents Click="function(s, e) {
	popup_refrvpo.Show();
}" Init="function(s, e) {
	popup_refrvpo.Hide();
}" />
                                                    <PressedStyle CssClass="buttonHover">
                                                    </PressedStyle>
                                                    <HoverStyle CssClass="buttonHover">
                                                    </HoverStyle>
                                                    <DisabledStyle CssClass="buttonDisable">
                                                    </DisabledStyle>
                                                </dx:ASPxButton>
                                </div>
                            </div>
                            <div style="clear:both; padding-top:10px;">
                                <asp:UpdatePanel ID="ClassesUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <dx:ASPxGridView ID="gridClVPOView" runat="server" AutoGenerateColumns="False" Width="100%"
                                            KeyFieldName="id" Theme="Default" ClientInstanceName="gridClVPOView" EnableCallBacks="False"
                                            EnableTheming="True" OnCustomCallback="gridClVPOView_CustomCallback" OnHtmlRowPrepared="gridClVPOView_HtmlRowPrepared">
                                            <ClientSideEvents CustomButtonClick="function(s, e) {
	                                        if (e.buttonID == 'cbClDelete') {
                                                if (!confirm('Вы уверены, что хотите удалить событие?')) { return;}
                                                gridClVPOView.PerformCallback(e.buttonID+','+ s.GetRowKey(e.visibleIndex));
                                                }
	                                        if (e.buttonID == 'cbClEdit') {
                                                document.location.href = '/Pages/Settings/EditClass.aspx?itemid=' + s.GetRowKey(e.visibleIndex);
                                                }
                                            }" RowClick="function(s, e) {
	                                            if (!gridClVPOView.IsGroupRow(e.visibleIndex))
                                                    document.location.href = '/Pages/Settings/EditClass.aspx?itemid=' + s.GetRowKey(e.visibleIndex);
                                            }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="Модуль" VisibleIndex="2" FieldName="Module" SortIndex="1"
                                                    SortOrder="Ascending" GroupIndex="1">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Параметр" FieldName="Param" VisibleIndex="4">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Событие" VisibleIndex="3" FieldName="Event">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="№" FieldName="Id" Name="Id" VisibleIndex="0"
                                                    Visible="False">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Наименование" VisibleIndex="1" FieldName="Name"
                                                    GroupIndex="0" SortIndex="0" SortOrder="Ascending">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewCommandColumn VisibleIndex="6" ButtonType="Image" Width="50px" Caption="Редактировать">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="cbClEdit">
                                                            <Image ToolTip="Редактировать" Url="../../Content/Images/Icons/edit2.png" />
                                                            <Image ToolTip="Редактировать" Url="../../Content/Images/Icons/edit2.png">
                                                            </Image>
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <CellStyle HorizontalAlign="Center">
                                                    </CellStyle>
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewCommandColumn VisibleIndex="7" ButtonType="Image" Width="50px" Caption="Удалить">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="cbClDelete">
                                                            <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png" />
                                                            <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png">
                                                            </Image>
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <CellStyle HorizontalAlign="Center">
                                                    </CellStyle>
                                                </dx:GridViewCommandColumn>
                                            </Columns>
                                            <SettingsBehavior AllowFocusedRow="True" AutoExpandAllGroups="True" EnableRowHotTrack="True"
                                                ColumnResizeMode="Control" />
                                            <SettingsBehavior AllowFocusedRow="True" AutoExpandAllGroups="True" ColumnResizeMode="Control"
                                                EnableRowHotTrack="True" />
                                            <SettingsPager AlwaysShowPager="True" PageSize="100">
                                            </SettingsPager>
                                            <SettingsLoadingPanel Mode="Disabled" />
                                            <Styles>
                                                <Header Font-Bold="True">
                                                </Header>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
            </TabPages>
        </dx:ASPxPageControl>
    </div>
</asp:Content>
