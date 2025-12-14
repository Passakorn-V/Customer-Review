-- ================================
-- Dimension: Platform
-- ================================
CREATE TABLE dim_platform (
    platform_id SERIAL PRIMARY KEY,
    platform_name VARCHAR(50) NOT NULL UNIQUE
);

-- ================================
-- Dimension: Product
-- ================================
CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    platform_product_id VARCHAR(100) NOT NULL,
    platform_id INT NOT NULL,
    CONSTRAINT fk_product_platform
        FOREIGN KEY (platform_id)
        REFERENCES dim_platform(platform_id),
    CONSTRAINT uq_platform_product
        UNIQUE (platform_product_id, platform_id)
);

-- ================================
-- Fact: Customer Review
-- ================================
CREATE TABLE fact_customer_review (
    review_id SERIAL PRIMARY KEY,
    platform_review_id VARCHAR(100) NOT NULL,
    product_id INT NOT NULL,
    rating_score INT NULL,
    rating_text VARCHAR(100) NULL,
    review_text TEXT NOT NULL,
    reviewer_name VARCHAR(100) NULL,
    review_date DATE NOT NULL,
    product_option VARCHAR(100),

    CONSTRAINT fk_review_product
        FOREIGN KEY (product_id)
        REFERENCES dim_product(product_id),

    CONSTRAINT uq_platform_review
        UNIQUE (platform_review_id)
);

-- ================================
-- Optional: Indexes for Analytics
-- ================================
CREATE INDEX idx_review_date
    ON fact_customer_review (review_date);

CREATE INDEX idx_rating_score
    ON fact_customer_review (rating_score);

CREATE INDEX idx_rating_text
    ON fact_customer_review (rating_text);