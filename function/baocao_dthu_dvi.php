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
            margin-left:10%;
        }
        #thang{
            padding: 10px;
        }
        #nam{
            padding: 10px;
            margin-left:10px;
            margin-bottom:10px;
        }
        #donvi{
            padding: 10px;
            margin-left:10px;
            margin-bottom:10px;
            width: 15%;
        }
        select {
            width: 15%;
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
        button{
            background-color: #3498db;
            color: white;
            font-size: 14px;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            float: right;
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
    <form id="tieude">Báo cáo doanh thu theo đơn vị</form>

    <form action="../db/dl_baocao_dthu_dvi.php" method="get">

    <label for="nam">Năm:</label>
    <select name="nam" id="nam">
    <option value="all">Tất cả</option>
        <?php
        // Kết nối đến CSDL
        $conn = mysqli_connect("localhost", "root", "", "demo6");

        if (!$conn) {
            die("Kết nối không thành công: " . mysqli_connect_error());
        }

        // Truy vấn để lấy dữ liệu tháng từ bảng da
        $namQuery = "SELECT DISTINCT nam FROM da";
        $namResult = mysqli_query($conn, $namQuery);

        if ($namResult) {
            // Lặp qua kết quả và tạo các tùy chọn
            while ($namRow = mysqli_fetch_assoc($namResult)) {
                $nam = $namRow['nam'];
                echo "<option value=\"$nam\">$nam</option>";
            }

            // Giải phóng bộ nhớ sau khi sử dụng kết quả
            mysqli_free_result($namResult);
        } else {
            echo "Lỗi truy vấn tháng: " . mysqli_error($conn);
        }

        // Đóng kết nối
        mysqli_close($conn);
        ?>
    </select>

    <label for="thang">Tháng:</label>
    <select name="thang">
        <option value="all">Tất cả</option>
        <?php
        // Kết nối đến CSDL
        $conn = mysqli_connect("localhost", "root", "", "demo6");

        if (!$conn) {
            die("Kết nối không thành công: " . mysqli_connect_error());
        }

        // Truy vấn để lấy dữ liệu tháng từ bảng da
        $thangQuery = "SELECT DISTINCT thang FROM da";
        $thangResult = mysqli_query($conn, $thangQuery);

        if ($thangResult) {
            // Lặp qua kết quả và tạo các tùy chọn
            while ($thangRow = mysqli_fetch_assoc($thangResult)) {
                $thang = $thangRow['thang'];
                echo "<option value=\"$thang\">$thang</option>";
            }

            // Giải phóng bộ nhớ sau khi sử dụng kết quả
            mysqli_free_result($thangResult);
        } else {
            echo "Lỗi truy vấn tháng: " . mysqli_error($conn);
        }

        // Đóng kết nối
        mysqli_close($conn);
        ?>
    </select>

    <label for="donvi">Đơn vị:</label>
    <select name="donvi">
        <option value="all">Tất cả</option>
        <?php
        // Kết nối đến CSDL
        $conn = mysqli_connect("localhost", "root", "", "demo6");

        if (!$conn) {
            die("Kết nối không thành công: " . mysqli_connect_error());
        }

        // Truy vấn để lấy dữ liệu đơn vị từ bảng da
        $donviQuery = "SELECT DISTINCT donvi FROM da";
        $donviResult = mysqli_query($conn, $donviQuery);

        if ($donviResult) {
            // Lặp qua kết quả và tạo các tùy chọn
            while ($donviRow = mysqli_fetch_assoc($donviResult)) {
                $donvi = $donviRow['donvi'];
                echo "<option value=\"$donvi\">$donvi</option>";
            }

            // Giải phóng bộ nhớ sau khi sử dụng kết quả
            mysqli_free_result($donviResult);
        } else {
            echo "Lỗi truy vấn đơn vị: " . mysqli_error($conn);
        }

        // Đóng kết nối
        mysqli_close($conn);
        ?>
    </select>

    <label for="loai_tb">Dịch vụ:</label>
    <select name="loai_tb">
        <option value="all">Tất cả</option>
        <!-- Thêm các tùy chọn cho dịch vụ từ cơ sở dữ liệu hoặc một danh sách cố định -->
        <?php
        // Kết nối đến CSDL
        $conn = mysqli_connect("localhost", "root", "", "demo6");

        if (!$conn) {
            die("Kết nối không thành công: " . mysqli_connect_error());
        }

        // Truy vấn để lấy dữ liệu đơn vị từ bảng da
        $loai_tbQuery = "SELECT DISTINCT loai_tb FROM da";
        $loai_tbResult = mysqli_query($conn, $loai_tbQuery);

        if ($loai_tbResult) {
            // Lặp qua kết quả và tạo các tùy chọn
            while ($loai_tbRow = mysqli_fetch_assoc($loai_tbResult)) {
                $loai_tb = $loai_tbRow['loai_tb'];
                echo "<option value=\"$loai_tb\">$loai_tb</option>";
            }

            // Giải phóng bộ nhớ sau khi sử dụng kết quả
            mysqli_free_result($loai_tbResult);
        } else {
            echo "Lỗi truy vấn đơn vị: " . mysqli_error($conn);
        }

        // Đóng kết nối
        mysqli_close($conn);
        ?>
    </select>
    
    <!-- Các input ẩn để giữ lại giá trị lọc -->
    <input type="hidden" name="input_nam" value="<?php echo htmlspecialchars($nam); ?>">
    <input type="hidden" name="input_thang" value="<?php echo htmlspecialchars($thang); ?>">
    <input type="hidden" name="input_donvi" value="<?php echo htmlspecialchars($donvi); ?>">
    <input type="hidden" name="input_loai_tb" value="<?php echo htmlspecialchars($loai_tb);?>">
        
    <button type="submit">Lọc</button>
</form>

</div>

</body>
</html>
