<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="NewResearch.aspx.cs" Inherits="SandBox.WebUi.Pages.Research.NewResearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
    // <![CDATA[
        function csGetClientInstanceName(editorControl) {
            var clientInstanceName = null;
            if (typeof (editorControl) !== 'undefined') {
                var parts = editorControl.name.split('_');
                if (parts != null)
                    clientInstanceName = parts[parts.length - 1];
            }

            return clientInstanceName;
        }
        function AddLbItem(ListBox, task, tparam) {
            var icount = ListBox.GetItemCount();
            ListBox.AddItem([(icount + 1).toString(), task, tparam, "<div style=\"text-align: center;\"><img style=\"cursor:pointer;\" alt=\"Удалить\" src=\"../../Content/Images/Icons/delete.png\" onclick=\"DeleteLbItem(" + csGetClientInstanceName(ListBox) + ")\" title=\"Удалить\"></div>"], icount);
            ListBox.SetHeight(50 + (icount + 1) * 25);
        }
        function DeleteLbItem(ListBox) {
            if (!confirm('Вы уверены, что хотите удалить задание?')) { return; }
            var itemindex = ListBox.GetSelectedItems()[0].index;
            var count = ListBox.GetItemCount();
            if (count > itemindex+1) {
                var lbitems = new Array();
                var j = 0;
                for (var i = 0; i < count; i++) {
                    if (i != itemindex) {
                        lb_items = new Array();
                        lb_items = ListBox.GetItem(i).text.split(';');
                        lb_items[0] = (j + 1).toString();
                        lb_items[1] = lb_items[1].slice(1);
                        lb_items[2] = lb_items[2].slice(1);
                        lb_items[3] = "<img style=\"cursor:pointer;\" alt=\"Удалить\" src=\"../../Content/Images/Icons/delete.png\" onclick=\"DeleteLbItem(" + csGetClientInstanceName(ListBox) + ")\" title=\"Удалить\">";
                        lbitems[j] = lb_items;
                        if (i < count - 1) ListBox.InsertItem(lb_items, i);
                        else ListBox.AddItem(lb_items, i);
                        j++;
                    }
                }
                ListBox.BeginUpdate();
                ListBox.ClearItems();
                for (var i = 0; i < j; i++) { ListBox.AddItem(lbitems[i], i); }
                ListBox.EndUpdate();
            }
            else ListBox.RemoveItem(itemindex);
            ListBox.SetHeight(50 + (count - 1) * 25);
        }
    // ]]>
    </script>
    <div id="content-top">
        <div id="pagename">
            Создание исследования <a href="/Pages/Research/Current.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
        <div class="titlegr">
            <dx:ASPxTextBox ID="rschName" runat="server" Width="345px" 
                NullText="Имя исследования">
                <ValidationSettings ValidationGroup="AddResearchValidationGroup" ErrorText="Введите имя исследования">
                    <RequiredField ErrorText="Введите имя исследования" IsRequired="true" />
                </ValidationSettings>
            </dx:ASPxTextBox>
        </div>
        <div style="float: left; width: 400px;">
            <div class="mainparams">
                Основные параметры исследования</div>
            <div id="mainprmcont">
                <table class='form'>
                        <tr>
                            <td style="width: 150px; padding-left: 20px;">
                                ВПО
                            </td>
                            <td style="padding-right: 16px;">
                                <dx:ASPxComboBox ID="cbMalware" runat="server" Width="200px" ShowLoadingPanel="False" 
                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <fieldset>
                                    <legend>Выбор среды</legend>
                                    <table>
                                        <tr>
                                            <td style="width: 150px">
                                                <dx:ASPxRadioButton ID="rbEtln" runat="server" Text="Эталон" GroupName="LIRSelect"
                                                    Checked="True">
                                                    <ClientSideEvents CheckedChanged="function(s, e) {
	                                            cbEtln.SetEnabled(true);
	                                            cbVLIR.SetEnabled(false);
	                                            cbLIR.SetEnabled(false);
                                            }" />
                                                </dx:ASPxRadioButton>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbEtln" runat="server" Width="200px" ShowLoadingPanel="False"
                                                    ClientInstanceName="cbEtln" AutoResizeWithContainer="True" ValueField="Id" TextFormatString="{0}"
                                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="Name" Caption="Имя" />
                                                        <dx:ListBoxColumn FieldName="System" Caption="Система" Width="200px" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px">
                                                <dx:ASPxRadioButton ID="rbVLIR" runat="server" Text="ВЛИР" GroupName="LIRSelect">
                                                    <ClientSideEvents CheckedChanged="function(s, e) {
	                                                    cbEtln.SetEnabled(false);
	                                                    cbVLIR.SetEnabled(true);
	                                                    cbLIR.SetEnabled(false);
                                                    }" />
                                                </dx:ASPxRadioButton>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbVLIR" runat="server" Width="200px" ShowLoadingPanel="False"
                                                    ClientInstanceName="cbVLIR" ClientEnabled="False" AutoResizeWithContainer="True"
                                                    ValueField="Id" TextFormatString="{0}" IncrementalFilteringMode="StartsWith"
                                                    EnableIncrementalFiltering="True">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="Name" Caption="Имя" />
                                                        <dx:ListBoxColumn FieldName="System" Caption="Система" Width="200px" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px">
                                                <dx:ASPxRadioButton ID="rbLIR" runat="server" Text="ЛИР" GroupName="LIRSelect">
                                                    <ClientSideEvents CheckedChanged="function(s, e) {
	                                                    cbEtln.SetEnabled(false);
	                                                    cbVLIR.SetEnabled(false);
	                                                    cbLIR.SetEnabled(true);
                                                    }" />
                                                </dx:ASPxRadioButton>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbLIR" runat="server" Width="200px" ShowLoadingPanel="False"
                                                    ClientInstanceName="cbLIR" ClientEnabled="False" ValueField="Id" TextFormatString="{0}"
                                                    IncrementalFilteringMode="StartsWith" AutoResizeWithContainer="True" EnableIncrementalFiltering="True">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="Name" Caption="Имя" />
                                                        <dx:ListBoxColumn FieldName="System" Caption="Система" Width="200px" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <fieldset>
                                    <legend>Завершить</legend>
                                    <table>
                                        <tr>
                                            <td style="width: 150px">
                                                <dx:ASPxCheckBox ID="cbTimeEnd" runat="server" Text="По времени" CheckState="Checked"
                                                    Checked="True" ClientInstanceName="cbTimeEnd">
                                                    <ClientSideEvents CheckedChanged="function(s, e) {
	                                                    spinTime.SetEnabled(cbTimeEnd.GetChecked());

                                                    }" />
                                                </dx:ASPxCheckBox>
                                            </td>
                                            <td valign="middle">
                                                <div style="float: left">
                                                    <dx:ASPxSpinEdit ID="spinTime" runat="server" Width="100px" MinValue="1" MaxValue="525949"
                                                        NumberType="Integer" Number="10" ClientInstanceName="spinTime">
                                                    </dx:ASPxSpinEdit>
                                                </div>
                                                <div style="float: left; text-indent: 10px; padding-top: 3px">
                                                    мин.</div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px">
                                                <dx:ASPxCheckBox ID="cbEventEnd" runat="server" Text="По событию" CheckState="Unchecked"
                                                    ClientInstanceName="cbEventEnd">
                                                    <ClientSideEvents CheckedChanged="function(s, e) {
	                                                    var eegc = cbEventEnd.GetChecked();
                                                        cbModule.SetEnabled(eegc);
	                                                    cbEvent.SetEnabled(eegc);
	                                                    tbWho.SetEnabled(eegc);
	                                                    tbDest.SetEnabled(eegc);
                                                    }" />
                                                </dx:ASPxCheckBox>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px">
                                                <div class="table_text">
                                                    Модуль</div>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbModule" runat="server" Width="200px" DropDownStyle="DropDownList"
                                                    IncrementalFilteringMode="StartsWith" EnableSynchronization="False" EnableIncrementalFiltering="True"
                                                    ShowLoadingPanel="False" ClientEnabled="False" ClientInstanceName="cbModule">
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) { cbEvent.PerformCallback(s.GetValue().toString()); }" />
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px">
                                                <div class="table_text">
                                                    Событие</div>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cbEvent" runat="server" Width="200px" ClientEnabled="False"
                                                    ClientInstanceName="cbEvent" ShowLoadingPanel="False" TextField="EventsEventDescription"
                                                    EnableIncrementalFiltering="True" EnableSynchronization="False" ValueField="EventID"
                                                    IncrementalFilteringMode="StartsWith" OnCallback="cbEvent_Callback" AutoResizeWithContainer="True">
                                                    <ClientSideEvents EndCallback="function(s, e) { s.SetSelectedIndex(0); }" />
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px">
                                                Объект
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="tbWho" runat="server"
                                                    Width="200px" ClientEnabled="False" ClientInstanceName="tbWho" 
                                                    NullText="[Имя образа]">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px">
                                                Цель
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="tbDest" runat="server" Width="200px" ClientEnabled="False" 
                                                    ClientInstanceName="tbDest" NullText="[Параметр]">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                            <div style="float: right; padding-left: 10px;">
                                <dx:ASPxButton ID="btnReset" runat="server" Text="Очистить" AutoPostBack="False"
                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="90px">
                                    <ClientSideEvents Click="function(s, e) {
	document.location.href = '/Pages/Research/NewResearch.aspx';
}" />
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                                </dx:ASPxButton>
                            </div>
                            <div style="float: right; padding-left: 10px;">
                                <dx:ASPxButton ID="btnCancel" runat="server" Text="Отменить" AutoPostBack="False"
                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="90px">
                                    <ClientSideEvents Click="function(s, e) {
	document.location.href = '/Pages/Research/Current.aspx';
}" />
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                                </dx:ASPxButton>
                            </div>
                            <div style="float: right">
                                <dx:ASPxButton ID="btnCreate" runat="server" Text="Создать" ValidationGroup="AddResearchValidationGroup"
                                    OnClick="BtnCreateClick" AutoPostBack="false" CssClass="button" EnableDefaultAppearance="False"
                                    EnableTheming="False" Width="90px">
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                                </dx:ASPxButton>
                            </div>
                            </td>
                        </tr>
                </table>
            </div>
        </div>
        <div style="margin-left: 410px;">
            <div class="addparams">Дополнительные параметры исследования</div>
            <ajaxToolkit:Accordion ID="Accordion1" runat="server" HeaderCssClass="accordionHeader"
                HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent"
                CssClass="accordion" FadeTransitions="False" RequireOpenedPane="False" SelectedIndex="-1">
                <Panes>
                    <ajaxToolkit:AccordionPane runat="server">
                        <Header>
                            <div id="accfs">
                            </div>
                            <div class="acchdr">Файловая система</div>
                        </Header>
                        <Content>
                            <dx:ASPxListBox ID="lbFSParams" runat="server" Width="100%" 
                                ClientInstanceName="lbFSParams" EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID" CssClass="lbpar">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
