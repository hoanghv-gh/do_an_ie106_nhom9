@echo off
setlocal EnableDelayedExpansion

:: Đặt mã hóa UTF-8 để hiển thị tiếng Việt
chcp 65001 >nul

:: Lưu đường dẫn gốc của script tránh xóa nhầm
set "SCRIPT_DIR=%~dp0"

:: Thiết lập ngôn ngữ mặc định (vi=Vietnamese, en=English)
if not defined LANG set "LANG=vi"

:: Hiển thị logo ASCII art
cls
echo.
echo    ╔══════════════════════════════════════╗
echo    ║          LaTeX Builder v1.0          ║
echo    ║  ╔════╗   ╔══════╗  ╔══════╗  ╔══╗   ║
echo    ║  ║    ║   ║      ║  ║      ║  ║  ║   ║
echo    ║  ║════╬═══╬════╗ ║  ║══════╩══╩══╬═╗ ║
echo    ║  ║    ║   ║    ║ ║  ║      ╔══╗  ║   ║
echo    ║  ║    ║   ║    ╚═╩══╩══════╝  ╚══╩═╝ ║
echo    ║  Professional LaTeX Compilation Tool ║
echo    ╚══════════════════════════════════════╝
echo.

:menu
if "%LANG%"=="vi" goto menu_vi
goto menu_en

:menu_vi
echo Công cụ biên dịch LaTeX
echo =================
echo 1. Biên dịch tài liệu LaTeX
echo 2. Xóa các tệp tạm
echo 3. Biên dịch từ đường dẫn tùy chỉnh
echo 4. Hướng dẫn
echo 5. Thông tin về công cụ này
echo 6. Chuyển sang tiếng Anh
echo 7. Thoát
echo =================
set /p choice=Chọn một tùy chọn (1-7): 
goto process_choice

:menu_en
echo LaTeX Compilation Tool
echo =================
echo 1. Compile LaTeX document
echo 2. Clean temporary files
echo 3. Compile from custom path
echo 4. Help
echo 5. About this tool
echo 6. Switch to Vietnamese
echo 7. Exit
echo =================
set /p choice=Select an option (1-7): 
goto process_choice

:process_choice
if "%choice%"=="1" goto build
if "%choice%"=="2" goto clean
if "%choice%"=="3" goto custom_build
if "%choice%"=="4" goto help
if "%choice%"=="5" goto about
if "%choice%"=="6" goto switch_lang
if "%choice%"=="7" goto end

if "%LANG%"=="vi" goto invalid_vi
goto invalid_en

:invalid_vi
echo Lựa chọn không hợp lệ! Vui lòng chọn 1-7.
pause
goto menu

:invalid_en
echo Invalid choice! Please select 1-7.
pause
goto menu

:build
:: Kiểm tra và tạo thư mục ../output nếu chưa tồn tại
if not exist "..\output" (
    if "%LANG%"=="vi" goto create_output_vi
    goto create_output_en
)
goto check_main_tex

:create_output_vi
echo Đang tạo thư mục output...
mkdir "..\output"
goto check_main_tex

:create_output_en
echo Creating output directory...
mkdir "..\output"
goto check_main_tex

:check_main_tex
:: Kiểm tra sự tồn tại của main.tex
if not exist "..\main.tex" (
    if "%LANG%"=="vi" goto error_main_tex_vi
    goto error_main_tex_en
)
goto check_latexmk

:error_main_tex_vi
echo Lỗi: Không tìm thấy tệp main.tex!
pause
goto menu

:error_main_tex_en
echo Error: main.tex file not found!
pause
goto menu

:check_latexmk
:: Kiểm tra xem latexmk có được cài đặt không
where latexmk >nul 2>&1
if !errorlevel! neq 0 (
    if "%LANG%"=="vi" goto error_latexmk_vi
    goto error_latexmk_en
)
goto compile_latex

:error_latexmk_vi
echo Lỗi: Không tìm thấy latexmk! Vui lòng cài đặt TeX Live hoặc một bản phân phối LaTeX khác.
pause
goto menu

:error_latexmk_en
echo Error: latexmk not found! Please install TeX Live or another LaTeX distribution.
pause
goto menu

:compile_latex
:: Biên dịch tài liệu LaTeX
if "%LANG%"=="vi" goto compile_msg_vi
goto compile_msg_en

:compile_msg_vi
echo Đang biên dịch main.tex...
goto run_latexmk

:compile_msg_en
echo Compiling main.tex...
goto run_latexmk

