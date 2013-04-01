<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="FilesTree.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.FilesTree" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Образ файловой системы <a href="javascript: history.go(-1)">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" /></a></div>
    </div>
    <div id="content-main">
        <div class="titlegr">
            <dx:ASPxLabel ID="ResearchTitle" runat="server" EnableDefaultAppearance="False">
            </dx:ASPxLabel>
        </div>
            Операционная система: <dx:ASPxLabel ID="LOS" runat="server" EnableDefaultAppearance="False" Font-Bold="True"></dx:ASPxLabel>
            <br/>
            Корневая директория: <dx:ASPxLabel ID="FilesRoot" runat="server" EnableDefaultAppearance="False" Font-Bold="True"></dx:ASPxLabel>
            <br/>
            <br/>
        <asp:UpdatePanel ID="FileTreeUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <dx:ASPxTreeList ID="FileTreeList" runat="server" AutoGenerateColumns="False" EnableCallbacks="False"
                    OnVirtualModeCreateChildren="FileTree_VirtualModeCreateChildren" OnVirtualModeNodeCreating="FileTree_VirtualModeNodeCreating">
                    <Columns>
                        <dx:TreeListDataColumn FieldName="Name" VisibleIndex="0" Caption="Директория/Файл" Width="500px">
                        </dx:TreeListDataColumn>
                    </Columns>
                    <SettingsBehavior ExpandCollapseAction="NodeDblClick" AllowFocusedNode="True" />
                    <SettingsLoadingPanel Enabled="False" />
                    <Styles>
                        <FocusedNode BackColor="#0C627F">
                        </FocusedNode>
                    </Styles>
                   <Templates>
                        <DataCell>
                            <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <dx:ASPxImage ID="ASPxImage1" runat="server" ImageUrl='<%# GetIconUrl(Container) %>'
                                            Width="16" Height="16" IsPng="true" />
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td style="padding-bottom: 1px;">
                                        <%# Container.Text %>
                                    </td>
                                </tr>
                            </table>
                        </DataCell>
                    </Templates>
                    <Border BorderStyle="Solid" />
                </dx:ASPxTreeList>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="FileTreeUpdateProgress" runat="server" AssociatedUpdatePanelID="FileTreeUpdatePanel">
            <ProgressTemplate>
                Обновление данных:&nbsp;&nbsp;<img alt="Обновление данных..." src="/content/images/progress.gif">
            </ProgressTemplate>
        </asp:UpdateProgress>
    </div>
</asp:Content>
