<?php
session_start();
$loginError = ""; // Khởi tạo biến thông báo lỗi

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Kết nối đến cơ sở dữ liệu
    $conn = mysqli_connect("localhost", "root", "", "demo6");

    if ($conn->connect_error) {
        die("Kết nối thất bại: " . $conn->connect_error);
    }

    // Lấy thông tin đăng nhập từ form
    $username = $_POST["username"];
    $password = $_POST["password"];

    // Kiểm tra thông tin đăng nhập
    $sql = "SELECT * FROM tai_khoan WHERE user='$username' AND pass='$password'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        // Lưu thông tin người dùng vào session
        $_SESSION["user_id"] = $row["id"];
        $_SESSION["sdt"] = $row["sdt"];
        $_SESSION["ten_tk"] = $row["ten_tk"];
        $_SESSION["username"] = $row["user"];
        $_SESSION["password"] = $row["pass"];
        $_SESSION["donvi"] = $row["donvi"];
        $_SESSION["chucdanh"] = $row["chucdanh"];
        $_SESSION["role"] = $row["role"];

        // Chuyển hướng dựa trên role
        switch ($row["role"]) {
            case 0:
                header("Location: nguoidung.php");
                break;
            case 1:
                header("Location: quantri.php");
                break;
            case 2:
                header("Location: trangkhac.php");
                break;
            default:
                // Xử lý nếu role không khớp với bất kỳ trường hợp nào
                break;
        }
    } else {
        $loginError = "Tên đăng nhập hoặc mật khẩu không đúng"; // Gán giá trị cho biến thông báo lỗi
    }

    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: rgba(52, 152, 219, 0.8); /* Màu xanh trong suốt */
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .login-container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 350px; /* Điều chỉnh chiều rộng */
        }

        .login-header {
            background-color: #3498db;
            color: #fff;
            text-align: center;
            padding: 15px;
        }

        .login-form {
            padding: 20px;
        }

        .login-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .login-form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .login-form button {
            background-color: #3498db;
            color: #fff;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        .login-form button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-header">
        <h2>Đăng Nhập</h2>
    </div>
    <form action="login.php" method="post">
    <div class="login-form">
    
        <label for="username">Tên đăng nhập:</label>
        <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập">

        <label for="password">Mật khẩu:</label>
        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu">

        <button type="submit">Đăng Nhập</button>
        
        <?php if ($loginError): ?>
            <div style="color: red; text-align: center; margin-top:10px"><?php echo $loginError; ?></div>
        <?php endif; ?>
    </div>
    </form>
</div>

</body>
</html>
