<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="Comparer.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.Comparer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    var postbackElement;
    Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequest);
    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(EndRequestHandler);

    function beginRequest(sender, args) {
        postbackElement = args.get_postBackElement();
    }
    
    function EndRequestHandler(sender, args) {
        if (typeof (postbackElement) === "undefined") {
            return;
        }
        if (postbackElement.id.toLowerCase().indexOf('wceventssign1') > -1) {
            $get('<%=ChartUpdateProgress2.ClientID%>').style.display = "block";
            wcEventsSign2.PerformCallback();
        }
    }
</script>
    <div id="content-top">
        <div id="pagename">
            Сравнение исследований
            <a href="javascript: history.go(-1)">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
<%--    <dx:ASPxLabel ID="LHeader" runat="server" Theme="iOS">
    </dx:ASPxLabel>
    <asp:TreeView ID="TreeView1" runat="server" style="margin-left: 36px" 
        ImageSet="Simple">
        <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />
        <NodeStyle Font-Names="Tahoma" Font-Size="10pt" ForeColor="Black" 
            HorizontalPadding="0px" NodeSpacing="0px" VerticalPadding="0px" />
        <ParentNodeStyle Font-Bold="False" />
        <SelectedNodeStyle Font-Underline="True" ForeColor="#5555DD" 
            HorizontalPadding="0px" VerticalPadding="0px" />
    </asp:TreeView>
    <br />
    <dx:ASPxComboBox ID="ASPxComboBox1" runat="server" ValueType="System.String">
    </dx:ASPxComboBox>
    <dx:ASPxButton ID="ASPxButton1" runat="server" onclick="ASPxButton1_Click" 
        Text="Сравнить">
    </dx:ASPxButton>
    <br />
    <dx:ASPxTreeList ID="ASPxTreeList1" runat="server" 
        EnableTheming="True" Theme="Default" Width="600px" 
        onhtmldatacellprepared="ASPxTreeList1_HtmlDataCellPrepared">
        <Settings GridLines="Both" />
<SettingsCustomizationWindow Caption="Выбор колонок"></SettingsCustomizationWindow>

<SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>

<SettingsPopupEditForm Caption="Форма редактирования"></SettingsPopupEditForm>

<SettingsText ConfirmDelete="Подверждаете удаление?" CommandEdit="Изменить" CommandNew="Создать" CommandDelete="Удалить" CommandUpdate="Сохранить" CommandCancel="Отмена" RecursiveDeleteError="Узел имеет дочерние узлы." CustomizationWindowCaption="Выбор колонок" LoadingPanelText="Загрузка&amp;hellip;"></SettingsText>
    </dx:ASPxTreeList>
--%>
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
                        <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="ВПО:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="Mlwr" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel8" runat="server" Text="ТИП ЛИР:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LIRType" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel9" runat="server" Text="ОС:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LOS" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel10" runat="server" Text="Время запуска:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStartTime" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel11" runat="server" Text="Длительность:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStopTime" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel12" runat="server" Text="Статус:">
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
        </div>
        <div style="float: left; padding-left: 30px; width: 47%; display:inline-table;">
            <div class="detailrowevents">
                <img src="../../Content/images/bluebox.png" />&nbsp;&nbsp;ВАЖНЫЕ&nbsp;&nbsp;&nbsp;&nbsp;<img
                    src="../../Content/images/redbox.png" />&nbsp;&nbsp;КРИТИЧЕСКИЕ <span id="Span1"
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
<div style="float: left;">
<table>
<tr><td>
<asp:UpdatePanel ID="ChartUpdatePanel" runat="server" UpdateMode="Conditional" >
                <ContentTemplate>
            <dx:WebChartControl ID="wcEventsSign1" runat="server" Height="200px" LoadingPanelText="Загрузка данных&amp;hellip;"
                SideBySideEqualBarWidth="True" Width="600px" CrosshairEnabled="False" 
                ToolTipEnabled="False" ClientInstanceName="wcEventsSign1" EnableCallBacks="False" 
                        AlternateText="Диаграмма событий" 
                        oncustomcallback="wcEventsSign_CustomCallback">
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
                <dx:Series Name="События" ShowInLegend="False" SynchronizePointOptions="False">
                    <viewserializable>
                        <dx:SideBySideRangeBarSeriesView Color="74, 134, 153">
                            <border visible="False" /><border visible="False" />
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
            </td></tr>
            <tr><td>
                            <div  style="width:500px;">
                            <asp:UpdateProgress ID="SearchGridUpdateProgress" runat="server" AssociatedUpdatePanelID="ChartUpdatePanel">
                    <ProgressTemplate>
                        <span style="padding-left:100px">Обновление данных:&nbsp;&nbsp;<img alt="Обновление данных..." src="/content/images/progress.gif"> </span>
                                        </ProgressTemplate>
                </asp:UpdateProgress></div>
                </td></tr></table>
