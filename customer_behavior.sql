select*from customer limit 20;

--Q1. Erkak va ayol mijozlar tomonidan yaratilgan jami daromad qancha?
select gender,sum(purchase_amount) as revenue from customer group by gender;

--Q2. Qaysi mijozlar chegirmadan foydalangan, lekin o‘rtacha xarid summasidan ko‘proq sarflagan?
select customer_id,purchase_amount from customer 
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer);

--Q3. O‘rtacha bahosi eng yuqori bo‘lgan eng yaxshi 5 ta mahsulot qaysilar?
select item_purchased,round(avg(review_rating::numeric),2) as "O'rtacha mahsulot reytingi" from customer 
group by item_purchased
order by avg(review_rating) desc limit 5;

--Q4. Standart va tezkor (Express) yetkazib berish turlari bo‘yicha o‘rtacha xarid summalarini solishtiring.
select shipping_type,round(avg(purchase_amount::"numeric"),2) from customer
WHERE shipping_type in ('Standard','Express')
group by shipping_type;


--Q5. Obuna bo‘lgan mijozlar ko‘proq sarflaydimi? Obuna bo‘lgan va bo‘lmagan mijozlar o‘rtasida o‘rtacha 
--xarid summasi va jami daromadni solishtiring.
select subscription_status,count(subscription_status) as total_customer,
round(avg(purchase_amount::"numeric"),2) as avg_spend,round(sum(purchase_amount),2) as total_revenue from customer
group by subscription_status order by total_revenue,avg_spend;


--Q6. Qaysi 5 ta mahsulotga eng yuqori foizda chegirma qo‘llangan xaridlar to‘g‘ri keladi?
select item_purchased,round(100*sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*),2) as foiz from customer
group by item_purchased
order by foiz desc limit 10;

--Q7. Mijozlarni avvalgi xaridlar soniga qarab “Yangi”, “Qaytgan” va “Sodiq” toifalarga bo‘ling, 
--va har bir toifada nechta mijoz borligini chiqaring.
with customer_type as (
select customer_id,previous_purchases,
case
	WHEN previous_purchases = 1 then 'New'
	WHEN previous_purchases BETWEEN 2 and 10 THEN 'Returning'
	ELSE 'Loyal'
	END AS customer_segment
from customer
)
SELECT 
	customer_segment,count(*) as "Mijozlar soni"
from customer_type
GROUP by customer_segment;

--Q8. Har bir kategoriya bo‘yicha eng ko‘p sotilgan 3 ta mahsulotni toping?
with item_count as (
	select category,item_purchased,
	count(customer_id) as total_orders,
	row_number() over(partition by category order by count(customer_id) desc) as item_rank
	from customer 
group by category, item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_count 
where item_rank <= 3;

--Q9. 5 martadan ko‘p xarid qilgan mijozlar odatda obuna bo‘lishadimi?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;


--Q10. Har bir yosh guruhining daromadga qo‘shgan hissasi qancha?
SELECT age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;














