<?php
// add_user.php

// Kết nối đến cơ sở dữ liệu
$conn = mysqli_connect("localhost", "root", "", "demo4");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối không thành công: " . $conn->connect_error);
}

// Hàm để kiểm tra email đã tồn tại hay chưa
function isEmailExist($conn, $mail) {
    $query = "SELECT * FROM users WHERE mail = '$mail'";
    $result = $conn->query($query);
    return $result->num_rows > 0;
}

// Hàm để xử lý thêm người dùng
function addUser($conn, $ten, $donvi, $chucdanh, $mail, $user, $pass, $role) {
    // Kiểm tra xem email đã tồn tại hay chưa
    if (isEmailExist($conn, $mail)) {
        echo "Người dùng đã tồn tại. Vui lòng nhập email khác.";
        return; // Không thêm người dùng nếu email đã tồn tại
    }

    // Thêm người dùng vào cơ sở dữ liệu
    $query = "INSERT INTO users (Ten, Donvi, ChucDanh, mail, user, pass, role) 
              VALUES ('$ten', '$donvi', '$chucdanh', '$mail', '$user', '$pass', '$role')";

    $result = $conn->query($query);

    if ($result) {
        echo "Thêm người dùng thành công.";

        // Chuyển hướng về trang user_administration.php sau 2 giây
        echo "<script>
                setTimeout(function() {
                    window.location.href = '../function/user_administration.php';
                }, 2000);
              </script>";
    } else {
        echo "Lỗi thêm người dùng: " . $conn->error;
    }
}

// Xử lý yêu cầu thêm người dùng khi nhấn nút "Thêm"
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['addUser'])) {
    $ten = $_POST['ten'];
    $donvi = $_POST['donvi'];
    $chucdanh = $_POST['chucdanh'];
    $mail = $_POST['mail'];
    $user = $_POST['user'];
    $pass = $_POST['pass'];
    $role = $_POST['role'];

    addUser($conn, $ten, $donvi, $chucdanh, $mail, $user, $pass, $role);
}

// Hiển thị form thêm người dùng
echo "<form id='addUserForm' action='' method='post'>
        <h2>Thêm Người Dùng</h2>
        Tên: <input type='text' name='ten' required><br>
        Đơn Vị: <input type='text' name='donvi' required><br>
        Chức Danh: <input type='text' name='chucdanh' required><br>
        Mail: <input type='text' name='mail' required><br>
        User: <input type='text' name='user' required><br>
        Pass: <input type='text' name='pass' required><br>
        Role: <input type='text' name='role' required><br>
        <input type='submit' name='addUser' value='Thêm'>
      </form>";

// Đóng kết nối
$conn->close();
?>
