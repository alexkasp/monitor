<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="ReportList.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.ReportList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Подробный отчет <a href="javascript: history.go(-1)">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" /></a></div>
    </div>
    <div id="content-main">
        <div class="titlegr">
            <dx:ASPxLabel ID="LHeader" runat="server" EnableDefaultAppearance="False">
            </dx:ASPxLabel>
        </div>
        <div style="float: left; width: 47%;">
            <div class="mainparams">
                Основные параметры исследования</div>
            <br />
            <table style="width: 100%;">
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="ВПО:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="Mlwr" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="ТИП ЛИР:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LIRType" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="ОС:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LOS" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Время запуска:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStartTime" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="Длительность:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStopTime" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="Статус:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStatus" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
            </table>
            <br />
            <div class="addparams">
                Дополнительные параметры исследования</div>
            <dx:ASPxGridView ID="gridAddParams" runat="server" AutoGenerateColumns="False" Width="100%">
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="ModuleX" VisibleIndex="0" Caption="Module X"
                        Width="100px">
                        <CellStyle Font-Bold="True">
                        </CellStyle>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="TypeX" VisibleIndex="2" Width="200px">
                        <EditCellStyle Font-Bold="True">
                        </EditCellStyle>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="ValueX" VisibleIndex="3">
                        <PropertiesTextEdit>
                            <ValidationSettings ErrorText="Неверное значение">
                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <PropertiesTextEdit>
                            <ValidationSettings ErrorText="Неверное значение">
                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle Font-Bold="True">
                        </CellStyle>
                    </dx:GridViewDataTextColumn>
                </Columns>
                <SettingsPager Visible="False" Mode="ShowAllRecords">
                </SettingsPager>
                <Settings GridLines="Horizontal" ShowColumnHeaders="False" ShowHeaderFilterBlankItems="False" />
                <SettingsText EmptyDataRow="Дополнительные параметры исследования не установлены" />
                <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />
                <Styles>
                    <Table BackColor="White">
                    </Table>
                    <EmptyDataRow HorizontalAlign="Left">
                    </EmptyDataRow>
                    <Cell BackColor="White">
                        <BorderLeft BorderWidth="0px" />
                        <BorderTop BorderWidth="0px" />
                        <BorderRight BorderWidth="0px" />
                        <BorderBottom BorderColor="#D8D7D7" BorderStyle="Solid" BorderWidth="1px" />
                    </Cell>
                </Styles>
                <Border BorderStyle="None" />
                <BorderBottom BorderColor="#D8D7D7" BorderStyle="Solid" BorderWidth="1px" />
            </dx:ASPxGridView>
            <%--    <div class="addparamhd">Файловая система</div>
                                        <dx:ASPxGridView ID="AddParamRegGrid"  runat="server" 
                                        AutoGenerateColumns="False" 
                                        Width="100%" 
            onbeforeperformdataselect="AddParamRegGrid_BeforePerformDataSelect">     
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="ModuleX" VisibleIndex="0" 
                                                Caption="Module X" Width="100px" Visible="False">
                                                <CellStyle Font-Bold="True" Font-Underline="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="TypeX" VisibleIndex="2" Width="200px">
                                                <EditCellStyle Font-Bold="True">
                                                </EditCellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="ValueX" VisibleIndex="3">
                                                <CellStyle Font-Bold="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsPager Visible="False">
                                        </SettingsPager>
                                        <Settings GridLines="Horizontal" ShowColumnHeaders="False" 
                                            ShowHeaderFilterBlankItems="False" />
                                        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />                                
                                        <Styles>
                                            <Table BackColor="White">
                                            </Table>
                                            <Cell BackColor="White">
                                                <BorderLeft BorderWidth="0px" />
                                                <BorderTop BorderWidth="0px" />
                                                <BorderRight BorderWidth="0px" />
                                                <BorderBottom BorderWidth="0px" />
                                            </Cell>
                                        </Styles>
                                        <Border BorderStyle="None" />
                                    </dx:ASPxGridView>
                                    <div class="addparamhr"></div>
    <div class="addparamhd">Реестр</div>
                                        <dx:ASPxGridView ID="ASPxGridView1"  runat="server" 
                                        AutoGenerateColumns="False" 
                                        Width="100%" 
            onbeforeperformdataselect="AddParamRegGrid_BeforePerformDataSelect">     
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="ModuleX" VisibleIndex="0" 
                                                Caption="Module X" Width="100px" Visible="False">
                                                <CellStyle Font-Bold="True" Font-Underline="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="TypeX" VisibleIndex="2" Width="200px">
                                                <EditCellStyle Font-Bold="True">
                                                </EditCellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="ValueX" VisibleIndex="3">
                                                <CellStyle Font-Bold="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsPager Visible="False">
                                        </SettingsPager>
                                        <Settings GridLines="Horizontal" ShowColumnHeaders="False" 
                                            ShowHeaderFilterBlankItems="False" />
                                        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />                                
                                        <Styles>
                                            <Table BackColor="White">
                                            </Table>
                                            <Cell BackColor="White">
                                                <BorderLeft BorderWidth="0px" />
                                                <BorderTop BorderWidth="0px" />
                                                <BorderRight BorderWidth="0px" />
                                                <BorderBottom BorderWidth="0px" />
                                            </Cell>
                                        </Styles>
                                        <Border BorderStyle="None" />
                                    </dx:ASPxGridView>
                                    <div class="addparamhr"></div>
    <div class="addparamhd">Процессы</div>
                                        <dx:ASPxGridView ID="ASPxGridView2"  runat="server" 
                                        AutoGenerateColumns="False" 
                                        Width="100%" 
            onbeforeperformdataselect="AddParamRegGrid_BeforePerformDataSelect">     
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="ModuleX" VisibleIndex="0" 
                                                Caption="Module X" Width="100px" Visible="False">
                                                <CellStyle Font-Bold="True" Font-Underline="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="TypeX" VisibleIndex="2" Width="200px">
                                                <EditCellStyle Font-Bold="True">
                                                </EditCellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="ValueX" VisibleIndex="3">
                                                <CellStyle Font-Bold="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsPager Visible="False">
                                        </SettingsPager>
                                        <Settings GridLines="Horizontal" ShowColumnHeaders="False" 
                                            ShowHeaderFilterBlankItems="False" />
                                        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />                                
                                        <Styles>
                                            <Table BackColor="White">
                                            </Table>
                                            <Cell BackColor="White">
                                                <BorderLeft BorderWidth="0px" />
                                                <BorderTop BorderWidth="0px" />
                                                <BorderRight BorderWidth="0px" />
                                                <BorderBottom BorderWidth="0px" />
                                            </Cell>
                                        </Styles>
                                        <Border BorderStyle="None" />
                                    </dx:ASPxGridView>
                                    <div class="addparamhr"></div>
    <div class="addparamhd">Сетевая активность</div>
                                        <dx:ASPxGridView ID="ASPxGridView3"  runat="server" 
                                        AutoGenerateColumns="False" 
                                        Width="100%" 
            onbeforeperformdataselect="AddParamRegGrid_BeforePerformDataSelect">     
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="ModuleX" VisibleIndex="0" 
                                                Caption="Module X" Width="100px" Visible="False">
                                                <CellStyle Font-Bold="True" Font-Underline="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="TypeX" VisibleIndex="2" Width="200px">
                                                <EditCellStyle Font-Bold="True">
                                                </EditCellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="ValueX" VisibleIndex="3">
                                                <CellStyle Font-Bold="True">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsPager Visible="False">
                                        </SettingsPager>
                                        <Settings GridLines="Horizontal" ShowColumnHeaders="False" 
                                            ShowHeaderFilterBlankItems="False" />
                                        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />                                
                                        <Styles>
                                            <Table BackColor="White">
                                            </Table>
                                            <Cell BackColor="White">
                                                <BorderLeft BorderWidth="0px" />
                                                <BorderTop BorderWidth="0px" />
                                                <BorderRight BorderWidth="0px" />
                                                <BorderBottom BorderWidth="0px" />
                                            </Cell>
                                        </Styles>
                                        <Border BorderStyle="None" />
                                    </dx:ASPxGridView>
                                    <div class="addparamhr"></div>
            --%>
        </div>
        <div style="float: left; padding-left: 30px; width: 47%; display: inline-table;">
            <div class="detailrowevents">
                <img alt="Важные" src="../../Content/images/bluebox.png" />&nbsp;&nbsp;ВАЖНЫЕ&nbsp;&nbsp;&nbsp;&nbsp;<img alt="Критические"
                    src="../../Content/images/redbox.png" />&nbsp;&nbsp;КРИТИЧЕСКИЕ <span id="DetailCharts"
                        runat="server">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    &nbsp;
                                </td>
                                <td width="150">
                                    &nbsp;
                                </td>
                                <td width="150">
                                    &nbsp;
                                </td>
                                <td width="150">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr align="center">
                                <td>
                                    <div class="chartHolder">
                                        <div id="chartHolder1">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="chartHolder">
                                        <div id="chartHolder2">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="chartHolder">
                                        <div id="chartHolder3">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="chartHolder">
                                        <div id="chartHolder4">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr align="center">
                                <td height="30">
                                    ФАЙЛОВАЯ СИСТЕМА
                                </td>
                                <td height="30">
                                    РЕЕСТР
                                </td>
                                <td height="30">
                                    ПРОЦЕССЫ
                                </td>
                                <td height="30">
                                    СЕТЬ
                                </td>
                            </tr>
                        </table>
                    </span>
            </div>
            <%--            <table border="0" cellspacing="0" cellpadding="10">
                <tr>
                    <td>
                        Критические
                    </td>
                    <td rowspan="3"> 
            --%>
            <div style="height: 200px; float: left;">
                <asp:UpdatePanel ID="ChartUpdatePanel" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <dx:WebChartControl ID="wcEventsSign" runat="server" Height="200px" LoadingPanelText="Загрузка данных&amp;hellip;"
                            SideBySideEqualBarWidth="True" Width="600px" CrosshairEnabled="False" ToolTipEnabled="False"
                            ClientInstanceName="wcEventsSign" EnableCallBacks="False" AlternateText="Диаграмма событий"
                            OnCustomCallback="wcEventsSign_CustomCallback">
                            <padding bottom="0" left="0" right="0" top="0" />
                            <borderoptions visible="False" />
                            <padding left="0" top="0" right="0" bottom="0"></padding>
                            <borderoptions visible="False"></borderoptions>
                            <diagramserializable>
                            <dx:XYDiagram>
                                <axisx visibleinpanesserializable="-1" title-text="Количество событий">
                                    <Range SideMarginsEnabled="True"></Range>
                                </axisx>
                                <axisy Title-Text="Важность событий" VisibleInPanesSerializable="-1" 
                                    Interlaced="True">
                                <Strips>
                                    <dx:Strip Color="255, 246, 239" ShowAxisLabel="True" Name="КРИТИЧЕСКИЕ" 
                                        ShowInLegend="False">
                                    <MinLimit AxisValueSerializable="2"></MinLimit>
                                    <MaxLimit AxisValueSerializable="3"></MaxLimit>
                                    <FillStyle FillMode="Solid"><OptionsSerializable>
