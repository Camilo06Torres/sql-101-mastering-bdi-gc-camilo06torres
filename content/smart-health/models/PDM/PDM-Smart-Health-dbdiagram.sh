Table patient {
  patient_id int [pk]
  document varchar
  first_name varchar
  middle_name varchar
  last_name varchar
  maternal_surname varchar
  sex char(1)
  date_of_birth date
  registration_date datetime
  address varchar
  phone varchar
  email varchar
  policy_id int [ref: > policy.policy_id]
  insurer_id int [ref: > insurer.insurer_id]
  clinical_record_id int [ref: > clinical_record.clinical_record_id]
  emergency_contact_id int [ref: > emergency_contact.emergency_contact_id]
  active boolean
}

Table appointment {
  appointment_id int [pk]
  patient_id int [ref: > patient.patient_id]
  professional_id int [ref: > professional.professional_id]
  date date
  start_time time
  end_time time
  appointment_type varchar
  status varchar
  room varchar
  reason varchar
  created_by varchar
  created_at datetime
}

Table professional {
  professional_id int [pk]
  internal_code varchar
  license_number varchar
  first_name varchar
  middle_name varchar
  last_name varchar
  maternal_surname varchar
  email varchar
  hire_date date
  active boolean
  speciality_id int [ref: > speciality.speciality_id]
  schedule_id int [ref: > schedule.schedule_id]
}

Table speciality {
  speciality_id int [pk]
  speciality_name varchar
}

Table schedule {
  schedule_id int [pk]
  day_of_week varchar
  start_time time
  end_time time
}

Table clinical_record {
  clinical_record_id int [pk]
  patient_id int [ref: > patient.patient_id]
  record_type varchar
  summary_text text
  structure_summary text
  vital_sign_id int [ref: > vital_sign.vital_sign_id]
  main_diagnosis_id int [ref: > diagnosis.diagnosis_id]
  procedure_id int [ref: > procedure.procedure_id]
}

Table vital_sign {
  vital_sign_id int [pk]
  temperature float
  blood_pressure varchar
  heart_rate int
  respiratory_rate int
}

Table diagnosis {
  diagnosis_id int [pk]
  diagnosis_code varchar
  diagnosis_description text
}

Table procedure {
  procedure_id int [pk]
  procedure_name varchar
  description text
}

Table prescription {
  prescription_id int [pk]
  clinical_record_id int [ref: > clinical_record.clinical_record_id]
  prescription_date datetime
  notes text
}

Table audit_log {
  audit_log_id int [pk]
  prescription_id int [ref: > prescription.prescription_id]
  entity_name varchar
  action_type varchar
  timestamp datetime
}

Table emergency_contact {
  emergency_contact_id int [pk]
  full_name varchar
  phone varchar
  relationship varchar
}

Table insurer {
  insurer_id int [pk]
  insurer_name varchar
  contact_email varchar
  contact_phone varchar
}

Table policy {
  policy_id int [pk]
  policy_number varchar
  coverage_details text
  insurer_id int [ref: > insurer.insurer_id]
}