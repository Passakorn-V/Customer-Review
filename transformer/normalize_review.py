def normalize_review(raw, platform):
    return {
        "platform": platform,
        "platform_review_id": raw.get("review_id"),
        "platform_product_id": raw.get("product_id"),
        "rating_score": normalize_rating_score(platform, raw.get("rating")),
        "rating_text": normalize_rating_text(platform, raw.get("rating")),
        "review_text": raw.get("review_text"),
        "reviewer_name": raw.get("reviewer"),
        "review_date": raw.get("review_date"),
        "product_option": raw.get("product_option"),
    }


def normalize_rating_score(platform, rating):
    if platform == "Shopee":
        try:
            return int(rating)
        except Exception:
            return None
    return None


def normalize_rating_text(platform, rating):
    if platform == "Lazada":
        if rating in ["Nice performance", "ประสิทธิภาพดี"]:
            return rating
    return None
