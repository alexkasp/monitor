<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="RegsTree.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.RegsTree" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Образ реестра <a href="javascript: history.go(-1)">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" /></a></div>
    </div>
    <div id="content-main">
        <div class="titlegr">
            <dx:ASPxLabel ID="ResearchTitle" runat="server" EnableDefaultAppearance="False">
            </dx:ASPxLabel>
        </div>
            Операционная система: <dx:ASPxLabel ID="LOS" runat="server" EnableDefaultAppearance="False" Font-Bold="True"></dx:ASPxLabel>
            <br/>
            Корневая директория: <dx:ASPxLabel ID="RegRoot" runat="server" EnableDefaultAppearance="False" Font-Bold="True"></dx:ASPxLabel>
            <br/>
            <br/>
        <asp:UpdatePanel ID="RegTreeUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <dx:ASPxTreeList ID="RegTreeList" runat="server" AutoGenerateColumns="False" EnableCallbacks="False"
                    OnVirtualModeCreateChildren="RegTree_VirtualModeCreateChildren" OnVirtualModeNodeCreating="RegTree_VirtualModeNodeCreating">
                    <Columns>
                        <dx:TreeListDataColumn FieldName="KeyName" VisibleIndex="0" Caption="Раздел реестра"
                            SortIndex="0" SortOrder="Ascending" Width="500px">
                            <CellStyle>
                                <Paddings PaddingLeft="20px" />
                                <BackgroundImage HorizontalPosition="left" ImageUrl="~/Content/Images/Icons/reg_dir.png"
                                    Repeat="NoRepeat" VerticalPosition="center" />
                            </CellStyle>
                        </dx:TreeListDataColumn>
                    </Columns>
                    <SettingsBehavior ExpandCollapseAction="NodeDblClick" AllowFocusedNode="True" />
                    <SettingsLoadingPanel Enabled="False" />
                    <Styles>
                        <FocusedNode BackColor="#0C627F">
                        </FocusedNode>
                    </Styles>
                    <Border BorderStyle="Solid" />
                </dx:ASPxTreeList>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="RegTreeUpdateProgress" runat="server" AssociatedUpdatePanelID="RegTreeUpdatePanel">
            <ProgressTemplate>
                Обновление данных:&nbsp;&nbsp;<img alt="Обновление данных..." src="/content/images/progress.gif">
            </ProgressTemplate>
        </asp:UpdateProgress>
    </div>
</asp:Content>
