<%@ Page Language="C#" AutoEventWireup="True" MasterPageFile="~/Empty.master" CodeBehind="Login.aspx.cs" Inherits="SandBox.WebUi.Account.Login" Title="бУНД" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div id="loginbox" class="vpanel">
    <table width="524" border="0" cellpadding="9" cellspacing="0">
      <tr>
        <td align="center" id="loginhr">хмтнплюжхнммн-юмюкхрхвеяйюъ<br>
          яхярелю лнмхрнпхмцю бон</td>
      </tr>
      <tr>
        <td id="logincr"><table border="0" cellspacing="0" cellpadding="10">
            <tr>
              <td width="40" rowspan="3">&nbsp;</td>
              <td width="300">кнцхм<br>
                          <dx:ASPxTextBox ID="tbUserName" runat="server" Width="350px">
	        <ValidationSettings ValidationGroup="LoginUserValidationGroup" ErrorTextPosition="Bottom" SetFocusOnError="True">
	         <RequiredField ErrorText=" " IsRequired="true" />
	        </ValidationSettings>
	      </dx:ASPxTextBox>
</td>
              <td width="40" rowspan="3">&nbsp;</td>
            </tr>
            <tr>
              <td>оюпнкэ<br>
          <dx:ASPxTextBox ID="tbPassword" runat="server" Password="true" Width="350px">
	       <ValidationSettings ValidationGroup="LoginUserValidationGroup" ErrorTextPosition="Bottom" SetFocusOnError="True">
	         <RequiredField ErrorText=" " IsRequired="true" />
	       </ValidationSettings>
	      </dx:ASPxTextBox>
                </td>
            </tr>
            <tr>
              <td><span style="float:left">
                <input name="rememberme" id="rememberme" type="checkbox" runat="server" value="0" />
                гЮОНЛМХРЭ ЛЕМЪ</span><span style="float:right">
                        <dx:ASPxButton ID="btnLogin" AutoPostBack="False" runat="server" 
                            Text="бНИРХ" onclick="btnLogin_Click" CssClass="button" Native="True" ValidationGroup="LoginUserValidationGroup"
                            HoverStyle-CssClass="buttonHover" ClientIDMode="Inherit" EnableDefaultAppearance="True" EnableTheming="True" EnableViewState="True" EncodeHtml="True" SkinID="btnLogin" Height="25px">
                            <PressedStyle CssClass="buttonHover">
                            </PressedStyle>
                            <HoverStyle CssClass="buttonHover">
                            </HoverStyle>
                            <Border BorderColor="Gainsboro" BorderStyle="Solid" BorderWidth="1px" />
                            <DisabledStyle CssClass="buttonDisable">
                            </DisabledStyle>
                        </dx:ASPxButton>
                </span></td>
            </tr>
          </table></td>
      </tr>
    </table>
  </div>
</asp:Content>