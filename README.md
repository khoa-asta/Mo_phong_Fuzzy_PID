 viện
/
README_Mo_phong_Fuzzy_PID.md


# MÔ PHỎNG BỘ ĐIỀU KHIỂN FUZZY PID CHO QUADROTOR

## 1. Giới thiệu

Dự án này xây dựng và mô phỏng bộ điều khiển **Fuzzy PID** cho Quadrotor trên nền tảng **MATLAB/Simulink**.

Mục tiêu của mô phỏng là đánh giá khả năng bám quỹ đạo và ổn định tư thế của bộ điều khiển Fuzzy PID, đồng thời so sánh với bộ điều khiển PID truyền thống trong hai điều kiện:

- Quadrotor hoạt động với thông số mô hình ban đầu.
- Thông số mô hình thay đổi khi Quadrotor được lắp thêm vật nặng.

Bộ điều khiển Fuzzy PID sử dụng logic mờ để điều chỉnh các tham số PID theo sai lệch của hệ thống trong quá trình hoạt động. Nhờ đó, bộ điều khiển có khả năng thích nghi tốt hơn khi tải trọng hoặc điều kiện làm việc thay đổi.

---

## 2. Mục tiêu của dự án

- Xây dựng mô hình động lực học 6 bậc tự do của Quadrotor.
- Thiết kế cấu trúc điều khiển phân tầng cho vị trí, tư thế và tốc độ góc.
- Xây dựng bộ điều khiển PID truyền thống làm cơ sở so sánh.
- Thiết kế bộ điều khiển Fuzzy PID tự điều chỉnh tham số.
- Mô phỏng Quadrotor bay theo quỹ đạo hình vuông trong không gian ba chiều.
- Đánh giá khả năng bám quỹ đạo, độ vọt lố, thời gian xác lập và khả năng thích nghi khi tải trọng thay đổi.

---

## 3. Mô hình Quadrotor

Quadrotor sử dụng cấu hình chữ **X**, gồm bốn động cơ bố trí đối xứng quanh trọng tâm:

- Hai động cơ quay theo chiều kim đồng hồ.
- Hai động cơ quay ngược chiều kim đồng hồ.
- Mô-men phản lực giữa các động cơ được triệt tiêu khi hệ thống cân bằng.

Chuyển động của Quadrotor được mô tả thông qua 6 bậc tự do:

### Chuyển động tịnh tiến

- Vị trí theo trục \(x\).
- Vị trí theo trục \(y\).
- Độ cao theo trục \(z\).

### Chuyển động quay

- Góc Roll \(\phi\).
- Góc Pitch \(\theta\).
- Góc Yaw \(\psi\).

Đầu vào điều khiển của mô hình gồm:

- \(U_1\): tổng lực đẩy.
- \(U_2\): mô-men điều khiển Roll.
- \(U_3\): mô-men điều khiển Pitch.
- \(U_4\): mô-men điều khiển Yaw.

---

## 4. Cấu trúc điều khiển phân tầng

Hệ thống điều khiển được chia thành nhiều vòng điều khiển:

### Vòng điều khiển vị trí và độ cao

Vòng ngoài nhận giá trị đặt của vị trí và độ cao, sau đó sinh ra lực đẩy tổng và giá trị đặt tư thế.

### Vòng điều khiển tư thế

Vòng điều khiển tư thế nhận giá trị đặt Roll, Pitch và Yaw, sau đó sinh ra giá trị đặt tốc độ góc.

Cấu trúc phân tầng giúp chia bài toán phi tuyến, đa biến thành các vòng điều khiển nhỏ hơn và dễ ổn định hơn.

---

## 5. Bộ điều khiển PID truyền thống

Bộ điều khiển PID được mô tả bởi:

\[
u(t)=K_p e(t)+K_i\int_0^t e(\tau)d\tau+K_d\frac{de(t)}{dt}
\]

Trong đó:

- \(e(t)\): sai lệch giữa giá trị đặt và giá trị thực tế.
- \(K_p\): hệ số tỉ lệ.
- \(K_i\): hệ số tích phân.
- \(K_d\): hệ số vi phân.

PID truyền thống có cấu trúc đơn giản và dễ triển khai. Tuy nhiên, bộ tham số PID thường chỉ phù hợp với một điều kiện làm việc nhất định. Khi khối lượng, tải trọng hoặc thông số mô hình thay đổi, chất lượng điều khiển có thể suy giảm.

---

## 6. Bộ điều khiển Fuzzy PID

Bộ điều khiển Fuzzy PID kết hợp bộ điều khiển PID với một hệ suy luận mờ.

Các tham số PID được hiệu chỉnh theo thời gian thực:

