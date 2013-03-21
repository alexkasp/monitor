<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="SandBox.WebUi.Pages.Settings.Users" %>
<%@ Register TagPrefix="dxwgv" Namespace="DevExpress.Web.ASPxGridView" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Настройки <a href="javascript: history.go(-1)">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
    <dx:ASPxPageControl ID="pcSettings" runat="server" ActiveTabIndex="0">
        <TabPages>
            <dx:TabPage Text="Управление пользователями">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                       <div style="padding-bottom:10px;">
                        <dx:ASPxButton ID="btnNewUser" AutoPostBack="False" runat="server" 
                            Text="Добавить пользователя" CssClass="button" 
                            EnableDefaultAppearance="False" EnableTheming="False" Width="200px">
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
                        </div><div>
   <dx:ASPxGridView ID="gridViewUsers" runat="server" AutoGenerateColumns="False" KeyFieldName="UserId" 
        OnCustomCallback="gridViewUsers_CustomCallback" EnableTheming="True" Theme="SandboxTheme" 
                        ClientInstanceName="gridViewUsers" >
        <ClientSideEvents CustomButtonClick="function(s, e) {
	if (e.buttonID == 'cbDelete') {
 if (!confirm('Вы уверены, что хотите удалить пользователя?')) { return;}}
 gridViewUsers.PerformCallback(e.buttonID+','+ s.GetRowKey(e.visibleIndex));
}" />
        <Columns>
            <dx:GridViewDataTextColumn Caption="id пользователя" FieldName="UserId" 
                VisibleIndex="0" Visible="False">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="имя пользователя" FieldName="Login" 
                VisibleIndex="0">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="дата создания" FieldName="CreatedDate" 
                VisibleIndex="1">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="дата последнего входа" 
                FieldName="LastLoginDate" VisibleIndex="2">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="Роль" FieldName="Name" VisibleIndex="3">
            </dx:GridViewDataTextColumn>
            <dx:GridViewCommandColumn VisibleIndex="4" ButtonType="Image" Width = "50px">
                <CustomButtons>
                    <dx:GridViewCommandColumnCustomButton ID="cbDelete">
                        <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png" />
                    </dx:GridViewCommandColumnCustomButton>
                </CustomButtons>
                <CellStyle HorizontalAlign="Center">
                </CellStyle>
            </dx:GridViewCommandColumn>
        </Columns>
                        <SettingsBehavior AllowFocusedRow="True" 
                    EnableRowHotTrack="True" />
         <SettingsLoadingPanel Mode="Disabled" />
    </dx:ASPxGridView>
    </div>
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
        </TabPages>
    </dx:ASPxPageControl>

</div>
</asp:Content>
