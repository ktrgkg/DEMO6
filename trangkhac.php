<?php
session_start();

if (!isset($_SESSION["username"]) || $_SESSION["role"] != 2) {
    header("Location: index.php"); // Chuyển hướng nếu không đăng nhập hoặc không phải trang khác
    exit();
}

// Trang khác
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Khác</title>
</head>
<body>

<h1>Xin chào, <?php echo $_SESSION["username"]; ?></h1>

</body>