:run_latexmk
cd ..
latexmk -pdf -outdir=output main.tex >nul 2>&1
if !errorlevel! neq 0 (
    if "%LANG%"=="vi" goto compile_error_vi
    goto compile_error_en
)
if "%LANG%"=="vi" goto compile_success_vi
goto compile_success_en

:compile_error_vi
echo Lỗi: Biên dịch main.tex thất bại!
echo Để xem chi tiết lỗi, chạy lệnh: latexmk -pdf -outdir=output main.tex
cd "%SCRIPT_DIR%"
pause
goto menu

:compile_error_en
echo Error: main.tex compilation failed!
echo To see detailed error messages, run: latexmk -pdf -outdir=output main.tex
cd "%SCRIPT_DIR%"
pause
goto menu

:compile_success_vi
echo Biên dịch thành công!
cd "%SCRIPT_DIR%"
pause
goto menu

:compile_success_en
echo Compilation successful!
cd "%SCRIPT_DIR%"
pause
goto menu

:clean
:: Kiểm tra thư mục output
if not exist "..\output" (
    if "%LANG%"=="vi" goto clean_error_vi
    goto clean_error_en
)
goto clean_start

:clean_error_vi
echo Lỗi: Thư mục output không tồn tại!
pause
goto menu

:clean_error_en
echo Error: Output directory does not exist!
pause
goto menu

:clean_start
if "%LANG%"=="vi" goto clean_msg_vi
goto clean_msg_en

:clean_msg_vi
echo Đang xóa các tệp tạm...
goto clean_process

:clean_msg_en
echo Cleaning temporary files...
goto clean_process

:clean_process
:: Lưu thư mục hiện tại và chuyển đến thư mục output
pushd "..\output"
if !errorlevel! neq 0 (
    if "%LANG%"=="vi" goto clean_access_error_vi
    goto clean_access_error_en
)
goto clean_files

:clean_access_error_vi
echo Lỗi: Không thể truy cập thư mục output!
pause
goto menu

:clean_access_error_en
echo Error: Cannot access output directory!
pause
goto menu

:clean_files
:: Xóa tất cả tệp trừ .pdf
for %%f in (*.*) do (
    if /i not "%%~xf"==".pdf" (
        if "%LANG%"=="vi" (
            echo Đang xóa: %%f
        ) else (
            echo Deleting: %%f
        )
        del "%%f"
    )
)

:: Quay lại thư mục gốc
popd

if "%LANG%"=="vi" goto clean_success_vi
goto clean_success_en

:clean_success_vi
echo Xóa tệp tạm hoàn tất!
pause
goto menu

:clean_success_en
echo Temporary files cleaned successfully!
pause
goto menu

:custom_build
cls
if "%LANG%"=="vi" goto custom_help_vi
goto custom_help_en

:custom_help_vi
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                    BIÊN DỊCH TỪ ĐƯỜNG DẪN TUỲ CHỈNH              ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.
echo Hướng dẫn cú pháp đường dẫn:
echo ─────────────────────────────
echo • Đường dẫn tuyệt đối:   C:\Users\Name\Documents\MyProject
echo • Đường dẫn ổ đĩa khác:  D:\Projects\LaTeX\MyDocument
echo • Đường dẫn mạng:        \\server\share\folder
echo • Đường dẫn có khoảng trắng: "C:\My Documents\Project"
echo.
echo Lưu ý quan trọng:
echo • Thư mục phải chứa tệp main.tex
echo • Thư mục output sẽ được tạo tự động
echo • Sử dụng dấu ngoặc kép nếu đường dẫn có khoảng trắng
echo.
set /p custom_path=Nhập đường dẫn đầy đủ đến thư mục chứa main.tex: 
goto custom_process

:custom_help_en
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                    COMPILE FROM CUSTOM PATH                      ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.
echo Path syntax guide:
echo ──────────────────
echo • Absolute path:      C:\Users\Name\Documents\MyProject
echo • Different drive:    D:\Projects\LaTeX\MyDocument
echo • Network path:       \\server\share\folder
echo • Path with spaces:   "C:\My Documents\Project"
echo.
echo Important notes:
echo • Directory must contain main.tex file
echo • Output directory will be created automatically
echo • Use quotes if path contains spaces
echo.
set /p custom_path=Enter full path to directory containing main.tex: 
goto custom_process

:custom_process
:: Loại bỏ dấu ngoặc kép nếu có
set "custom_path=%custom_path:"=%"

:: Kiểm tra đường dẫn có tồn tại không
if not exist "%custom_path%" (
    if "%LANG%"=="vi" goto custom_path_error_vi
    goto custom_path_error_en
)
goto custom_check_tex

