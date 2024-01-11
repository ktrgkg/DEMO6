<?php
// update_user.php

// Kết nối đến cơ sở dữ liệu
$conn = mysqli_connect("localhost","root","","demo4");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối không thành công: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['user_id'])) {
    $user_id = $_POST['user_id'];
    $ten = $_POST['ten'];
    $donvi = $_POST['donvi'];
    $chucdanh = $_POST['chucdanh'];
    $mail = $_POST['mail'];
    $user = $_POST['user'];
    $pass = $_POST['pass'];
    $role = $_POST['role'];

    // Thực hiện truy vấn cập nhật thông tin người dùng
    $query = "UPDATE users SET Ten='$ten', Donvi='$donvi', ChucDanh='$chucdanh', mail='$mail', user='$user', pass='$pass', role='$role' WHERE id = $user_id";
    $result = $conn->query($query);

    if ($result) {
        echo "Cập nhật thông tin người dùng thành công.";
    } else {
        echo "Lỗi cập nhật thông tin người dùng: " . $conn->error;
    }
} else {
    echo "Tham số không hợp lệ.";
}

// Đóng kết nối
$conn->close();
?>
