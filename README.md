# MÔ PHỎNG BỘ ĐIỀU KHIỂN FUZZY PID CHO QUADROTOR

## 1. Giới thiệu

Dự án xây dựng và mô phỏng bộ điều khiển **Fuzzy PID** cho Quadrotor trên nền tảng **MATLAB/Simulink**.

Mục tiêu chính của dự án là đánh giá khả năng bám quỹ đạo, ổn định vị trí và ổn định tư thế của Quadrotor khi sử dụng bộ điều khiển Fuzzy PID. Kết quả được so sánh với bộ điều khiển PID truyền thống trong hai điều kiện:

- Quadrotor hoạt động với thông số mô hình ban đầu.
- Thông số mô hình thay đổi khi Quadrotor được lắp thêm tải trọng.

Bộ điều khiển Fuzzy PID sử dụng logic mờ để hiệu chỉnh các hệ số PID dựa trên sai lệch và tốc độ thay đổi của sai lệch. Nhờ đó, bộ điều khiển có khả năng thích nghi tốt hơn khi tải trọng hoặc điều kiện hoạt động thay đổi.

---

## 2. Mục tiêu của dự án

- Xây dựng mô hình động lực học 6 bậc tự do của Quadrotor.
- Thiết kế cấu trúc điều khiển phân tầng cho vị trí và tư thế.
- Xây dựng bộ điều khiển PID truyền thống làm cơ sở so sánh.
- Thiết kế bộ điều khiển Fuzzy PID tự hiệu chỉnh tham số.
- Mô phỏng Quadrotor bay theo quỹ đạo hình vuông trong không gian ba chiều.
- So sánh khả năng bám quỹ đạo của PID và Fuzzy PID.
- Đánh giá độ vọt lố, thời gian xác lập và khả năng dập tắt dao động.
- Kiểm tra khả năng thích nghi khi khối lượng của Quadrotor thay đổi.

---

## 3. Mô hình Quadrotor

Quadrotor sử dụng cấu hình chữ **X**, gồm bốn động cơ bố trí đối xứng quanh trọng tâm:

- Hai động cơ quay theo chiều kim đồng hồ.
- Hai động cơ quay ngược chiều kim đồng hồ.
- Mô-men phản lực giữa các động cơ được triệt tiêu khi hệ thống ở trạng thái cân bằng.

Chuyển động của Quadrotor được mô tả thông qua 6 bậc tự do.

### 3.1. Chuyển động tịnh tiến

- Vị trí theo trục $x$.
- Vị trí theo trục $y$.
- Độ cao theo trục $z$.

### 3.2. Chuyển động quay

- Góc Roll $\phi$.
- Góc Pitch $\theta$.
- Góc Yaw $\psi$.

### 3.3. Đầu vào điều khiển

Các đầu vào điều khiển của mô hình gồm:

- $U_1$: tổng lực đẩy của bốn động cơ.
- $U_2$: mô-men điều khiển Roll.
- $U_3$: mô-men điều khiển Pitch.
- $U_4$: mô-men điều khiển Yaw.

---

## 4. Cấu trúc điều khiển phân tầng

Hệ thống sử dụng cấu trúc điều khiển phân tầng nhằm chia bài toán điều khiển phi tuyến và đa biến thành các vòng điều khiển nhỏ hơn.

### 4.1. Vòng điều khiển vị trí và độ cao

Vòng ngoài nhận giá trị đặt của vị trí và độ cao:

- $x_d$.
- $y_d$.
- $z_d$.

Từ sai lệch vị trí, bộ điều khiển tính toán:

- Tổng lực đẩy yêu cầu.
- Góc Roll đặt.
- Góc Pitch đặt.
- Góc Yaw đặt.

### 4.2. Vòng điều khiển tư thế

Vòng điều khiển tư thế nhận giá trị đặt của các góc:

- Roll $\phi_d$.
- Pitch $\theta_d$.
- Yaw $\psi_d$.

Bộ điều khiển tạo ra các mô-men điều khiển $U_2$, $U_3$ và $U_4$ để ổn định tư thế Quadrotor.

Cấu trúc phân tầng giúp các vòng điều khiển có thể được thiết kế và tinh chỉnh độc lập, từ đó cải thiện độ ổn định của hệ thống.

---

## 5. Bộ điều khiển PID truyền thống

Bộ điều khiển PID được mô tả bởi:

$$
u(t) =
K_p e(t)
+
K_i \int_{0}^{t} e(\tau)\,d\tau
+
K_d \frac{de(t)}{dt}
$$

Trong đó:

- $e(t)$: sai lệch giữa giá trị đặt và giá trị thực tế.
- $K_p$: hệ số tỉ lệ.
- $K_i$: hệ số tích phân.
- $K_d$: hệ số vi phân.
- $u(t)$: tín hiệu điều khiển.

