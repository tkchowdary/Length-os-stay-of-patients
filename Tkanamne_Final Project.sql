CREATE database project




use project

SELECT * from dbo.[admissions]
SELECT * FROM dbo.CPTEVENTS
SELECT * FROM dbo.ICUSTAYS
SELECT * FROM dbo.PATIENTS
SELECT * from dbo.SERVICES



SELECT COUNT(*) from dbo.[admissions]
SELECT COUNT(*) FROM dbo.CPTEVENTS
SELECT COUNT(*) FROM dbo.ICUSTAYS
SELECT COUNT(*) FROM dbo.PATIENTS
SELECT COUNT(*) from dbo.SERVICES



SELECT count(distinct diagnosis)  FROM ADMISSIONS


select distinct diagnosis from ADMISSIONS
 


select (a.subject_id) as SUBJECT_ID, (a.hadm_id) as HADM_ID, cast(admittime as date) as Admit_time, cast(dischtime as date) as Discharge_Time,
case
	when a.ethnicity = 'ASIAN' then 0
	when a.ethnicity = 'ASIAN - THAI' then 1
	when a.ethnicity = 'ASIAN - VIETNAMESE' then 2
	when a.ethnicity = 'ASIAN - ASIAN INDIAN' then 3
	when a.ethnicity = 'ASIAN - FILIPINO' then 4
	when a.ethnicity = 'ASIAN - CHINESE' then 5
	when a.ethnicity =  'ASIAN - CAMBODIAN' then 6
	when a.ethnicity = 'ASIAN - KOREAN' then 7
	when a.ethnicity = 'ASIAN - OTHER' then 8
	when a.ethnicity = 'AMERICAN INDIAN/ALASKA NATIVE FEDERALLY RECOGNIZED TRIBE' then 9
	when a.ethnicity =  'HISPANIC/LATINO - COLOMBIAN'  then 10
	when a.ethnicity = 'HISPANIC/LATINO - HONDURAN' then 11
	when a.ethnicity = 'AMERICAN INDIAN/ALASKA NATIVE' then 12
	when a.ethnicity = 'UNKNOWN/NOT SPECIFIED' then 13
	when a.ethnicity = 'BLACK/HAITIAN' then 14
	when a.ethnicity = 'MULTI RACE ETHNICITY' then 15
	when a.ethnicity ='HISPANIC/LATINO - CENTRAL AMERICAN (OTHER)' then 16
	when a.ethnicity ='UNABLE TO OBTAIN' then 17
	when a.ethnicity ='HISPANIC/LATINO - DOMINICAN' then 18
	when a.ethnicity ='HISPANIC/LATINO - GUATEMALAN' then 19
	when a.ethnicity ='CARIBBEAN ISLAND' then 20
	when a.ethnicity = 'HISPANIC/LATINO - PUERTO RICAN'  then 21
	when a.ethnicity ='HISPANIC/LATINO - SALVADORAN' then 22
	when a.ethnicity ='WHITE - EASTERN EUROPEAN' then 23
	when a.ethnicity ='WHITE - BRAZILIAN' then 24
	when a.ethnicity = 'WHITE - OTHER EUROPEAN' then 25
	when a.ethnicity ='ASIAN - JAPANESE' then 26
	when a.ethnicity ='BLACK/AFRICAN' then 27
	when a.ethnicity = 'NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER' then 28
	when a.ethnicity ='MIDDLE EASTERN' then 29
	when a.ethnicity = 'SOUTH AMERICAN' then 30
	when a.ethnicity ='HISPANIC/LATINO - CUBAN' then 31
	when a.ethnicity ='WHITE' then 32
	when a.ethnicity ='HISPANIC/LATINO - MEXICAN' then 33
	when a.ethnicity ='OTHER' then 34
	when a.ethnicity ='HISPANIC OR LATINO' then 35
	when a.ethnicity = 'PORTUGUESE' then 36
	when a.ethnicity ='BLACK/AFRICAN AMERICAN' then 37
	when a.ethnicity ='WHITE - RUSSIAN' then 38
	when a.ethnicity ='BLACK/CAPE VERDEAN' then 39
	when a.ethnicity = 'PATIENT DECLINED TO ANSWER' then 40
	else 41
	end as ETHNICITY

