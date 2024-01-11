<?php
session_start();
session_destroy(); // Hủy phiên đăng nhập
header("Location: ../index.php"); // Chuyển hướng về trang đăng nhập
exit();
?>
