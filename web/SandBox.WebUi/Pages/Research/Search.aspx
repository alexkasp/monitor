<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="Search.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.WebForm1" %>

<%@ Register Assembly="DevExpress.Web.v12.1, Version=12.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Data.Linq" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Поиск</div>
    </div>
    <div id="content-main">
        <table class='panel'>
            <tbody>
                <tr>
                    <td class='panel-left'>
                        <div class='panel-text'>
                            <cc1:LinqServerModeDataSource ID="LinqServerModeDataSource1" runat="server" ContextTypeName="SandBox.Db.SandBoxDataContext"
                                TableName="EventsTableViews" />
                            <br />
                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 362px">
                                        <dx:ASPxTextBox ID="SearchTextBox" runat="server" Height="18px" Width="345px">
                                            <ClientSideEvents KeyPress="function(s, e) {
                                                            if (e.htmlEvent.keyCode == 13) {
                                                                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                                SearchButton.DoClick();
                                                            }
                                                }" />
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="SearchButton" runat="server" AutoPostBack="False" Height="16px"
                                            Text="Найти" Width="60px" ClientInstanceName="SearchButton">
                                            <ClientSideEvents Click="function(s, e) {
	                                                gridSearchView.PerformCallback('ApplyFilter');
                                                }" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                            <script type="text/javascript">
                                $(document).ready(function () {

                                    $('#extfilterbtn').toggle(function () {

                                        $('#extfilter').slideDown();
                                    }, function () {

                                        $('#extfilter').slideUp();
                                    });

                                })
                            </script>
                            <div id="extfilterbtn">
                                <a href="#">Расширенный фильтр</a></div>
                            <br />
                            <div id="extfilter" style="display: none; padding-bottom: 30px;">
                                <asp:UpdatePanel ID="ExtFilterUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <dx:ASPxFilterControl ID="ExtFilter" runat="server" ClientInstanceName="ExtFilter"
                                            EnableCallBacks="False">
                                            <Columns>
                                                <dx:FilterControlSpinEditColumn ColumnType="Integer" DisplayName="№" PropertyName="Id">
                                                    <PropertiesSpinEdit DisplayFormatString="g">
                                                    </PropertiesSpinEdit>
                                                </dx:FilterControlSpinEditColumn>
                                                <dx:FilterControlDateColumn ColumnType="DateTime" DisplayName="Время события" PropertyName="timeofevent">
                                                    <PropertiesDateEdit EditFormat="DateTime">
                                                    </PropertiesDateEdit>
                                                </dx:FilterControlDateColumn>
                                                <dx:FilterControlComboBoxColumn ColumnType="String" DisplayName="Модуль" PropertyName="ModuleId">
                                                    <PropertiesComboBox>
                                                        <Items>
                                                            <dx:ListEditItem Selected="True" Text="Файловая система" Value="Файловая система" />
                                                            <dx:ListEditItem Text="Реестр" Value="Реестр" />
                                                            <dx:ListEditItem Text="Процессы" Value="Процессы" />
                                                            <dx:ListEditItem Text="NDISMON" Value="NDISMON" />
                                                            <dx:ListEditItem Text="TDIMON" Value="TDIMON" />
                                                        </Items>
                                                    </PropertiesComboBox>
                                                </dx:FilterControlComboBoxColumn>
                                                <dx:FilterControlSpinEditColumn ColumnType="Integer" DisplayName="PID" PropertyName="pid1">
                                                    <PropertiesSpinEdit DisplayFormatString="g">
                                                    </PropertiesSpinEdit>
                                                </dx:FilterControlSpinEditColumn>
                                                <dx:FilterControlSpinEditColumn ColumnType="Integer" DisplayName="PID2" PropertyName="pid2">
                                                    <PropertiesSpinEdit DisplayFormatString="g">
                                                    </PropertiesSpinEdit>
                                                </dx:FilterControlSpinEditColumn>
                                                <dx:FilterControlTextColumn DisplayName="Событие" PropertyName="EventCode" ColumnType="String">
                                                </dx:FilterControlTextColumn>
                                                <dx:FilterControlTextColumn ColumnType="String" DisplayName="Цель" PropertyName="who">
                                                </dx:FilterControlTextColumn>
                                                <dx:FilterControlTextColumn ColumnType="String" DisplayName="Объект" PropertyName="dest">
                                                </dx:FilterControlTextColumn>
                                                <dx:FilterControlTextColumn ColumnType="String" DisplayName="Данные" PropertyName="adddata1">
                                                </dx:FilterControlTextColumn>
                                                <dx:FilterControlTextColumn ColumnType="String" DisplayName="Дополтительные" PropertyName="adddata2">
                                                </dx:FilterControlTextColumn>
                                            </Columns>
                                            <SettingsLoadingPanel Enabled="False" />
                                        </dx:ASPxFilterControl>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div style="float: left; padding-top: 10px;">
                                    <dx:ASPxButton runat="server" ID="btnApply" Text="Поиск" AutoPostBack="false" UseSubmitBehavior="false">
                                        <ClientSideEvents Click="function() {   setTimeout(function () {
                gridSearchView.PerformCallback('ApplyExtFilter');
            },1500);
 }" />
                                    </dx:ASPxButton>
                                </div>
                                <div style="float: left; padding-left: 20px; padding-top: 10px;">
                                    <dx:ASPxButton runat="server" ID="btnReset" Text="Очистить" AutoPostBack="false"
                                        UseSubmitBehavior="false">
                                        <ClientSideEvents Click="function() { ExtFilter.Reset(); }" />
                                    </dx:ASPxButton>
                                </div>
                            </div>
                            <br />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="page_table">
            <div style="float: left">
                Результаты поиска:</div>
            <div style="float: left">
                <asp:UpdateProgress ID="SearchGridUpdateProgress" runat="server" AssociatedUpdatePanelID="SearchGridUpdatePanel">
                    <ProgressTemplate>
                        <img alt="Обновление данных..." src="/content/images/progress.gif">
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
            <br />
            <hr style="width: 100%;" />
            <asp:UpdatePanel ID="SearchGridUpdatePanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
