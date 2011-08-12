require 'sham'
require 'forgery'

# Shams
# We use forgery to make up some test data

Sham.class_eval do
  def self.some_number_of min_qty, max_qty, &block
    (min_qty .. (min_qty+rand(max_qty - min_qty))).map(&block)
  end
end


class Forgery::Internet < Forgery
  def self.ip_address
    (0..3).to_a.map{ rand(256).to_s }.join(".")
  end
end

Sham.text                          { |idx| Forgery(:lorem_ipsum).paragraphs( (1..3).random )  }
Sham.word                          { Forgery(:basic).text               }
Sham.string                        { Forgery(:lorem_ipsum).sentence                           }
Sham.title                         { |idx| 5.times.map { |i| Sham.word }.join " " }
Sham.sentence                      { Forgery(:lorem_ipsum).sentence     }
Sham.variable                      { Forgery(:lorem_ipsum).word         }
Sham.last_name(:unique => false)   { Forgery(:name).last_name           }
Sham.first_name(:unique => false)  { Forgery(:name).first_name          }
Sham.username                      { Forgery(:internet).user_name       }
Sham.email                         { Forgery(:internet).email_address   }
Sham.password                      { Forgery(:basic).password           }
Sham.link                          { "http://" + Forgery(:internet).domain_name }
Sham.ip_address                    { Forgery(:internet).ip_address      }
Sham.cached_slug                   { Forgery(:lorem_ipsum).words(1..25).split(" ").shuffle[0,5].join("-")   }
Sham.host                          { Forgery(:internet).domain_name     }
Sham.rating(:unique =>false)       {  (1..5).random                     }
Sham.boolean(:unique =>false)      { [ true, false ].random             }
Sham.path                          { '/' + (1..3).map{ Forgery(:lorem_ipsum).word }.join("/")  }
Sham.date_time                     { DateTime.parse("2003-01-01") + (2.0*(0.5+rand()) * 365 * 5)  }
Sham.tag_name                      { Sham.word.downcase }
Sham.tag_list                      {|idx| Sham.some_number_of(1,9){ Forgery(:lorem_ipsum).word }  }

Sham.dataset_id                    { Forgery(:basic).number }
Sham.description(:unique => false) { |idx| Forgery(:lorem_ipsum).paragraphs( (1..4).random )  }
Sham.query                         { Forgery(:lorem_ipsum).words( (1..3).random )             }
                                                                                            
Sham.price_in_cents                { (Forgery(:monetary).money(:min => 1).to_f * 100).round }
Sham.price                         {  Forgery(:monetary).money(:min => 1).to_f }

Sham.street_address                { Forgery(:address).street_address  }
Sham.address_1                     { Forgery(:address).street_address  }
Sham.address_2                     { Forgery(:address).street_address  }
Sham.city                          { Forgery(:address).city            }
Sham.state                         { Forgery(:address).state_abbrev    }
Sham.zip                           { Forgery(:address).zip             }   
Sham.country                       { Forgery(:address).country         }   

Sham.credit_card_number             { "4222222222222" }
Sham.card_expires_on                { Time.now + (365 * (1..3).to_a.random).days }
Sham.credit_card_number             { 1 } # ActiveMerchant makes 1 == success, 2 = failure, 3 == error during testing
Sham.credit_card_verification_value { (100..999).to_a.random    }

Sham.http_verb                      { %w{GET POST PUT DELETE HEAD}.random }   

Sham.file_handle do
  # tmp_file = TESTING_DIR + "/#{UUID.generate}"
  tmp_file = "/tmp/cucumber-#{rand}-#{$PID}" # FIXME -- this shouldn't exist at all. But if it does, use Tempfile
  File.open(tmp_file,'w') { |f| f.write(Forgery(:lorem_ipsum).paragraphs(3)) }
  fh = File.open(tmp_file)
  def fh.original_filename      # because files uploaded to rails have this...
    Sham.variable
  end
  fh
end

Sham.fmt(:unique => false) { ["csv", "xml", "xls", "nb", "flat", "text", "tsv"].random }   
Sham.image_fmt(:unique=>false) { %w{jpg png gif}.random }
Sham.s3_url                { "s3://bucket/path/to/file/#{Forgery(:basic).text}.#{Sham.fmt}"       }
Sham.image_url             { "s3://bucket/path/to/file/#{Forgery(:basic).text}.#{Sham.image_fmt}" }
Sham.avro_schema(:unique => false) do
  {
    "name"   => "foo",
    "fields" => [{
      "type" => "string",
      "name" => "field1",
      "doc"  => "blah blah blah and stuff"
    }] 
  }  
end

Sham.apikey { Forgery(:internet).user_name + '-' + Base64.encode64(Digest::SHA1.digest(Time.now.to_i.to_s)).strip.tr('+/', '-_').gsub(/=/,'') + '69' }
