# E-commerce Sales Funnel Analysis
## Overview
This project analyzes user behavior through a five stage e-commerce sales funnel. The goal was to identify where users drop off, which traffic sources convert best,
how long conversion takes and what the funnel is worth in the revenue.

## Dataset
The dataset contains user-level event logs with the following fields:
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
+ Page View - user visits a product/site
+ Add to Cart - user adds a product to their cart
+ Checkout Start - user begins checkout
+ Payment Info - user enters payment details
+ Purchase - user completes the transaction

## Analysis Performed
+ Funnel Stage Counts - distinct users reaching each stage
+ Stage-to-stage conversion rates — % of users moving from one stage to the next, plus overall view-to-purchase conversion
+ Funnel by traffic source — cart and purchase conversion rates broken out by acquisition channel, to identify the highest- and lowest-converting sources
+ Time-to-conversion analysis — average time (in minutes) between view → cart, cart → purchase, and total journey time, for users who converted
+ Revenue funnel analysis — total revenue, average order value, revenue per buyer, and revenue per visitor

## Tools and Techniques
+ SQL Server/SSMS
+ Common Table Expressions (CTEs)
+ Conditional Aggregation
+ BULK INSERT for data loading

## Key Findings
+ Only 16% of users who viewed a product went on to purchase, with the biggest drop-off occurring between the view and add to cart stage.
+ Average Order Value - $106.5
+ Revenue Per Visitor - $17.6

## Files
+ sales_funnel.sql
+ user_events.csv