<%--                            <dx:ASPxGridView ID="ASPxGridView2" runat="server" Width="100%" Style="margin-bottom: 5px;
                                margin-top: 5px;" AutoGenerateColumns="False" KeyFieldName="f2">
                                <Columns>
                                    <dx:GridViewDataTextColumn Caption="№" FieldName="f0" VisibleIndex="0" Width="300px">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Задание" FieldName="f1" VisibleIndex="1" Width="300px">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Параметр" FieldName="f2" VisibleIndex="2">
                                    </dx:GridViewDataTextColumn>
                                                <dx:GridViewCommandColumn VisibleIndex="3" ButtonType="Image" Width="50px" Caption="Удалить">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="cbDelete">
                                                            <Image ToolTip="Удалить" Url="../../Content/Images/Icons/delete.png" />
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <CellStyle HorizontalAlign="Center">
                                                    </CellStyle>
                                                </dx:GridViewCommandColumn>
                                </Columns>
                            </dx:ASPxGridView>
--%>                            <table style="width: 100%;padding-top:5px;">
                                <tr>
                                    <td style="width: 35px">Задание</td>
                                    <td style="width: 210px">
                                        <dx:ASPxComboBox ID="CBFileActiv" runat="server" ValueType="System.String" Width="210px" ClientInstanceName="CBFileActiv" ShowLoadingPanel="False" 
                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td style="width: 400px">
                                        <dx:ASPxTextBox ID="TBNFileTaskValue" runat="server" Width="390px" ClientInstanceName="TBNFileTaskValue" NullText="[Параметр]">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td style="width: 20px">
                                    <img style="cursor:pointer;" alt="Добавить" src="../../Content/Images/Icons/btn_addparam.png" onclick="AddLbItem(lbFSParams,CBFileActiv.GetText(),TBNFileTaskValue.GetValue());" title="Добавить">
                                    </td>
                                    <td>
                                    <img style="cursor:pointer;" alt="Очистить" src="../../Content/Images/Icons/btn_clearpr.png" onclick="if (confirm('Вы уверены, что хотите очистить задания?')) { lbFSParams.ClearItems(); lbFSParams.SetHeight(50); }" title="Очистить">
                                    </td>
                                </tr>
                            </table>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            	<tr>
                            		<td style="width: 265px">
                                        <dx:ASPxCheckBox ID="cbFileRoot" runat="server" Text="Получить структуру файловой системы" CheckState="Unchecked"
                                            ClientInstanceName="cbFileRoot">
                                            <ClientSideEvents CheckedChanged="function(s, e) {
	                                            tbFileRoot.SetEnabled(cbFileRoot.GetChecked());

                                            }" />
                                        </dx:ASPxCheckBox>
                                    </td>
                            		<td>
                                        <dx:ASPxTextBox ID="tbFileRoot" runat="server" Width="390px" ClientInstanceName="tbFileRoot" ClientEnabled="False" NullText="[Корневой каталог]">
                                        </dx:ASPxTextBox>
                                    </td>
                            	</tr>
                            	<tr>
                            		<td style="width: 265px">
                                        <dx:ASPxCheckBox ID="cbSignature" runat="server" Text="Поиск сигнатуры" CheckState="Unchecked"
                                            ClientInstanceName="cbSignature">
                                            <ClientSideEvents CheckedChanged="function(s, e) {
	                                            tbSignature.SetEnabled(cbSignature.GetChecked());

                                            }" />
                                        </dx:ASPxCheckBox>
                                    </td>
                            		<td>
                                        <dx:ASPxTextBox ID="tbSignature" runat="server" Width="390px" ClientInstanceName="tbSignature" ClientEnabled="False" NullText="[Сигнатура]">
                                        </dx:ASPxTextBox>
                                    </td>
                            	</tr>
                            	<tr>
                            		<td style="width: 265px">
                                        <dx:ASPxCheckBox ID="cbExtension" runat="server" Text="Отслеживать расширение" CheckState="Unchecked"
                                            ClientInstanceName="cbExtension">
                                            <ClientSideEvents CheckedChanged="function(s, e) {
	                                            tbExtension.SetEnabled(cbExtension.GetChecked());

                                            }" />
                                        </dx:ASPxCheckBox>
                                    </td>
                            		<td>
                                        <dx:ASPxTextBox ID="tbExtension" runat="server" Width="390px" ClientInstanceName="tbExtension" ClientEnabled="False" NullText="[Расширение]">
                                        </dx:ASPxTextBox>
                                    </td>
                            	</tr>
                            	<tr>
                            		<td style="width: 265px" valign="top">
                                        <dx:ASPxCheckBox ID="cbEnul" runat="server" Text="Запустить эмуляцию активности" CheckState="Unchecked"
                                            ClientInstanceName="cbEnul">
                                            <ClientSideEvents CheckedChanged="function(s, e) {
	                                            tbEmulCommand.SetEnabled(cbEnul.GetChecked());
	                                            tbEmulParams.SetEnabled(cbEnul.GetChecked());
	                                            spEmulTime.SetEnabled(cbEnul.GetChecked());
                                            }" />
                                        </dx:ASPxCheckBox>
                                    </td>
                            		<td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="390px">
                                        	<tr>
                                        		<td style="width: 70px">
                                                Команда</td><td>
                                                <dx:ASPxTextBox ID="tbEmulCommand" runat="server" Width="320px" ClientInstanceName="tbEmulCommand" ClientEnabled="False" NullText="[Команда для выполнения в cmd]">
                                                </dx:ASPxTextBox>
                                                </td>
                                        	</tr>
                                        	<tr>
                                        		<td style="width: 70px">
                                                Параметры</td><td>
                                                <dx:ASPxTextBox ID="tbEmulParams" runat="server" Width="320px" ClientInstanceName="tbEmulParams" ClientEnabled="False" NullText="[Параметры команды]">
                                                </dx:ASPxTextBox>
                                                </td>
                                        	</tr>
                                        	<tr>
                                        		<td colspan="2">
                                                <div style="float: left; padding-top: 3px;width:150px">Выполнить команду через</div>
                                                <div style="float: left"><dx:ASPxSpinEdit ID="spEmulTime" runat="server" Width="80px" MinValue="0" MaxValue="604800"
                                                        NumberType="Integer" Number="0" ClientInstanceName="spEmulTime" ClientEnabled="False">
                                                </dx:ASPxSpinEdit></div>
                                                <div style="float: left; padding-top: 3px;width:50px; text-align:right">секунд</div>
                                                </td>
                                        	</tr>
                                        </table>
                                    </td>
                            	</tr>
                            </table>
                        </Content>
                    </ajaxToolkit:AccordionPane>
                    <ajaxToolkit:AccordionPane ID="AccordionPane1" runat="server">
                        <Header>
                            <div id="accrg">
                            </div>
                            <div class="acchdr">
                                Реестр</div>
                        </Header>
                        <Content>
                            <dx:ASPxListBox ID="lbRegParams" runat="server" Width="100%"  CssClass="lbpar"
                                ClientInstanceName="lbRegParams" EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