<%--            <dx:ASPxCallbackPanel ID="ASPxCallbackPanel" runat="server" Width="200px">
                <ClientSideEvents Init="function(s, e) {
	wcEventsSign.PerformCallback();
}" />
                <PanelCollection>
<dx:PanelContent ID="PanelContent" runat="server" SupportsDisabledAttribute="True"></dx:PanelContent>
</PanelCollection>
            </dx:ASPxCallbackPanel>
--%>            </div>
        </div>
<div style="clear:both"></div>
        <div class="titlegr">
            <dx:ASPxLabel ID="LHeader2" runat="server" EnableDefaultAppearance="False">
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
                        <dx:ASPxLabel ID="Mlwr2" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="ТИП ЛИР:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LIRType2" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="ОС:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LOS2" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Время запуска:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStartTime2" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="Длительность:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStopTime2" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="Статус:">
                        </dx:ASPxLabel>
                    </td>
                    <td>
                        <dx:ASPxLabel ID="LStatus2" runat="server">
                        </dx:ASPxLabel>
                    </td>
                </tr>
            </table>
            <br />
            <div class="addparams">
                Дополнительные параметры исследования</div>
            <dx:ASPxGridView ID="gridAddParams2" runat="server" AutoGenerateColumns="False" Width="100%">
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
                                        <div id="chartHolder5">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="chartHolder">
                                        <div id="chartHolder6">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="chartHolder">
                                        <div id="chartHolder7">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="chartHolder">
                                        <div id="chartHolder8">
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
<div style="float: left;">
<table><tr><td>
<asp:UpdatePanel ID="ChartUpdatePanel2" runat="server" UpdateMode="Conditional" >
                <ContentTemplate>
            <dx:WebChartControl ID="wcEventsSign2" runat="server" Height="200px" LoadingPanelText="Загрузка данных&amp;hellip;"
                SideBySideEqualBarWidth="True" Width="600px" CrosshairEnabled="False" 
                ToolTipEnabled="False" ClientInstanceName="wcEventsSign2" EnableCallBacks="False" 
                        AlternateText="Диаграмма событий" 
                        oncustomcallback="wcEventsSign_CustomCallback2">
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
                <dx:Series Name="События" ShowInLegend="False" SynchronizePointOptions="False">
                    <viewserializable>
                        <dx:SideBySideRangeBarSeriesView Color="74, 134, 153">
                            <border visible="False" /><border visible="False" />
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
</td></tr><tr><td>
                            <div  style="width:500px;">
                            <asp:UpdateProgress ID="ChartUpdateProgress2" runat="server" AssociatedUpdatePanelID="ChartUpdatePanel2">
                    <ProgressTemplate>
                        <span style="padding-left:100px">Обновление данных:&nbsp;&nbsp;<img alt="Обновление данных..." src="/content/images/progress.gif"> </span>
                                        </ProgressTemplate>
                </asp:UpdateProgress>
                </div>
            <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" runat="server" Width="200px">
                <ClientSideEvents Init="function(s, e) {
    wcEventsSign1.PerformCallback();
}" />
                <PanelCollection>
<dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True"></dx:PanelContent>
</PanelCollection>
            </dx:ASPxCallbackPanel>
            </td></tr></table>
            </div>
        </div>
    </div>
</asp:Content>
