<%@ Page Title="Premium Car Rentals" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="nnnnnnn.Home" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* MAIN HERO */
        .hero-section {
            background: linear-gradient(rgba(0, 32, 96, 0.85), rgba(0, 20, 60, 0.9)),
                        url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?auto=format&fit=crop&w=1600&q=80');
            background-size: cover;
            background-position: center;
            padding: 130px 0;
            display: flex;
            align-items: center;
            color: white;
            position: relative;
        }

        .hero-container {
            max-width: 1500px;
            margin: 0 auto;
            padding: 0 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .hero-subtitle {
            font-size: 1.3rem;
            opacity: 0.9;
            margin-bottom: 30px;
        }

        .hero-buttons a {
            padding: 14px 32px;
            border-radius: 8px;
            font-size: 1.15rem;
            font-weight: 600;
            text-decoration: none;
            transition: 0.3s;
            display: inline-block;
        }

        .btn-primary {
            background-color: #FF6B35;
            color: #fff;
        }
        .btn-primary:hover { background-color: #e55524; }

        .btn-secondary {
            border: 2px solid #ffffff80;
            color: white;
        }
        .btn-secondary:hover { background: #ffffff20; }

        .hero-image img {
            width: 520px;
            filter: drop-shadow(0 12px 25px rgba(0,0,0,0.4));
            border-radius: 15px;
        }

        /* SECOND HERO – Rent a Car */
        .rent-section {
            padding: 100px 20px;
            background: #f5f5f5;
        }

        .rent-container {
            max-width: 1200px;
            margin: auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
        }

        .rent-text h2 {
            font-size: 3rem;
            color: #222;
            font-weight: 700;
        }

        .rent-text p {
            font-size: 1.2rem;
            color: #555;
            line-height: 1.7;
        }

        .rent-text a {
            display: inline-block;
            margin-top: 20px;
            padding: 14px 30px;
            background: #003366;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .rent-text a:hover {
            background: #002244;
        }

        .rent-image img {
            width: 100%;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.25);
        }

        /* HIGHLIGHTS */
        .highlight-section {
            padding: 80px 20px;
            background: white;
            text-align: center;
        }

        .highlight-title {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 50px;
        }

        .highlight-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
        }

        .highlight-box {
            padding: 30px;
            background: #fafafa;
            border-radius: 10px;
            border: 1px solid #ddd;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            transition: 0.3s;
        }

        .highlight-box:hover {
            transform: translateY(-5px);
        }

        .highlight-box span {
            font-size: 3rem;
            display: block;
            margin-bottom: 15px;
        }

        @media (max-width: 900px) {
            .rent-container {
                grid-template-columns: 1fr;
            }
            .highlight-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .hero-container {
                flex-direction: column;
                text-align: center;
            }
            .hero-title { font-size: 3rem; }
            .hero-image img { width: 350px; margin-top: 30px; }
        }
    </style>
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- MAIN HERO -->
    <section class="hero-section">
        <div class="hero-container">
            <div>
                <h1 class="hero-title">Drive Your Dream Car Today</h1>
                <p class="hero-subtitle">
                    Premium, affordable, and fast car rentals. Choose from luxury, sports, economy, SUVs, 
                    and more — all available within minutes.
                </p>

                <div class="hero-buttons">
                    <a href="RentaCar.aspx" class="btn-primary">Browse Available Cars</a>
                    <a href="About.aspx" class="btn-secondary">Why Choose Us?</a>
                </div>
            </div>

            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1553440569-bcc63803a83d?auto=format&fit=crop&w=900&q=80" />
            </div>
        </div>
    </section>



    <!-- RENT A CAR SECTION -->
    <section class="rent-section">
        <div class="rent-container">
            <div class="rent-text">
                <h2>Rent a Car in Just 2 Minutes</h2>
                <p>
                    Choose your car, select your dates, and confirm your booking instantly.  
                    Our rental system is fast, secure, and convenient — perfect for daily use, travel, events, 
                    business trips, and weekend getaways.
                </p>
                <a href="SearchCars.aspx">Rent a Car Now</a>
            </div>

            <div class="rent-image">
                <img src="https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80" />
            </div>
        </div>
    </section>
        <section style="padding: 80px 20px; background:#f8f9fb;">
    <h2 style="text-align:center; font-size:2.8rem; margin-bottom:50px; color:#222; font-weight:700;">
        Explore Our Car Categories
    </h2>

    <div style="
        max-width:1200px; margin:auto; 
        display:grid; 
        grid-template-columns:repeat(auto-fit, minmax(250px, 1fr)); 
        gap:30px;
    ">

        <div style="
            background:white; padding:30px; border-radius:12px;
            box-shadow:0 4px 12px rgba(0,0,0,0.08);
            text-align:center; transition:.3s;
        " onmouseover="this.style.transform='translateY(-5px)';"
          onmouseout="this.style.transform='translateY(0)';">
            <div style="font-size:3rem;">🚙</div>
            <h3 style="margin:10px 0; font-size:1.5rem;">SUVs</h3>
            <p>Spacious and strong vehicles for family trips and adventures.</p>
        </div>

        <div style="
            background:white; padding:30px; border-radius:12px;
            box-shadow:0 4px 12px rgba(0,0,0,0.08);
            text-align:center; transition:.3s;
        " onmouseover="this.style.transform='translateY(-5px)';"
          onmouseout="this.style.transform='translateY(0)';">
            <div style="font-size:3rem;">🚗</div>
            <h3 style="margin:10px 0; font-size:1.5rem;">Sedans</h3>
            <p>Comfortable and stylish cars perfect for city or long drives.</p>
        </div>

        <div style="
            background:white; padding:30px; border-radius:12px;
            box-shadow:0 4px 12px rgba(0,0,0,0.08);
            text-align:center; transition:.3s;
        " onmouseover="this.style.transform='translateY(-5px)';"
          onmouseout="this.style.transform='translateY(0)';">
            <div style="font-size:3rem;">🏎️</div>
            <h3 style="margin:10px 0; font-size:1.5rem;">Sports Cars</h3>
            <p>Experience speed and excitement with our premium sports models.</p>
        </div>

        <div style="
            background:white; padding:30px; border-radius:12px;
            box-shadow:0 4px 12px rgba(0,0,0,0.08);
            text-align:center; transition:.3s;
        " onmouseover="this.style.transform='translateY(-5px)';"
          onmouseout="this.style.transform='translateY(0)';">
            <div style="font-size:3rem;">🚐</div>
            <h3 style="margin:10px 0; font-size:1.5rem;">Vans</h3>
            <p>Great for group travel, tours, and business transportation.</p>
        </div>

    </div>
</section>



    <!-- HIGHLIGHTS -->
    <section class="highlight-section">
        <h2 class="highlight-title">Why People Choose Us</h2>

        <div class="highlight-grid">

            <div class="highlight-box">
                <span>🚗</span>
                <h3>New Models</h3>
                <p>We offer clean and highly maintained vehicles.</p>
            </div>

            <div class="highlight-box">
                <span>🕒</span>
                <h3>Fast Booking</h3>
                <p>Book your car within 2 minutes — no hassle.</p>
            </div>

            <div class="highlight-box">
                <span>💳</span>
                <h3>Online Payments</h3>
                <p>Pay securely using our automated system.</p>
            </div>

            <div class="highlight-box">
                <span>⭐</span>
                <h3>Top Rated</h3>
                <p>Our customers love our reliable service.</p>
            </div>

        </div>
    </section>
    
</asp:Content>
