<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: rgba(52, 152, 219, 0.8); /* Màu xanh trong suốt */
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .login-container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 350px; /* Điều chỉnh chiều rộng */
        }

        .login-header {
            background-color: #3498db;
            color: #fff;
            text-align: center;
            padding: 15px;
        }

        .login-form {
            padding: 20px;
        }

        .login-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .login-form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .login-form button {
            background-color: #3498db;
            color: #fff;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        .login-form button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-header">
        <h2>Đăng Nhập</h2>
    </div>
    <form action="login.php" method="post">
    <div class="login-form">
        <label for="username">Tên đăng nhập:</label>
        <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập">

        <label for="password">Mật khẩu:</label>
        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu">

        <button type="submit">Đăng Nhập</button>
    </div>
    </form>
</div>

</body>
</html>
