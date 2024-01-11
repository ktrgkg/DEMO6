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
        .hidden {
            display: none;
        }
        li{
            margin:10px;
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
        <a onclick="toggleList()">Báo cáo
        <ul id="myList" class="hidden">
            <li ><a href="function/baocao_dthu_dvi.php">Báo cáo doanh thu theo đơn vị</a></li>
            <li>Phần tử 2</li>
            <li>Phần tử 3</li>
        </ul>
        </a>
        <!-- Thêm các liên kết và chức năng của bạn ở đây -->
    </div>
    </div>    
<div class="content">
    <h1>Xin chào, <?php echo $_SESSION["username"]; ?></h1>
        <hr color="rgb(0,0,255)">
        <tbody>
        <?php
// Kết nối đến CSDL
$conn = mysqli_connect("localhost", "root", "", "demo6");

if (!$conn) {
    die("Kết nối không thành công: " . mysqli_connect_error());
}
// Xử lý dữ liệu được gửi từ form
$nam = isset($_GET['nam']) ? $_GET['nam'] : 'all';
$thang = isset($_GET['thang']) ? $_GET['thang'] : 'all';
$donvi = isset($_GET['donvi']) ? $_GET['donvi'] : 'all';
$loai_tb = isset($_GET['loai_tb']) ? $_GET['loai_tb'] : 'all';

// Xây dựng câu truy vấn dựa trên dữ liệu đã chọn và điều kiện trạng thái
$query = "SELECT * FROM da WHERE 1";

if ($nam !== 'all') {
    $query .= " AND nam = '$nam'";
}

if ($thang !== 'all') {
    $query .= " AND thang = '$thang'";
}

if ($donvi !== 'all') {
    $query .= " AND donvi = '$donvi'";
}

if ($loai_tb !== 'all') {
    $query .= " AND loai_tb = '$loai_tb'";
}

// Thêm điều kiện trạng thái là "đặt cọc đang hiệu lực"
$query .= " AND hieuluc = 'đặt cọc đang hiệu lực'";

// Thực hiện truy vấn
$result = mysqli_query($conn, $query);

// Kiểm tra xem có dữ liệu hay không
if ($result && mysqli_num_rows($result) > 0) {
    // Số dòng trên mỗi trang
    $rowsPerPage = 15;

    // Tính số trang dựa trên số dòng và số dòng trên mỗi trang
    $totalPages = ceil(mysqli_num_rows($result) / $rowsPerPage);

    // Xác định trang hiện tại
    $currentPage = isset($_GET['page']) ? (int)$_GET['page'] : 1;

    // Xác định dòng bắt đầu của trang hiện tại
    $startRow = ($currentPage - 1) * $rowsPerPage;

    // Thêm LIMIT vào truy vấn để chỉ lấy các dòng của trang hiện tại
    $query .= " LIMIT $startRow, $rowsPerPage";
    $result = mysqli_query($conn, $query);
    echo "<h2>Kết quả tìm kiếm</h2>";
    
    // Tạo bảng HTML
    echo "<table>";
    echo "<tr>
            <th>STT</th>
            <th>Tên</th>
            <th>Địa chỉ</th>
            <th>Mã TB</th>
            <th>Mã số thuế</th>
            <th>Đơn vị</th>
            <th>Loại thuê bao</th>
            <th>Số tháng</th>
            <th>Tháng BD trừ</th>
            <th>Tháng KT trừ</th>
            <th>Người cập nhật</th>
            </tr>";

    // Lặp qua kết quả và hiển thị dữ liệu
    while ($row = mysqli_fetch_assoc($result)) {
        echo "<tr>";
        echo "<td>" . $row['stt'] . "</td>";
        echo "<td>" . $row['ten_tb'] . "</td>";
        echo "<td>" . $row['diachi_tb'] . "</td>";
        echo "<td>" . $row['ma_tb'] . "</td>";
        echo "<td>" . $row['mst_kh'] . "</td>";
        echo "<td>" . $row['donvi'] . "</td>";
        echo "<td>" . $row['loai_tb'] . "</td>";
        echo "<td>" . $row['sothang'] . "</td>";
        echo "<td>" . $row['thang_bdtru'] . "</td>";
        echo "<td>" . $row['thang_kttru'] . "</td>";
        echo "<td>" . $row['nguoi_cn'] . "</td>";
        echo "</tr>";
    }

    echo "</table>";
    // Hiển thị phân trang
    //echo "Page: $currentPage, Nam: $nam, Thang: $thang, Donvi: $donvi, Loai_tb: $loai_tb";

    echo '<div style="clear: both;">';
    if ($totalPages > 1) {
        for ($i = 1; $i <= $totalPages; $i++) {
            echo '<a href="?page=' . $i . '&nam=' . urlencode($nam) . '&thang=' . urlencode($thang) . '&donvi=' . urlencode($donvi) . '&loai_tb=' . urlencode($loai_tb) . '">' . $i . '</a>';
        }
    }
    echo '</div>';

    // Thêm nút Quay lại
    echo '<button onclick="goBack()" style="float: right;">Quay lại</button>';
} else {
    echo "<p>Không có dữ liệu phù hợp.</p>";
}

// Đóng kết nối
mysqli_close($conn);
?>
        </tbody>
</div>
<script>
    function toggleList() {
        var myList = document.getElementById("myList");
        myList.classList.toggle("hidden");
    }
    function goBack() {
        window.history.back();
    }
</script>
</body>
</html>
