--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu
select p.product_id,p.product_name,s.company_name,s.phone from products p
left join  suppliers s on p.supplier_id=s.supplier_id

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select e.first_name,e.last_name, e.address from orders o
left join employees e on o.employee_id=e.employee_id
where date_part('month',o.order_date)=03 and date_part('year',o.order_date)=1998

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) as " 1997 yılı Şubat ayı sipariş" from orders o
left join order_details od on o.order_id=od.order_id
where date_part('month',o.order_date)=02 and date_part('year',o.order_date)=1997

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(*)  from orders o
left join order_details od on o.order_id=od.order_id
where date_part('year',o.order_date)=1998 and o.ship_city='London'

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select contact_name, phone from customers c
left join orders o on c.customer_id=o.customer_id
where date_part('year',o.order_date)=1997

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select*from orders
where freight>40 order by freight asc

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select c.contact_name,o.ship_city from orders o
left join customers c on o.customer_id=c.customer_id
where freight>40 

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select upper(e.first_name||' '||e.last_name) as "AD SOYAD",o.order_date,o.ship_city from orders o
left join employees e on o.employee_id=e.employee_id
where date_part('year',o.order_date)=1997

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select distinct(c.contact_name),
replace(replace(replace(replace(replace(replace(c.phone, '(', ''), ')', ''), ' ', ''), '-', ''), '.', ''), ' ', '') AS "Phone Number"
from orders o
left join customers c on o.customer_id=c.customer_id
where date_part('year',o.order_date)=1997

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date,c.contact_name,e.first_name,e.last_name from orders o
left join customers c on o.customer_id=c.customer_id
left join employees e on o.employee_id=e.employee_id

--36. Geciken siparişlerim?
select*from orders
where required_date<shipped_date

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select o.order_date,c.contact_name from orders o
left join customers c on o.customer_id=c.customer_id
where required_date<shipped_date

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name,c.category_name,o.quantity from order_details o
left join products p on o.product_id=p.product_id
left join categories c on p.category_id=c.category_id
where o.order_id=10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.company_name from order_details o
left join products p on o.product_id=p.product_id
left join suppliers s on p.supplier_id=s.supplier_id
where o.order_id=10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name,sum(od.quantity),p.product_id from employees e
left join orders o on e.employee_id=o.employee_id
left join order_details od on o.order_id=od.order_id
left join products p on od.product_id=p.product_id
where o.employee_id=3 and date_part('year',o.order_date)=1997
group by p.product_id

select p.product_name,sum(od.quantity), p.product_id from products p
left join order_details od on p.product_id=od.product_id
left join orders o on od.order_id=o.order_id
where o.employee_id=3 and date_part('year',o.order_date)=1997
group by p.product_id

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id,e.last_name,e.first_name from orders o
left join employees e on o.employee_id=e.employee_id
left join order_details od on o.order_id=od.order_id
where date_part('year',o.order_date)=1997 
order by od.quantity desc limit 1

--42.  1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id,e.last_name,e.first_name,sum(od.quantity) from orders o
left join employees e on o.employee_id=e.employee_id
left join order_details od on o.order_id=od.order_id
where date_part('year',o.order_date)=1997 
group by e.employee_id
order by sum(od.quantity) desc limit 1

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price,c.category_name from products p
left join categories c on  p.category_id=c.category_id
where p.unit_price=(select max(unit_price) from products)


--44.Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.last_name, e.first_name,o.order_date, o.order_id from orders o
left join employees e on o.employee_id=e.employee_id
order by o.order_date desc

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select order_id,avg(unit_price*quantity) from order_details 
where order_id in (select order_id from orders order by order_date desc limit 5)
group by order_id

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,p.product_id ,sum(od.quantity)from products p
left join categories c on p.category_id=c.category_id
left join order_details od on p.product_id=od.product_id
left join orders o on o.order_id=od.order_id
where date_part('month',o.order_date)=01
group by p.product_id,c.category_name

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select p.product_name, o.quantity from order_details o
left join products p on o.product_id=p.product_id
where (select avg(quantity) from order_details)<o.quantity

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select  p.product_name,c.category_name,s.company_name, sum(o.quantity) from order_details o
left join products p on o.product_id=p.product_id
left join categories c on p.category_id=c.category_id
left join suppliers s on p.supplier_id=s.supplier_id
group by p.product_name,c.category_name,s.company_name
order by sum(o.quantity) desc limit 1

--49. Kaç ülkeden müşterim var
select count(distinct(country)) from customers

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.employee_id,e.last_name,e.first_name,sum(od.quantity*od.unit_price) from employees e
left join orders o on e.employee_id=o.employee_id
left join order_details od on o.order_id=od.order_id
where e.employee_id = 3 
and o.order_date >= date '1998-01-01'
and o.order_date <= current_date
group by e.last_name,e.first_name, e.employee_id

--63. Hangi ülkeden kaç müşterimiz var
select country,count(country) from customers
group by country

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select  o.order_date ,sum(od.unit_price*od.quantity) from products p
left join order_details od on p.product_id=od.product_id
left join orders o on  od.order_id=o.order_id
where p.product_id=10 
group by o.order_date
order by o.order_date desc limit 3


--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select  e.employee_id, count(o.order_id), e.last_name,e.first_name from employees e
left join orders o on e.employee_id=o.employee_id
group by e.employee_id
order by e.employee_id


--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.company_name, o.order_id from orders o
right join customers c on o.customer_id=c.customer_id
where o.order_id is null

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name,contact_name,address,city,country from customers
where  country='Brazil'

--69. Brezilya’da olmayan müşteriler
select*from customers
where  country!='Brazil'

--72. Londra’da ya da Paris’de bulunan müşterilerim
select*from customers
where city='London'or city='Paris'

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select*from customers
where city='México D.F.' and contact_title='Owner'


--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where upper(product_name) like 'C%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name,last_name,birth_date from employees
where lower(first_name) like 'a%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers
where upper(company_name) like '%RESTAURANT%'


--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price between 50 and 100 

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id,order_date from orders
where order_date between '1-7-1996' and '31-12-1996'

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, country from customers
where country='Spain' or country='France' or country='Germany'

--80. Faks numarasını bilmediğim müşteriler
select company_name, fax from customers
where fax is null
order by company_name

--81. Müşterilerimi ülkeye göre sıralıyorum:
select  distinct country, company_name from customers
order by country  asc

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price from products
order by unit_price desc 

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price from products
order by unit_price desc , units_in_stock asc

--84. 1 Numaralı kategoride kaç ürün vardır..?
select count( distinct product_name) from products p
left join categories c on p.category_id=c.category_id
where c.category_id=1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct country) from customers






