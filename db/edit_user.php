<?php
// edit_user.php

// Kết nối đến cơ sở dữ liệu
$conn = mysqli_connect("localhost", "root", "", "demo4");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Kết nối không thành công: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET['id'])) {
    $user_id = $_GET['id'];

    // Truy vấn dữ liệu người dùng cần sửa
    $query = "SELECT * FROM users WHERE id = $user_id";
    $result = $conn->query($query);

    if ($result->num_rows == 1) {
        $user_data = $result->fetch_assoc();

        // Hiển thị form sửa thông tin người dùng
        echo "<form id='editForm' action='update_user.php' method='post'>
                <input type='hidden' name='user_id' value='{$user_data['id']}'>
                Tên: <input type='text' name='ten' value='{$user_data['Ten']}'><br>
                Đơn Vị: <input type='text' name='donvi' value='{$user_data['Donvi']}'><br>
                Chức Danh: <input type='text' name='chucdanh' value='{$user_data['ChucDanh']}'><br>
                Mail: <input type='text' name='mail' value='{$user_data['mail']}'><br>
                User: <input type='text' name='user' value='{$user_data['user']}'><br>
                Pass: <input type='text' name='pass' value='{$user_data['pass']}'><br>
                Role: <input type='text' name='role' value='{$user_data['role']}'><br>
                <input type='submit' value='Lưu'>
              </form>";

        // Thêm mã JavaScript để xử lý sự kiện gửi form
        echo "<script>
                document.getElementById('editForm').addEventListener('submit', function (e) {
                    e.preventDefault(); // Ngăn chặn hành động mặc định của form
                    var formData = new FormData(this);
                    var xhr = new XMLHttpRequest();

                    xhr.onreadystatechange = function () {
                        if (xhr.readyState == 4) {
                            if (xhr.status == 200) {
                                alert('Cập nhật thông tin người dùng thành công!');
                             //   location.reload(); // Tải lại trang để hiển thị dữ liệu đã cập nhật
                             setTimeout(function() {
                                window.location.href = '../function/user_administration.php';
                            }, 1000);
                            } else {
                                alert('Lỗi cập nhật thông tin người dùng: ' + xhr.responseText);
                            }
                        }
                    };

                    xhr.open('POST', 'update_user.php', true);
                    xhr.send(formData);
                });
              </script>";
    } else {
        echo "Không tìm thấy người dùng.";
    }
} else {
    echo "Tham số không hợp lệ.";
}

// Đóng kết nối
$conn->close();
?>
