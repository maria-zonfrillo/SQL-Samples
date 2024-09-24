WITH last_visit AS (
  SELECT patient_id,
         id AS visit_id,
         date AS visit_date,
         ROW_NUMBER() OVER (PARTIION BY patient_id, visit_date DESC) as row
  FROM visits  
  ),

next_appt AS (
  SELECT patient_id,
         id AS appt_id,
         date AS appt_date,
         ROW_NUMBER() OVER (PARTIION BY patient_id, visit_date ASC) as row
  FROM appointments
  )
  
--all pediatric pts, does not matter if they had a recent visit
SELECT
  patients.dob AS date_of_birth,
FROM patients
LEFT JOIN last_visit ON visits.patient_id = patients.id AND last_visit.row = 1
LEFT JOIN next_appt ON next_appt.patient_id = patients.id AND next_appt.row = 1
WHERE EXTRACT(YEAR FROM AGE(dob)) < 18
