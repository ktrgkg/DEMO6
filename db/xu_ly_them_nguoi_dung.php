<?php
// Kết nối đến cơ sở dữ liệu


$conn = mysqli_connect("localhost","root","","demo6");

if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
}

// Lấy dữ liệu từ form
$ten_tk = isset($_POST['ten_tk']) ? $_POST['ten_tk'] : '';
$sdt = isset($_POST['sdt']) ? $_POST['sdt'] : '';
$donvi = isset($_POST['donvi']) ? $_POST['donvi'] : '';
$chucdanh = isset($_POST['chucdanh']) ? $_POST['chucdanh'] : '';
$username = isset($_POST['user']) ? $_POST['user'] : '';
$pass = isset($_POST['pass']) ? $_POST['pass'] : '';
$role = isset($_POST['role']) ? $_POST['role'] : '';

// Kiểm tra sự tồn tại của tài khoản hoặc số điện thoại trong cơ sở dữ liệu trước khi thêm mới
$sqlCheck = "SELECT * FROM tai_khoan WHERE user = '$username' OR sdt = '$sdt'";
$resultCheck = $conn->query($sqlCheck);

if ($resultCheck->num_rows > 0) {
    echo "Tài khoản hoặc số điện thoại đã tồn tại. Vui lòng kiểm tra lại.";
} else {
    // Thực hiện truy vấn để thêm người dùng mới vào cơ sở dữ liệu
    $sql = "INSERT INTO tai_khoan (ten_tk, sdt, donvi, chucdanh, user, pass, role) 
            VALUES ('$ten_tk', '$sdt', '$donvi', '$chucdanh', '$username', '$pass', '$role')";

    if ($conn->query($sql) === TRUE) {
        echo "Thêm người dùng thành công!";
        // Chuyển hướng về trang thongtin_user.php sau khi thêm người dùng thành công
        header("Location: ../function/quantri_user.php");
        exit();
    } else {
        echo "Lỗi: " . $sql . "<br>" . $conn->error;
    }
}

$conn->close();
?>