,
case 
	when a.admission_location ='HMO REFERRAL/SICK' then 0
	when a.admission_location = 'TRANSFER FROM SKILLED NUR' then 1
	when a.admission_location= 'TRANSFER FROM OTHER HEALT' then 2 
	when a.admission_location ='TRANSFER FROM HOSP/EXTRAM' then 3
	when a.admission_location ='EMERGENCY ROOM ADMIT' then 4 
	when a.admission_location = 'TRSF WITHIN THIS FACILITY'  then 5 
	when a.admission_location ='** INFO NOT AVAILABLE **'  then 6 
	when a.admission_location ='PHYS REFERRAL/NORMAL DELI' then 7 
	when a.admission_location = 'CLINIC REFERRAL/PREMATURE' then 8 
	end as ADMISSION_LOC
, 
case 
	when a.admission_type = 'EMERGENCY' then 0
	when a.admission_type = 'ELECTIVE' then 1
	when a.admission_type = 'URGENT' then 2
	when a.admission_type = 'NEWBORN' then 3
	end as ADMISSION_TYPE


,  
case
	when a.insurance  = 'Medicare' then 0
	when a.insurance  = 'Medicaid' then 1
	when a.insurance  = 'Government' then 2
	when a.insurance  = 'Self Pay' then 3
	when a.insurance  = 'Private' then 4
	end as INSURANCE_TYPE

into #Admissions
from dbo.ADMISSIONS a
where DIAGNOSIS like '%PNEUMONIA%'

DROP TABLE IF EXISTS  #patients4
GO

select count(*) from #Admissions

SELECT count(*) from dbo.PATIENTS

--Converting Gender into binary format 
select b.subject_id as SUBJECT_ID, cast(DOB as date) as DOB,
case 
	when b.gender = 'F' then 0 else 1
end as GENDER
into #patients
from dbo.PATIENTS b






-- Joining the columns gender and date of birth.

select a.*, b.DOB, b.GENDER
into #patients2
from #Admissions a
inner join #patients b on a.subject_id = b.SUBJECT_ID



SELECT COUNT(*) from #PATIENTS2


--Calculating age and length of stay using Date of birth, Date of admission and date of discharge.

select *,  datediff(year,  DOB, Admit_time) as AGE, datediff(d, Admit_time, Discharge_Time) as Length_of_stay
into #patients3
from #patients2


select * from #patients3

-- Calculating age for deceased patients caused noise in the age column. Finding such values and removing them.

select * 
into #patients4
from #patients3
where age != 300 and age!>300

select * from #patients4


---Selecting needed columns from services table and converting the previous service and current service.

DROP TABLE IF EXISTS  #service
GO


  select subject_id as SUBJECT_ID, hadm_id as HADM_ID, 
  case 
  when PREV_SERVICE = 'TRAUM' then 0  
  when PREV_SERVICE = 'NSURG' then 1
  when PREV_SERVICE = 'MED' then 2
  when PREV_SERVICE = 'NBB' then 3 
  when PREV_SERVICE = 'OBS' then 4
  when PREV_SERVICE = 'GU' then 5
  when PREV_SERVICE = 'PSYCH' then 6
  when PREV_SERVICE = 'ORTHO' then 7
  when PREV_SERVICE = 'NB' then 8  
  when PREV_SERVICE = 'GYN' then 9 
  when PREV_SERVICE = 'VSURG' then 10
  when PREV_SERVICE = 'OMED' then 11 
  when PREV_SERVICE = 'DENT' then 12
  when PREV_SERVICE = 'NMED' then 13
  when PREV_SERVICE = 'PSURG' then 14 
  when PREV_SERVICE = 'ENT' then 15 
  when PREV_SERVICE = 'TSURG'  then 16
  when PREV_SERVICE = 'CSURG' then 17
  when PREV_SERVICE = 'CMED' then 18 
  when PREV_SERVICE = 'SURG' then 19
  else 20
  end as PREVIOUS_SERVICE
  , case 
  when CURR_SERVICE = 'TRAUM' then 0
  when CURR_SERVICE = 'NSURG' then 1
  when CURR_SERVICE = 'MED' then 2
  when CURR_SERVICE =  'NBB' then 3
  when CURR_SERVICE = 'OBS' then 4
  when CURR_SERVICE = 'GU' then 5
  when CURR_SERVICE = 'PSYCH' then 6
  when CURR_SERVICE = 'ORTHO' then 7
  when CURR_SERVICE = 'NB' then 8
  when CURR_SERVICE = 'GYN' then 9
  when CURR_SERVICE = 'VSURG' then 10
  when CURR_SERVICE =  'OMED' then 11
  when CURR_SERVICE = 'DENT' then 12
  when CURR_SERVICE =  'NMED' then 13
  when CURR_SERVICE = 'PSURG' then 14
  when CURR_SERVICE = 'ENT' then 15
  when CURR_SERVICE =  'TSURG' then 16
  when CURR_SERVICE = 'CSURG' then 17
  when CURR_SERVICE = 'CMED' then 18
  when CURR_SERVICE = 'SURG' then 19
  else 20
  end as CURRENT_SERVICE
  into #service
  from dbo.SERVICES