<%--                            <dx:ASPxGridView ID="ASPxGridView3" runat="server" Width="100%" Style="margin-bottom: 5px;
                                margin-top: 5px;" AutoGenerateColumns="False" KeyFieldName="f2">
                                <Columns>
                                    <dx:GridViewDataTextColumn Caption="Задание" FieldName="f1" VisibleIndex="0" Width="300px">
                                        <PropertiesTextEdit>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                            </ValidationSettings>
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Параметр" FieldName="f2" VisibleIndex="1">
                                        <PropertiesTextEdit>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                            </ValidationSettings>
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <SettingsBehavior AllowFocusedRow="True" />
                                <SettingsPager Visible="False">
                                </SettingsPager>
                                <SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
                            </dx:ASPxGridView>
--%>                            <table style="width: 100%;padding-top:5px;">
                                <tr>
                                    <td style="width: 35px">Задание</td>
                                    <td style="width: 210px">
                                        <dx:ASPxComboBox ID="CBRegActiv" runat="server" ValueType="System.String" Width="210px" ClientInstanceName="CBRegActiv" ShowLoadingPanel="False" 
                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td style="width: 400px">
                                        <dx:ASPxTextBox ID="TBNRegTaskValue" runat="server" Width="390px" ClientInstanceName="TBNRegTaskValue" NullText="[Параметр]">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td style="width: 20px">
                                    <img style="cursor:pointer;" alt="Добавить" src="../../Content/Images/Icons/btn_addparam.png" onclick="AddLbItem(lbRegParams,CBRegActiv.GetText(),TBNRegTaskValue.GetValue());" title="Добавить">
                                    </td>
                                    <td>
                                    <img style="cursor:pointer;" alt="Очистить" src="../../Content/Images/Icons/btn_clearpr.png" onclick="if (confirm('Вы уверены, что хотите очистить задания?')) { lbRegParams.ClearItems(); lbRegParams.SetHeight(50); }" title="Очистить">
                                    </td>
                                </tr>
                            </table>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            	<tr>
                            		<td style="width: 265px">
                                        <dx:ASPxCheckBox ID="cbRegRoot" runat="server" Text="Получить структуру реестра" CheckState="Unchecked"
                                            ClientInstanceName="cbRegRoot">
                                            <ClientSideEvents CheckedChanged="function(s, e) {
	                                            tbRegRoot.SetEnabled(cbRegRoot.GetChecked());
                                                cmbRegRoot.SetEnabled(cbRegRoot.GetChecked());
                                            }" />
                                        </dx:ASPxCheckBox>
                                    </td>
                            		<td>
                                        <div style="float: left">
                                        <dx:ASPxComboBox ID="cmbRegRoot" runat="server" Width="160px" ValueType="System.String" ClientInstanceName="cmbRegRoot" ClientEnabled="False" ShowLoadingPanel="False" 
                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                            <Items>
                                                <dx:ListEditItem Text="Весь реестр" Value="full" />
                                                <dx:ListEditItem Text="HKEY_CLASSES_ROOT" Value="HKEY_CLASSES_ROOT" Selected="True" />
                                                <dx:ListEditItem Text="HKEY_CURRENT_USER" Value="HKEY_CURRENT_USER" />
                                                <dx:ListEditItem Text="HKEY_LOCAL_MACHINE" Value="HKEY_LOCAL_MACHINE" />
                                                <dx:ListEditItem Text="HKEY_USERS" Value="HKEY_USERS" />
                                                <dx:ListEditItem Text="HKEY_CURRENT_CONFIG" Value="HKEY_CURRENT_CONFIG" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                        </div>
                                        <div style="float: left"><dx:ASPxTextBox ID="tbRegRoot" runat="server" Width="230px" ClientInstanceName="tbRegRoot" ClientEnabled="False" NullText="[Корневой раздел]">
                                        </dx:ASPxTextBox></div>
                                    </td>
                            	</tr>
                                </table>