:custom_path_error_vi
echo Lỗi: Đường dẫn không tồn tại: %custom_path%
pause
goto menu

:custom_path_error_en
echo Error: Path does not exist: %custom_path%
pause
goto menu

:custom_check_tex
:: Kiểm tra tệp main.tex
if not exist "%custom_path%\main.tex" (
    if "%LANG%"=="vi" goto custom_tex_error_vi
    goto custom_tex_error_en
)
goto custom_check_latexmk

:custom_tex_error_vi
echo Lỗi: Không tìm thấy tệp main.tex trong đường dẫn: %custom_path%
pause
goto menu

:custom_tex_error_en
echo Error: main.tex not found in path: %custom_path%
pause
goto menu

:custom_check_latexmk
:: Kiểm tra xem latexmk có được cài đặt không
where latexmk >nul 2>&1
if !errorlevel! neq 0 (
    if "%LANG%"=="vi" goto custom_latexmk_error_vi
    goto custom_latexmk_error_en
)
goto custom_create_output

:custom_latexmk_error_vi
echo Lỗi: Không tìm thấy latexmk! Vui lòng cài đặt TeX Live hoặc một bản phân phối LaTeX khác.
pause
goto menu

:custom_latexmk_error_en
echo Error: latexmk not found! Please install TeX Live or another LaTeX distribution.
pause
goto menu

:custom_create_output
:: Tạo thư mục output nếu chưa tồn tại
if not exist "%custom_path%\output" (
    if "%LANG%"=="vi" goto custom_create_vi
    goto custom_create_en
)
goto custom_compile

:custom_create_vi
echo Đang tạo thư mục output trong: %custom_path%
mkdir "%custom_path%\output"
goto custom_compile

:custom_create_en
echo Creating output directory in: %custom_path%
mkdir "%custom_path%\output"
goto custom_compile

:custom_compile
:: Biên dịch tài liệu LaTeX từ đường dẫn tùy chỉnh
if "%LANG%"=="vi" goto custom_compile_msg_vi
goto custom_compile_msg_en

:custom_compile_msg_vi
echo Đang biên dịch main.tex từ: %custom_path%
goto custom_run_latexmk

:custom_compile_msg_en
echo Compiling main.tex from: %custom_path%
goto custom_run_latexmk

:custom_run_latexmk
pushd "%custom_path%"
latexmk -pdf -outdir=output main.tex >nul 2>&1
if !errorlevel! neq 0 (
    if "%LANG%"=="vi" goto custom_compile_error_vi
    goto custom_compile_error_en
)
popd

if "%LANG%"=="vi" goto custom_success_vi
goto custom_success_en

:custom_compile_error_vi
echo Lỗi: Biên dịch main.tex thất bại!
echo Để xem chi tiết lỗi, chạy lệnh trong thư mục "%custom_path%":
echo latexmk -pdf -outdir=output main.tex
popd
pause
goto menu

:custom_compile_error_en
echo Error: main.tex compilation failed!
echo To see detailed error messages, run in directory "%custom_path%":
echo latexmk -pdf -outdir=output main.tex
popd
pause
goto menu

:custom_success_vi
echo Biên dịch thành công!
echo Tệp PDF được lưu tại: %custom_path%\output\main.pdf
pause
goto menu

:custom_success_en
echo Compilation successful!
echo PDF file saved at: %custom_path%\output\main.pdf
pause
goto menu

:about
cls
if "%LANG%"=="vi" goto about_vi
goto about_en

:about_vi
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                         VỀ TOOL NÀY                              ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.
echo ┌─────────────────────────────────────────────────────────────────┐
echo │                    LaTeX Builder CLI v1.0                       │
echo └─────────────────────────────────────────────────────────────────┘
echo.
echo 📝 Mô tả:
echo    Công cụ dòng lệnh chuyên nghiệp để biên dịch tài liệu LaTeX
echo    một cách nhanh chóng và hiệu quả trên Windows.
echo.
echo ⚡ Tính năng chính:
echo    • Biên dịch LaTeX tự động với latexmk
echo    • Hỗ trợ đường dẫn tùy chỉnh từ bất kỳ ổ đĩa nào
echo    • Xóa tệp tạm thông minh (chỉ giữ lại PDF)
echo    • Giao diện song ngữ (Việt/Anh)
echo    • Thông báo lỗi rõ ràng và hướng dẫn khắc phục
echo    • Tự động tạo thư mục output
echo.
echo 🎯 Mục tiêu:
echo    Đơn giản hóa quy trình biên dịch LaTeX, đặc biệt hữu ích cho người không quen thao tác CLI và nhớ lệnh biên dịch.
echo.
echo 🔧 Yêu cầu hệ thống:
echo    • Windows (bất kỳ phiên bản nào)
echo    • TeX Live hoặc MiKTeX
echo    • latexmk (thường đi kèm với bản phân phối LaTeX)
echo.
echo 💡 Phiên bản:   1.0
echo 📅 Ngày tạo:    2025
echo 🌐 Encoding:    UTF-8
echo ⚖️ Giấy phép:   MIT License
echo 🤷‍♂️ Phát triển bởi: Hoanghv-23730169
echo.
pause
goto menu