<dx:SolidFillOptions></dx:SolidFillOptions>
                                    </OptionsSerializable>
                                    </FillStyle>
                                    </dx:Strip>
                                    <dx:Strip Color="239, 249, 252" ShowAxisLabel="True" Name="ВАЖНЫЕ" 
                                        ShowInLegend="False">
                                    <MinLimit AxisValueSerializable="1"></MinLimit>
                                    <MaxLimit AxisValueSerializable="2"></MaxLimit>
                                    <FillStyle FillMode="Solid"><OptionsSerializable>
<dx:SolidFillOptions></dx:SolidFillOptions>
                                    </OptionsSerializable>
                                    </FillStyle>
                                    </dx:Strip>
                                    <dx:Strip Color="254, 252, 252" ShowAxisLabel="True" Name="НЕ ВАЖНЫЕ" 
                                        ShowInLegend="False">
                                    <MinLimit AxisValueSerializable="0"></MinLimit>
                                    <MaxLimit AxisValueSerializable="1"></MaxLimit>
                                    <FillStyle FillMode="Solid"><OptionsSerializable>
<dx:SolidFillOptions></dx:SolidFillOptions>
                                    </OptionsSerializable>
                                    </FillStyle>
                                    </dx:Strip>
                                </Strips>
                                    <label font="Trebuchet MS, 12px">
                                    </label>
                                    <Range Auto="False" MinValueSerializable="0" MaxValueSerializable="3" SideMarginsEnabled="True"></Range>
                                </axisy>
                                <margins bottom="0" left="0" right="0" top="0" />

