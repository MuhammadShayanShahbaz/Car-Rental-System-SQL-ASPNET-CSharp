<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="nnnnnnn.login"  MaintainScrollPositionOnPostback="true"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

        <style>
body {
    margin: 0;
    padding: 0;
    position: relative;
    font-family: Arial;

    /* Darkened background */
    background: 
        linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
        url('background/background.jpeg') bottom center no-repeat fixed;
    background-size: cover;
}




        /* Login Page Styles */
        .login-container {
            min-height: calc(100vh - 200px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            background: linear-gradient(135deg, #f0f8ff 0%, #e6f2ff 100%);
        }
        
        .login-box {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 32, 96, 0.15);
            padding: 40px;
            width: 100%;
            max-width: 420px;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(0, 32, 96, 0.1);
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }
        
        .login-icon {
            background: linear-gradient(135deg, #002060, #0040a0);
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: white;
            font-size: 2rem;
            box-shadow: 0 5px 15px rgba(0, 32, 96, 0.2);
        }
        
        .login-title {
            color: #002060;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .login-subtitle {
            color: #666;
            font-size: 0.95rem;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e1e5eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-sizing: border-box;
            font-family: inherit;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #002060;
            box-shadow: 0 0 0 3px rgba(0, 32, 96, 0.1);
        }
        
        .login-button {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #002060, #0040a0);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            font-family: inherit;
        }
        
        .login-button:hover {
            background: linear-gradient(135deg, #001850, #003080);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 32, 96, 0.2);
        }
        
        .register-button {
            width: 100%;
            padding: 16px;
            background: #0040a0;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 15px;
            font-family: inherit;
        }
        
        .register-button:hover {
            background: #002060;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.2);
        }
        
        .message-box {
            margin-top: 20px;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .error-message {
            background: #fff5f5;
            color: #e53e3e;
            border: 1px solid #fc8181;
        }
        
        .success-message {
            background: #f0fff4;
            color: #38a169;
            border: 1px solid #9ae6b4;
        }
        
        .form-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e1e5eb;
            color: #666;
            font-size: 0.9rem;
        }
        
        .form-footer a {
            color: #002060;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .form-footer a:hover {
            color: #FF6B35;
        }
        
        .input-with-icon {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 1.1rem;
        }
        
        .input-with-icon .form-input {
            padding-left: 45px;
        }
        
        /* Animation for the login box */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-box {
            animation: fadeInUp 0.5s ease-out;
        }
        
        /* Responsive adjustments */
        @media (max-width: 480px) {
            .login-box {
                padding: 30px 20px;
                margin: 0 10px;
            }
            
            .login-title {
                font-size: 1.7rem;
            }
            
            .login-icon {
                width: 70px;
                height: 70px;
                font-size: 1.8rem;
            }
        }
        
        /* Focus states for accessibility */
        .login-button:focus,
        .register-button:focus,
        .form-input:focus {
            outline: 2px solid #002060;
            outline-offset: 2px;
        }

</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="width: 300px; margin: 120px auto; border: 1px solid #ccc; padding: 20px; border-radius: 5px; 
        background-color:white">
        <h2>User Login</h2>
        
        <label>Username:</label><br />
        <asp:TextBox ID="txtUsername" runat="server" Width="97%"></asp:TextBox>
        <br /><br />

        <label>Password:</label><br />
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="97%"></asp:TextBox>
        <br /><br />

        <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" BackColor="#333" ForeColor="White" Height="30px" Width="100%" />
        <asp:Button ID="btnGoToRegister" runat="server" Text="Create New Account" OnClick="btnGoToRegister_Click" 
            BackColor="blue" ForeColor="White" Height="40px" Width="100%" BorderStyle="None" Font-Bold="true" />
        <br /><br />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
    </div>
</asp:Content>