<%--                            <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="Ветка реестра">
                            </dx:ASPxLabel>
                            <dx:ASPxComboBox ID="ASPxComboBox3" runat="server" Width="50%" AutoPostBack="True"
                                LoadingPanelText="Загрузка&amp;hellip;">
                                <Items>
                                    <dx:ListEditItem Text="весь реестр" Value="full" />
                                    <dx:ListEditItem Text="HKEY_CLASSES_ROOT" Value="HKEY_CLASSES_ROOT" />
                                    <dx:ListEditItem Text="HKEY_CURRENT_USER" Value="HKEY_CURRENT_USER" />
                                    <dx:ListEditItem Text="HKEY_LOCAL_MACHINE" Value="HKEY_LOCAL_MACHINE" />
                                    <dx:ListEditItem Text="HKEY_USERS" Value="HKEY_USERS" />
                                    <dx:ListEditItem Text="HKEY_CURRENT_CONFIG" Value="HKEY_CURRENT_CONFIG" />
                                </Items>
                                <ValidationSettings ErrorText="Неверное значение">
                                    <RegularExpression ErrorText="Ошибка проверки регулярного выражения"></RegularExpression>
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                            <dx:ASPxLabel ID="ASPxLabel8" runat="server" Text="Подветка реестра">
                            </dx:ASPxLabel>
                            <dx:ASPxTextBox ID="ASPxTextBox3" runat="server" Width="50%">
                            </dx:ASPxTextBox>
