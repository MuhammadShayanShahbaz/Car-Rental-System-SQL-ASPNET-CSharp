<%@ Page Title="Rent A Car" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="RentaCar.aspx.cs" Inherits="nnnnnnn.RentaCar"  MaintainScrollPositionOnPostback="true"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- General Typography --- */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #222;
            margin-bottom: 10px;
        }

        p {
            font-size: 1rem;
            color: #666;
        }

        /* --- Filter Section Styling --- */
        .filter-section {
            background: #fff;
            padding: 25px 30px;
            margin: 30px auto;
            max-width: 1200px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            align-items: flex-end;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .filter-section:hover {
            box-shadow: 0 12px 25px rgba(0,0,0,0.12);
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            min-width: 180px;
        }

        .filter-label {
            font-size: 0.85rem;
            color: #555;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control-custom {
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control-custom:focus {
            border-color: #007bff;
            box-shadow: 0 0 6px rgba(0, 123, 255, 0.25);
            outline: none;
        }

        .btn-search {
            background: linear-gradient(45deg, #007bff, #0056b3);
            color: white;
            padding: 12px 35px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1rem;
            height: 45px;
            transition: all 0.3s ease;
        }

        .btn-search:hover {
            background: linear-gradient(45deg, #0056b3, #003f7f);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }

        /* --- Car Grid Layout --- */
        .car-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto 50px auto;
        }

        /* --- Car Card Styling --- */
        .car-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            background: #fff;
            display: flex;
            flex-direction: column;
        }

        .car-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }

        .image-wrapper {
            position: relative;
            width: 100%;
            height: 220px;
            overflow: hidden;
        }

        .car-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .car-card:hover .car-image {
            transform: scale(1.08);
        }

        .category-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #0042a9, #007bff);
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }

        .car-details {
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-grow: 1;
            text-align: center;
        }

        .car-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: #222;
            margin-bottom: 5px;
        }

        .car-specs {
            color: #777;
            font-size: 0.95rem;
            margin-bottom: 15px;
        }

        .car-price {
            color: #28a745;
            font-weight: 800;
            font-size: 1.3rem;
            margin-bottom: 15px;
        }

        .btn-rent {
            background: linear-gradient(45deg, #0056b3, #007bff);
            color: white;
            padding: 12px 0;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: all 0.3s ease;
            display: block;
            width: 100%;
        }

        .btn-rent:hover {
            background: linear-gradient(45deg, #007bff, #0056b3);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }

        /* --- No Results Styling --- */
       .no-results {
    grid-column: 1 / -1;
    text-align: center;
    padding: 60px 20px;
    font-size: 1.2rem;
    color: #dc3545;
    font-weight: 600;
}

    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div style="text-align: center; margin-top: 40px;">
        <h2>Find Your Perfect Ride</h2>
        <p style="color: #666;">Browse our fleet of premium vehicles</p>
    </div>

    <div class="filter-section">
        
        <div class="filter-group">
            <span class="filter-label">Search</span>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control-custom" placeholder="e.g. BMW, Civic"></asp:TextBox>
        </div>

        <div class="filter-group">
            <span class="filter-label">Category</span>
            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control-custom">
                <asp:ListItem Value="All">All Categories</asp:ListItem>
                <asp:ListItem Value="Sedan">Sedan</asp:ListItem>
                <asp:ListItem Value="SUV">SUV</asp:ListItem>
                <asp:ListItem Value="Luxury">Luxury</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="filter-group">
            <span class="filter-label">Sort By Price</span>
            <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-control-custom">
                <asp:ListItem Value="Default">Latest</asp:ListItem>
                <asp:ListItem Value="PriceLow">Low to High</asp:ListItem>
                <asp:ListItem Value="PriceHigh">High to Low</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="filter-group">
            <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" CssClass="btn-search" OnClick="btnFilter_Click" />
        </div>

    </div>

    <div class="car-container">
        
        <asp:Label ID="lblNoResults" CssClass="no-results"  runat="server" Text="No cars found matching your search." 
            Visible="false" ForeColor="Red" Font-Bold="true" Font-Size="Large" style="grid-column: 1/-1; text-align:center; padding: 50px;">
        </asp:Label>

        <asp:Repeater ID="rptCars" runat="server">
            <ItemTemplate>
                <div class="car-card">
                    
                    <a href="cardetails.aspx?CarID=<%# Eval("CarID") %>" class="image-wrapper">
                        <img src='<%# ResolveUrl(Eval("CarImage").ToString()) %>' alt="Car Image" class="car-image" />
                        <span class="category-badge"><%# Eval("TypeName") %></span>
                    </a>
                    
                    <div class="car-details">
                        <div>
                            <div class="car-title">
                                <%# Eval("Brand") %> <%# Eval("Model") %>
                            </div>
                            <div class="car-specs">
                                Year: <%# Eval("Year") %> &bull; <%# Eval("Transmission") %> &bull; <%# Eval("FuelType") %>
                            </div>
                        </div>
                        
                        <div>
                            <div class="car-price">
                                PKR <%# Eval("DailyRate", "{0:N0}") %> <span style="font-size:0.8rem; color:#888; font-weight:normal;">/ day</span>
                            </div>
                            
                            <a href="reservation.aspx?CarID=<%# Eval("CarID") %>" class="btn-rent">Book Now</a>
                        </div>
                    </div>

                </div>
            </ItemTemplate>
        </asp:Repeater>

    </div>

</asp:Content>