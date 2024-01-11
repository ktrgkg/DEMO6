<?php
require '../vendor/autoload.php';
use PhpOffice\PhpSpreadsheet\IOFactory;

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_FILES["file"])) {
    $file = $_FILES["file"];
    $nam = $_POST["nam"];
    $thang = $_POST["thang"];

    if ($file["error"] > 0 || pathinfo($file["name"], PATHINFO_EXTENSION) !== 'xls') {
        echo "Lỗi upload file.";
    } else {
        // Đường dẫn để lưu trữ file tạm thời
        $uploadDir = '../uploads/';
        $uploadFile = $uploadDir . basename($file["name"]);

        // Di chuyển file từ thư mục tạm thời vào thư mục uploads
        if (move_uploaded_file($file["tmp_name"], $uploadFile)) {
            // Gọi hàm xử lý cập nhật dữ liệu từ file Excel vào cơ sở dữ liệu
            updateDataFromExcel($uploadFile, $nam, $thang);

            // Xóa file tạm thời sau khi cập nhật xong
            unlink($uploadFile);

            echo "Cập nhật dữ liệu thành công.";
        } else {
            echo "Lỗi di chuyển file.";
        }
    }
}

// ...

function updateDataFromExcel($filePath, $namParam, $thangParam) {
    $conn = mysqli_connect("localhost", "root", "", "demo6");

    if (!$conn) {
        die("Kết nối không thành công: " . mysqli_connect_error());
    }

    // Kiểm tra xem có dữ liệu cho tháng, năm này chưa
    $checkSql = "SELECT COUNT(*) as count FROM da WHERE thang = ? AND nam = ?";
    $checkStmt = $conn->prepare($checkSql);

    if ($checkStmt) {
        $checkStmt->bind_param("ss", $thangParam, $namParam);
        $checkStmt->execute();
        $result = $checkStmt->get_result();
        $row = $result->fetch_assoc();

        if ($row["count"] > 0) {
            // Nếu đã có dữ liệu cho tháng, năm này, xóa dữ liệu cũ
            $deleteSql = "DELETE FROM da WHERE thang = ? AND nam = ?";
            $deleteStmt = $conn->prepare($deleteSql);

            if ($deleteStmt) {
                $deleteStmt->bind_param("ss", $thangParam, $namParam);
                $deleteStmt->execute();
                $deleteStmt->close();
            } else {
                echo "Lỗi prepare statement: " . $conn->error;
            }
        }
    } else {
        echo "Lỗi prepare statement: " . $conn->error;
    }

    // Load file Excel
    $spreadsheet = IOFactory::load($filePath);
    $worksheet = $spreadsheet->getActiveSheet();
    $highestRow = $worksheet->getHighestRow();

    // Chuẩn bị câu lệnh SQL
    $sql = "INSERT INTO da (stt, ten_tb, diachi_tb, ma_tb, mst_kh, ngay_sd, loai_tb, dichvuvt_id, ngay_dk, ngay_bd_dc, ngay_kt_dc, giacuoc, tienthu, sothang, congvan, thang_bdtru, thang_kttru, ctv_kinhdoanh, ctv_kythuat, nguoi_gioithieu, nguoi_cn, ghichu, donvi, diaban, hieuluc, loai_hd, kieu, magd, trangthai, ngaythoaitra, tienthoaitra, thang, nam) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $paramTypeString = "sssssssssssssssssssssssssssssssss";

    // Chuẩn bị câu lệnh
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        // Lặp qua từng dòng
        for ($row = 2; $row <= $highestRow; $row++) {
            $stt = $worksheet->getCellByColumnAndRow(1, $row)->getValue();
            // Lấy giá trị từ form và file
            $ten_tb = $worksheet->getCellByColumnAndRow(2, $row)->getValue();
            $diachi_tb = $worksheet->getCellByColumnAndRow(3, $row)->getValue();
            $ma_tb = $worksheet->getCellByColumnAndRow(4, $row)->getValue();
            $mst_kh = $worksheet->getCellByColumnAndRow(5, $row)->getValue();
            $ngay_sd = $worksheet->getCellByColumnAndRow(6, $row)->getValue();
            $loai_tb = $worksheet->getCellByColumnAndRow(7, $row)->getValue();
            $dichvuvt_id = $worksheet->getCellByColumnAndRow(8, $row)->getValue();
            $ngay_dk = $worksheet->getCellByColumnAndRow(9, $row)->getValue();
            $ngay_bd_dc = $worksheet->getCellByColumnAndRow(10, $row)->getValue();
            if ($ngay_bd_dc === null) {
                $ngay_bd_dc = ''; // hoặc giá trị mặc định khác nếu cần
            }
            $ngay_kt_dc = $worksheet->getCellByColumnAndRow(11, $row)->getValue();
            if ($ngay_kt_dc === null) {
                $ngay_kt_dc = ''; // hoặc giá trị mặc định khác nếu cần
            }
            $giacuoc = $worksheet->getCellByColumnAndRow(12, $row)->getValue();
            $tienthu = $worksheet->getCellByColumnAndRow(13, $row)->getValue();
            $sothang = $worksheet->getCellByColumnAndRow(14, $row)->getValue();
            $congvan = $worksheet->getCellByColumnAndRow(15, $row)->getValue();
            $thang_bdtru = $worksheet->getCellByColumnAndRow(16, $row)->getValue();
            $thang_kttru = $worksheet->getCellByColumnAndRow(17, $row)->getValue();
            $ctv_kinhdoanh = $worksheet->getCellByColumnAndRow(18, $row)->getValue();
            $ctv_kythuat = $worksheet->getCellByColumnAndRow(19, $row)->getValue();
            if ($ctv_kythuat === null) {
                $ctv_kythuat = ''; // hoặc giá trị mặc định khác nếu cần
            }
            $nguoi_gioithieu = $worksheet->getCellByColumnAndRow(20, $row)->getValue();
            if ($nguoi_gioithieu === null) {
                $nguoi_gioithieu = ''; // hoặc giá trị mặc định khác nếu cần
            }
            $nguoi_cn = $worksheet->getCellByColumnAndRow(21, $row)->getValue();
            $ghichu = $worksheet->getCellByColumnAndRow(22, $row)->getValue();
            if ($ghichu === null) {
                $ghichu = ''; // hoặc giá trị mặc định khác nếu cần
            }
            $donvi = $worksheet->getCellByColumnAndRow(23, $row)->getValue();
            $diaban = $worksheet->getCellByColumnAndRow(24, $row)->getValue();
            $hieuluc = $worksheet->getCellByColumnAndRow(25, $row)->getValue();
            $loai_hd = $worksheet->getCellByColumnAndRow(26, $row)->getValue();
            $kieu = $worksheet->getCellByColumnAndRow(27, $row)->getValue();
            $magd = $worksheet->getCellByColumnAndRow(28, $row)->getValue();
            $trangthai = $worksheet->getCellByColumnAndRow(29, $row)->getValue();
            $ngaythoaitra = $worksheet->getCellByColumnAndRow(30, $row)->getValue();
            if ($ngaythoaitra === null) {
                $ngaythoaitra = ''; // hoặc giá trị mặc định khác nếu cần
            }
            $tienthoaitra = $worksheet->getCellByColumnAndRow(31, $row)->getValue();
            if ($tienthoaitra === null) {
                $tienthoaitra = ''; // hoặc giá trị mặc định khác nếu cần
            }
            $thang = $worksheet->getCellByColumnAndRow(32, $row)->getValue();
            if ($thang === null) {
                $thang = $thangParam; // hoặc giá trị mặc định khác nếu cần
            }
            $nam = $worksheet->getCellByColumnAndRow(33, $row)->getValue();
            if ($nam === null) {
                $nam = $namParam; // hoặc giá trị mặc định khác nếu cần
            }

            // Binding parameters
            $stmt->bind_param($paramTypeString, $stt, $ten_tb, $diachi_tb, $ma_tb, $mst_kh, $ngay_sd, $loai_tb, $dichvuvt_id, $ngay_dk, $ngay_bd_dc, $ngay_kt_dc, $giacuoc, $tienthu, $sothang, $congvan, $thang_bdtru, $thang_kttru, $ctv_kinhdoanh, $ctv_kythuat, $nguoi_gioithieu, $nguoi_cn, $ghichu, $donvi, $diaban, $hieuluc, $loai_hd, $kieu, $magd, $trangthai, $ngaythoaitra, $tienthoaitra, $thang, $nam);
            
            // Thực hiện execute
            $stmt->execute();
        }

        // Đóng statement
        $stmt->close();
    } else {
        echo "Lỗi prepare statement: " . $conn->error;
    }

    // Đóng kết nối
    $conn->close();
}

// ...
?>
