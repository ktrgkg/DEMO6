<?php
session_start();

if (!isset($_SESSION["sdt"]) || !isset($_SESSION["chucdanh"]) || !isset($_SESSION["donvi"]) || !isset($_SESSION["ten_tk"]) || !isset($_SESSION["username"]) || $_SESSION["role"] != 1) {
    header("Location: index.php"); // Chuyển hướng nếu không đăng nhập hoặc không phải quản trị
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Quản Trị</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            display: flex;
        }

        .sidebar {
            width: 20%;
            height: 100vh;
            background-color: #3498db;
            color: #fff;
            padding: 20px;
            box-sizing: border-box;
            overflow: hidden;
        }

        .sidebar h2 {
            margin-bottom: 10px;
        }
        .user-info {
            margin-bottom: 20px;
        }

        .user-info p {
            margin: 0;
            padding: 5px;
            border-bottom: 1px solid #fff;
        }

        .navigation {
            margin-top: 20px;
        }

        .navigation a {
            display: block;
            color: #fff;
            text-decoration: none;
            padding: 10px;
            border-bottom: 1px solid #fff;
            transition: background-color 0.3s;
        }

        .navigation a:hover {
            background-color: #2980b9;
        }

        .user-form {
            display: none;
            padding: 20px;
            background-color: #fff;
            color: #333;
            border-radius: 8px;
            margin-top: 20px;
        }

        label {
            width: 20%;
            float:center;
            padding: 30px;
            margin-left:30%;
            margin-right:0px;
        }
        #thang{
            padding: 10px;
        }
        #nam{
            padding: 10px;
            margin-left:10px;
            margin-bottom:10px;
        }
        select {
            width: 10%;
            text-align: center;
        }
        form{
            width: 100%;
            padding: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .toggle-password {
            cursor: pointer;
            position: relative;
            left: -25px;
            top: 10px;
        }

        .content {
            width: 80%;
            padding: 20px;
        }

        h1 {
            color: #333;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #3498db;
            color: #fff;
        }
        #file{
            background-color: #fff;
            margin-left: 0%;
            color: #333;
        }
        input{
        background-color: #3498db;
        color: white;
        font-size: 14px;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
    }
    #exit{
        margin-left: 40%;
        margin-top:10px;
    }
    #tieude{
        border: none;
        border-top: 1px solid #ddd;
        border-left: 1px solid #ddd;
        border-right: 1px solid #ddd;
        margin-bottom: 0px;
        background-color: #3498db;
        color: white;
    }

    </style>
</head>
<body>

<div class="sidebar">
<div class="user-info">
        <h2>Xin chào, <?php echo $_SESSION["ten_tk"]; ?></h2>
        <div class="navigation">
            <a href="function/thongtin_user.php">Thông tin người dùng</a>
        </div>  
        </from> 
</div>
    <div class="navigation">
        <a href="function/quantri_user.php">Quản trị người dùng</a>
        <a href="function/dl_dc_109.php">Dữ liệu đặc cọc 109</a>
        <a href="#">Chức năng 3</a>
        <!-- Thêm các liên kết và chức năng của bạn ở đây -->
    </div>
    </div>    
<div class="content">
    <h1>Xin chào, <?php echo $_SESSION["username"]; ?></h1>
        <hr color="rgb(0,0,255)">
    <h2>Dữ liệu Quản Trị</h2>
    <form id="tieude">Upload file đặc cọc</form>
    <form action="../db/upload_109.php" method="post" enctype="multipart/form-data">
    <label for="nam">Chọn năm:</label>
    <select name="nam" id="nam">
        <option value="2023">2023</option>
        <option value="2024">2024</option>
    </select>    
    <br>
    <label for="thang">Chọn tháng:</label>
    <select name="thang" id="thang">
        <option value="01">Tháng 1</option>
        <option value="02">Tháng 2</option>
        <option value="03">Tháng 3</option>
        <option value="04">Tháng 4</option>
        <option value="05">Tháng 5</option>
        <option value="06">Tháng 6</option>
        <option value="07">Tháng 7</option>
        <option value="08">Tháng 8</option>
        <option value="09">Tháng 9</option>
        <option value="10">Tháng 10</option>
        <option value="11">Tháng 11</option>
        <option value="12">Tháng 12</option>
        <!-- Thêm các tháng khác tùy vào nhu cầu của bạn -->
    </select>
    <br>
    <label for="file">Chọn file:</label>
    <input type="file" name="file" id="file">
    <br>
    <input id="exit" type="submit" value="Quay lại">
    <input type="submit" value="Upload">
    </form>
    <form>
        <h2>lịch sử upload</h2>
      
    </form>
</div>

</body>
</html>
