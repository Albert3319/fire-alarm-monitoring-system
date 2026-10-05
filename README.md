# Smart Fire Alarm & Building Monitoring System (WPF & SQL Server)

Hệ thống giám sát và cảnh báo cháy thông minh cho hạ tầng tòa nhà, phát triển trong khuôn khổ bài tập lớn môn **Kỹ thuật phần mềm ứng dụng** - Đại học Bách khoa Hà Nội.

## 📌 Tính năng chính
- **Giám sát thời gian thực:** Hiển thị trực quan tham số nhiệt độ, khói và trạng thái an toàn trên **Fire Map**.
- **Cảnh báo khẩn cấp tự động:** So khớp ngưỡng nguy hiểm, chuyển màu giao diện, kích hoạt hệ thống còi, quạt hút khói.
- **Phân quyền người dùng RBAC:** Đăng nhập an toàn, chia quyền quản trị theo 5 cấp độ (Admin, Manager, Operator, Tech, Viewer).
- **Nhật ký & Báo cáo:** Lưu trữ toàn bộ lịch sử cảnh báo (`AlarmLog`) và thao tác hệ thống (`SystemLog`).

## 🛠 Công nghệ sử dụng
- **Ngôn ngữ & Nền tảng:** C#, .NET Framework, WPF (Windows Presentation Foundation)
- **Cơ sở dữ liệu:** Microsoft SQL Server (12 bảng thực thể chuẩn hóa)
- **Công cụ:** Visual Studio, SQL Server Management Studio (SSMS)
