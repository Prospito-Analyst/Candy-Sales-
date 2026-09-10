# Candy-Sales-
**An Analysis on Candy Sales Performance**


**📌 Project Overview**

Candy Sales profitability is driven by more than just volume, it’s impacted by product mix, division performance, factory efficiency, ship mode costs, and regional demand fluctuations. Without clear visibility, companies struggle to identify which products drive profits vs. which drain it. 
The end product is an interactive, highly customized Power BI executive dashboard designed to track high-level operational health and pinpoint areas for systemic improvement.

**🎯 The Problem & Business Questions**

1. What was our top performing year? Did we outperform our previous year?
2. Which country/state generated the most revenue? How does location affect sales? 
3. Which Product division do customers order most? Does it account for most revenue?
4. What was our top performing product? Any we should stop producing?
5. How do revenue, orders, and quantities vary by month? 
6. Which ship mode do customers prefer most? 
7. Which production factory generated the most revenue? 
8. Do we have repeating customers? Any patterns? 

**🛠️ Data Architecture & Analytical Approach**

This project was built using a robust, end-to-end data pipeline to efficiently process, clean, and visualize thousands of records.

**Database Architecture:** Designed an optimized, scalable relational schema within Microsoft SQL Server to house the dataset. I designed and implemented a snowflake + partial star schema data model for the data to enable efficient reporting and analysis.

**Exploratory Data Analysis (EDA):** Before moving to visualization, I performed initial EDA using advanced SQL queries. I wrote complex aggregations, subqueries, validate baseline metrics, test hypotheses, and extract high-level operational insights directly from the database.

**Power BI Integration & Data Modeling:** Connected Power BI to the SQL Server database via DirectQuery/Import to extract the structured tables. Designed a cohesive Star Schema data model, establishing clear, active relationships between the central fact table and dimensional lookup tables.

**Advanced DAX & Metric Engineering:** Wrote highly complex DAX measures to handle the heavy analytical lifting. 

**Custom UI/UX Engineering:** Utilized Figma for Wire Frame designing. Generated beautiful, dark-themed insight cards, providing a sleek, web-app-like user experience that stands out from standard corporate reports.

**📊 Deep Dive: Key Insights**

**1. 2024 Was a Breakout Year, With Sustained YoY Growth Since 2021**

The business hit its all-time high in 2024 with **$46,968 in revenue and $30,950 in gross profit**. This represents a **+27.4% YoY** revenue growth ($46,968 vs $36,859 in 2023) and **+27.2%** YoY profit growth ($30,950 vs $24,340 in 2023). The data confirms consistent year-over-year growth since 2021, proving strong commercial momentum heading into Q4.

**2. The Revenue Engine is Geographically Concentrated and Unbalanced**

Location is a primary driver of sales. California generated **$9,655** in revenue in 2024 alone, nearly 2x New York at $5,083 and 20.6% of total annual revenue. By region, **Pacific** leads with $16,011, followed by **Atlantic** at $13,477. This proves that West Coast + major urban metros drive the business. High-income, urban states not only order more frequently but also show higher Average Order Values (AOV), indicating a clear opportunity for targeted regional marketing and inventory placement on the West Coast.

**3. Extreme Product & Division Dependency**

The business is dangerously dependent on one division. Chocolate Division generated $43,379 in revenue from 3,257 orders in 2024 — that is 92.4% of total revenue. The other divisions are negligible: Others is $3,444 and Sugar is only $143 (0.3%). The top product, "Wonka Bar - Triple Dazzle Caramel" drove $9,532 in revenue (677 orders), followed by "Wonka Bar - Scrumdiddlyumptious" at $9,306 and "Wonka Bar - Milk Chocolate" at $8,752. This concentration is a major risk — if Chocolate demand drops, 92% of revenue is at risk.

**4. The Sugar Division is a Drag on Profitability and Should Be Discontinued**
   