--%>                        </Content>
                    </ajaxToolkit:AccordionPane>
                    <ajaxToolkit:AccordionPane ID="AccordionPane2" runat="server">
                        <Header>
                            <div id="accpr">
                            </div>
                            <div class="acchdr">
                                Процессы</div>
                        </Header>
                        <Content>
                            <dx:ASPxListBox ID="lbProcParams" runat="server" Width="100%"  CssClass="lbpar"
                                ClientInstanceName="lbProcParams"  EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
<%--                            <dx:ASPxGridView ID="ASPxGridView4" runat="server" Width="100%" Style="margin-bottom: 5px;
                                margin-top: 5px;" AutoGenerateColumns="False" KeyFieldName="f2">
                                <Columns>
                                    <dx:GridViewDataTextColumn Caption="Задание" FieldName="f1" VisibleIndex="0" Width="300px">
                                        <PropertiesTextEdit>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                            </ValidationSettings>
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Параметр" FieldName="f2" VisibleIndex="1">
                                        <PropertiesTextEdit>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                            </ValidationSettings>
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <SettingsBehavior AllowFocusedRow="True" />
                                <SettingsPager Visible="False">
                                </SettingsPager>
                                <SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
                            </dx:ASPxGridView>
--%>                            <table style="width: 100%;padding-top:5px;">
                                <tr>
                                    <td style="width: 35px">Задание</td>
                                    <td style="width: 210px">
                                        <dx:ASPxComboBox ID="CBProcActiv" runat="server" ValueType="System.String" Width="210px" ClientInstanceName="CBProcActiv" ShowLoadingPanel="False" 
                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td style="width: 400px">
                                        <dx:ASPxTextBox ID="TBProcTaskValue" runat="server" Width="390px" ClientInstanceName="TBProcTaskValue" NullText="[Параметр]">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td style="width: 20px">
                                    <img style="cursor:pointer;" alt="Добавить" src="../../Content/Images/Icons/btn_addparam.png" onclick="AddLbItem(lbProcParams,CBProcActiv.GetText(),TBProcTaskValue.GetValue());" title="Добавить">
                                    </td>
                                    <td>
                                    <img style="cursor:pointer;" alt="Очистить" src="../../Content/Images/Icons/btn_clearpr.png" onclick="if (confirm('Вы уверены, что хотите очистить задания?')) { lbProcParams.ClearItems(); lbProcParams.SetHeight(50); }" title="Очистить">
                                    </td>
                                </tr>
                            </table>
