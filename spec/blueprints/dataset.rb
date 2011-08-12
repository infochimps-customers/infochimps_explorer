Dataset.blueprint do
  title
  cached_slug
  self.link            nil
  description     { Sham.description }
  private         false
  price_in_cents  nil
  created_at      { Sham.date_time }
  updated_at      { Sham.date_time }
  description     { Sham.text      }
end

Dataset.blueprint(:for_sale) do
  price_in_cents  { (10..100).random * 100 }
  owner           { User.make(:vendor_agreement => VendorAgreement.make) }
end

Dataset.blueprint(:only_link) do
  self.link { Sham.link }
end

# Dataset.blueprint(:protected) do
#   protected(true)
# end

# Dataset.blueprint(:unprotected) do
#   protected(false)
# end
