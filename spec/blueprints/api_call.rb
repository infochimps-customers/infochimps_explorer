ApiCall.blueprint do     
  dataset   { Dataset.make }
  owner     { User.make }
  verb      { Sham.http_verb }
  self.link { Sham.link }
  request   { Sham.avro_schema }
  response  { Sham.avro_schema }
  created_at    { Sham.date_time }
  updated_at    { Sham.date_time }
end