<%--                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 210px">
                                        <dx:ASPxComboBox ID="CBProcActiv" runat="server" ValueType="System.String" Width="200px">
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td style="width: 262px">
                                        <dx:ASPxTextBox ID="TBProcTaskValue" runat="server" Width="250px" Style="left: 210px;"
                                            Height="20px">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td style="width: 80px">
                                        <dx:ASPxButton ID="BAddProcTask" runat="server" Text="Вставить" OnClick="BAddProcTask_Click">
                                        </dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="BDelProcTask" runat="server" Text="Удалить" OnClick="BDelProcTask_Click">
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
--%>                            <dx:ASPxCheckBox ID="cbProcMon" runat="server" Text="Включить монитор процессов">
                            </dx:ASPxCheckBox>
                        </Content>
                    </ajaxToolkit:AccordionPane>
                    <ajaxToolkit:AccordionPane ID="AccordionPane4" runat="server">
                        <Header>
                            <div id="accnt">
                            </div>
                            <div class="acchdr">
                                Сетевая активность</div>
                        </Header>
                        <Content>
                            <dx:ASPxListBox ID="lbNetParams" runat="server" Width="100%"  CssClass="lbpar"
                                ClientInstanceName="lbNetParams" EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
<%--                            <dx:ASPxGridView ID="ASPxGridView1" runat="server" Width="100%" Style="margin-bottom: 5px;
                                margin-top: 5px;" AutoGenerateColumns="False" OnRowDeleting="ASPxGridView1_RowDeleting"
                                KeyFieldName="f2">
                                <Columns>
                                    <dx:GridViewDataTextColumn Caption="Задание" FieldName="f1" VisibleIndex="0" Width="300px">
                                        <PropertiesTextEdit>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                            </ValidationSettings>
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Параметр" FieldName="f2" VisibleIndex="1">
                                        <PropertiesTextEdit>
                                            <ValidationSettings ErrorText="Неверное значение">
                                                <RegularExpression ErrorText="Ошибка проверки регулярного выражения" />
                                            </ValidationSettings>
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <SettingsBehavior AllowFocusedRow="True" />
                                <SettingsPager Visible="False">
                                </SettingsPager>
                                <SettingsLoadingPanel Text="Загрузка&amp;hellip;"></SettingsLoadingPanel>
                            </dx:ASPxGridView>
