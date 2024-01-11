<?php
// Kết nối đến cơ sở dữ liệu
session_start();

if (!isset($_SESSION["sdt"]) || !isset($_SESSION["chucdanh"]) || !isset($_SESSION["donvi"]) || !isset($_SESSION["ten_tk"]) || !isset($_SESSION["username"]) || $_SESSION["role"] != 1) {
    header("Location: index.php"); // Chuyển hướng nếu không đăng nhập hoặc không phải quản trị
    exit();
}
$conn = mysqli_connect("localhost", "root", "", "demo6");

if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
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
        button{
        background-color: #3498db;
        color: white;
        font-size: 16px;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
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
        <a href="dl_dc_109.php">Dữ liệu đặc cọc 109</a>
        <a href="#">Chức năng 3</a>
        <!-- Thêm các liên kết và chức năng của bạn ở đây -->
    </div>
    </div>    
<div class="content">
    <h1>Xin chào, <?php echo $_SESSION["username"]; ?></h1>
        <hr color="rgb(0,0,255)">
    <h2>Dữ liệu Quản Trị</h2>
    <!--<a href="them_tai_khoan.php"><button>Thêm</button></a>-->
    <div style="text-align: right;">
    <button type="button" onclick="redirectToPage('them_user.php')" >
            Thêm người dùng
        </button>
        </div>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Số điện thoại</th>
            <th>Đơn Vị</th>
            <th>Chức danh</th>
            <th>Tài khoản</th>
            <th>Mặt khẩu</th>
            <!-- Thêm các cột khác tùy vào dữ liệu của bạn -->
        </tr>
        </thead>
        <tbody>
        <?php
        $page = isset($_GET['page']) ? $_GET['page'] : 1;
        $rowsPerPage = 10;
        $offset = ($page - 1) * $rowsPerPage;
        // Hiển thị dữ liệu từ cơ sở dữ liệu ở đây
        // Truy vấn để lấy thông tin tất cả các tài khoản
$sql = "SELECT * FROM tai_khoan";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Hiển thị dữ liệu trong bảng
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . $row["id"] . "</td>";
        echo "<td>" . $row["ten_tk"] . "</td>";
        echo "<td>" . $row["sdt"] . "</td>";
        echo "<td>" . $row["donvi"] . "</td>";
        echo "<td>" . $row["chucdanh"] . "</td>";
        echo "<td>" . $row["user"] . "</td>";
        echo "<td>" . $row["pass"] . "</td>";
        // Thêm các cột khác tùy vào dữ liệu của bạn
        echo "</tr>";
    }
} else {
    echo "Không có dữ liệu";
}

$conn->close();
        ?>
        </tbody>
    </table>
</div>
<script>
    function redirectToPage(pageURL) {
        window.location.href = pageURL;
    }
</script>
</body>
</html>