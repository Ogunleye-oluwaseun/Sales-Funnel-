# E-commerce Sales Funnel Analysis
## Overview
This project analyzes user behavior through a five stage e-commerce sales funnel. The goal was to identify where users drop off, which traffic sources convert best,
how long conversion takes and what the funnel is worth in the revenue.

## Dataset
The dataset (user_events.csv) contains user-level event logs with the following fields:
| Column | Description |
|---|---|
| event_id | Unique identifier for each event |
| user_id | Unique identifier for each user |
| event_type | Stage of the funnel |
| event_date | Timestamp of the event |
| product_id | Product associated with the event |
| amount| Transaction amount |
| traffic_source| Acquisiton channel that brought the user in |

## Funnel Stages
+ Page View - User visits a product/site
+ Add to Cart - User adds a product to their cart
+ Checkout Start - User begins checkout
+ Payment Info - User enters payment details
+ Purchase - User completes the transaction

## Analysis Performed