### Vai trò của các thành phần PID

- Thành phần tỉ lệ $K_p e(t)$ giúp hệ thống phản ứng nhanh với sai lệch.
- Thành phần tích phân giúp giảm sai lệch xác lập.
- Thành phần vi phân giúp hạn chế dao động và cải thiện độ ổn định.

PID truyền thống có cấu trúc đơn giản và dễ triển khai. Tuy nhiên, một bộ tham số PID cố định thường chỉ phù hợp với một điều kiện hoạt động nhất định.

Khi khối lượng, tải trọng hoặc thông số mô hình thay đổi, chất lượng điều khiển có thể suy giảm.

---

## 6. Bộ điều khiển Fuzzy PID

Bộ điều khiển Fuzzy PID kết hợp bộ điều khiển PID truyền thống với một hệ suy luận mờ.

Hệ suy luận mờ tính toán các lượng hiệu chỉnh:

- $\Delta K_p$.
- $\Delta K_i$.
- $\Delta K_d$.

Các tham số PID sau khi hiệu chỉnh được xác định bởi:

$$ K_p^{*}=K_p+\Delta K_p $$

$$ K_i^{*}=K_i+\Delta K_i $$

$$ K_d^{*}=K_d+\Delta K_d $$

Tín hiệu điều khiển Fuzzy PID được xác định bởi:

$$ u(t) = K_p^{*}e(t) + K_i^{*}\int_{0}^{t}e(\tau)\,d\tau + K_d^{*}\frac{de(t)}{dt} $$

Hoặc viết đầy đủ:

$$ u(t) = \left(K_p+\Delta K_p\right)e(t) + \left(K_i+\Delta K_i\right) \int_{0}^{t}e(\tau)\,d\tau + \left(K_d+\Delta K_d\right) \frac{de(t)}{dt} $$

---

## 7. Hệ suy luận mờ

### 7.1. Đầu vào của bộ điều khiển mờ

Hệ suy luận mờ sử dụng hai đầu vào:

- Sai lệch $e(t)$.
- Tốc độ thay đổi sai lệch $de(t)$.

Trong mô hình rời rạc, tốc độ thay đổi sai lệch có thể được tính gần đúng:

$$
de(k) =
\frac{e(k)-e(k-1)}{T_s}
$$

Trong đó $T_s$ là chu kỳ lấy mẫu.

### 7.2. Đầu ra của bộ điều khiển mờ

Hệ suy luận mờ tạo ra ba đầu ra:

- $\Delta K_p$.
- $\Delta K_i$.
- $\Delta K_d$.

### 7.3. Các biến ngôn ngữ

Mỗi đầu vào được mô tả bằng 7 biến ngôn ngữ:

| Ký hiệu | Ý nghĩa |
|---|---|
| NB | Âm lớn |
| NM | Âm vừa |
| NS | Âm nhỏ |
| Z | Bằng không |
| PS | Dương nhỏ |
| PM | Dương vừa |
| PB | Dương lớn |

Với hai đầu vào và 7 biến ngôn ngữ cho mỗi đầu vào, hệ thống sử dụng:

$$
7 \times 7 = 49
$$

luật mờ cho mỗi đầu ra.

### 7.4. Quy trình suy luận mờ

Quá trình suy luận gồm ba bước:

1. **Mờ hóa:** chuyển các giá trị số của $e$ và $de$ thành mức độ thuộc của các biến ngôn ngữ.
2. **Suy luận:** áp dụng tập luật If–Then theo phương pháp Mamdani.
3. **Giải mờ:** chuyển kết quả suy luận thành các giá trị số $\Delta K_p$, $\Delta K_i$ và $\Delta K_d$.

---

## 8. Nguyên tắc xây dựng luật mờ

Bảng luật được xây dựng dựa trên trạng thái sai lệch của hệ thống.

### Khi sai lệch lớn

- Tăng $K_p$ để hệ thống phản ứng nhanh hơn.
- Hạn chế $K_i$ để tránh tích lũy sai lệch quá mức.
- Điều chỉnh $K_d$ để hạn chế dao động.

### Khi sai lệch nhỏ

- Giảm $K_p$ để hạn chế vọt lố.
- Tăng ảnh hưởng của $K_i$ để loại bỏ sai lệch xác lập.
- Điều chỉnh $K_d$ để duy trì đáp ứng ổn định.

### Khi sai lệch thay đổi nhanh

- Tăng tác động của thành phần vi phân.
- Hạn chế sự thay đổi quá nhanh của tín hiệu điều khiển.
- Giảm khả năng xuất hiện dao động lớn.

---

## 9. Quỹ đạo mô phỏng

