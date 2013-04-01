<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="ProcTree.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.ProcTree" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Список процессов <a href="javascript: history.go(-1)">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" /></a></div>
    </div>
    <div id="content-main">
        <div class="titlegr">
            <dx:ASPxLabel ID="ResearchTitle" runat="server" EnableDefaultAppearance="False">
            </dx:ASPxLabel>
        </div>
            Операционная система: <dx:ASPxLabel ID="LOS" runat="server" EnableDefaultAppearance="False" Font-Bold="True"></dx:ASPxLabel>
            <br/>
            <br/>
        <asp:UpdatePanel ID="ProcTreeUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <dx:ASPxTreeList ID="ProcTreeList" runat="server" AutoGenerateColumns="False" EnableCallbacks="False" >
                    <Columns>
                        <dx:TreeListDataColumn FieldName="Name" VisibleIndex="0" Caption="Процесс" Width="200px">
                        </dx:TreeListDataColumn>
                        <dx:TreeListDataColumn FieldName="Pid1" VisibleIndex="1" Caption="PID" 
                            Width="100px" SortIndex="0" SortOrder="Ascending">
                        </dx:TreeListDataColumn>
                        <dx:TreeListDataColumn FieldName="Count" VisibleIndex="2" Caption="Число потоков" Width="100px">
                        </dx:TreeListDataColumn>
                    </Columns>
                    <Settings GridLines="Vertical" />
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
        <asp:UpdateProgress ID="ProcTreeUpdateProgress" runat="server" AssociatedUpdatePanelID="ProcTreeUpdatePanel">
            <ProgressTemplate>
                Обновление данных:&nbsp;&nbsp;<img alt="Обновление данных..." src="/content/images/progress.gif">
            </ProgressTemplate>
        </asp:UpdateProgress>
    </div>
</asp:Content>
