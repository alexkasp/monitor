﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="AddLir.aspx.cs" Inherits="SandBox.WebUi.Pages.Information.CreateNewVlir" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content-top">
        <div id="pagename">
            Добавление ЛИР <a href="/Pages/Information/Resources.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
        <table style="width: 100%;">
            <tr>
                <td style="width: 115px">
                    <div class="table_text" __designer:mapid="35a">
                        Имя ЛИР:</div>
                </td>
                <td>
                    <dx:ASPxTextBox ID="tbLir" runat="server" Width="200px" OnTextChanged="tbLir_TextChanged">
                        <ValidationSettings ValidationGroup="CreateEtalonMachineValidationGroup">
                            <RequiredField ErrorText=" " IsRequired="true" />
                        </ValidationSettings>
                    </dx:ASPxTextBox>
                    <dx:ASPxLabel ID="LValidation" runat="server" Visible="False">
                    </dx:ASPxLabel>
                </td>
            </tr>
            <tr>
                <td style="width: 115px">
                    <div class="table_text" __designer:mapid="35a">
                        Тип ОС:</div>
                </td>
                <td>
                    <dx:ASPxComboBox ID="cbSystem" runat="server" Width="200px">
                        <ValidationSettings ValidationGroup="CreateEtalonMachineValidationGroup">
                            <RequiredField ErrorText=" " IsRequired="true" />
                        </ValidationSettings>
                    </dx:ASPxComboBox>
                </td>
            </tr>
            <tr>
                <td style="width: 115px">
                    <div class="table_text" __designer:mapid="35a">
                        MAC-адрес:</div>
                </td>
                <td>
                    <dx:ASPxTextBox ID="tbLirMac" runat="server" Width="200px">
                        <MaskSettings ErrorText="MAC-адрес не верный!" 
                            Mask="&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;-&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;-&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;-&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;-&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;-&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;&lt;0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F&gt;" />
                        <ValidationSettings ValidationGroup="CreateEtalonMachineValidationGroup" 
                            ErrorText="MAC-адрес не верный!" SetFocusOnError="True">
                            <RegularExpression ErrorText="MAC-адрес не верный!" 
                                ValidationExpression="([0-9A-Fa-f]{2}\-){5}[0-9A-Fa-f]{2}" />
                            <RequiredField ErrorText="MAC-адрес не может быть пустым" IsRequired="true" />
                        </ValidationSettings>
                    </dx:ASPxTextBox>
                    <dx:ASPxLabel ID="LValidation2" runat="server" Visible="False">
                    </dx:ASPxLabel>
                </td>
            </tr>
            <tr>
                  <td>
                  </td>
                  <td>
                  <br />
                     <div style="width:200px;">
                     <div style="float:right;padding-left:10px;">
                      <dx:ASPxButton ID="btnCancel" runat="server" Text="Отменить" 
                             AutoPostBack = "False" CssClass="button" EnableDefaultAppearance="False" 
                             EnableTheming="False" Width="90px">
                          <ClientSideEvents Click="function(s, e) {
	document.location.href = '/Pages/Information/Resources.aspx';
}" />
                                    <PressedStyle CssClass="buttonHover">
                                    </PressedStyle>
                                    <HoverStyle CssClass="buttonHover">
                                    </HoverStyle>
                                    <DisabledStyle CssClass="buttonDisable">
                                    </DisabledStyle>
                      </dx:ASPxButton>
                      </div>
                     <div style="float:right">
                      <dx:ASPxButton ID="BAdd" runat="server" Text="Добавить" 
                             ValidationGroup="CreateEtalonMachineValidationGroup" onclick="BAdd_Click" 
                             AutoPostBack = "false" CssClass="button" EnableDefaultAppearance="False" 
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
                  </td>
            </tr>
        </table>
    </div>
</asp:Content>
