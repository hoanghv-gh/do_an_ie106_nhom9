# Báo Cáo Đồ Án Môn Học Thiết Kế Giao Diện Người Dùng - IE106.E31.CN1.CNTT

## 📌 Giới thiệu

Repository này là kho lưu trữ chính thức cho báo cáo đồ án môn học *Thiết kế Giao Diện Người Dùng*, lớp IE106.E31.CN1.CNTT.

Dự án tập trung vào việc thiết kế và phát triển giao diện người dùng cho hệ thống **đặt vé xe khách**, nhằm rèn luyện tư duy thiết kế, khả năng làm việc nhóm và trình bày tài liệu khoa học bằng LaTeX.

---

## 📝 Thông tin chung

- **Tên đề tài:** Thiết Kế Giao Diện Đặt Vé Xe Khách  
- **Thời gian thực hiện:** Từ ngày 01/08/2025 đến khi hoàn thiện (dự kiến nộp tháng 31/08/2025)  
- **Trạng thái dự án:** Đang hoàn thiện (chuẩn bị nộp)  

---

## 👥 Thành viên nhóm (Nhóm 9)

| Họ và tên               | Vai trò                     |
|------------------------|-----------------------------|
| Nguyễn Quốc Nhứt       | Chưa phân công (sẽ cập nhật)|
| Trần Khắc Nhu          | Chưa phân công (sẽ cập nhật)|
| Phan Nhật Hòa          | Chưa phân công (sẽ cập nhật)|
| Phạm Phương Hồng Ngữ   | Chưa phân công (sẽ cập nhật)|
| Hoàng Văn Hoàng        | Chưa phân công (sẽ cập nhật)|

> *Vai trò cụ thể sẽ được cập nhật sau khi phân công chính thức.*

---

## 📂 Cấu trúc thư mục
```
BAOCAO/
├── .github/
│   └── workflows/
│       └── latex-build.yml     # GitHub Action workflow
├── assets/                     # Thư mục chứa tài nguyên đa phương tiện của báo cáocáo
│   ├── chart/                  # Ảnh biểu đồ và các ảnh khác
│   └── uit_logo/               # Thư mục chứa logo trường
│       └── uit_logo.png        # Logo trường
├── docs/                       # Thư mục deploy static page
│   ├── index.html              # Trang index của static page
│   ├── assets/                 # Tài nguyên của static page
│   ├── output/                 # Thư mục chứa PDF (auto-generated)
│   │   └── main.pdf            # File PDF được build tự động
│   └── pages/                  # Thư mục chứa các trang của static page
│       ├── overview.html       # Trang tổng quan
│       ├── pdf-viewer.html     # Trình xem PDF
│       └── notion-viewer.html  # Trình xem notion các task và deadline dự án
├── scripts/                    # Thư mục chứa scripts
│   └── build.bat               # CLI tool build latex trên Windows          
├── src/                        # Source files LaTeX
├── styles/                     # Style và formatting files
├── main.tex                    # File LaTeX chính
├── .gitignore                  # file .gitignore để loại bỏ một số file không cần thiết khi commit
└── README.md                   # README mô tả dự án
```

---

## Hướng dẫn cài đặt & biên dịch

### 1. Yêu cầu hệ thống

- Hệ điều hành: Windows / macOS / Linux  
- Phần mềm cần cài:
  - **MiKTeX**
  - **Visual Studio Code**
  - **Perl** (cho Windows)
  - **LaTeX Workshop** extension

### 2. Cài đặt môi trường

1. **Cài đặt MiKTeX**
   - Cài [MikTex](https://miktex.org/download) 
   - Chọn “Install missing packages on-the-fly”  
   - Mở MiKTeX Console > `Updates` > `Check for updates`

3. **Cài đặt Perl (Windows)**  
   - Cài [Strawberry Perl](https://strawberryperl.com)  
   - Kiểm tra (Nếu cài đặt thành công se có tên phiên bản, Perl đã mặc định thêm Path khi cài đặt):  
     ```bash
     perl -v

4. **Cài VSCode + LaTeX Workshop**
   - Cài đặt extension [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) 
   - Cấu hình settings.json như sau:  
     ```json
     {
       "latex-workshop.latex.tools": [
         {
           "name": "latexmk",
           "command": "latexmk",
           "args": [
             "-synctex=1",
             "-interaction=nonstopmode",
             "-file-line-error",
             "-pdf",
             "%DOC%"
           ]
         }
       ],
       "latex-workshop.latex.recipes": [
         {
           "name": "latexmk",
           "tools": ["latexmk"]
         }
       ],
       "latex-workshop.view.pdf.viewer": "tab"
     }

  

 6. **Clone Repository**  
     ```bash
     git clone <https://github.com/hoanghv-gh/do_an_ie106_nhom9.git>
     cd do_an_ie106_nhom9
     
### 3. Biên dịch báo cáo
 1. **Biên dịch bằng Latex Workshop + Miktex + Perl**
    - Mở main.tex bằng VSCode
    - Nhấn Ctrl + Alt + B để biên dịch có hỗ trợ bởi Latex Workshoop.
    - File PDF và các file tạm sẽ được tạo ra sau biên dịch.
 2. **Biên dịch bằng tệp 'build.bat' trên windows đã có trong repository**
    - Mở CMD trên Windows và trong thư mục gốc nhập lệnh sau:
      ```bash
      cd scripts
      build.bat
      
### 4. Lưu ý quan trọng

1. Kiểm tra lỗi: Mở tab Output (Ctrl + Shift + U)
2. Cập nhật gói: Dùng MiKTeX Console
3. Quản lý phiên bản: Dùng Git (commit rõ ràng, chia nhánh hợp lý)
4. Bảo mật: Không lưu thông tin nhạy cảm vào repository


### 5. Liên hệ
- Mọi thắc mắc liên quan đến phần thiết kế giao diện, kỹ thuật LaTeX hoặc cấu trúc repository, vui lòng liên hệ qua nhóm làm việc.