<%--                    <dx:ASPxPager ID="gridSearchViewPager" runat="server" ItemCount="1000" ItemsPerPage="100"
                        OnPageIndexChanged="gridSearchViewPager_PageIndexChanged" Visible="False" OnPageSizeChanged="gridSearchViewPager_PageSizeChanged"
                        ShowNumericButtons="False" Theme="SandboxTheme">
                        <Summary AllPagesText="{0}-{1} из {2}" Text="{0}-{1} из {2}" />
                        <PageSizeItemSettings AllItemText="Все" Caption="" Visible="True">
                        </PageSizeItemSettings>
                    </dx:ASPxPager>--%>
            <div style="float: left">
                <dx:ASPxMenu ID="OpenReportMenu" runat="server" ClientInstanceName="OpenReportMenu"
                    ClientVisible="False" BackColor="Transparent" >
                    <Paddings PaddingLeft="25px" />
                    <Items>
                        <dx:MenuItem Name="OpenReport" Text="Открыть отчет по исследованию" 
                            NavigateUrl="~/Pages/Research/ReportList.aspx?research=">
                        </dx:MenuItem>
                    </Items>
                    <ItemStyle BackColor="Transparent">
                    <hoverstyle backcolor="Transparent" font-underline="True">
                        <Border BorderWidth="0px" />
                    </hoverstyle>
                    <Border BorderWidth="0px" />
                    </ItemStyle>
                    <BackgroundImage HorizontalPosition="left" 
                        ImageUrl="~/Content/Images/Icons/report.png" Repeat="NoRepeat" 
                        VerticalPosition="center" />
                    <Border BorderWidth="0px" />
                </dx:ASPxMenu>
            </div>
            <div style="float: right">
                <dx:ASPxMenu ID="SearchTableMenu" runat="server" ClientInstanceName="SearchTableMenu"
                    ClientVisible="False" BackColor="Transparent" RenderMode="Lightweight">
                    <ClientSideEvents ItemClick="function(s, e) {
	                    switch (e.item.name) {
                           case 'ExpandAll':
                              gridSearchView.ExpandAll();
                              break
                           case 'CollapseAll':
                              gridSearchView.CollapseAll();
                              break
                           case 'CustomColumns':
                              if(gridSearchView.IsCustomizationWindowVisible())
                               gridSearchView.HideCustomizationWindow();
                              else
                               gridSearchView.ShowCustomizationWindow();  
                              break
                           case 'SaveGridProps':
                               gridSearchView.PerformCallback('SaveLayout'); 
                              break
                            }
                         }" />
                    <Paddings PaddingLeft="25px" />
                    <Items>
                        <dx:MenuItem Text="Настройка">
                            <Items>
                                <dx:MenuItem Text="Раскрыть все группы" Name="ExpandAll">
                                </dx:MenuItem>
                                <dx:MenuItem Text="Свернуть все группы" Name="CollapseAll">
                                </dx:MenuItem>
                                <dx:MenuItem Text="Скрыть колонки" Name="CustomColumns">
                                </dx:MenuItem>
                                <dx:MenuItem Text="Сохранить настройки" Name="SaveGridProps">
                                </dx:MenuItem>
                            </Items>
                        </dx:MenuItem>
                    </Items>
                    <ItemStyle BackColor="Transparent">
                    <hoverstyle backcolor="Transparent" font-underline="True">
                        <Border BorderWidth="0px" />
                    </hoverstyle>
                    <Border BorderWidth="0px" />
                    </ItemStyle>
                    <BackgroundImage HorizontalPosition="left" 
                        ImageUrl="~/Content/Images/Icons/tools.png" Repeat="NoRepeat" 
                        VerticalPosition="center" />
                    <Border BorderWidth="0px" />
                </dx:ASPxMenu>
            </div>
            <div style="float: right">
                <dx:ASPxMenu ID="SearchTableExportMenu" runat="server" ClientInstanceName="SearchTableExportMenu"
                    ClientVisible="False" BackColor="Transparent" RenderMode="Lightweight">
                    <ClientSideEvents ItemClick="function(s, e) {
	                    switch (e.item.name) {
                           case 'ExportToPDF':
                               ExportPDFBtn.DoClick(); 
                              break
                           case 'ExportToXLS':
                               ExportXLSBtn.DoClick(); 
                              break
                           case 'ExportToXLSX':
                               ExportXLSXBtn.DoClick(); 
                              break
                           case 'ExportToRTF':
                               ExportRTFBtn.DoClick(); 
                              break
                           case 'ExportToCSV':
                               ExportCSVBtn.DoClick(); 
                              break
                            }
                         }" />
                    <Paddings PaddingLeft="25px" />
                    <Items>
                        <dx:MenuItem Text="Экспорт">
                            <Items>
                                        <dx:MenuItem Name="ExportToPDF" Text="Экспорт в PDF">
                                        </dx:MenuItem>
                                        <dx:MenuItem Name="ExportToXLS" Text="Экспорт в XLS">
                                        </dx:MenuItem>
                                        <dx:MenuItem Name="ExportToXLSX" Text="Экспорт в XLSX">
                                        </dx:MenuItem>
                                        <dx:MenuItem Name="ExportToRTF" Text="Экспорт в RTF">
                                        </dx:MenuItem>
                                        <dx:MenuItem Name="ExportToCSV" Text="Экспорт в CSV">
                                        </dx:MenuItem>
                            </Items>
                        </dx:MenuItem>
                    </Items>
                    <ItemStyle BackColor="Transparent">
                    <hoverstyle backcolor="Transparent" font-underline="True">
                        <Border BorderWidth="0px" />
                    </hoverstyle>
                    <Border BorderWidth="0px" />
                    </ItemStyle>
                    <BackgroundImage HorizontalPosition="left" 
                        ImageUrl="~/Content/Images/Icons/export.png" Repeat="NoRepeat" 
                        VerticalPosition="center" />
                    <Border BorderWidth="0px" />
                </dx:ASPxMenu>
            </div>            
            <div style="float: right">
                <dx:ASPxMenu ID="SearchTableFilterMenu" runat="server" ClientInstanceName="SearchTableFilterMenu"
                    ClientVisible="False" BackColor="Transparent" RenderMode="Lightweight" >
                    <ClientSideEvents ItemClick="function(s, e) {
	                    switch (e.item.name) {
                           case 'ShowFiterRow':
                               gridSearchView.PerformCallback('ShowFilterRow'); 
                              break
                           case 'ShowExtFilter':
                               gridSearchView.ShowFilterControl(); 
                              break
                            }
                         }" />
                    <Paddings PaddingLeft="25px" />
                    <Items>
                        <dx:MenuItem Text="Фильтр">
                            <Items>
                                        <dx:MenuItem Name="ShowFiterRow" Text="Показать фильтр" Checked="True">
                                        </dx:MenuItem>
                                        <dx:MenuItem Name="ShowExtFilter" Text="Расширенный фильтр">
                                        </dx:MenuItem>
                            </Items>
                        </dx:MenuItem>
                    </Items>
                    <ItemStyle BackColor="Transparent">
                    <hoverstyle backcolor="Transparent" font-underline="True">
                        <Border BorderWidth="0px" />
                    </hoverstyle>
                    <Border BorderWidth="0px" />
                    </ItemStyle>
                    <BackgroundImage HorizontalPosition="left" 
                        ImageUrl="~/Content/Images/Icons/filter.png" Repeat="NoRepeat" 
                        VerticalPosition="center" />
                    <Border BorderWidth="0px" />
                </dx:ASPxMenu>
            </div>            
            <div style="clear:both">
                    <dx:ASPxGridView ID="gridSearchView" runat="server" AutoGenerateColumns="False" Width="100%"
                        KeyFieldName="Id" DataSourceID="LinqServerModeDataSource1" ClientInstanceName="gridSearchView"
                        OnCustomCallback="gridSearchView_CustomCallback" ClientVisible="False" EnableCallBacks="False"
                        OnCustomColumnDisplayText="gridSearchView_CustomColumnDisplayText" EnableTheming="True"
                        Theme="Default" oncustomjsproperties="gridSearchView_CustomJSProperties">
                        <ClientSideEvents SelectionChanged="function(s, e) {
                        if (e.isSelected) {
                            var ResearchId = gridSearchView.cprschId[e.visibleIndex - gridSearchView.visibleStartIndex];
                            if (ResearchId != null && ResearchId > 0) {
                                OpenReportMenu.GetItem(0).SetEnabled(true);
                                OpenReportMenu.GetItem(0).SetNavigateUrl('/Pages/Research/ReportList.aspx?researchId=' + ResearchId);
                            }
                            else { OpenReportMenu.GetItem(0).SetEnabled(false); }
                        }
                        else { OpenReportMenu.GetItem(0).SetEnabled(false); }
}" />
                        <GroupSummary>
                            <dx:ASPxSummaryItem DisplayFormat="Количество событий: {0}" FieldName="Id" SummaryType="Count" />
                        </GroupSummary>
                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0" Visible="False" ShowInCustomizationForm="False">
                                <ClearFilterButton Visible="True">
                                </ClearFilterButton>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" ReadOnly="True" Caption="№"
                                UnboundType="Integer">
                                <PropertiesTextEdit>
                                    <MaskSettings IncludeLiterals="DecimalSymbol" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Модуль" FieldName="ModuleId" 
                                VisibleIndex="3">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Событие" FieldName="EventCode" 
                                VisibleIndex="6">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="who" VisibleIndex="7" Caption="Цель">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="dest" VisibleIndex="8" Caption="Объект">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="11" 
                                ShowInCustomizationForm="False" Visible="False">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="rschId" VisibleIndex="12" 
                                Caption="Исследование" GroupIndex="0" SortIndex="0" SortOrder="Ascending">
                                <%--                                <GroupRowTemplate>
                                    <dx:ASPxLabel ID="ReportLabel" runat="server" Text='<%# GetLabelText(Container)%>'>
                                    </dx:ASPxLabel>
                                    <dx:ASPxHyperLink ID="ReportLink" runat="server" NavigateUrl="/Pages/Research/ReportList.aspx?researchId="
                                        Target="_self" Text="Подробный отчет" OnInit="ReportLink_Init">
                                    </dx:ASPxHyperLink>
                                    <%# "Исследование: "+Container.GroupText+Container.SummaryText + " <a href='/Pages/Research/ReportList.aspx?researchId="+Container.KeyValue+"'>Подробный отчет</a>"%>
                                </GroupRowTemplate>--%>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="pid1" VisibleIndex="4" 
                                UnboundType="Integer">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="pid2" VisibleIndex="5" 
                                UnboundType="Integer">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="adddata1" VisibleIndex="9" 
                                Caption="Данные">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="adddata2" VisibleIndex="10" 
                                Caption="Дополнительные">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="timeofevent" VisibleIndex="2" Caption="Время события"
                                UnboundType="DateTime">
                                <PropertiesDateEdit EditFormat="DateTime" DisplayFormatString="dd.MM.yy hh:mm:ss.fff">
                                </PropertiesDateEdit>
                                <Settings AllowAutoFilterTextInputTimer="True" GroupInterval="Date" />
                            </dx:GridViewDataDateColumn>
                        </Columns>
                        <SettingsBehavior AllowFocusedRow="True" AutoExpandAllGroups="True" EnableCustomizationWindow="True"
                            EnableRowHotTrack="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True"
                            ColumnResizeMode="Control" />
                        <SettingsPager PageSize="50" Position="TopAndBottom">
                            <PageSizeItemSettings AllItemText="Все" Caption="Количество строк на странице:" ShowAllItem="True"
                                Visible="True">
                            </PageSizeItemSettings>
                        </SettingsPager>
                        <Settings ShowFilterRow="True" ShowFilterRowMenu="True" ShowGroupPanel="True" ShowFilterBar="Auto" />
                        <SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
                    </dx:ASPxGridView>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="gridSearchView"
                FileName="SearchReport" Landscape="True" PaperKind="A4" ReportHeader="{\rtf1\ansi\ansicpg1251\deff0\deflang1049{\fonttbl{\f0\fnil\fcharset204{\*\fname Times New Roman;}Times New Roman CYR;}}
