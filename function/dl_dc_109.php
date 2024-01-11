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
        <a href="#">Dữ liệu đặc cọc 109</a>
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
    <button type="button" onclick="redirectToPage('giaodien_upload_109.php')" >
            Upload dữ liệu
        </button>
        <button type="button" onclick="redirectToPage('upload_109.php')" >
            Upload dữ liệu
        </button>
        </div>
    <table>
        <thead>
        <tr>
            <th>Stt</th>
            <th>Tên thuê bao</th>
            <th>Địa chỉ</th>
            <th>Mã thuê bao</th>
            <th>Mã số thuế</th>
            <th>Số tháng</th>
            <th>Tháng bắt đầu trừ</th>
            <th>Tháng kết thúc trừ</th>
            <th>Người cập nhật</th>
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
        // Truy vấn để lấy thông tin từ bảng da với điều kiện trạng thái là "đặt cọc đang hiệu lực"
        $sql = "SELECT stt, ten_tb, diachi_tb, ma_tb, mst_kh, sothang, thang_bdtru, thang_kttru, nguoi_cn FROM da WHERE hieuluc = 'đặt cọc đang hiệu lực' LIMIT $offset, $rowsPerPage";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $totalRows = 100;
        $totalPages = ceil($totalRows / $rowsPerPage);

        $offset = ($page - 1) * $rowsPerPage;

        $sql = "SELECT stt, ten_tb, diachi_tb, ma_tb, mst_kh, sothang, thang_bdtru, thang_kttru, nguoi_cn FROM da WHERE hieuluc = 'đặt cọc đang hiệu lực' LIMIT $offset, $rowsPerPage";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
           
        
            while ($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td>" . $row["stt"] . "</td>";
                echo "<td>" . $row["ten_tb"] . "</td>";
                echo "<td>" . $row["diachi_tb"] . "</td>";
                echo "<td>" . $row["ma_tb"] . "</td>";
                echo "<td>" . $row["mst_kh"] . "</td>";
                echo "<td>" . $row["sothang"] . "</td>";
                echo "<td>" . $row["thang_bdtru"] . "</td>";
                echo "<td>" . $row["thang_kttru"] . "</td>";
                echo "<td>" . $row["nguoi_cn"] . "</td>";
                echo "</tr>";
            }
        
            echo "</tbody>";
            echo "</table>";
        
            // Hiển thị phân trang
            echo "<div class='pagination'>";
            for ($i = 1; $i <= $totalPages; $i++) {
                echo "<a href='dl_dc_109.php?page=$i'>$i</a>";
            }
            echo "</div>";
        } else {
            echo "<p>Không có dữ liệu</p>";
        }
        
        $conn->close();
        ?>
</div>
<script>
    function redirectToPage(pageURL) {
        window.location.href = pageURL;
    }
</script>
</body>
</html>