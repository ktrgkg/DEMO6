<?php
session_start();

if (!isset($_SESSION["password"]) || !isset($_SESSION["sdt"]) || !isset($_SESSION["chucdanh"]) || !isset($_SESSION["donvi"]) || !isset($_SESSION["ten_tk"])) {
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

        input {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
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
        input {
            width: 40%;
            padding: 8px;
            margin-bottom: 0px;
            /*box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;*/
        }

        .toggle-password {
            cursor: pointer;
            position: relative;
            left: 0px;
            top: 3px;
        }
        #table_user{
            width: 70%;
        }
    </style>
</head>
<body>

<div class="sidebar">
<div class="user-info">
        <h2>Xin chào, <?php echo $_SESSION["ten_tk"]; ?></h2>
        <div class="navigation">
            <a href="">Thông tin người dùng</a>
        </div>  
        </from> 
</div>
    <div class="navigation">
        <a href="quantri_user.php">Quản trị người dùng</a>
        <a href="#">Chức năng 2</a>
        <a href="#">Chức năng 3</a>
        <!-- Thêm các liên kết và chức năng của bạn ở đây -->
    </div>
    </div>    

<div class="content">
    <h1>Xin chào, <?php echo $_SESSION["username"]; ?></h1>
        <hr>
    <h2>Dữ liệu Quản Trị</h2>
    <table id="table_user">
        <th colspan="2">Thông tin tài khoản</th>
        <tr>
            <td>Tên người dùng: </td>
            <td><?php echo $_SESSION["ten_tk"]; ?></td>
        </tr>
        <tr>
            <td>Số điện thoại: </td>
            <td><?php echo $_SESSION["sdt"]; ?></td>
        </tr>
        <tr>
            <td>Đơn vị: </td>
            <td><?php echo $_SESSION["donvi"]; ?></td>
        </tr>
        <tr>
            <td>Chức danh: </td>
            <td><?php echo $_SESSION["chucdanh"]; ?></td>
        </tr>
        <tr>
            <td>Tài khoản: </td>
            <td><?php echo $_SESSION["username"]; ?></td>
        </tr>
        <tr>
            <td>Mặt khẩu: </td>
             <!-- Thêm icon hiển thị mật khẩu -->
            <td>
             <input type="password" id="password" value="<?php echo $_SESSION['password']; ?>" disabled>
             <span class="toggle-password" onclick="togglePasswordVisibility()">👁️</span></td>
            </tr>
    </table>
</div>
<script>
    function togglePasswordVisibility() {
        var passwordInput = document.getElementById("password");

        // Chuyển đổi giữa hiển thị và ẩn mật khẩu
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
        } else {
            passwordInput.type = "password";
        }
    }
</script>
</body>
</html>
