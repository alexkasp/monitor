<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="Users.aspx.cs" Inherits="SandBox.WebUi.Pages.Settings.Users" %>

<%@ Register TagPrefix="dxwgv" Namespace="DevExpress.Web.ASPxGridView" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Настройки
        </div>
    </div>
    <div id="content-main">
        <dx:ASPxPageControl ID="pcSettings" runat="server" ActiveTabIndex="0" Width="100%">
            <TabPages>
                <dx:TabPage Text="Управление пользователями">
                    <ContentCollection>
                        <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                            <div style="padding-bottom: 10px;">
                                <dx:ASPxButton ID="btnNewUser" AutoPostBack="False" runat="server" Text="Добавить пользователя"
                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="200px">
                                    <ClientSideEvents Click="function(s, e) {
            document.location.href = '/Account/AddUser.aspx';
}" />
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
                                            <SettingsCookies CookiesID="UserGrid2" Enabled="True" StoreFiltering="False" />
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
