<?php
// delete_user.php

// Kết nối đến cơ sở dữ liệu
$conn = mysqli_connect("localhost", "root", "", "demo4");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối không thành công: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET['id'])) {
    $user_id = $_GET['id'];

    // Thực hiện truy vấn xóa người dùng
    $query = "DELETE FROM users WHERE id = $user_id";
    $result = $conn->query($query);

    if ($result) {
        echo "Xóa người dùng thành công.";

        // Chuyển hướng về trang user_administration.php sau 2 giây
        echo "<script>
                setTimeout(function() {
                    window.location.href = '../function/user_administration.php';
                }, 1000);
              </script>";
    } else {
        echo "Lỗi xóa người dùng: " . $conn->error;
    }
} else {
    echo "Tham số không hợp lệ.";
}

// Đóng kết nối
$conn->close();
?>