SELECT count(*) from CPTEVENTS



-- selecting needed columns from CPT Events table and converting cost center


DROP TABLE IF EXISTS  #cpt_events
GO

select subject_id as SUBJECT_ID, hadm_id as HADM_ID, avg(cast(cpt_number as int)) as CPT_NUMBER,
case 
when costcenter = 'ICU' then 1 else 0 end as COST_CENTER
into #cpt_events
from dbo.CPTEVENTS
group by subject_id,hadm_id,costcenter


-- Selecting needed columns from ICU Stays table and converting the first care unit and last care unit 
DROP TABLE IF EXISTS  #icu_stay
GO



select subject_id as SUBJECT_ID, hadm_id as HADM_ID, 

case
	 when FIRST_CAREUNIT = 'MICU' then 0 
	 when FIRST_CAREUNIT =  'NICU' then 1
	 when FIRST_CAREUNIT = 'CCU'  then 2
	 when FIRST_CAREUNIT = 'CSRU' then 3
	 when FIRST_CAREUNIT = 'TSICU'  then 4 
	 when FIRST_CAREUNIT = 'SICU' then 5
	 end as FIRST_CARE_UNIT
	 ,
case 
	when LAST_CAREUNIT = 'MICU' then 0
	when LAST_CAREUNIT = 'NICU' then 1
	when LAST_CAREUNIT = 'CCU' then 2
	when LAST_CAREUNIT = 'CSRU' then 3
	when LAST_CAREUNIT = 'TSICU' then 4
	when LAST_CAREUNIT = 'SICU' then 5
	end as LAST_CARE_UNIT
	into #icu_stay
   FROM [dbo].[ICUSTAYS] 

SELECT * from #icu_stay


  


--Table joins
DROP TABLE IF EXISTS #temp3
GO

select a.*, b.FIRST_CARE_UNIT as First_Care_Unit, b.LAST_CARE_UNIT as Last_Care_Unit
into #temptable1
from #patients4 a
inner join #icu_stay b on a.SUBJECT_ID = b.SUBJECT_ID and a.HADM_ID = b.HADM_ID


select * from #temptable1


select distinct a.*, b.previous_service as PREVIOUS_SERVICE, b.current_service as CURRENT_SERVICE
into #temptable2
from #temptable1 a
inner join #service b on a.subject_id = b.subject_id and a.hadm_id = b.hadm_id

SELECT * from #temptable2

select a.*, b.cost_center as COST_NUMBER,b.cpt_number as CPT_NUMBER
into #temptable3
from #temptable2 a
inner join #cpt_events b on a.SUBJECT_ID = b.SUBJECT_ID and a.HADM_ID = b.HADM_ID

SELECT * from #temptable3

drop table dbo.preprocessed_final

select a.*, case when a.LENGTH_OF_STAY >= 6 then 1 else 0 end as FINAL_LOS 
into dbo.preprocessed_final
from #temptable3 a


select * from dbo.preprocessed_final

