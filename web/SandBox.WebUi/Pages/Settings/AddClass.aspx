<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="AddClass.aspx.cs" Inherits="SandBox.WebUi.Account.AddClass" %>

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
            if (count > itemindex + 1) {
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
            Добавление класса ВПО <a href="/Pages/Settings/Main.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
        <table>
            <tbody>
                <tr>
                    <td style="width: 150px;font-weight:bold;">
                        Класс ВПО
                    </td>
                    <td style="width: 600px">
                        <dx:ASPxTextBox ID="tbClass" runat="server" Width="200px" ClientInstanceName="tbWho"
                            NullText="[Имя класса]">
                            <ValidationSettings ErrorText="Введите класс ВПО" 
                                ValidationGroup="AddResearchValidationGroup">
                                <RequiredField ErrorText="Введите класс ВПО" IsRequired="True" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr>
                    <td style="width: 150px;font-weight:bold;" valign="top">
                        Файловая система
                    </td>
                    <td>
                            <dx:ASPxListBox ID="lbFSParams" runat="server" Width="100%"  CssClass="lbpar"
                                ClientInstanceName="lbFSParams" EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID" >
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
                            <table style="width: 100%;padding-top:5px;">
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

                    </td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr>
                    <td style="width: 150px;font-weight:bold;" valign="top">
                        Реестр
                    </td>
                    <td>
                            <dx:ASPxListBox ID="lbRegParams" runat="server" Width="100%"  CssClass="lbpar"
                                ClientInstanceName="lbRegParams" EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
                            <table style="width: 100%;padding-top:5px;">
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
                    </td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr>
                    <td style="width: 150px;font-weight:bold;" valign="top">
                        Процессы
                    </td>
                    <td>
                            <dx:ASPxListBox ID="lbProcParams" runat="server" Width="100%"  CssClass="lbpar"
                                ClientInstanceName="lbProcParams"  EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
                            <table style="width: 100%;padding-top:5px;">
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
                    </td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr>
                    <td style="width: 150px;font-weight:bold;" valign="top">
                        Сеть
                    </td>
                    <td>
                            <dx:ASPxListBox ID="lbNetParams" runat="server" Width="100%"  CssClass="lbpar"
                                ClientInstanceName="lbNetParams" EncodeHtml="False" ItemStyle-Wrap="True" Height="50px" ValueField="ID">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="ID" Caption="№" Width="10px" />
                                    <dx:ListBoxColumn FieldName="Task" Caption="ЗАДАНИЕ" Width="200px" />
                                    <dx:ListBoxColumn FieldName="Param" Caption="ПАРАМЕТРЫ" Width="100%" />
                                    <dx:ListBoxColumn Caption="УДАЛИТЬ" Width="50px" />
                                </Columns>
                            </dx:ASPxListBox>
                            <table style="width: 100%;padding-top:5px;">
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
                    </td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr>
                    <td style="width: 150px;font-weight:bold;" valign="top">
                        Комментарий
                    </td>
                    <td>
                        <dx:ASPxMemo ID="mmClass" runat="server" NullText="[Комментарий]" Width="100%" 
                            Height="70px" ClientInstanceName="mmClass">
                            <ClientSideEvents Init="function(s, e) {
	var textArea = mmClass.GetInputElement();
    textArea.style.height = 'auto';
	textArea.style.height = textArea.scrollHeight+'px';
}" TextChanged="function(s, e) {
	var textArea = mmClass.GetInputElement();
    textArea.style.height = 'auto';
	textArea.style.height = textArea.scrollHeight+'px';
}" />
                        </dx:ASPxMemo>
                    </td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <div>
                            <div style="float: right; padding-left: 10px;">
                                <dx:ASPxButton ID="btnCancel" runat="server" Text="Отменить" AutoPostBack="False"
                                    CssClass="button" EnableDefaultAppearance="False" EnableTheming="False" Width="90px">
                                    <ClientSideEvents Click="function(s, e) {
	document.location.href = '/Pages/Settings/Main.aspx';
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
                                <dx:ASPxButton ID="btnCreate" runat="server" Text="Добавить" ValidationGroup="AddResearchValidationGroup"
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
                        </div>
                      <br />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