\[
K_p^\ast=K_p+\Delta K_p
\]

\[
K_i^\ast=K_i+\Delta K_i
\]

\[
K_d^\ast=K_d+\Delta K_d
\]

Tín hiệu điều khiển được xác định bởi:

\[
u(t)=K_p^\ast e(t)+K_i^\ast\int_0^t e(\tau)d\tau+K_d^\ast\frac{de(t)}{dt}
\]

### Đầu vào của bộ điều khiển mờ

- Sai lệch \(e(t)\).
- Đạo hàm sai lệch \(de(t)\).

### Đầu ra của bộ điều khiển mờ

- \(\Delta K_p\).
- \(\Delta K_i\).
- \(\Delta K_d\).

### Các biến ngôn ngữ

Mỗi đầu vào được mô tả bằng 7 biến ngôn ngữ:

- NB: âm lớn.
- NM: âm vừa.
- NS: âm nhỏ.
- Z: bằng không.
- PS: dương nhỏ.
- PM: dương vừa.
- PB: dương lớn.

Với hai đầu vào và 7 biến ngôn ngữ, hệ thống sử dụng **49 luật mờ** cho mỗi đầu ra.

### Quy trình suy luận mờ

1. **Mờ hóa:** chuyển đổi các giá trị số của \(e\) và \(de\) thành mức độ thuộc của các biến ngôn ngữ.
2. **Suy luận:** áp dụng các luật If–Then theo phương pháp Mamdani.
3. **Giải mờ:** chuyển kết quả suy luận thành các giá trị số \(\Delta K_p\), \(\Delta K_i\), \(\Delta K_d\).

---

## 7. Kịch bản mô phỏng

Quadrotor được yêu cầu bay theo quỹ đạo hình vuông trong không gian ba chiều.

Hai bộ điều khiển được mô phỏng trong cùng điều kiện:

- PID truyền thống.
- Fuzzy PID.

### Kịch bản 1: Không lắp thêm vật nặng

Quadrotor hoạt động với khối lượng và thông số mô hình ban đầu.

Mục đích của kịch bản này là kiểm tra khả năng bám quỹ đạo và ổn định tư thế trong điều kiện danh định.

### Kịch bản 2: Lắp thêm vật nặng

Khối lượng của Quadrotor được thay đổi trong quá trình mô phỏng.

Mục đích của kịch bản này là đánh giá khả năng thích nghi của bộ điều khiển khi thông số mô hình không còn giống với điều kiện thiết kế ban đầu.

---

## 8. Các tín hiệu được đánh giá

Kết quả mô phỏng được đánh giá thông qua:

- Quỹ đạo thực tế theo các trục \(x\), \(y\), \(z\).
- Sai số vị trí \(e_x\), \(e_y\), \(e_z\).
- Sai số góc Roll \(e_\phi\).
- Sai số góc Pitch \(e_\theta\).
- Sai số góc Yaw \(e_\psi\).
- Độ vọt lố.
- Thời gian xác lập.
- Khả năng dập tắt dao động.
- Khả năng thích nghi khi tải trọng thay đổi.

---

## 9. Nhận xét kết quả mô phỏng

### Sai số vị trí

Trong giai đoạn khởi động, PID truyền thống có thể bám quỹ đạo tốt hơn. Tuy nhiên, tại các thời điểm thay đổi trạng thái tiếp theo, Fuzzy PID duy trì biên độ sai số và độ vọt lố nhỏ hơn.

### Góc Roll và Pitch

Khi Quadrotor chuyển hướng đột ngột, Fuzzy PID có thể tạo ra sai số tức thời lớn hơn. Tuy nhiên, bộ điều khiển dập tắt dao động nhanh và có thời gian xác lập ngắn hơn PID truyền thống.

PID truyền thống có xu hướng mất nhiều thời gian hơn để ổn định và có thể còn dao động quanh giá trị đặt.

### Góc Yaw

Fuzzy PID giúp sai số góc Yaw hội tụ nhanh và mượt hơn. Trong kết quả mô phỏng, bộ điều khiển hạn chế hiện tượng vọt lố âm tốt hơn PID truyền thống.

### Khi tải trọng thay đổi

Fuzzy PID thể hiện khả năng thích nghi tốt hơn nhờ tự động điều chỉnh các hệ số PID theo trạng thái sai lệch của hệ thống.

Kết quả cho thấy Fuzzy PID có tiềm năng cải thiện độ ổn định và khả năng đáp ứng của Quadrotor khi thông số mô hình thay đổi.

---


- PX4 Autopilot.
- Hệ thống tự hành.
- Logic mờ và điều khiển thích nghi.