Quadrotor được yêu cầu bay theo quỹ đạo hình vuông trong không gian ba chiều.

Quá trình mô phỏng bao gồm:

1. Cất cánh và đạt độ cao yêu cầu.
2. Di chuyển theo trục $x$.
3. Chuyển hướng và di chuyển theo trục $y$.
4. Tiếp tục di chuyển qua các cạnh của quỹ đạo hình vuông.
5. Trở về vị trí ban đầu.

Hai bộ điều khiển được mô phỏng trong cùng điều kiện:

- PID truyền thống.
- Fuzzy PID.

---

## 10. Các kịch bản mô phỏng

### 10.1. Kịch bản 1: Không lắp thêm tải trọng

Quadrotor hoạt động với khối lượng và thông số mô hình ban đầu.

Mục tiêu của kịch bản này là đánh giá:

- Khả năng cất cánh.
- Khả năng bám quỹ đạo.
- Khả năng ổn định vị trí.
- Khả năng ổn định các góc Roll, Pitch và Yaw.
- Độ vọt lố và thời gian xác lập.

### 10.2. Kịch bản 2: Lắp thêm tải trọng

Khối lượng của Quadrotor được thay đổi bằng cách bổ sung thêm tải trọng.

Mục tiêu của kịch bản này là đánh giá khả năng thích nghi của bộ điều khiển khi thông số mô hình không còn giống điều kiện thiết kế ban đầu.

Bộ tham số PID truyền thống được giữ nguyên để quan sát ảnh hưởng của sự thay đổi tải trọng. Trong khi đó, Fuzzy PID tiếp tục hiệu chỉnh các hệ số điều khiển theo trạng thái sai lệch của hệ thống.

---

## 11. Các tín hiệu được đánh giá

Kết quả mô phỏng được đánh giá thông qua các tín hiệu sau.

### 11.1. Vị trí

- Vị trí thực tế theo trục $x$.
- Vị trí thực tế theo trục $y$.
- Độ cao thực tế theo trục $z$.
- Giá trị đặt theo từng trục.

### 11.2. Sai số vị trí

$$
e_x=x_d-x
$$

$$
e_y=y_d-y
$$

$$
e_z=z_d-z
$$

### 11.3. Sai số tư thế

$$
e_{\phi}=\phi_d-\phi
$$

$$
e_{\theta}=\theta_d-\theta
$$

$$
e_{\psi}=\psi_d-\psi
$$

### 11.4. Các tiêu chí đánh giá

- Sai số bám quỹ đạo.
- Độ vọt lố.
- Thời gian xác lập.
- Mức độ dao động.
- Khả năng dập tắt dao động.
- Khả năng thích nghi khi tải trọng thay đổi.

---

## 12. Nhận xét kết quả mô phỏng

### 12.1. Sai số vị trí

Trong giai đoạn khởi động, PID truyền thống có thể tạo ra đáp ứng bám quỹ đạo nhanh hơn.

Tuy nhiên, tại các thời điểm Quadrotor thay đổi hướng chuyển động, Fuzzy PID có khả năng duy trì biên độ sai số và độ vọt lố nhỏ hơn.

### 12.2. Góc Roll và Pitch

Khi Quadrotor chuyển hướng đột ngột, Fuzzy PID có thể tạo ra một số đỉnh sai số tức thời.

Tuy nhiên, bộ điều khiển có khả năng dập tắt dao động nhanh và đạt trạng thái ổn định trong thời gian ngắn hơn.

PID truyền thống có xu hướng mất nhiều thời gian hơn để ổn định và có thể xuất hiện dao động dư quanh giá trị đặt.

### 12.3. Góc Yaw

Fuzzy PID giúp sai số góc Yaw hội tụ nhanh và mượt hơn.

Trong kết quả mô phỏng, bộ điều khiển Fuzzy PID hạn chế hiện tượng vọt lố âm tốt hơn PID truyền thống.

### 12.4. Khi tải trọng thay đổi

Khi khối lượng Quadrotor thay đổi, chất lượng đáp ứng của PID truyền thống có thể suy giảm do các hệ số $K_p$, $K_i$ và $K_d$ được giữ cố định.

Fuzzy PID thể hiện khả năng thích nghi tốt hơn nhờ tự động điều chỉnh các hệ số PID theo trạng thái sai lệch của hệ thống.

Kết quả mô phỏng cho thấy Fuzzy PID có tiềm năng cải thiện:

- Độ ổn định.
- Khả năng bám quỹ đạo.
- Khả năng dập tắt dao động.
- Khả năng thích nghi khi thông số mô hình thay đổi.

---

## 13. Công cụ sử dụng

- MATLAB.
- Simulink.
- Fuzzy Logic Toolbox.
- Control System Toolbox.

---

