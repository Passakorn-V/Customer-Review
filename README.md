Customer Review ETL Pipeline (Shopee & Lazada)

1. Overview

โปรเจกต์นี้เป็น Customer Review ETL Pipeline สำหรับดึงข้อมูลรีวิวสินค้าจากแพลตฟอร์ม E-commerce ได้แก่ Shopee และ Lazada แล้วนำมารวมไว้ใน Database กลาง เพื่อรองรับการวิเคราะห์เชิงธุรกิจ (BI / Analytics) ในอนาคต

ขอบเขตงานออกแบบให้:
รองรับหลายแพลตฟอร์ม (Multi-platform)
รองรับสินค้าใหม่ในอนาคต
Query เพื่อวิเคราะห์ข้อมูลได้ง่าย


2. Architecture Overview

<img width="483" height="243" alt="image" src="https://github.com/user-attachments/assets/84d103fd-ae3d-4524-b74b-22cabd9f8dfe" />



ETL Flow

Extract: ดึงข้อมูลรีวิวจากแต่ละแพลตฟอร์ม (Mock Data)
Transform: ปรับ schema ให้อยู่ในรูปแบบกลาง (Unified Schema)
Load: โหลดข้อมูลเข้าสู่ Database กลาง (แสดงผลด้วย print เพื่อจำลอง)


3. Project Structure

<img width="292" height="503" alt="image" src="https://github.com/user-attachments/assets/c347d2d9-ae6c-4cde-8346-e46bdb850778" />



4. Data Handling Rules


Shopee

ใช้เฉพาะรีวิวที่ คะแนน = 4 ดาวเท่านั้น
rating ถูกเก็บในฟิลด์ rating_score


Lazada

ใช้เฉพาะรีวิวที่ rating เป็นข้อความ:
Nice performance
ประสิทธิภาพดี
rating ถูกเก็บในฟิลด์ rating_text

Dirty Data Handling
reviewer_name สามารถเป็น NULL
rating ที่ไม่เข้าเงื่อนไขจะไม่ถูกแปลงเป็นค่าอื่น (คงค่า NULL)
review_date ต้องมีอย่างน้อยระดับวัน (DATE)


5. Unified Review Schema

<img width="541" height="285" alt="image" src="https://github.com/user-attachments/assets/06df460e-b554-47c4-a3e1-b6ea39450b93" />



6. Database Design

รายละเอียด ER Diagram และ SQL DDL อยู่ในโฟลเดอร์:

<img width="227" height="96" alt="image" src="https://github.com/user-attachments/assets/90d1b6ea-a99c-4636-b249-fe5b435c58b2" />


โครงสร้างถูกออกแบบแบบ Star Schema (Dimension + Fact) เพื่อรองรับ BI และ Analytics


7. How to Run


Run : python main.py

ตัวอย่าง Output:
Load to DB: { platform: 'Shopee', ... }
Load to DB: { platform: 'Lazada', ... }
Shopee Review : 2
Lazada Review : 3


8. Future Enhancement

เชื่อมต่อ API จริงของ Shopee / Lazada
Load ข้อมูลเข้า Database จริง (PostgreSQL / MySQL)
เพิ่มแพลตฟอร์มใหม่ เช่น TikTok (rating_score)
เพิ่ม orchestration ด้วย Airflow


9. Notes for Reviewer

โปรเจกต์นี้เน้น แนวคิด Data Engineering:
การออกแบบ schema กลาง
รองรับ schema ที่แตกต่างกันของแต่ละแพลตฟอร์ม
คำนึงถึง scalability และ analytics use case
Mock Data ถูกใช้เพื่อจำลองโครงสร้างและ logic ของ ETL Pipeline


## ข้อจำกัดในการดึงข้อมูล (Web Scraping & Data Access Constraint)

ใน Assignment นี้ **ไม่ได้ทำการดึงข้อมูลรีวิวจากหน้าเว็บไซต์ของ Shopee และ Lazada โดยตรง (Web Scraping)**

### เหตุผล
แพลตฟอร์ม Shopee และ Lazada มีการออกแบบระบบดังนี้
- ใช้การแสดงผลข้อมูลแบบ Dynamic (JavaScript Rendering)
- เรียกข้อมูลรีวิวผ่าน API ที่ต้องใช้ Access Token 
- มีระบบป้องกันการดึงข้อมูลอัตโนมัติ (Anti-Bot / Rate Limit / Token Validation)

ดังนั้น การดึงข้อมูลรีวิวด้วยวิธี Web Scraping แบบทั่วไป  
เช่น `requests`, `BeautifulSoup` **ไม่สามารถทำได้อย่างถูกต้อง**
หากไม่มี Token หรือการยืนยันตัวตนจากแพลตฟอร์ม

### แนวทางที่เลือกใช้ในโปรเจคนี้
เพื่อให้สอดคล้องกับวัตถุประสงค์ของ Data Engineer Assignment  
ซึ่งเน้นไปที่
- การออกแบบ ETL Pipeline
- การออกแบบ Database Schema
- การรองรับหลายแพลตฟอร์ม (Multi-platform)
- การเตรียมข้อมูลเพื่อใช้งานด้าน Analytics / BI

โปรเจคนี้จึงใช้ **Mock Data** แทนการดึงข้อมูลจริง โดย:
- ออกแบบโครงสร้างข้อมูลให้ใกล้เคียงข้อมูลจริงจากแต่ละแพลตฟอร์ม
- รองรับรูปแบบคะแนนรีวิวที่แตกต่างกันของ Shopee และ Lazada
- จำลองกรณีข้อมูลไม่สมบูรณ์ (Dirty Data) เช่น
  - ไม่มีชื่อผู้รีวิว
  - ไม่มีคะแนนรีวิว

### เหตุผลเชิง Data Engineering
ในงานจริง ข้อมูลมักถูกดึงมาจาก:
- Internal API
- Official Partner API
- Data Provider
- Message Queue หรือ Data Lake

Data Engineer จึงมีหน้าที่หลักในการ:
- Normalize ข้อมูลจากหลายแหล่ง
- จัดการ Schema ที่แตกต่างกัน
- เตรียมข้อมูลให้อยู่ในรูปแบบที่พร้อมต่อการวิเคราะห์

### แนวทางการพัฒนาในอนาคต
หากมีการเข้าถึง Official API หรือ Token ที่ได้รับอนุญาตจากแพลตฟอร์ม
สามารถนำ Extract Layer ไปเชื่อมต่อ API จริงได้ทันที
โดยไม่ต้องแก้ไขโครงสร้าง Transform และ Load ที่ออกแบบไว้

### ตัวอย่างผลลัพธ์ 
<img width="1488" height="324" alt="image" src="https://github.com/user-attachments/assets/f542dc96-e0d3-4510-b964-1dad06573ef3" />