:about_en
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                        ABOUT THIS TOOL                           ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.
echo ┌─────────────────────────────────────────────────────────────────┐
echo │                    LaTeX Builder CLI v1.0                       │
echo └─────────────────────────────────────────────────────────────────┘
echo.
echo 📝 Description:
echo    Professional command-line tool for compiling LaTeX documents
echo    quickly and efficiently on Windows systems.
echo.
echo ⚡ Key Features:
echo    • Automated LaTeX compilation with latexmk
echo    • Custom path support from any drive
echo    • Smart temporary file cleaning (preserves PDFs only)
echo    • Bilingual interface (Vietnamese/English)
echo    • Clear error messages with troubleshooting guides
echo    • Automatic output directory creation
echo.
echo 🎯 Purpose:
echo    Streamline the LaTeX compilation workflow, especially useful for no-tech users.
echo.
echo 🔧 System Requirements:
echo    • Windows (any version)
echo    • TeX Live or MiKTeX
echo    • latexmk (usually included with LaTeX distributions)
echo.
echo 💡 Version:     1.0
echo 📅 Created:     2025
echo 🌐 Encoding:    UTF-8
echo ⚖️ License:     MIT License
echo 🤷‍♂️ Developed by: Hoanghv-23730169
echo.
pause
goto menu

:switch_lang
if "%LANG%"=="vi" goto switch_to_en
goto switch_to_vi

:switch_to_en
set "LANG=en"
echo Language switched to English.
pause
goto menu

:switch_to_vi
set "LANG=vi"
echo Đã chuyển sang tiếng Việt.
pause
goto menu

:help
cls
if "%LANG%"=="vi" goto help_vi
goto help_en

:help_vi
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                            HƯỚNG DẪN                             ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.
echo Yêu cầu hệ thống để biên dịch LaTeX:
echo ═══════════════════════════════════
echo 1. Cài đặt một bản phân phối LaTeX:
echo    • TeX Live: https://www.tug.org/texlive/
echo    • MiKTeX: https://miktex.org/
echo.
echo 2. Đảm bảo 'latexmk' có sẵn trong PATH của hệ thống
echo.
echo 3. Cấu trúc thư mục yêu cầu:
echo    Dự_án/
echo    ├── main.tex
echo    ├── scripts/
echo    │   └── build.bat
echo    └── output/
echo.
echo Các tùy chọn biên dịch:
echo ══════════════════════
echo • Tùy chọn 1: Biên dịch từ thư mục mẹ của script
echo • Tùy chọn 3: Biên dịch từ bất kỳ đường dẫn nào
echo.
echo Ví dụ đường dẫn hợp lệ:
echo ══════════════════════
echo • C:\Users\YourName\Documents\LaTeX\Project1
echo • D:\MyProjects\Thesis
echo • "C:\Folder With Spaces\My Project"
echo.
pause
goto menu

:help_en
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                              HELP                                ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.
echo System requirements for LaTeX compilation:
echo ═════════════════════════════════════════
echo 1. Install a LaTeX distribution:
echo    • TeX Live: https://www.tug.org/texlive/
echo    • MiKTeX: https://miktex.org/
echo.
echo 2. Ensure 'latexmk' is available in system PATH
echo.
echo 3. Required directory structure:
echo    your-project/
echo    ├── main.tex
echo    ├── scripts/
echo    │   └── build.bat
echo    └── output/
echo.
echo Compilation options:
echo ═══════════════════
echo • Option 1: Compile from script's parent directory
echo • Option 3: Compile from any custom path
echo.
echo Valid path examples:
echo ═══════════════════
echo • C:\Users\YourName\Documents\LaTeX\Project1
echo • D:\MyProjects\Thesis
echo • "C:\Folder With Spaces\My Project"
echo.
pause
goto menu

:end
if "%LANG%"=="vi" goto exit_vi
goto exit_en

:exit_vi
echo Đang thoát, vui lòng chờ...
endlocal
exit /b 0

:exit_en
echo Exiting, please wait...
endlocal
exit /b 0