While Chocolate thrives, Sugar is statistically irrelevant. The entire Sugar division made $143 in revenue for the year, with its worst product "Nerds" generating only $6.00 from 2 orders. "Kazookles" generated only $24 in profit on 24 orders. At the factory level, this is mirrored by Sugar Shack Factory generating only $220 in total revenue , compared to *Lot's O' Nuts Factory at $76,340 and Wicked Choccy's Factory at $55,352. The data strongly supports discontinuing Sugar products and repurposing Sugar Shack capacity for Chocolate.

**5. Severe Seasonality — Q4 is 42% of the Entire Business**

Revenue, orders, and quantity are not evenly distributed. The business lives and dies by Q4. Peak months are September ($19,369), November ($20,646), and December ($21,234), while February is the trough at $3,933 and 300 orders. Combined, Sept, Nov, Dec account for 42% of annual revenue, showing a clear holiday and back-to-school seasonality pattern. This requires a seasonal production and staffing strategy — overstaff and overstock in Q3 for Q4 fulfillment,and run promotions in Q1/Q2 to smooth cash flow.

**6. Customers Choose Cheap Over Fast, and Loyalty is Misleading**

Shipping behavior proves price sensitivity. Standard Class accounts for 60% of all orders (5,142 orders, $85,490 revenue), followed by Second Class (1,653), First Class (1,312), and Same Day (442). Customers overwhelmingly choose the cheapest option. On the customer side, 44.3% are repeat buyers (2,233 out of 5,044 total), but analysis of ordering patterns shows this is not true loyalty. Top customers order every ∼365 days for 3+ years and *99% have a ProductsPerOrderRatio = 1.0 — they buy one new product each time, likely for gifting/sampling, and some place 5-6 orders in one day due to order splitting, not increased spend.


**🎯 Strategic Recommendations**

**1. Discontinue Sugar Division and Reallocate Sugar Shack Factory to Chocolate Production**

Discontinue all Sugar division products immediately. The division generated only $143 in 2024 with products like Nerds at $6.00 from 2 orders and Kazookles at $24 profit. The Sugar Shack factory only made $220 total. Repurpose its space, staff and machines to produce the top 3 Chocolate SKUs: Triple Dazzle Caramel ($9,532), Scrumdiddlyumptious ($9,306), and Milk Chocolate ($8,752). This eliminates a loss-making line, frees overhead, and adds capacity to the division that drives 92.4% of revenue to prevent stock-outs in Q4.

**2. Build a California Fulfillment Hub and Execute a Q4-Focused Inventory Plan**

California is $9,655 in 2024 (20.6% of revenue) and Pacific region leads at $16,011. At the same time, Sept, Nov, Dec = 42% of annual revenue while February drops to $3,933. Set up a 3PL or micro-fulfillment center in California to cut delivery time and cost for your biggest market, since 60% of orders (5,142) are Standard Class. From July, build 40% extra inventory of top Chocolate bars for Q4 and shift 70% of marketing budget to Q3/Q4 targeting CA, NY, and Pacific states. Run a Valentine's/Easter bundle promo in Feb-Mar to lift the Q1 trough.

**3. Stop Order Splitting and Convert Sampling Behavior into Higher AOV**

Your 44.3% repeat rate (2,233 of 5,044 customers) is inflated. 99% of repeaters have a ProductsPerOrderRatio of 1.0, they buy one new product per order and often place 5-6 orders in one day. They are sampling/gifting, not loyal bulk buyers. Introduce a bundle incentive like "Buy 3 bars, get free Standard shipping" to push the ratio from 1.0 to 2.5+ and increase AOV. Launch a Chocolate Explorer Club where customers who try 5+ Chocolate SKUs in a year get a reward. Since customers prefer cheap shipping, also renegotiate your Standard Class carrier rate — with 60% of volume there, any savings goes straight to profit.


**Tools Utilized**

Excel, SQL, Figma, Power BI

