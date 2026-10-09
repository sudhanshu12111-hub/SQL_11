-- Task 1 :  Retrieve the total number of orders placed.

select count(order_id)
from orders;

-- Task 2: Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizzas.price))
from order_details
Left Join pizzas
On order_details.pizza_id = pizzas.pizza_id;

-- Highets price Pizza
select pizza_types.name,pizzas.price,pizzas.pizza_type_id AS pizzasID,pizza_types.pizza_type_id AStypeID
from pizzas
LEFT JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
Order by pizzas.price DESC
Limit 1;

-- Highets price Pizza alternate_solution

select * from ( 
select pizzas.pizza_id,pizza_types.name,pizzas.price
, dense_rank() over (order by pizzas.price desc) as rn
from pizzas;


-- Task 4 : Identify the most common pizza size ordered.
select count(order_details.quantity) AS QTY, count(distinct order_id) as orders,pizzas.size
from order_details
Join pizzas
on order_details.pizza_id = pizzas.pizza_id
group by  pizzas.size
order by QTY DESC;

 -- List the top 5 most ordered pizza types along with their quantities
 select Sum(order_details.quantity) as QTY,pizzas.pizza_type_id
 from order_details
 Join pizzas
 on order_details.pizza_id = pizzas.pizza_id
 Group by  pizzas.pizza_type_id
 order by QTY DESC
 LIMIT 5;
 
 -- alternate solution  again
 select pt.name as pizza_name, sum(od.quantity) as QTY 
 from pizza_types as pt
 left join pizzas as p
 on pt.pizza_type_id = p.pizza_type_id
 left join order_details as od
 on od.pizza_id = p.pizza_id
 group by pt.name
 order by QTY DESC
 Limit 5;
 
 
 -- Task 2 : Determine the distribution of orders by hour of the day.
select * 
, sum(hr_orders) over () as total_orders
, hr_orders * 1.0 / sum(hr_orders) over () as orderdistribution
from (
select hour(time) as Hr, count(distinct order_details.order_id) as hr_orders
from orders
Left join order_details
on orders.order_id = order_details.order_id
group by hour(time))
as a;


-- top 3 most ordered pizza with names revenuewise
select pizza_types.name as pizza_name,sum(pizzas.price * order_details.quantity) as revenue
from pizza_types
left join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
left join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.name
order by revenue DESC
limit 3;


-- top performer & comparing Satisfaction

with Top_Performer AS (select pizza_types.name as pizza_name,sum(pizzas.price * order_details.quantity) as revenue
from pizza_types
left join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
left join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.name
order by revenue DESC
limit 3)
