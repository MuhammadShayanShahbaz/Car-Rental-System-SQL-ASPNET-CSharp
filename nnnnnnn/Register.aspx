<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="nnnnnnn.Register"  MaintainScrollPositionOnPostback="true"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Container for the register form */
        .register-container {
            width: 400px;
            margin: 30px auto;
            border: 1px solid #ccc;
            padding: 25px;
            border-radius: 8px;
            background-color: #fff;
        }

        /* Centered heading */
        .register-container h2,
        .register-container p {
            text-align: center;
        }

        .register-container p {
            color: #666;
        }

        /* Inputs and dropdowns */
        .register-container .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        /* Buttons */
        .btn-register {
            background-color: #003366; /* Dark Blue */
            color: white;
            border: none;
            font-weight: bold;
            height: 40px;
            width: 100%;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-register:hover {
            background-color: #002244; /* Darker on hover */
        }

        /* Links */
        .register-container .back-link {
            text-align: center;
            margin-top: 10px;
        }

        .register-container .back-link a {
            text-decoration: none;
            color: #333;
        }

        /* Spacing */
        .register-container label,
        .register-container br {
            display: block;
        }

        .register-container .spacer {
            margin: 15px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="register-container">
        <h2>Register</h2>
        <p>Create a new customer account</p>
        <hr />

        <label>First Name:</label>
        <asp:TextBox ID="txtFirst" runat="server" CssClass="form-control"></asp:TextBox>
        <div class="spacer"></div>

        <label>Last Name:</label>
        <asp:TextBox ID="txtLast" runat="server" CssClass="form-control"></asp:TextBox>
        <div class="spacer"></div>

        <label>Email:</label>
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control"></asp:TextBox>
        <div class="spacer"></div>

        <label>Phone Number:</label>
        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
        <div class="spacer"></div>

        <label>Date of Birth:</label>
        <asp:TextBox ID="txtDOB" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
        <div class="spacer"></div>

        <label>Gender:</label>
        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
            <asp:ListItem Value="Male">Male</asp:ListItem>
            <asp:ListItem Value="Female">Female</asp:ListItem>
            <asp:ListItem Value="Other">Other</asp:ListItem>
        </asp:DropDownList>
        <div class="spacer"></div>

        <label>Username:</label>
        <asp:TextBox ID="txtUser" runat="server" CssClass="form-control"></asp:TextBox>
        <div class="spacer"></div>

        <label>Password:</label>
        <asp:TextBox ID="txtPass" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
        <div class="spacer"></div>

        <asp:Button ID="btnRegister" runat="server" Text="Sign Up" OnClick="btnRegister_Click" CssClass="btn-register" />

        <div class="spacer"></div>
        <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>

        <div class="back-link">
            <a href="Login.aspx">Back to Login</a>
        </div>
    </div>
</asp:Content>
