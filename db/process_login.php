<?php


// Kết nối đến cơ sở dữ liệu
$conn = mysqli_connect("localhost","root","","demo4");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối không thành công: " . $conn->connect_error);
}

// Xử lý đăng nhập khi form được submit
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Xây dựng truy vấn SQL
    $query = "SELECT * FROM users WHERE user='$username' AND pass='$password'";
    $result = $conn->query($query);

    // Kiểm tra và xử lý kết quả
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $role = $row['role'];

        // Chuyển hướng người dùng dựa trên vai trò
        if ($role == 1) {
            header("Location: ../Trangchinh");
        } else {
            header("Location: ../Trangchinh");
        }
        exit();
    } else {
        // Đăng nhập thất bại
        echo "Đăng nhập thất bại. Vui lòng kiểm tra lại tên đăng nhập và mật khẩu.";
    }
}

// Đóng kết nối
$conn->close();
?>