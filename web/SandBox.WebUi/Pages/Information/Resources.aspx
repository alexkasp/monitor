<%@ Page Title="Ресурсы" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="Resources.aspx.cs" Inherits="SandBox.WebUi.Pages.Information.Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Ресурсы</div>
        <div id="toolbuttons">
            <table>
                <tr>
                    <td width="170px">
                        <dx:ASPxButton ID="btnAddVLIR" AutoPostBack="False" runat="server" Text="Создать ВЛИР"
                            CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="150px">
                            <PressedStyle CssClass="buttonHover">
                            </PressedStyle>
                            <HoverStyle CssClass="buttonHover">
                            </HoverStyle>
                            <DisabledStyle CssClass="buttonDisable">
                            </DisabledStyle>
                            <ClientSideEvents Click="function(s, e) {
		document.location.href = '/Pages/Information/CreateVLir.aspx';
}" />
                        </dx:ASPxButton>
                    </td>
                    <td width="170px">
                        <dx:ASPxButton ID="btnAddHardware" AutoPostBack="False" runat="server" Text="Добавить ЛИР"
                            CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="150px">
                            <Border BorderColor="Gainsboro" BorderStyle="Solid" BorderWidth="1px" />
                            <PressedStyle CssClass="buttonHover">
                            </PressedStyle>
                            <HoverStyle CssClass="buttonHover">
                            </HoverStyle>
                            <DisabledStyle CssClass="buttonDisable">
                            </DisabledStyle>
                            <ClientSideEvents Click="function(s, e) {
	document.location.href = '/Pages/Information/AddLir.aspx';
}" />
                        </dx:ASPxButton>
                    </td>
                    <td>
                        <dx:ASPxButton ID="btnAddLIR" AutoPostBack="False" runat="server" Text="Добавить эталон ВЛИР"
                            CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="225px">
                            <Border BorderColor="Gainsboro" BorderStyle="Solid" BorderWidth="1px" />
                            <PressedStyle CssClass="buttonHover">
                            </PressedStyle>
                            <HoverStyle CssClass="buttonHover">
                            </HoverStyle>
                            <DisabledStyle CssClass="buttonDisable">
                            </DisabledStyle>
                            <ClientSideEvents Click="function(s, e) {
	document.location.href = '/Pages/Information/CreateEtalonVLir.aspx';
}" />
                        </dx:ASPxButton>
                    </td>
                </tr>
            </table>
        </div>
        <div id="tablenavbuttons">
            <asp:UpdatePanel ID="UpdatePagerPanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <dx:ASPxPager ID="gridResourceViewPager" runat="server" ItemCount="1000" ItemsPerPage="100"
                        OnPageIndexChanged="gridResourceViewPager_PageIndexChanged" Visible="False" OnPageSizeChanged="gridResourceViewPager_PageSizeChanged"
                        ShowNumericButtons="False" RenderMode="Lightweight" Theme="SandboxTheme">
                        <Summary AllPagesText="{2} эл." Text="{0} из {1} ({2} эл.)" />
                        <PageSizeItemSettings AllItemText="Все" Caption="" Visible="True">
                        </PageSizeItemSettings>
                    </dx:ASPxPager>
                </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="gridViewMachines" EventName="DataBinding" />
            </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="content-main">
        <div class="page_table">
            <dx:ASPxLabel ID="labelNoItems" runat="server" Text="">
            </dx:ASPxLabel>
        </div>
        <asp:UpdatePanel ID="UpdateMachinesPanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div style="float: left">
                    <dx:ASPxCheckBox ID="cbShowEtalon" runat="server" Text="Показать эталонные" 
                        AutoPostBack="True" oncheckedchanged="cbShowEtalon_CheckedChanged">
                    </dx:ASPxCheckBox>
                </div>
                <div style="float: left; padding-left: 10px;">
                    <dx:ASPxCheckBox ID="cbShowTemp" runat="server" Text="Показать временные" 
                        AutoPostBack="True" oncheckedchanged="cbShowTemp_CheckedChanged">
                    </dx:ASPxCheckBox>
                </div>
                <div style="clear: both; padding-top: 10px;">
                    <asp:Timer ID="Timer2" runat="server" Interval="5000" OnTick="Timer2_Tick">
                    </asp:Timer>
                    <dx:ASPxGridView ID="gridViewMachines" runat="server" AutoGenerateColumns="False"
                        EnableTheming="True" Theme="SandboxTheme" Width="100%" OnHtmlRowPrepared="GridViewMachinesHtmlRowPrepared"
                        KeyFieldName="Id"
                        EnableCallBacks="False" OnCustomCallback="gridViewMachines_CustomCallback" ClientInstanceName="gridViewMachines"
                        OnCustomButtonInitialize="gridViewMachines_CustomButtonInitialize">
                        <ClientSideEvents CustomButtonClick="function(s, e) {
 if (e.buttonID == 'btnDelete') {
 if (!confirm(&quot;Вы уверены, что хотите удалить ресурс?&quot;)) { return;}}
 gridViewMachines.PerformCallback(e.buttonID+','+ s.GetRowKey(e.visibleIndex));
}" />
                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0" ButtonType="Image" Width="50px" Caption="Статус">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="btnStatus" Image-Url="../../Content/Images/Icons/run.png"
                                        Image-ToolTip="Запустить" Image-AlternateText="Запустить">
                                        <Image AlternateText="Запустить" ToolTip="Запустить" Url="../../Content/Images/Icons/run.png">
                                        </Image>
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                                <CellStyle HorizontalAlign="Center">
                                </CellStyle>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn Caption="№" FieldName="Id" VisibleIndex="0" Visible="False">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Имя" FieldName="Name" VisibleIndex="1" Width="100px">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Тип" FieldName="Type" VisibleIndex="2" Width="50px">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Система" FieldName="System" VisibleIndex="3"
                                Width="150px">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Исследование" FieldName="SessionName" Name="SessionName"
                                VisibleIndex="4">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <DataItemTemplate>
                                    <dx:ASPxHyperLink ID="HLSession" runat="server" NavigateUrl="~/Pages/Research/ReportList.aspx" />
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Состояние" FieldName="State" VisibleIndex="5"
                                Width="200px" Visible="False">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="ВПО" FieldName="MlwrName" VisibleIndex="6" Name="MlwrName">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <DataItemTemplate>
                                    <dx:ASPxHyperLink ID="HLMlwr" runat="server" NavigateUrl="~/Pages/Malware/MalwareCard.aspx" />
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Тип среды" FieldName="EnvType" VisibleIndex="7"
                                Width="50px" Visible="False">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Состояние среды" FieldName="EnvState" VisibleIndex="8"
                                Width="100px">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Ip-адрес" FieldName="EnvIp" VisibleIndex="9"
                                Width="100px">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn Caption="Mac-адрес" FieldName="EnvMac" VisibleIndex="10"
                                Width="120px">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorText="Неверное значение">
                                        <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewCommandColumn VisibleIndex="11" ButtonType="Image" Width="50px" Caption="Удалить">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="btnDelete">
                                        <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png" />
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                                <CellStyle HorizontalAlign="Center">
                                </CellStyle>
                            </dx:GridViewCommandColumn>
                        </Columns>
                        <SettingsBehavior ColumnResizeMode="NextColumn" EnableRowHotTrack="True" />
                        <SettingsPager Visible="False">
                            <PageSizeItemSettings Items="10, 20, 50, 100" ShowAllItem="True">
                            </PageSizeItemSettings>
                        </SettingsPager>
                        <SettingsText EmptyDataRow="У Вас нет ресурсов, доступных для использования" />
                        <SettingsLoadingPanel Mode="Disabled" />
                        <SettingsCookies Enabled="True" StorePaging="False" />
                        <Styles>
                            <Header Font-Bold="True">
                            </Header>
                        </Styles>
                    </dx:ASPxGridView>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="gridViewMachines" EventName="DataBinding" />
            </Triggers>
         </asp:UpdatePanel>
    </div>
</asp:Content>
