﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true"
    CodeBehind="CreateEtalonVLir.aspx.cs" Inherits="SandBox.WebUi.Pages.Information.CreateEtalonMachine" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" type="text/css" href="../../Content/PageView.css" />
    <div id="content-top">
        <div id="pagename">
            Добавление эталона ВЛИР <a href="/Pages/Information/Resources.aspx">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Content/Images/btn_back.jpg" CssClass="backbtn" />
            </a>
        </div>
    </div>
    <div id="content-main">
        <table class='form'>
            <tbody>
                <tr>
                    <td>
                        <div class="simple_text">
                            Имя эталона ВЛИР:</div>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="tbLir" runat="server" Width="200px">
                            <ValidationSettings ValidationGroup="CreateEtalonMachineValidationGroup">
                                <RequiredField ErrorText=" " IsRequired="true" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="simple_text">
                            Тип ОС:</div>
                    </td>
                    <td>
                        <dx:ASPxComboBox ID="cbSystem" runat="server" ValueType="System.String" Width="200px">
                            <ValidationSettings ValidationGroup="CreateEtalonMachineValidationGroup">
                                <RequiredField ErrorText=" " IsRequired="true" />
                            </ValidationSettings>
                        </dx:ASPxComboBox>
                    </td>
                </tr>
<%--                <tr>
                    <td>
                        <div class="simple_text">
                            Тип среды:</div>
                    </td>
                    <td>
                        <dx:ASPxComboBox ID="cbEnvType" runat="server" ValueType="System.String" Width="100px">
                            <ValidationSettings ValidationGroup="CreateEtalonMachineValidationGroup">
                                <RequiredField ErrorText=" " IsRequired="true" />
                            </ValidationSettings>
                        </dx:ASPxComboBox>
                    </td>
                </tr>--%>
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
                      <dx:ASPxButton ID="btnCreate" runat="server" Text="Добавить" 
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
