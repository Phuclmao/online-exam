# Website thi trực tuyến – Kế hoạch dự án (nhóm 5 người)

> Repo chung của nhóm. README này là **kế hoạch chính thức**: phạm vi, công nghệ, phân công, lộ trình 10 tuần và quy ước làm việc. Có thay đổi gì thì sửa trực tiếp file này qua Pull Request.

**Mục lục**

1. [Tổng quan dự án](#1-tổng-quan-dự-án)
2. [Công nghệ sử dụng](#2-công-nghệ-sử-dụng)
3. [Cấu trúc thư mục](#3-cấu-trúc-thư-mục)
4. [Hướng dẫn chạy dự án](#4-hướng-dẫn-chạy-dự-án)
5. [Phân công vai trò](#5-phân-công-vai-trò)
6. [Thiết kế database](#6-thiết-kế-database)
7. [Lộ trình chi tiết 10 tuần](#7-lộ-trình-chi-tiết-10-tuần)
8. [Quy ước làm việc nhóm](#8-quy-ước-làm-việc-nhóm)
9. [Danh sách API chính](#9-danh-sách-api-chính)
10. [Rủi ro và checklist nộp bài](#10-rủi-ro-và-checklist-nộp-bài)

---

## 1. Tổng quan dự án

Nhóm 5 người xây dựng website thi trắc nghiệm trực tuyến trong 10 tuần, có đủ luồng: giáo viên tạo đề → thí sinh làm bài có giới hạn thời gian → hệ thống chấm tự động và thống kê.

**Vai trò người dùng:** Admin (quản lý tài khoản, môn học), Giáo viên (ngân hàng câu hỏi, đề thi, kỳ thi, xem điểm), Thí sinh (làm bài, xem kết quả).

**Phạm vi bắt buộc (MVP):**

- Đăng ký, đăng nhập, quên mật khẩu, phân quyền theo vai trò
- Quản lý môn học, lớp học, người dùng
- Ngân hàng câu hỏi trắc nghiệm (1 hoặc nhiều đáp án đúng), phân loại theo môn, chương, độ khó; import từ Excel
- Tạo đề thủ công hoặc sinh ngẫu nhiên theo ma trận (số câu dễ/trung bình/khó)
- Tạo kỳ thi: thời gian mở/đóng, thời lượng, số lần làm, mật khẩu, lớp được thi
- Làm bài: đồng hồ đếm ngược, tự lưu đáp án, tự nộp khi hết giờ, đảo câu và đáp án
- Chấm điểm tự động, xem lại bài làm
- Thống kê điểm, phổ điểm, xuất bảng điểm Excel

**Phạm vi nâng cao (làm nếu kịp):** phát hiện chuyển tab, chặn copy, toàn màn hình; câu hỏi tự luận chấm tay; gửi email kết quả; dashboard biểu đồ.

## 2. Công nghệ sử dụng

Stack chọn: **React (Vite) + Java Spring Boot + MySQL**. Nhóm quen Java nên backend dùng Spring Boot; frontend tách riêng bằng React để 2 người làm giao diện song song với backend.

| Lớp | Công nghệ | Dùng để |
| --- | --- | --- |
| Frontend | ReactJS + Vite, React Router | Xây giao diện SPA, điều hướng trang |
| UI | Tailwind CSS hoặc Ant Design | Giao diện nhanh, đẹp; Ant Design có sẵn bảng, form cho trang quản trị |
| Gọi API | Axios | Gửi request tới backend |
| Biểu đồ | Chart.js / Recharts | Phổ điểm, thống kê |
| Backend | Java 17 + Spring Boot 3 (Spring Web) | REST API |
| Build | Maven | Quản lý thư viện, build file .jar |
| ORM | Spring Data JPA (Hibernate) + Flyway | Làm việc với MySQL, quản lý thay đổi bảng |
| Xác thực | Spring Security + JWT (thư viện jjwt), BCrypt | Đăng nhập, mã hoá mật khẩu, phân quyền |
| Validate | Bean Validation (@Valid, @NotBlank…) | Kiểm tra dữ liệu đầu vào |
| Giảm code lặp | Lombok, MapStruct (tuỳ chọn) | Getter/setter, chuyển Entity ↔ DTO |
| Excel | Apache POI | Import câu hỏi, xuất bảng điểm |
| Email | Spring Boot Starter Mail | Quên mật khẩu, gửi kết quả |
| Tài liệu API | springdoc-openapi (Swagger UI) | Frontend xem và thử API ngay trên trình duyệt |
| Database | MySQL 8 | Lưu toàn bộ dữ liệu |
| IDE | IntelliJ IDEA (backend), VS Code (frontend) | Viết code |
| Deploy | Vercel (frontend), Render hoặc Railway qua Docker (backend + MySQL) | Đưa web lên mạng để demo |
| Quản lý code | Git + GitHub | Làm việc nhóm, review code |
| Quản lý công việc | Trello hoặc GitHub Projects | Chia task, theo dõi tiến độ |
| Thiết kế | Figma, draw.io | Giao diện, use case, ERD |
| Kiểm thử API | Postman | Test API, chia sẻ collection |

Nếu nhóm chưa ai quen React, có thể dùng Thymeleaf (render giao diện ngay trong Spring Boot). Tuy nhiên cách đó khó chia việc song song giữa frontend và backend hơn.

## 3. Cấu trúc thư mục

```
online-exam/
├── README.md                     # kế hoạch dự án (file này)
├── .gitignore
├── docs/                         # tài liệu: báo cáo, use case, ERD, Figma, test case
│   ├── bao-cao/
│   ├── thiet-ke/
│   └── kiem-thu/
├── backend/                      # Spring Boot (Maven)
│   ├── pom.xml
│   └── src/
│       ├── main/
│       │   ├── java/com/nhom/exam/
│       │   │   ├── OnlineExamApplication.java
│       │   │   ├── config/       # SecurityConfig, CORS, Swagger
│       │   │   ├── security/     # JwtFilter, JwtUtil, UserDetailsService
│       │   │   ├── entity/       # User, Question, Exam, Attempt…
│       │   │   ├── repository/   # Spring Data JPA repositories
│       │   │   ├── dto/          # request/response DTO
│       │   │   ├── service/      # nghiệp vụ (sinh đề, chấm điểm)
│       │   │   ├── controller/   # REST controllers
│       │   │   └── exception/    # GlobalExceptionHandler
│       │   └── resources/
│       │       ├── application.yml
│       │       ├── application-local.yml.example
│       │       └── db/migration/ # Flyway: V1__init.sql…
│       └── test/java/com/nhom/exam/
└── frontend/                     # React + Vite
    ├── package.json
    ├── vite.config.js
    ├── index.html
    ├── .env.example
    └── src/
        ├── main.jsx
        ├── App.jsx
        ├── api/                  # hàm gọi API (Axios)
        ├── components/           # component dùng chung
        ├── layouts/              # layout admin, giáo viên, thí sinh
        ├── pages/
        │   ├── auth/             # đăng nhập, đăng ký, quên mật khẩu
        │   ├── student/          # danh sách kỳ thi, làm bài, kết quả
        │   ├── teacher/          # câu hỏi, đề thi, kỳ thi, thống kê
        │   └── admin/            # người dùng, môn, lớp
        ├── hooks/
        └── utils/
```

## 4. Hướng dẫn chạy dự án

**Yêu cầu:** JDK 17, Maven 3.9+, Node.js 20+, MySQL 8.

**Backend**

```bash
# 1. Tạo database
mysql -u root -p -e "CREATE DATABASE online_exam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. Tạo file cấu hình local (KHÔNG commit file này)
cd backend
cp src/main/resources/application-local.yml.example src/main/resources/application-local.yml
#    -> sửa username/password MySQL trong application-local.yml

# 3. Chạy (Flyway tự tạo bảng từ db/migration)
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

Backend chạy ở `http://localhost:8080`. Kiểm tra: `http://localhost:8080/api/health`, Swagger UI: `http://localhost:8080/swagger-ui.html`.

**Frontend**

```bash
cd frontend
cp .env.example .env
npm install
npm run dev
```

Frontend chạy ở `http://localhost:5173`.

## 5. Phân công vai trò

Mỗi người sở hữu trọn một mảng, từ code đến phần báo cáo của mảng đó. Thay TV1–TV5 bằng tên thành viên.

| Thành viên | Vai trò | Mảng phụ trách | Phần báo cáo viết |
| --- | --- | --- | --- |
| TV1 | Trưởng nhóm, BA, Tester | Yêu cầu, use case, quản lý tiến độ, test case, kiểm thử, tổng hợp báo cáo và slide | Giới thiệu, đặc tả yêu cầu, use case, kiểm thử, kết luận |
| TV2 | Backend 1 | Thiết kế CSDL; auth (JWT), phân quyền; quản lý người dùng, môn, lớp; deploy backend | Thiết kế CSDL, kiến trúc hệ thống, triển khai |
| TV3 | Backend 2 | Ngân hàng câu hỏi, import Excel; đề thi, sinh đề ngẫu nhiên; kỳ thi, nộp bài, chấm điểm; thống kê, xuất Excel | Sơ đồ tuần tự luồng thi, thuật toán sinh đề và chấm điểm |
| TV4 | Frontend 1 (thí sinh) | Trang chủ, đăng nhập/đăng ký; danh sách kỳ thi; **màn làm bài** (timer, tự lưu, chống gian lận); kết quả, lịch sử thi | Giao diện phía thí sinh, hướng dẫn sử dụng |
| TV5 | Frontend 2 (giáo viên/admin), UI/UX | Thiết kế Figma; layout chung; trang quản lý câu hỏi, đề, kỳ thi, người dùng; dashboard thống kê | Thiết kế giao diện, giao diện quản trị |

**Cặp làm việc:** TV3 với TV4 (luồng làm bài), TV3 với TV5 (quản lý đề), TV2 với cả TV4 và TV5 (đăng nhập, phân quyền). Luồng làm bài và chấm điểm khó nhất, nên giao cho người code vững nhất (TV3).

## 6. Thiết kế database

Cơ sở dữ liệu gồm 12 bảng (script khởi tạo: `backend/src/main/resources/db/migration/V1__init.sql`). TV2 chốt bản này vào cuối tuần 2; sau đó muốn sửa phải báo cả nhóm và **tạo file migration mới** (`V2__...sql`), không sửa file cũ.

| Bảng | Các cột chính | Ghi chú |
| --- | --- | --- |
| users | id, full_name, email, password_hash, role (admin/teacher/student), status, created_at | Email duy nhất |
| subjects | id, name, code | Môn học |
| chapters | id, subject_id, name, order | Chương thuộc môn |
| classes | id, name, teacher_id | Lớp học |
| class_students | class_id, student_id | Nhiều–nhiều |
| questions | id, subject_id, chapter_id, content, type (single/multiple), level (easy/medium/hard), created_by | Câu hỏi |
| answers | id, question_id, content, is_correct | Đáp án của câu hỏi |
| exams | id, title, subject_id, duration_minutes, total_score, created_by | Đề thi |
| exam_questions | exam_id, question_id, order, score | Câu hỏi trong đề |
| exam_sessions | id, exam_id, class_id, start_time, end_time, max_attempts, password, shuffle | Kỳ thi (đợt mở đề) |
| attempts | id, session_id, student_id, started_at, submitted_at, score, status, tab_switch_count | Mỗi lượt làm bài |
| attempt_answers | attempt_id, question_id, selected_answer_ids, is_correct | Đáp án thí sinh chọn |

**Lưu ý:** giờ bắt đầu làm bài phải lưu ở server (`attempts.started_at`), và server tự tính hết giờ. Không tin đồng hồ của trình duyệt, nếu không thí sinh có thể sửa để kéo dài thời gian.

## 7. Lộ trình chi tiết 10 tuần

Mỗi tuần kết thúc bằng một sản phẩm kiểm tra được; **tuần 8 là mốc bắt buộc chạy được toàn bộ luồng thi**.

### Giai đoạn 1 – Phân tích và thiết kế (tuần 1–2)

| Tuần | TV1 (Leader/BA) | TV2 (Backend 1) | TV3 (Backend 2) | TV4 (FE thí sinh) | TV5 (FE quản trị, UI/UX) | Sản phẩm |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Khảo sát 2–3 web thi (Azota, Google Forms quiz…), viết danh sách chức năng, lập Trello | Tìm hiểu Spring Boot, Spring Data JPA, Spring Security + JWT | Tìm hiểu Apache POI (Excel), thuật toán sinh đề | Tìm hiểu React, React Router | Wireframe các màn hình chính | Danh sách chức năng chốt, wireframe |
| 2 | Vẽ use case tổng quát và chi tiết, đặc tả use case | Thiết kế ERD, chốt database | Viết tài liệu API (đường dẫn, request, response) cùng TV2 | Vẽ sơ đồ luồng làm bài | Thiết kế Figma hoàn chỉnh (màu, font, component) | Use case, ERD, tài liệu API, Figma |

### Giai đoạn 2 – Khởi tạo dự án (tuần 3)

| Tuần | TV1 | TV2 | TV3 | TV4 | TV5 | Sản phẩm |
| --- | --- | --- | --- | --- | --- | --- |
| 3 | Tạo repo GitHub, quy ước nhánh, chia task vào Trello, bắt đầu viết báo cáo chương 1–2 | Tạo project Spring Boot (Spring Initializr), kết nối MySQL, tạo Entity và migration Flyway cho tất cả bảng, dữ liệu mẫu | Dựng cấu trúc package, DTO, xử lý lỗi chung (@RestControllerAdvice), validate, Swagger | Dựng project React + Vite, cấu hình router, Axios | Dựng layout chung (header, sidebar), component dùng chung (nút, form, bảng, modal) | Cả nhóm chạy được project trên máy mình |

### Giai đoạn 3 – Code chức năng chính (tuần 4–7)

| Tuần | TV1 | TV2 | TV3 | TV4 | TV5 | Sản phẩm |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | Viết test case đăng nhập, phân quyền; test API bằng Postman | API đăng ký, đăng nhập, JWT, cấu hình Spring Security phân quyền, quên mật khẩu | API môn học, chương; API CRUD câu hỏi và đáp án | Trang đăng nhập, đăng ký, quên mật khẩu; lưu token, chặn trang theo vai trò | Trang quản lý môn học, chương | Đăng nhập đủ 3 vai trò |
| 5 | Test ngân hàng câu hỏi; viết báo cáo phần phân tích | API quản lý người dùng, lớp học, thêm học sinh vào lớp | API import câu hỏi từ Excel; API tạo đề thủ công và ngẫu nhiên theo ma trận | Trang chủ thí sinh, danh sách kỳ thi được thi | Trang ngân hàng câu hỏi (thêm, sửa, xóa, lọc, import Excel) | Giáo viên tạo được câu hỏi |
| 6 | Test tạo đề, tạo kỳ thi | API hồ sơ cá nhân, đổi mật khẩu; hỗ trợ TV3 | API kỳ thi; API bắt đầu làm bài, lưu đáp án, nộp bài, chấm điểm | **Màn làm bài**: hiển thị câu hỏi, chọn đáp án, đồng hồ, ô điều hướng câu | Trang tạo đề, tạo kỳ thi | Thí sinh làm được bài đầu tiên |
| 7 | Test luồng thi đầy đủ, ghi lỗi lên Trello | API quản trị cho admin; tối ưu truy vấn | API kết quả, xem lại bài; API thống kê, xuất Excel bảng điểm | Tự lưu bài, tự nộp khi hết giờ, trang kết quả, lịch sử thi | Trang quản lý người dùng, lớp; trang xem điểm của giáo viên | Đủ chức năng MVP (chưa đẹp) |

### Giai đoạn 4 – Ghép, kiểm thử, hoàn thiện (tuần 8–10)

| Tuần | TV1 | TV2 | TV3 | TV4 | TV5 | Sản phẩm |
| --- | --- | --- | --- | --- | --- | --- |
| 8 | Chạy toàn bộ test case, lập bảng kết quả kiểm thử | Sửa lỗi backend; bảo mật (giới hạn request, kiểm tra quyền từng API) | Sửa lỗi luồng thi; kiểm tra nhiều người thi cùng lúc | Sửa lỗi; responsive cho điện thoại | Sửa lỗi; dashboard biểu đồ thống kê | **Mốc: luồng thi chạy trọn vẹn** |
| 9 | Test lại sau sửa; viết báo cáo kiểm thử | Viết Dockerfile, deploy backend + MySQL lên Render/Railway | Chức năng nâng cao: email kết quả, câu tự luận (nếu kịp) | Chống gian lận: phát hiện chuyển tab, chặn copy, toàn màn hình | Deploy frontend lên Vercel; chỉnh giao diện cho khớp Figma | Web chạy online có link |
| 10 | Ghép báo cáo, làm slide, phân công phần thuyết trình | Viết hướng dẫn cài đặt (README) | Chuẩn bị dữ liệu demo (đề, câu hỏi, tài khoản) | Quay video demo dự phòng | Chụp ảnh màn hình cho báo cáo | Báo cáo, slide, video demo, tập thuyết trình 2 lần |

## 8. Quy ước làm việc nhóm

**Git:**

- Nhánh `main` chỉ chứa code chạy được; nhánh `develop` để ghép code hằng ngày
- Mỗi task một nhánh riêng: `feature/ten-chuc-nang` hoặc `fix/ten-loi`
- Merge vào `develop` qua Pull Request, có ít nhất 1 người review
- Commit rõ nội dung: `feat: them API nop bai`, `fix: loi dong ho het gio`
- Không commit file `.env` và `application-local.yml` (mật khẩu DB, khoá JWT) — đã có sẵn trong `.gitignore`

**Bắt đầu làm một task:**

```bash
git checkout develop
git pull origin develop
git checkout -b feature/ten-chuc-nang
# ... code, commit ...
git push origin feature/ten-chuc-nang
# -> mở Pull Request vào develop trên GitHub
```

**Họp:**

- 2 buổi/tuần, mỗi buổi 15–30 phút: mỗi người nói đã làm gì, sắp làm gì, đang vướng gì
- Vướng quá 1 ngày thì báo ngay trong nhóm chat, không đợi đến buổi họp
- TV1 cập nhật Trello sau mỗi buổi

**Đặt tên:** biến và hàm dùng camelCase, component React và class Java dùng PascalCase, package Java viết thường, bảng và cột DB dùng snake_case, đường dẫn API dùng danh từ số nhiều (`/api/questions`).

## 9. Danh sách API chính

Tất cả API có tiền tố `/api` và trả về JSON. Trừ đăng ký, đăng nhập và quên mật khẩu, mọi API đều cần gửi token (`Authorization: Bearer <token>`).

| Method | Đường dẫn | Chức năng | Quyền | Người làm |
| --- | --- | --- | --- | --- |
| POST | /auth/register, /auth/login | Đăng ký, đăng nhập | Tất cả | TV2 |
| POST | /auth/forgot-password, /auth/reset-password | Quên mật khẩu | Tất cả | TV2 |
| GET/POST/PUT/DELETE | /users | Quản lý người dùng | Admin | TV2 |
| GET/POST/PUT/DELETE | /subjects, /chapters, /classes | Môn, chương, lớp | Admin, Giáo viên | TV2, TV3 |
| GET/POST/PUT/DELETE | /questions | Ngân hàng câu hỏi (lọc theo môn, chương, độ khó) | Giáo viên | TV3 |
| POST | /questions/import | Import câu hỏi từ Excel | Giáo viên | TV3 |
| GET/POST/PUT/DELETE | /exams | Đề thi | Giáo viên | TV3 |
| POST | /exams/generate | Sinh đề ngẫu nhiên theo ma trận | Giáo viên | TV3 |
| GET/POST/PUT | /sessions | Kỳ thi | Giáo viên (tạo), Thí sinh (xem) | TV3 |
| POST | /sessions/{id}/start | Bắt đầu làm bài, trả về đề đã đảo (không kèm đáp án đúng) | Thí sinh | TV3 |
| PUT | /attempts/{id}/answers | Lưu đáp án (tự lưu) | Thí sinh | TV3 |
| POST | /attempts/{id}/submit | Nộp bài, chấm điểm | Thí sinh | TV3 |
| GET | /attempts/{id} | Xem kết quả, xem lại bài | Thí sinh, Giáo viên | TV3 |
| GET | /sessions/{id}/statistics, /sessions/{id}/export | Thống kê, xuất Excel | Giáo viên | TV3 |

**Lưu ý bảo mật:** API trả đề cho thí sinh tuyệt đối không được gửi cột `is_correct`, nếu không thí sinh mở DevTools là thấy đáp án.

## 10. Rủi ro và checklist nộp bài

| Rủi ro | Cách xử lý |
| --- | --- |
| Một thành viên chậm tiến độ | Phát hiện sớm qua họp 2 buổi/tuần; chuyển bớt task cho người cùng cặp |
| Frontend và backend không khớp dữ liệu | Chốt tài liệu API ở tuần 2; dùng chung Swagger và Postman collection |
| Ghép code bị xung đột (conflict) | Nhánh nhỏ, merge thường xuyên, pull `develop` mỗi ngày |
| Không kịp chức năng nâng cao | Ưu tiên MVP; nâng cao chỉ làm từ tuần 9 |
| Deploy lỗi ngày bảo vệ | Deploy từ tuần 9, chạy được local, có video demo dự phòng |
| Thí sinh gian lận thời gian hoặc xem đáp án | Server tính giờ, không gửi đáp án đúng xuống trình duyệt |

**Checklist nộp bài:**

- [ ] Báo cáo: giới thiệu, đặc tả yêu cầu, use case, ERD, sơ đồ tuần tự, thiết kế giao diện, kiểm thử, kết luận
- [ ] Source code trên GitHub, có README hướng dẫn cài đặt
- [ ] File SQL tạo database và dữ liệu mẫu
- [ ] Link web đã deploy và tài khoản demo cho cả 3 vai trò
- [ ] Slide thuyết trình, mỗi người trình bày phần mình làm
- [ ] Video demo dự phòng 3–5 phút
- [ ] Bảng phân công và đánh giá mức độ đóng góp của từng thành viên
