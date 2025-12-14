# ER Diagram – Customer Review ETL Pipeline

## Entity: dim_platform
ใช้เก็บข้อมูลแพลตฟอร์ม E-commerce

| Field Name     | Type        | Description    |
|----------------|-------------|----------------|
| platform_id    | PK, INT     | Primary key    |
| platform_name  | VARCHAR     | Shopee, Lazada |

---

## Entity: dim_product
ใช้เก็บข้อมูลสินค้า แยกตามแพลตฟอร์ม

| Field Name            | Type        | Description             |
|-----------------------|-------------|-------------------------|
| product_id            | PK, INT     | Primary key             |
| platform_product_id   | VARCHAR     | Product ID จากแพลตฟอร์ม |
| platform_id           | FK, INT     | อ้างอิง dim_platform      |

Relationship:
- dim_platform (1) —— (N) dim_product

---

## Entity: fact_customer_review
ใช้เก็บข้อมูลรีวิวลูกค้า (Fact Table)

| Field Name           | Type          | Description            |
|----------------------|---------------|------------------------|
| review_id            | PK, INT       | Primary key            |
| platform_review_id   | VARCHAR       | Review ID จากแพลตฟอร์ม |
| product_id           | FK, INT       | อ้างอิง dim_product      |
| rating_score         | INT, NULL     | ใช้กับ Shopee (4 ดาว)    |
| rating_text          | VARCHAR, NULL | ใช้กับ Lazada            |
| review_text          | TEXT          | ข้อความรีวิว              |
| reviewer_name        | VARCHAR, NULL | ชื่อผู้รีวิว                 |
| review_date          | DATE          | วันที่รีวิว                 |
| product_option       | VARCHAR       | ตัวเลือกสินค้า             |

Relationship:
- dim_product (1) —— (N) fact_customer_review

---

## ER Relationship Overview

dim_platform
└───< dim_product
└───< fact_customer_review


## Design Consideration

- แยก Dimension / Fact รองรับ BI & Analytics
- รองรับหลายแพลตฟอร์มและสินค้าใหม่ในอนาคต
- รองรับ schema ที่ต่างกันของ Shopee และ Lazada
- ไม่บังคับ rating_score / rating_text พร้อมกัน