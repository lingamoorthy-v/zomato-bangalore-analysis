# Insights and Recommendations: Zomato Bangalore

**Data:** 12,464 unique restaurants (after cleaning). 9,446 have a rating. "Reliable" ratings below means restaurants with **50+ votes** (4,843 restaurants), so a 4.8 from 5 votes does not distort results.

## Key findings

**1. Restaurants are concentrated in a few areas.**
Whitefield (885), Electronic City (731), BTM (729), HSR (705) and Marathahalli (684) lead. The top 5 areas hold about 30% of all restaurants.

**2. The market is dominated by Quick Bites and budget places.**
Quick Bites are 41% of restaurants (5,136), followed by Casual Dining (2,422). Budget places (up to ₹300 for two) are 41%, Mid (₹301 to 600) 39%, Premium 13%, Luxury only 6%. Median cost for two is ₹400.

**3. Higher price goes with higher rating.**
Reliable average rating by price band: Budget 3.79, Mid 3.71, Premium 3.83, **Luxury 4.16**. Across areas, average cost and average rating correlate at about 0.64. Lavelle Road (avg cost ₹1,414) has the best area rating (4.13).

**4. Table booking goes with much higher ratings; online ordering does not.**
Among restaurants with 50+ votes, those with table booking average **4.13** vs 3.75 without. Online-order restaurants average 3.79 vs 3.88 for those without, so online ordering shows no rating advantage once unreliable ratings are removed. (Across all rated restaurants the gap flips slightly the other way, 3.65 vs 3.59, which is why the vote filter matters.) This shows association only; booking is likely a marker of sit-down, higher-end places.

**5. Cuisine type matters for ratings.**
Best-rated cuisines (30+ rated restaurants): Japanese 4.21, Mediterranean 4.20, European 4.19, Asian 4.07. Lowest: Hyderabadi 3.45, Rolls 3.49, Biryani 3.52. Biryani is the 5th most common cuisine (1,744 restaurants) but rates low, which suggests crowded competition and mass-market quality.

**6. A quarter of restaurants are unrated.**
3,018 restaurants (24%) have no rating, and 3,004 of them have 0 votes. They are mostly new or unreviewed listings, not data errors.

**7. Votes and rating are only moderately related.**
Correlation between votes and rating is 0.40, and between cost and rating 0.33. Popularity does not guarantee quality.

## Recommendations
1. **New operators:** consider under-served, high-rating cuisines (Japanese, Mediterranean, European) in dense, high-spending areas rather than entering crowded Biryani or Quick Bites segments.
2. **Existing restaurants:** table booking is strongly associated with higher ratings, so enabling reservations is worth testing.
3. **Mass-market brands (Biryani, Rolls, Hyderabadi):** quality and consistency are the differentiator, as average ratings are low across the category.
4. **Area targeting:** Koramangala 5th Block combines a large restaurant base (168 reliable-rated) with a high rating (4.12), indicating a strong, mature dining area. Areas like Bannerghatta Road (3.59) and Kaggadasapura (3.57) have below-average ratings and may have room for quality-led entrants.
5. **Zomato:** prompt new restaurants (the 24% unrated) to collect first reviews, since ratings drive discovery.

## Limitations
- No date column, so no time trends or seasonality.
- Bangalore only, and ratings are a single snapshot.
- 54% of `dish_liked` is empty, so dish analysis was skipped.
- Cost is "approximate cost for two" as listed, not actual spend.
- The wizard skipped 1 row (restaurant_id 3312) when importing into MySQL, so SQL shows 12,463 restaurants and Power BI 12,464.
- When ties in votes existed during de-duplication, one copy was kept arbitrarily (tiny effect).
- Findings show association, not causation.
