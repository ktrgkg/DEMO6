# Job Matching MVP (An Giang - Kiên Giang)

Ứng dụng Flutter hỗ trợ kết nối người lao động và nhà tuyển dụng tại An Giang - Kiên Giang.

## Chạy ứng dụng

```bash
flutter pub get
flutter run
```

## Cấu hình API base URL

Mặc định app dùng `http://localhost:8000`.

Khi cần đổi API base URL, dùng `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=http://your-api-host:8000
```

## MVP features

- Đăng ký, đăng nhập theo vai trò (người lao động/nhà tuyển dụng/admin)
- Danh sách công việc cho người lao động với bộ lọc và nhận việc
- Nhà tuyển dụng tạo, chỉnh sửa, đăng và quản lý job theo trạng thái
- Quản lý phí cho người lao động và admin (nộp phí, duyệt phí)
- Trạng thái công việc và thanh toán cơ bản
