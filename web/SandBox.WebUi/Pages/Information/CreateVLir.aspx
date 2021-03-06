﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="CreateVLir.aspx.cs" Inherits="SandBox.WebUi.Pages.Information.CreateMachine" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" type="text/css" href="../../Content/PageView.css" />
    <div id="content-top">
        <div id="pagename">
            Создание ВЛИР <a href="/Pages/Information/Resources.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
        <table>
            <tbody>
                <tr>
                    <td>
                        <div class="simple_text">
                            Имя ВЛИР:</div>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbLir" runat="server" Width="200px">
                            <ValidationSettings ValidationGroup="CreateEtalonMachineValidationGroup" 
                                ErrorText="Неверное имя ВЛИР!">
                                <RegularExpression ErrorText="Имя может содержать только латинские буквы, цифры и знак _" 
                                    ValidationExpression="[a-zA-Z0-9_]*" />
                                <RequiredField ErrorText=" " IsRequired="true" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                        <dx:ASPxLabel ID="LValidation" runat="server" Visible="False">
                        </dx:ASPxLabel>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="simple_text">
                            Эталон ВЛИР:</div>
                    </td>
                    <td>
                                                <dx:ASPxComboBox ID="cbEtalon" runat="server" Width="200px" ShowLoadingPanel="False"
                                                    ClientInstanceName="cbEtalon" AutoResizeWithContainer="True" ValueField="Id" TextFormatString="{0}"
                                                    IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="Name" Caption="Имя" />
                                                        <dx:ListBoxColumn FieldName="System" Caption="Система" Width="200px" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
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
                      <dx:ASPxButton ID="btnCreate" runat="server" Text="Создать" 
                             ValidationGroup="CreateEtalonMachineValidationGroup" onclick="BtnCreateClick" 
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
            </tbody>
        </table>
    </div>
</asp:Content>
