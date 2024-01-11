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

        input {
            width: 50%;
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
          /*  border: 1px solid #ddd; */
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #3498db;
            color: #fff;
        }
        #addUserForm{
            width: 100%;
        }
        .password-container {
            position: relative;
            width: 100%;
        }

        .password-input {
            width: 50%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .password-icon {
            position: absolute;
            top: 40%;
            right: 30%;
            transform: translateY(-50%);
            cursor: pointer;
        }
        button{
        background-color: #3498db;
        color: white;
        font-size: 16px;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        margin-top: 5px;
    }
    </style>
</head>
<body>

<div class="sidebar">
<div class="user-info">
        <h2>Xin chào, <?php echo $_SESSION["ten_tk"]; ?></h2>
        <div class="navigation">
            <a href="thongtin_user.php">Thông tin người dùng</a>
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
        <hr color="rgb(0,0,255)">
        <h2>Thêm Người Dùng</h2>
        <form action="../db/upload_109.php" method="post" enctype="multipart/form-data">
        <label for="file">Chọn file Excel:</label>
        <input type="file" name="file" id="file" accept=".xls, .xlsx">

        <button type="submit" name="submit">Upload</button>
    </form>

</div>
<script>
    function togglePasswordVisibility(passwordId) {
        var passwordInput = document.getElementById(passwordId);
        passwordInput.type = passwordInput.type === 'password' ? 'text' : 'password';
    }

    function validateAndSubmit() {
        var form = document.getElementById('addUserForm');
        var isValid = form.checkValidity();

        if (isValid) {
            // Thực hiện gửi dữ liệu lên máy chủ
            alert('Dữ liệu hợp lệ, có thể thực hiện gửi dữ liệu lên máy chủ.');
            // Thêm mã xử lý gửi dữ liệu lên máy chủ ở đây
        } else {
            alert('Vui lòng nhập đầy đủ thông tin và kiểm tra lại các trường.');
        }
    }
</script>
</body>
</html>