<Margins Left="0" Top="0" Right="0" Bottom="0"></Margins>

                                <defaultpane bordervisible="False">
                                </defaultpane>
                            </dx:XYDiagram>
                        </diagramserializable>
                            <fillstyle><OptionsSerializable>
<dx:SolidFillOptions></dx:SolidFillOptions>
</OptionsSerializable>
</fillstyle>
                            <seriesserializable>
                <dx:Series Name="Ряд 1" ShowInLegend="False" SynchronizePointOptions="False">
                    <viewserializable>
                        <dx:SideBySideRangeBarSeriesView Color="74, 134, 153">
                            <border visible="False" /><border visible="False" /><border visible="False" /><border visible="False" />
<Border Visible="False"></Border>

                            <fillstyle fillmode="Solid">
                                <optionsserializable>
                                    <dx:SolidFillOptions />
                                </optionsserializable>
                            </fillstyle>
                        </dx:SideBySideRangeBarSeriesView>
                    </viewserializable>
                    <labelserializable>
                        <dx:RangeBarSeriesLabel>
                            <fillstyle>
                                <optionsserializable>
                                    <dx:SolidFillOptions />
                                </optionsserializable>
                            </fillstyle>
                            <pointoptionsserializable>
                                <dx:RangeBarPointOptions>
                                </dx:RangeBarPointOptions>
                            </pointoptionsserializable>
                        </dx:RangeBarSeriesLabel>
                    </labelserializable>
                    <legendpointoptionsserializable>
                        <dx:RangeBarPointOptions>
                        </dx:RangeBarPointOptions>
                    </legendpointoptionsserializable>
                </dx:Series>
            </seriesserializable>
                            <seriestemplate>
                <viewserializable>
                    <dx:SideBySideRangeBarSeriesView>
                    </dx:SideBySideRangeBarSeriesView>
                </viewserializable>
                <labelserializable>
                    <dx:RangeBarSeriesLabel>
                        <fillstyle>
                            <optionsserializable>
                                <dx:SolidFillOptions />
                            </optionsserializable>
                        </fillstyle>
                        <pointoptionsserializable>
                            <dx:RangeBarPointOptions>
                            </dx:RangeBarPointOptions>
                        </pointoptionsserializable>
                    </dx:RangeBarSeriesLabel>
                </labelserializable>
                <legendpointoptionsserializable>
                    <dx:RangeBarPointOptions>
                    </dx:RangeBarPointOptions>
                </legendpointoptionsserializable>
            </seriestemplate>
                            <crosshairoptions showcrosshairlabels="False"><CommonLabelPositionSerializable>
