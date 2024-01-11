<?php
// Thông tin kết nối đến cơ sở dữ liệu
/*$host = "localhost";
$database = "demo4";
$user = "";
$password = "";*/
$conn = mysqli_connect("localhost","root","","demo4");
// Kết nối đến cơ sở dữ liệu
//$conn = new mysqli($host, $user, $password, $database);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối không thành công: " . $conn->connect_error);
}

// Thực hiện truy vấn SELECT để lấy dữ liệu từ bảng users
$query = "SELECT * FROM users";
$result = $conn->query($query);

// Kiểm tra và hiển thị dữ liệu
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $id = $row['id'];
        $Ten = $row['Ten'];
        $Donvi = $row['Donvi'];
        $Chucdanh = $row['Chucdanh'];
        $mail = $row['mail'];
        $user = $row['user'];
        $password = $row['pass'];
        $role = $row['role'];

        echo "ID: $id, Ten: $Ten, Donvi: $Donvi, Chucdanh: $Chucdanh, Mail: $mail, User: $user, Password: $password, Role: $role <br>";
    }
} else {
    echo "Không có dữ liệu";
}

// Đóng kết nối
$conn->close();
?>
