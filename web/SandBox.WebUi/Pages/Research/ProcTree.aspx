<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="ProcTree.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.ProcTree" %>

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
        Операционная система:
        <dx:ASPxLabel ID="LOS" runat="server" EnableDefaultAppearance="False" Font-Bold="True">
        </dx:ASPxLabel>
        <br />
        <br />
        <fieldset style="float: left; width: 48%;">
            <legend>Процессы ВПО</legend>
            <asp:UpdatePanel ID="ProcVPOTreeUpdatePanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <dx:ASPxTreeList ID="ProcVPOTreeList" runat="server" AutoGenerateColumns="False"
                        EnableCallbacks="False">
                        <Columns>
                            <dx:TreeListDataColumn FieldName="process" VisibleIndex="0" Caption="Процесс" Width="200px">
                            </dx:TreeListDataColumn>
                            <dx:TreeListDataColumn FieldName="pid" VisibleIndex="1" Caption="PID" Width="100px"
                                SortIndex="0" SortOrder="Ascending">
                            </dx:TreeListDataColumn>
                            <dx:TreeListDataColumn FieldName="timestart" VisibleIndex="2" Caption="Время запуска"
                                Width="100px">
                            </dx:TreeListDataColumn>
                            <dx:TreeListDateTimeColumn Caption="Время жизни" FieldName="timelife" VisibleIndex="3">
                                <PropertiesDateEdit DisplayFormatString="{0:HH:mm:ss.fff}">
                                </PropertiesDateEdit>
                            </dx:TreeListDateTimeColumn>
                            <dx:TreeListDataColumn Caption="Время завершения" FieldName="timeend" VisibleIndex="4">
                            </dx:TreeListDataColumn>
                        </Columns>
                        <Settings GridLines="Vertical" />
                        <SettingsBehavior ExpandCollapseAction="NodeDblClick" AllowFocusedNode="True" AutoExpandAllNodes="True" />
                        <SettingsLoadingPanel Enabled="False" />
                        <Styles>
                            <FocusedNode BackColor="#0C627F">
                            </FocusedNode>
                        </Styles>
                        <Border BorderStyle="Solid" />
                    </dx:ASPxTreeList>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdateProgress ID="ProcVPOTreeUpdateProgress" runat="server" AssociatedUpdatePanelID="ProcVPOTreeUpdatePanel">
                <ProgressTemplate>
                    Обновление данных:&nbsp;&nbsp;<img alt="Обновление данных..." src="/content/images/progress.gif">
                </ProgressTemplate>
            </asp:UpdateProgress>
        </fieldset>
        <fieldset style="float: left; width: 47%; margin-left: 10px;">
            <legend>Монитор процессов</legend>
            <asp:UpdatePanel ID="ProcTreeUpdatePanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <dx:ASPxTreeList ID="ProcTreeList" runat="server" AutoGenerateColumns="False" EnableCallbacks="False">
                        <Columns>
                            <dx:TreeListDataColumn FieldName="Name" VisibleIndex="0" Caption="Процесс" Width="200px">
                            </dx:TreeListDataColumn>
                            <dx:TreeListDataColumn FieldName="Pid1" VisibleIndex="1" Caption="PID" Width="100px"
                                SortIndex="0" SortOrder="Ascending">
                            </dx:TreeListDataColumn>
                            <dx:TreeListDataColumn FieldName="Count" VisibleIndex="2" Caption="Число потоков"
                                Width="100px">
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
        </fieldset>
    </div>
</asp:Content>