<dx:CrosshairMousePosition></dx:CrosshairMousePosition>
</CommonLabelPositionSerializable>
</crosshairoptions>
                            <tooltipoptions showforpoints="False"><ToolTipPositionSerializable>
<dx:ToolTipMousePosition></dx:ToolTipMousePosition>
</ToolTipPositionSerializable>
</tooltipoptions>
                        </dx:WebChartControl>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div style="float: left; width: 500px;">
                <asp:UpdateProgress ID="ChartUpdateProgress" runat="server" AssociatedUpdatePanelID="ChartUpdatePanel">
                    <ProgressTemplate>
                        <span style="padding-left: 100px">Обновление данных:&nbsp;&nbsp;<img alt="Обновление данных..."
                            src="/content/images/progress.gif">
                      </span>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </ProgressTemplate>
                </asp:UpdateProgress>
                <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" runat="server" Width="200px">
                    <ClientSideEvents Init="function(s, e) {
	wcEventsSign.PerformCallback();
}" />
                    <PanelCollection>
                        <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
            <%--
                    </td>
                </tr>
                <tr>
                    <td>
                        Важные
                    </td>
                </tr>
                <tr>
                    <td>
                        Не важные
                    </td>
                </tr>
            </table>
            --%>
        </div>
        <div style="clear: both" class="page_table">
            <dx:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" Width="100%"
                TabSpacing="5px">
                <TabPages>
                    <dx:TabPage Text="Таблица событий">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                                <asp:UpdatePanel ID="UpdategridPanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <%--                                        <dx:ASPxLabel ID="LPagingSize" runat="server" Text="Колличество строк на одной странице в таблице">
                                        </dx:ASPxLabel>
                                        <dx:ASPxComboBox ID="CBPagingSize" runat="server" ValueType="System.Int32" Height="21px"
                                            LoadingPanelText="Загрузка&amp;hellip;" SelectedIndex="2" Width="350px" AutoPostBack="True"
                                            OnSelectedIndexChanged="CBPagingSize_SelectedIndexChanged">
                                            <Items>
                                                <dx:ListEditItem Text="10" Value="10" />
                                                <dx:ListEditItem Text="20" Value="20" />
                                                <dx:ListEditItem Selected="True" Text="30" Value="30" />
                                                <dx:ListEditItem Text="40" Value="40" />
                                                <dx:ListEditItem Text="50" Value="50" />
                                                <dx:ListEditItem Text="60" Value="60" />
                                                <dx:ListEditItem Text="70" Value="70" />
                                                <dx:ListEditItem Text="80" Value="80" />
                                                <dx:ListEditItem Text="90" Value="90" />
                                                <dx:ListEditItem Text="100" Value="100" />
                                            </Items>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                        --%>
                                        <div style="float: left">
                                            <dx:ASPxMenu ID="TableFilterMenu" runat="server" ClientInstanceName="TableFilterMenu"
                                                BackColor="Transparent" RenderMode="Lightweight">
                                                <ClientSideEvents ItemClick="function(s, e) {
	                    switch (e.item.name) {
                           case 'ShowFiterRow':
                               gridViewReports.PerformCallback('ShowFilterRow'); 
                              break
                           case 'ShowExtFilter':
                               gridViewReports.ShowFilterControl(); 
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
                                                    <HoverStyle BackColor="Transparent" Font-Underline="True">
                                                        <Border BorderWidth="0px" />
                                                    </HoverStyle>
                                                    <Border BorderWidth="0px" />
                                                </ItemStyle>
                                                <BackgroundImage HorizontalPosition="left" ImageUrl="~/Content/Images/Icons/filter.png"
                                                    Repeat="NoRepeat" VerticalPosition="center" />
                                                <Border BorderWidth="0px" />
                                            </dx:ASPxMenu>
                                        </div>
                                        <div style="float: left">
                                            <dx:ASPxMenu ID="TableExportMenu" runat="server" ClientInstanceName="TableExportMenu"
                                                BackColor="Transparent" RenderMode="Lightweight">
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
                                                    <HoverStyle BackColor="Transparent" Font-Underline="True">
                                                        <Border BorderWidth="0px" />
                                                    </HoverStyle>
                                                    <Border BorderWidth="0px" />
                                                </ItemStyle>
                                                <BackgroundImage HorizontalPosition="left" ImageUrl="~/Content/Images/Icons/export.png"
                                                    Repeat="NoRepeat" VerticalPosition="center" />
                                                <Border BorderWidth="0px" />
                                            </dx:ASPxMenu>
                                        </div>
                                        <div style="float: left">
                                            <dx:ASPxMenu ID="TableMenu" runat="server" ClientInstanceName="TableMenu" BackColor="Transparent"
                                                RenderMode="Lightweight">
                                                <ClientSideEvents ItemClick="function(s, e) {
	                    switch (e.item.name) {
                           case 'ExpandAll':
                              gridViewReports.ExpandAll();
                              break
                           case 'CollapseAll':
                              gridViewReports.CollapseAll();
                              break
                           case 'CustomColumns':
                              if(gridViewReports.IsCustomizationWindowVisible())
                               gridViewReports.HideCustomizationWindow();
                              else
                               gridViewReports.ShowCustomizationWindow();  
                              break
                           case 'SaveGridProps':
                               gridViewReports.PerformCallback('SaveLayout'); 
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
                                                    <HoverStyle BackColor="Transparent" Font-Underline="True">
                                                        <Border BorderWidth="0px" />
                                                    </HoverStyle>
                                                    <Border BorderWidth="0px" />
                                                </ItemStyle>
                                                <BackgroundImage HorizontalPosition="left" ImageUrl="~/Content/Images/Icons/tools.png"
                                                    Repeat="NoRepeat" VerticalPosition="center" />
                                                <Border BorderWidth="0px" />
                                            </dx:ASPxMenu>
                                        </div>
                                        <div style="float: right">
                                            <asp:UpdateProgress ID="ReportGridUpdateProgress" runat="server" AssociatedUpdatePanelID="UpdategridPanel">
                                                <ProgressTemplate>
                                                    <img alt="Обновление данных..." src="/content/images/progress.gif">
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </div>
                                        <div style="clear: both">
                                            <dx:ASPxGridView ID="gridViewReports" runat="server" AutoGenerateColumns="False"
                                                EnableTheming="True" Theme="Default" KeyFieldName="Id" Width="100%" Style="margin-top: 0px;
                                                margin-right: 9px;" OnHtmlRowPrepared="gridViewReports_HtmlRowPrepared" EnableCallBacks="False"
                                                ClientInstanceName="gridViewReports" OnCustomCallback="gridViewReports_CustomCallback">
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" Visible="False" Name="Id"
                                                        Caption="№ события">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataDateColumn Caption="Время события" FieldName="timeofevent" VisibleIndex="3">
                                                        <PropertiesDateEdit DisplayFormatString="dd.MM.yy hh:mm:ss.fff" EditFormat="DateTime">
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesDateEdit>
                                                        <Settings AllowAutoFilterTextInputTimer="True" GroupInterval="Date" />
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="pid2" VisibleIndex="6" Caption="PID2">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="pid" VisibleIndex="5" Caption="PID">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                        <Settings HeaderFilterMode="CheckedList" />
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataComboBoxColumn Caption="Модуль" FieldName="ModuleId"
                                                        VisibleIndex="4">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="Процессы" Value="Процессы" />
                                                                <dx:ListEditItem Text="Реестр" Value="Реестр" />
                                                                <dx:ListEditItem Text="Сеть" Value="Сеть" />
                                                                <dx:ListEditItem Text="Файловая система" Value="Файловая система" />
                                                            </Items>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesComboBox>
                                                        <Settings HeaderFilterMode="CheckedList" />
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn Caption="Событие" FieldName="EventCode"
                                                        VisibleIndex="7">
                                                        <PropertiesComboBox DataSourceID="dsEventsDesc" DropDownStyle="DropDown" IncrementalFilteringMode="StartsWith"
                                                            TextField="EventsEventDescription" ValueField="EventID" ValueType="System.Int32">
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesComboBox>
                                                        <Settings HeaderFilterMode="CheckedList" />
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataTextColumn Caption="Объект" FieldName="who" VisibleIndex="8" 
                                                        Width="100px">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                        <Settings HeaderFilterMode="CheckedList" />
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Цель" FieldName="dest" VisibleIndex="9">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                        <Settings HeaderFilterMode="CheckedList" />
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Дополнительно" FieldName="adddata2" VisibleIndex="11">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Данные" FieldName="adddata1" VisibleIndex="10">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Статус" FieldName="status" VisibleIndex="13">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings ErrorText="Неверное значение">
                                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Важность" FieldName="significance" VisibleIndex="14"
                                                        Name="signcol" ShowInCustomizationForm="False" Visible="False">
                                                        <Settings ShowInFilterControl="False" />
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataComboBoxColumn Caption="Важность" FieldName="signdesc"
                                                        VisibleIndex="15">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="Не важное" Value="Не важное" />
                                                                <dx:ListEditItem Text="Важное" Value="Важное" />
                                                                <dx:ListEditItem Text="Критическое" Value="Критическое" />
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                </Columns>
                                                <SettingsBehavior AllowFocusedRow="True" AutoExpandAllGroups="True" EnableCustomizationWindow="True"
                                                    EnableRowHotTrack="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True"
                                                    ColumnResizeMode="Control" />
                                                <SettingsPager PageSize="50" Position="TopAndBottom" NumericButtonCount="20">
                                                    <PageSizeItemSettings AllItemText="Все" Caption="Количество строк на странице:" ShowAllItem="True"
                                                        Visible="True">
                                                    </PageSizeItemSettings>
                                                </SettingsPager>
                                                <Settings ShowFilterRow="True" ShowGroupPanel="True" ShowFilterBar="Visible" ShowFilterRowMenu="True" />
                                                <SettingsText CustomizationWindowCaption="Скрытые колонки" />
                                                <SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
                                            </dx:ASPxGridView>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <br />
                                <dx:ASPxComboBox ID="ASPxComboBox1" runat="server" LoadingPanelText="Загрузка&amp;hellip;"
                                    SelectedIndex="0" Width="200px">
                                    <Items>
                                        <dx:ListEditItem Text="Важное" Value="1" />
                                        <dx:ListEditItem Selected="True" Text="Критическое" Value="2" />
                                    </Items>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                                <dx:ASPxButton ID="ASPxButton2" runat="server" OnClick="ASPxButton2_Click" Text="Добавить в справочник выбранное событие"
                                    Width="200px">
                                </dx:ASPxButton>
                                <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="gridViewReports"
                                    FileName="Report" Landscape="True" PaperKind="A4" ReportHeader="{\rtf1\ansi\ansicpg1251\deff0\deflang1049{\fonttbl{\f0\fnil\fcharset204{\*\fname Times New Roman;}Times New Roman CYR;}}
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
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="Файловая система">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                                <div class='panel-text-nomargin'>
                                    <dx:ASPxHyperLink ID="linkGetFileList" runat="server" Text="Получить образ файловой системы"
                                        NavigateUrl="~/Pages/Research/FilesTree.aspx" Visible="true">
                                    </dx:ASPxHyperLink>
                                </div>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="Реестр">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                                <div class='panel-text-nomargin'>
                                    <dx:ASPxHyperLink ID="linkGetRegistryList" runat="server" Text="Получить образ реестра"
                                        NavigateUrl="~/Pages/Research/RegsTree.aspx" Visible="true">
                                    </dx:ASPxHyperLink>
                                </div>
                                <dx:ASPxHyperLink ID="ASPxHyperLink5" runat="server" NavigateUrl="~/Pages/Research/Comparer.aspx"
                                    Text="Сравнить ветки реестра" />
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="Процессы">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                                <div class='panel-text-nomargin'>
                                    <dx:ASPxHyperLink ID="linkGetProcessList" runat="server" Text="Получить список процессов"
                                        NavigateUrl="~/Pages/Research/ProcTree.aspx" Visible="true">
                                    </dx:ASPxHyperLink>
                                </div>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="Сетевая активность">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                                <div class='panel-text-nomargin'>
                                    <dx:ASPxHyperLink ID="linkGetTraffic" runat="server" Text="Получить перехват сетевого траффика"
                                        NavigateUrl="javascript:;" Visible="False" Enabled="False">
                                    </dx:ASPxHyperLink>
                                    <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Запросить перехват сетевого трафика"
                                        OnClick="BtnGetClick" Width="276px">
                                    </dx:ASPxButton>
                                    <dx:ASPxHyperLink ID="HLPorts" runat="server" NavigateUrl="~/Pages/Research/PortsList.aspx"
                                        Text="Получить список портов" />
                                </div>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                </TabPages>
                <ActiveTabStyle ForeColor="#474747">
                    <BackgroundImage ImageUrl="none" />
                </ActiveTabStyle>
                <TabStyle Font-Bold="False" Font-Names="Trebuchet MS,Arial" Font-Size="13pt" Font-Strikeout="False"
                    ForeColor="White" Height="27px" HorizontalAlign="Center" VerticalAlign="Middle"
                    Width="200px">
                    <BackgroundImage ImageUrl="~/Content/Images/bgtab.png" Repeat="RepeatX" />
                </TabStyle>
            </dx:ASPxPageControl>
            &nbsp;</div>
    </div>
    <asp:LinqDataSource ID="dsEventsDesc" runat="server" ContextTypeName="SandBox.Db.SandBoxDataContext"
        EntityTypeName="" TableName="EventsEventDescriptions">
    </asp:LinqDataSource>
</asp:Content>
