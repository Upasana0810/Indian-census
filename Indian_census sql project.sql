create database indian_census;
use indian_census;
select * from dataset1;
select * from dataset2;

-- Total number of rows into our dataset
select count(*) as number_of_rows from dataset1; 
select count(*) as number_of_rows from dataset2; 

-- dataset for Jharkhand and Bihar
select * from dataset1 where state in ('Jharkhand','Bihar');

-- population of india
select sum(population) as total_population from dataset2 ;

-- average growth 
select state, avg(growth) as avg_growth from dataset1 group by state;

-- average sex ratio 
select state,round(avg(sex_ratio),0) as avg_sex_ratio from dataset1 group by state order by avg_sex_ratio desc;

-- average literacy rate greater than 90
select state,round(avg(literacy),0) as avg_literacy_ratio from dataset1 group by state having avg_literacy_ratio >90  order by avg_literacy_ratio desc;

-- three state showing highest growth rate 
select state, avg(growth) as highest_growth from dataset1 group by state order by highest_growth desc limit 3;

-- three state showing lowest growth rate 
select state, avg(growth) as lowest_growth from dataset1 group by state order by lowest_growth  limit 3;

-- three state showing highest sex ratio
select state,round( avg(sex_ratio) ,0)as highest_ratio from dataset1 group by state order by highest_ratio desc limit 3;

-- three state showing lowest sex ratio 
select state, round(avg(sex_ratio),0) as lowest_ratio from dataset1 group by state order by lowest_ratio limit 3;

-- top and bottom three state in literacy state

select * from (select state,round(avg(literacy),0) as literacy_ratio from dataset1 group by state  order by literacy_ratio desc limit 3 )a
union 
select * from (select state,round(avg(literacy),0) as literacy_ratio from dataset1 group by state  order by literacy_ratio  limit 3)b;

-- states starting with the letter A
select distinct state from dataset1 where state like "A%";

-- state staring with letter A and ending with the letter H
select distinct state from dataset1 where state like "A%" and state like "%H";

-- joing both table
 select d1.district ,d1.state,d1.growth,d1.sex_ratio,d1.literacy,d2.population from dataset1 d1 inner join dataset2 d2 on d1.district=d2.district;

-- find no. of male and female 
-- using formula male =population /(sex_ratio+1) and female =(population(sex_ratio))/sex_ratio+1

select c.district ,c.state state,round(c.population/ (c.sex_ratio+1),0)as males,round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) as females from  
(select d1.district ,d1.state,d1.growth,d1.sex_ratio,d1.literacy,d2.population from dataset1 d1 inner join dataset2 d2 on d1.district=d2.district) c ;

-- total literacy rate 
 select d1.district ,d1.state,d1.literacy/100 as literacy_ratio,d2.population from dataset1 d1 inner join dataset2 d2 on d1.district=d2.district;
select c.state,sum(literate_people) total_literate,sum(illetrate_people) total_illetrate from (
 select a. district,a.state, a.literacy_ratio,round(a.literacy_ratio * a.population ,0) as literate_people,round((1-a.literacy_ratio)*a.population,0) as illetrate_people from
 ( select d1.district ,d1.state,d1.literacy/100 as literacy_ratio,d2.population from dataset1 d1 inner join dataset2 d2 on d1.district=d2.district) a)c group by c.state ;

-- population in previous census
select sum(c.previous_census_population),sum(c.current_census_population) from(
 select b.state,sum(b.previous_census_population) previous_census_population,sum(b.current_census_population) current_census_population from(
 select a.district,a.state,round(a.population/(1+a.growth),0) previous_census_population,a.population current_census_population from(
 select d1.district,d1.state,d1.growth/100 as growth,d2.population from dataset1 d1 join dataset2 d2 on d1.district=d2.district)a)b group by b.state)c;
 
 -- population per area
 select(g.total_area/g.previous_census_population)as previous_census_population_vs_area,(g.total_area/g.current_census_population)as current_census_population_vs_area from(
 select q.*,r.total_area from(
 
 select 'e' as keyy,n.*from(
select sum(c.previous_census_population)as previous_census_population,sum(c.current_census_population)as Current_census_population from(
 select b.state,sum(b.previous_census_population) previous_census_population,sum(b.current_census_population) current_census_population from(
 select a.district,a.state,round(a.population/(1+a.growth),0) previous_census_population,a.population current_census_population from(
 select d1.district,d1.state,d1.growth/100 as growth,d2.population from dataset1 d1 join dataset2 d2 on d1.district=d2.district)a)b group by b.state)c)n)q inner join(

select 'e'as keyy,m.*from(
select SUM(area_km2)total_area from dataset2)m)r on q.keyy=r.keyy)g;

-- Top 3 district from each state with highest literacy rate
select a.*from(
select district,state,literacy,rank() over(partition by state order by literacy desc)rnk from dataset1)a where a.rnk in (1,2,3) order by state;


 

















 
 