\viewkind4\uc1\pard\qc\b\f0\fs28\'c8\'cd\'d4\'ce\'d0\'cc\'c0\'d6\'c8\'ce\'cd\'cd\'ce-\'c0\'cd\'c0\'cb\'c8\'d2\'c8\'d7\'c5\'d1\'ca\'c0\'df \'d1\'c8\'d1\'d2\'c5\'cc\'c0\par
&quot;\'cc\'ce\'cd\'c8\'d2\'ce\'d0\'c8\'cd\'c3 \'c2\'cf\'ce&quot;\b0\fs20\par
\pard\par
\pard\qc\ul\fs28\'ce\'d2\'d7\'c5\'d2\par
\ulnone\fs20\par
}
" MaxColumnWidth="130" PreserveGroupRowStates="True">
                <PageHeader Center="Дата: [Дата печати]" Left="Имя пользователя: [Имя пользователя]"
                    Right="Время: [Время печати]">
                </PageHeader>
                <PageFooter Center="[Страница # из # страниц]">
                </PageFooter>
            </dx:ASPxGridViewExporter>
            <dx:ASPxButton ID="ExportPDFBtn" runat="server" OnClick="ExportPDFBtn_Click" ClientInstanceName="ExportPDFBtn"
                ClientVisible="False" Text="PDF">
            </dx:ASPxButton>
            <dx:ASPxButton ID="ExportXLSBtn" runat="server" OnClick="ExportXLSBtn_Click" ClientInstanceName="ExportXLSBtn"
                ClientVisible="False" Text="XLS">
            </dx:ASPxButton>
            <dx:ASPxButton ID="ExportXLSXBtn" runat="server" OnClick="ExportXLSXBtn_Click" ClientInstanceName="ExportXLSXBtn"
                ClientVisible="False" Text="XLSX">
            </dx:ASPxButton>
            <dx:ASPxButton ID="ExportRTFBtn" runat="server" OnClick="ExportRTFBtn_Click" ClientInstanceName="ExportRTFBtn"
                ClientVisible="False" Text="RTF">
            </dx:ASPxButton>
            <dx:ASPxButton ID="ExportCSVBtn" runat="server" OnClick="ExportCSVBtn_Click" ClientInstanceName="ExportCSVBtn"
                ClientVisible="False" Text="CSV">
            </dx:ASPxButton>
        </div>
    </div>
</asp:Content>
