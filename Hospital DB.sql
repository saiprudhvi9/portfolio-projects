--Show first name, last name, and gender of patients whose gender is 'M'

SELECT 	first_name,last_name,gender FROM patients
where gender='M'

--Show first name and last name of patients who does not have allergies. (null)

SELECT first_name,last_name FROM patients
where allergies is null

--Show first name of patients that start with the letter 'C'

SELECT first_name FROM patients
where first_name like 'C%'

--Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT first_name,last_name FROM patients
where weight between 100 and 120

--Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

update patients
set allergies='NKA'
where allergies is null

--Show first name and last name concatinated into one column to show their full name.

select  concat(first_name , ' ' , last_name) from patients

--Show first name, last name, and the full province name of each patient.

select  patients.first_name,patients.last_name,province_names.province_name from patients
join province_names on patients.province_id=province_names.province_id

--Show how many patients have a birth_date with 2010 as the birth year.

select  count(patient_id) from patients
where year(birth_date)=2010

--Show the first_name, last_name, and height of the patient with the greatest height.

select first_name,last_name,max(height) from patients

--Show all columns for patients who have one of the following patient_ids:1,45,534,879,1000

select * from patients where patient_id=1 or patient_id=45 or patient_id=534 or patient_id=879 or patient_id=1000

--Show the total number of admissions

select count(patient_id) from admissions

--Show all the columns from admissions where the patient was admitted and discharged on the same day.

select * from admissions where admission_date=discharge_date


--Show the patient id and the total number of admissions for patient_id 579.

select patient_id, count(admission_date) from admissions
where patient_id=579

--Based on the cities that our patients live in, show unique cities that are in province_id 'NS'

select distinct city as unique_city from patients
where province_id='NS'

--Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70

select first_name,last_name,birth_date from patients
where height>160 and weight>70

--Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'

select first_name,last_name,allergies from patients
where allergies is not null and city = 'Hamilton'

--Show unique birth years from patients and order them by ascending.

select distinct year(birth_date) as birth_year from patients
order by birth_year

--Show unique first names from the patients table which only occurs once in the list.

select first_name from patients
group by first_name having count(first_name) = 1

--Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

select patient_id, first_name FROM patients
where first_name LIKE 's____%s'

--Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.

select patients.patient_id, patients.first_name,patients.last_name from patients
join admissions on patients.patient_id=admissions.patient_id
where admissions.diagnosis = 'Dementia'

--Display every patient's first_name. Order the list by the length of each name and then by alphabetically.

select first_name from patients
order by len(first_name),first_name

--Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.

select
(select count(*) from patients where gender='M') as male_count,
(select count(*) from patients where gender='F') as female_count

--Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.

select first_name,last_name,allergies from patients 
where allergies='Penicillin' or allergies='Morphine'
order by allergies,first_name,last_name

--Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

select patients.patient_id, admissions.diagnosis from patients 
join admissions on patients.patient_id = admissions.patient_id
group by patients.patient_id, admissions.diagnosis HAVING count(*) > 1

--Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.

select city, count(*) as num_patients from patients
group by City
order by num_patients desc, city asc

--Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"

select first_name,last_name,'Patient' as Role from patients
union all
select first_name,last_name,'Doctor' as Role from doctors

--Show all allergies ordered by popularity. Remove NULL values from query.

select allergies, count(*) as total_diagnosis from patients
where allergies is not null
group by allergies
order by total_diagnosis DESC

--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.

select first_name, last_name,birth_date from patients
where year(birth_date) between 1970 and 1979
order by birth_date

--We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order

select concat(upper(last_name),',',lower(first_name)) as full_name from patients
order by first_name desc

--Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

select province_id,sum(height) as sum_height from patients
group by province_id having sum_height >= 7000

--Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

select (max(weight) - min(weight)) from  patients
where last_name = 'Maroni'

--Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

select day(admission_date) as day_number , count(*) as num_of_admissions from admissions
group by day_number
order by num_of_admissions desc

--Show all columns for patient_id 542's most recent admission_date.

select * from admissions
where patient_id = 542
group by patient_id
having admission_date = max(admission_date)

--Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

select patient_id, attending_doctor_id, diagnosis from admissions
where 
	(attending_doctor_id in (1,5,19) and patient_id % 2 != 0)
	OR 
	(attending_doctor_id like '%2%' and len(patient_id) = 3)

--Show first_name, last_name, and the total number of admissions attended for each doctor.

select first_name,last_name,count(*) from doctors p, admissions a
where a.attending_doctor_id = p.doctor_id
group by p.doctor_id

--For each doctor, display their id, full name, and the first and last admission date they attended.

select doctor_id, first_name || ' ' || last_name as full_name, 
		min(admission_date) as first_admission_date,
		max(admission_date) as last_admission_date 
from admissions a
join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id

--Display the total amount of patients for each province. Order by descending.

select province_names.province_name, count(*) as patients_count from patients 
join province_names on patients.province_id =  province_names.province_id
group by province_names.province_id
order by patients_count desc

--For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.

select patients.first_name || ' ' || patients.last_name as patient_name,
		admissions.diagnosis, doctors.first_name || ' ' || doctors.last_name  as doctor_name
from patients 
join admissions on patients.patient_id=admissions.patient_id
join doctors on admissions.attending_doctor_id=doctors.doctor_id

--display the first name, last name and number of duplicate patients based on their first name and last name.

select first_name,last_name,count(*) as num_of_duplicates from patients
group by first_name,last_name having count(*) > 1

--Display patient's full name, height in the units feet rounded to 1 decimal,weight in the unit pounds rounded to 0 decimals,birth_date,gender non abbreviated.

select 
  first_name || ' ' || last_name as full_name, 
  round(height/30.48,1) as Height,
  round(weight*2.205) as Weight ,
  birth_date, 
  case when gender='M' then 'Male' when gender='F' then 'Female' end as Gender
from patients
