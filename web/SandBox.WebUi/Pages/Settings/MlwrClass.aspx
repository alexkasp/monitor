﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="MlwrClass.aspx.cs" Inherits="SandBox.WebUi.Pages.Malware.MlwrClass" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>
<%@ Register assembly="DevExpress.Web.v12.1, Version=12.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Data.Linq" tagprefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div _designerregion="0">
        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="ASPxLabel" Theme="iOS">
        </dx:ASPxLabel>
        <dx:ASPxRoundPanel ID="RPNetwork" runat="server" 
            HeaderText="Сетевая активность" Height="16px" Width="100%" Theme="RedWine">
            <PanelCollection>
<dx:PanelContent runat="server" SupportsDisabledAttribute="True">
    <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" 
        DataSourceID="SqlDataSource1" KeyFieldName="Id" Width="100%">

<Settings ShowColumnHeaders="False" enablefiltercontrolpopupmenuscrolling="True"></Settings>

<SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
        <Columns>
            <dx:GridViewCommandColumn ShowInCustomizationForm="True" 
                VisibleIndex="0" Visible="False">
            </dx:GridViewCommandColumn>
            <dx:GridViewDataTextColumn FieldName="Id" ReadOnly="True" 
                ShowInCustomizationForm="True" Visible="False" VisibleIndex="1">
                <PropertiesTextEdit>
                    

<ValidationSettings ErrorText="Неверное значение">
                        

<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    

</ValidationSettings>
                

</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="MlwrId" ShowInCustomizationForm="True" 
                Visible="False" VisibleIndex="2">
                <PropertiesTextEdit>
                    

<ValidationSettings ErrorText="Неверное значение">
                        

<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    

</ValidationSettings>
                

</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="FClass" ShowInCustomizationForm="True" 
                Visible="False" VisibleIndex="3">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>
                <EditFormSettings Visible="False" />

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="Значение" FieldName="Value" 
                ShowInCustomizationForm="True" VisibleIndex="5">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="Действие" FieldName="SClass" 
                ShowInCustomizationForm="True" VisibleIndex="4">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>
            </dx:GridViewDataTextColumn>
        </Columns>
        <SettingsPager PageSize="20">
        </SettingsPager>
        <Settings ShowColumnHeaders="False" />
        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />

    </dx:ASPxGridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:sandBoxConnectionString %>" 
        
        
        SelectCommand="SELECT [Id], [MlwrId], [FClass], [Value], [SClass] FROM [MlwrFeature] WHERE (([FClass] = @FClass) AND ([MlwrId] = @MlwrId))" 
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:Parameter DefaultValue="Сетевая активность" Name="FClass" Type="String" />
            <asp:QueryStringParameter DefaultValue="-1" Name="MlwrId" 
                QueryStringField="mlwrID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <dx:ASPxPanel ID="ASPxPanel1" runat="server" Width="100%">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <table style="width:100%;">
                    <tr>
                        <td style="width: 255px">
                            <asp:DropDownList ID="DropDownList5" runat="server" Height="25px" Width="250px">
                                <asp:ListItem>Отправка пакетов свыше (Кб)</asp:ListItem>
                                <asp:ListItem>Доступ к ресурсу</asp:ListItem>
                                <asp:ListItem>Получение сетевого пакета</asp:ListItem>
                                <asp:ListItem>Отправка сетевого пакета</asp:ListItem>
                                <asp:ListItem>Открытие порта</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="width: 300px">
                            <dx:ASPxTextBox ID="ASPxTextBox1" runat="server" Width="400px">
                                <ValidationSettings ErrorText="Неверное значение">
                                    <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
<RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Вставить" 
                                OnClick="ASPxButton1_Click">
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxPanel>
                </dx:PanelContent>
</PanelCollection>
        </dx:ASPxRoundPanel>
        <dx:ASPxRoundPanel ID="RPFileSystem" runat="server" Width="100%" 
            HeaderText=" Файловая система" Theme="RedWine">

            <PanelCollection>
<dx:PanelContent runat="server" SupportsDisabledAttribute="True">
    <dx:ASPxGridView ID="ASPxGridView2" runat="server" AutoGenerateColumns="False" 
        DataSourceID="SqlDataSource2" Width="100%">
        <Columns>
            <dx:GridViewDataTextColumn FieldName="SClass" 
                ShowInCustomizationForm="True" VisibleIndex="0" Caption="Действие">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="Value" ShowInCustomizationForm="True" 
                VisibleIndex="1" Caption="Значение">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
        </Columns>
        <SettingsPager PageSize="20">
        </SettingsPager>
        <Settings ShowColumnHeaders="False" />
        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />

<Settings ShowColumnHeaders="False"></Settings>

<SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
    </dx:ASPxGridView>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString="<%$ ConnectionStrings:sandBoxConnectionString %>" 
        
        SelectCommand="SELECT [SClass], [Value] FROM [MlwrFeature] WHERE (([FClass] = @FClass) AND ([MlwrId] = @MlwrId))" 
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:Parameter DefaultValue="Файловая система" Name="FClass" Type="String" />
            <asp:QueryStringParameter DefaultValue="-1" Name="MlwrId" 
                QueryStringField="mlwrID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <dx:ASPxPanel ID="ASPxPanel2" runat="server" Width="100%">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <table style="width:100%;">
                    <tr>
                        <td style="width: 255px">
                            <asp:DropDownList ID="DropDownList6" runat="server" Height="25px" Width="250px">
                                <asp:ListItem>Редактирование файла</asp:ListItem>
                                <asp:ListItem>Чтение файла</asp:ListItem>
                                <asp:ListItem>Запись в файл</asp:ListItem>
                                <asp:ListItem>Переименование файла</asp:ListItem>
                                <asp:ListItem>Удаление файла</asp:ListItem>
                                <asp:ListItem>Изменение атрибутов файла/папки</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="width: 300px">
                            <dx:ASPxTextBox ID="ASPxTextBox2" runat="server" Width="400px">
                                <ValidationSettings ErrorText="Неверное значение">
                                    <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
<RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxButton ID="ASPxButton2" runat="server" Text="Вставить" 
                                OnClick="ASPxButton2_Click">
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxPanel>
                </dx:PanelContent>
</PanelCollection>

        </dx:ASPxRoundPanel>
        <dx:ASPxRoundPanel ID="RPRegister" runat="server" Width="100%" 
            HeaderText="Реестр" Theme="RedWine">
            <PanelCollection>
<dx:PanelContent runat="server" SupportsDisabledAttribute="True">
    <dx:ASPxGridView ID="ASPxGridView3" runat="server" AutoGenerateColumns="False" 
        DataSourceID="SqlDataSource3" Width="100%">

<Settings ShowColumnHeaders="False"></Settings>

<SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
        <Columns>
            <dx:GridViewDataTextColumn FieldName="Value" 
                ShowInCustomizationForm="True" VisibleIndex="1" Caption="Значение">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="SClass" ShowInCustomizationForm="True" 
                VisibleIndex="0" Caption="Действие">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
        </Columns>
        <SettingsPager PageSize="20">
        </SettingsPager>
        <Settings ShowColumnHeaders="False" />
        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />

    </dx:ASPxGridView>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
        ConnectionString="<%$ ConnectionStrings:sandBoxConnectionString %>" 
        
        SelectCommand="SELECT [Value], [SClass] FROM [MlwrFeature] WHERE (([FClass] = @FClass) AND ([MlwrId] = @MlwrId))" 
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:Parameter DefaultValue="Реестр" Name="FClass" Type="String" />
            <asp:QueryStringParameter DefaultValue="-1" Name="MlwrId" 
                QueryStringField="mlwrID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <dx:ASPxPanel ID="ASPxPanel3" runat="server" Width="100%">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <table style="width:100%;">
                    <tr>
                        <td style="width: 255px">
                            <asp:DropDownList ID="DropDownList7" runat="server" Height="25px" Width="250px">
                                <asp:ListItem>Создание ветки реестра</asp:ListItem>
                                <asp:ListItem>Удаление ветки реестра</asp:ListItem>
                                <asp:ListItem>Удаление ключа реестра</asp:ListItem>
                                <asp:ListItem>Задание ключа реестра</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="width: 300px">
                            <dx:ASPxTextBox ID="ASPxTextBox3" runat="server" Width="400px">
                                <ValidationSettings ErrorText="Неверное значение">
                                    <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
<RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxButton ID="ASPxButton3" runat="server" Text="Вставить" 
                                OnClick="ASPxButton3_Click">
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxPanel>
                </dx:PanelContent>
</PanelCollection>
        </dx:ASPxRoundPanel>
        <dx:ASPxRoundPanel ID="RPProc" runat="server" Width="100%" 
            HeaderText="Процессы" Theme="RedWine">
            <PanelCollection>
<dx:PanelContent runat="server" SupportsDisabledAttribute="True">
    <dx:ASPxGridView ID="ASPxGridView4" runat="server" AutoGenerateColumns="False" 
        DataSourceID="SqlDataSource4" Width="100%">
        <Columns>
            <dx:GridViewDataTextColumn FieldName="Value" 
                ShowInCustomizationForm="True" VisibleIndex="1" Caption="Значение">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="SClass" ShowInCustomizationForm="True" 
                VisibleIndex="0" Caption="Действие">
                <PropertiesTextEdit>
                    
<ValidationSettings ErrorText="Неверное значение">
                        
<RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                    
</ValidationSettings>
                
</PropertiesTextEdit>

<EditFormSettings Visible="False"></EditFormSettings>
            </dx:GridViewDataTextColumn>
        </Columns>
        <Settings ShowColumnHeaders="False" />
        <SettingsLoadingPanel Text="Загрузка&amp;hellip;" />

<Settings ShowColumnHeaders="False"></Settings>

<SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
    </dx:ASPxGridView>
    <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
        ConnectionString="<%$ ConnectionStrings:sandBoxConnectionString %>" 
        
        SelectCommand="SELECT [Value], [SClass] FROM [MlwrFeature] WHERE (([FClass] = @FClass) AND ([MlwrId] = @MlwrId))" 
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:Parameter DefaultValue="Процессы" Name="FClass" Type="String" />
            <asp:QueryStringParameter DefaultValue="-1" Name="MlwrId" 
                QueryStringField="mlwrID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <dx:ASPxPanel ID="ASPxPanel4" runat="server" Width="100%">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <table style="width:100%;">
                    <tr>
                        <td style="width: 255px">
                            <asp:DropDownList ID="DropDownList8" runat="server" Height="25px" Width="250px">
                                <asp:ListItem>Создание процесса</asp:ListItem>
                                <asp:ListItem>Закрытие процесса</asp:ListItem>
                                <asp:ListItem>Создание исполняемого образа</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="width: 300px">
                            <dx:ASPxTextBox ID="ASPxTextBox4" runat="server" Width="400px">
                                <ValidationSettings ErrorText="Неверное значение">
                                    <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
<RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxButton ID="ASPxButton4" runat="server" Text="Вставить" 
                                OnClick="ASPxButton4_Click">
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxPanel>
                </dx:PanelContent>
</PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
</asp:Content>
