User.blueprint do
  username              
  first_name
  last_name
  email                  { Sham.email }
  same_password =          Sham.password
  password               { same_password }
  password_confirmation  { same_password } 
  # first_name
  # last_name
  # description
  authentication_token { Sham.apikey }
end

User.blueprint(:vendor) do
  vendor_agreement  { VendorAgreement.make }
end

User.blueprint(:admin) do
  admin true
end
