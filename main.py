from shopee.extractor import ShopeeExtractor
from lazada.extractor import LazadaExtractor
from transformer.normalize_review import normalize_review
from loader.load_to_db import load


def run():
    shopee_reviews = []
    lazada_reviews = []

    # Shopee
    for r in ShopeeExtractor().extract():
        shopee_reviews.append(normalize_review(r, "Shopee"))
    load(shopee_reviews)

    # Lazada
    for r in LazadaExtractor().extract():
        lazada_reviews.append(normalize_review(r, "Lazada"))
    load(lazada_reviews)

    print(f"============================================")
    print(f"Shopee Review : {len(shopee_reviews)}")
    print(f"Lazada Review : {len(lazada_reviews)}")
    print(f"============================================")

if __name__ == "__main__":
    run()
