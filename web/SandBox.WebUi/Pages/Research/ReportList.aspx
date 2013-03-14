<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="ReportList.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.ReportList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" type="text/css" href="../../Content/PageView.css" />
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
                <SettingsPager Visible="False">
                </SettingsPager>
                <Settings GridLines="Horizontal" ShowColumnHeaders="False" ShowHeaderFilterBlankItems="False" />
                <SettingsText EmptyDataRow="Дополнительные параметры исследования не установлены" />
                <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />
                <Styles>
                    <Table BackColor="White">
                    </Table>
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
        <div style="float: left; padding-left: 30px; width: 47%; display:inline-table;">
            <div class="detailrowevents">
                <img src="../../Content/images/bluebox.png" />&nbsp;&nbsp;ВАЖНЫЕ&nbsp;&nbsp;&nbsp;&nbsp;<img
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
                                    СЕТЬ
                                </td>
                                <td height="30">
                                    ПРОЦЕССЫ
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
            <dx:WebChartControl ID="wcEventsSign" runat="server" Height="200px" LoadingPanelText="Загрузка&amp;hellip;"
                SideBySideEqualBarWidth="True" Width="600px" CrosshairEnabled="False" ToolTipEnabled="False">
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
                            <border visible="False" />
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
        <div style="clear:both" class="page_table">
            <asp:UpdatePanel ID="UpdategridPanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <dx:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" Width="100%">
                        <TabPages>
                            <dx:TabPage Text="Таблица событий">
                                <ContentCollection>
                                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                        <div class='panel-text-nomargin'>
                            <dx:ASPxHyperLink ID="ASPxHyperLink3" runat="server" Text="Диаграмма событий" NavigateUrl="~/Pages/Research/ChartOfEvents.aspx" />
                        </div>
                        <div class='panel-text-nomargin'>
                            <dx:ASPxHyperLink ID="ASPxHyperLink4" runat="server" Text="Распределение событий и классификация"
                                NavigateUrl="~/Pages/Research/EventsReport.aspx" ViewStateMode="Enabled" />
                        </div>
                                                                <hr style="width: 100%;" />
                                        <dx:ASPxLabel ID="LPagingSize" runat="server" Text="Колличество строк на одной странице в таблице">
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
                                        <dx:ASPxGridView ID="gridViewReports" runat="server" AutoGenerateColumns="False"
                                            EnableTheming="True" Theme="Default" KeyFieldName="Id" Width="100%" Style="margin-top: 0px;
                                            margin-right: 9px;" OnHtmlRowPrepared="gridViewReports_HtmlRowPrepared" EnableCallBacks="False">
                                            <Columns>
                                                <dx:GridViewCommandColumn VisibleIndex="0">
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" Visible="False" ReadOnly="True"
                                                    Name="Id">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Время события" FieldName="timeofevent" VisibleIndex="3">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="rschId" VisibleIndex="2" Visible="False">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="pid2" VisibleIndex="6">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="pid" VisibleIndex="5">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                    <Settings HeaderFilterMode="CheckedList" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ModuleId" VisibleIndex="4" Width="50px" Caption="Модуль">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                    <Settings HeaderFilterMode="CheckedList" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Действие" FieldName="EventCode" VisibleIndex="7"
                                                    Width="50px">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                    <Settings HeaderFilterMode="CheckedList" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Описание" FieldName="Description" VisibleIndex="12"
                                                    Visible="False">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Объект" FieldName="who" VisibleIndex="9" Width="100px">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorText="Неверное значение">
                                                            <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                    <Settings HeaderFilterMode="CheckedList" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Цель" FieldName="dest" VisibleIndex="8">
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
                                            </Columns>
                                            <SettingsBehavior AllowFocusedRow="True" />
                                            <SettingsPager PageSize="30">
                                            </SettingsPager>
                                            <Settings ShowFilterRow="True" ShowGroupPanel="True" ShowFilterBar="Visible" ShowFilterRowMenu="True" />
                                            <SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
                                        </dx:ASPxGridView>
                                        <br />
                                        <dx:ASPxComboBox ID="ASPxComboBox1" runat="server" LoadingPanelText="Загрузка&amp;hellip;"
                                            SelectedIndex="0" Width="200px">
                                            <Items>
                                                <dx:ListEditItem Selected="True" Text="Критически важное" Value="0" />
                                                <dx:ListEditItem Text="Важное" Value="1" />
                                            </Items>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                        <dx:ASPxButton ID="ASPxButton2" runat="server" OnClick="ASPxButton2_Click" Text="Добавить в справочник выбранное событие"
                                            Width="200px">
                                        </dx:ASPxButton>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                            <dx:TabPage Text="Файловая система">
                                <ContentCollection>
                                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                        <div class='panel-text-nomargin'>
                            <dx:ASPxHyperLink ID="linkGetFileList" runat="server" Text="Получить образ файловой системы"
                                NavigateUrl="~/Pages/Research/FileList.aspx" Visible="true">
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
                                NavigateUrl="~/Pages/Research/RegistryList.aspx" Visible="true">
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
                                NavigateUrl="~/Pages/Research/ProcessList.aspx" Visible="true">
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
                    </dx:ASPxPageControl>
                </ContentTemplate>
            </asp:UpdatePanel>
            &nbsp;</div>
    </div>
</asp:Content>