--%>                            <table style="width: 100%;padding-top:5px;">
                                <tr>
                                    <td style="width: 35px">Задание</td>
                                    <td style="width: 210px">
                                        <dx:ASPxComboBox ID="CBNetActiv" runat="server" ValueType="System.String" Width="210px" ClientInstanceName="CBNetActiv" ShowLoadingPanel="False" 
                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td style="width: 400px">
                                        <dx:ASPxTextBox ID="TBNetTaskValue" runat="server" Width="390px" ClientInstanceName="TBNetTaskValue" NullText="[Параметр]">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td style="width: 20px">
                                    <img style="cursor:pointer;" alt="Добавить" src="../../Content/Images/Icons/btn_addparam.png" onclick="AddLbItem(lbNetParams,CBNetActiv.GetText(),TBNetTaskValue.GetValue());" title="Добавить">
                                    </td>
                                    <td>
                                    <img style="cursor:pointer;" alt="Очистить" src="../../Content/Images/Icons/btn_clearpr.png" onclick="if (confirm('Вы уверены, что хотите очистить задания?')) { lbNetParams.ClearItems(); lbNetParams.SetHeight(50); }" title="Очистить">
                                    </td>
                                </tr>
                            </table>
<%--                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 210px">
                                        <dx:ASPxComboBox ID="CBNetActiv" runat="server" ValueType="System.String" Width="200px"
                                            AutoPostBack="True" ViewStateMode="Enabled">
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td style="width: 262px">
                                        <dx:ASPxTextBox ID="TBNetTaskValue" runat="server" Width="250px" Style="left: 210px;"
                                            Height="20px">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td style="width: 80px">
                                        <dx:ASPxButton ID="BAddNetTask" runat="server" Text="Вставить" OnClick="BAddNetTask_Click">
                                        </dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="BDelNetTask" runat="server" Text="Удалить" OnClick="BDelNetTask_Click">
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
--%>                        </Content>
                    </ajaxToolkit:AccordionPane>
                </Panes>
            </ajaxToolkit:Accordion>
        </div>
    </div>
</asp:Content>
