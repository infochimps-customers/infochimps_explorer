# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{infochimps_explorer}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["infochimps"]
  s.date = %q{2011-05-14}
  s.description = %q{Documentation and Explorer for the Infochimps API}
  s.email = %q{coders@infochimps.org}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.textile"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".watchr",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.textile",
    "Rakefile",
    "VERSION",
    "app/helpers/form.rb",
    "app/helpers/icss.rb",
    "app/helpers/main.rb",
    "app/views/404.haml",
    "app/views/all_calls.haml",
    "app/views/api_docs.haml",
    "app/views/api_explorer.erb",
    "app/views/debug.haml",
    "app/views/icss_record.haml",
    "app/views/layout.erb",
    "config.ru",
    "config/bootstrap.rb",
    "config/infochimps_explorer.yaml",
    "datasets/economics/finance/stocks/y_historical.icss.yaml",
    "datasets/encyclopedic/dbpedia/wikipedia/articles.icss.json",
    "datasets/encyclopedic/dbpedia/wikipedia/articles.icss.yaml",
    "datasets/encyclopedic/dbpedia/wikipedia/util.icss.yaml",
    "datasets/encyclopedic/freebase/topic.icss.yaml",
    "datasets/engineering/chemical/msds/hazard_msds.icss.yaml",
    "datasets/geo/location/crunchbase/tech_companies.icss.yaml",
    "datasets/geo/location/geonames/autocomplete.icss.yaml",
    "datasets/geo/location/infochimps/auto_nav_data.icss.yaml",
    "datasets/geo/location/infochimps/euro_wireless.icss.yaml",
    "datasets/geo/location/infochimps/fire.icss.yaml",
    "datasets/geo/location/infochimps/freebase_geo.icss.yaml",
    "datasets/geo/location/infochimps/geonames.icss.yaml",
    "datasets/geo/location/infochimps/natural_earth.icss.yaml",
    "datasets/geo/location/infochimps/tele.icss.yaml",
    "datasets/geo/location/infochimps/the_works.icss.yaml",
    "datasets/geo/location/infochimps/us_hospitals.icss.yaml",
    "datasets/geo/location/map/auto_nav_data.icss.yaml",
    "datasets/language/corpora/word_freq/bnc.icss.yaml",
    "datasets/meta/http.icss.yaml",
    "datasets/science/astronomy/seti/nuforc.icss.yaml",
    "datasets/social/network/qwerly/qwerly_profiles.icss.yaml",
    "datasets/social/network/tw/conversation.icss.yaml",
    "datasets/social/network/tw/graph.icss.yaml",
    "datasets/social/network/tw/influence.icss.yaml",
    "datasets/social/network/tw/search-people_search.icss.yaml",
    "datasets/social/network/tw/search-tweet_search.icss.yaml",
    "datasets/social/network/tw/token.icss.yaml",
    "datasets/social/network/tw/util.icss.yaml",
    "datasets/util/meta/debugging/complicated_types.icss.yaml",
    "datasets/util/meta/template/simple.icss.yaml",
    "datasets/util/text/lorem/forgery.icss.yaml",
    "datasets/util/time/README.md",
    "datasets/util/time/chronic.icss.yaml",
    "datasets/web/analytics/traffic/cedexis.icss.yaml",
    "infochimps_explorer.gemspec",
    "infochimps_explorer.rb",
    "lib/boot.rb",
    "lib/endpoint.rb",
    "lib/main.rb",
    "public/favicon.ico",
    "public/images/icon-api.png",
    "public/images/infochimps-logo-b.png",
    "public/javascripts/application.js",
    "public/javascripts/jquery.js",
    "public/javascripts/jquery/jquery-ui.js",
    "public/javascripts/jquery/jquery.js",
    "public/robots.txt",
    "public/stylesheets/infochimps.css",
    "spec/infochimps_explorer_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://infochimps.com/labs}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Documentation and Explorer for the Infochimps API}
  s.test_files = [
    "spec/infochimps_explorer_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<configliere>, ["~> 0.3.2"])
      s.add_runtime_dependency(%q<gorillib>, ["~> 0.0.4"])
      s.add_runtime_dependency(%q<icss>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, ["~> 0.8.2"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.2.1"])
      s.add_runtime_dependency(%q<rack-test>, ["~> 0.5.7"])
      s.add_runtime_dependency(%q<rack-flash>, ["~> 0.1.1"])
      s.add_runtime_dependency(%q<rack-abstract-format>, ["~> 0.9.9"])
      s.add_runtime_dependency(%q<rack-accept-media-types>, ["~> 0.9"])
      s.add_runtime_dependency(%q<unicorn>, ["~> 3.4.0"])
      s.add_runtime_dependency(%q<haml>, ["~> 3.0.25"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.2.2"])
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.1.2"])
      s.add_runtime_dependency(%q<RedCloth>, ["~> 4.2.4"])
      s.add_runtime_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.12"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.7"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_development_dependency(%q<rcov>, [">= 0.9.9"])
    else
      s.add_dependency(%q<configliere>, ["~> 0.3.2"])
      s.add_dependency(%q<gorillib>, ["~> 0.0.4"])
      s.add_dependency(%q<icss>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, ["~> 0.8.2"])
      s.add_dependency(%q<rack>, ["~> 1.2.1"])
      s.add_dependency(%q<rack-test>, ["~> 0.5.7"])
      s.add_dependency(%q<rack-flash>, ["~> 0.1.1"])
      s.add_dependency(%q<rack-abstract-format>, ["~> 0.9.9"])
      s.add_dependency(%q<rack-accept-media-types>, ["~> 0.9"])
      s.add_dependency(%q<unicorn>, ["~> 3.4.0"])
      s.add_dependency(%q<haml>, ["~> 3.0.25"])
      s.add_dependency(%q<tilt>, ["~> 1.2.2"])
      s.add_dependency(%q<sinatra>, ["~> 1.1.2"])
      s.add_dependency(%q<RedCloth>, ["~> 4.2.4"])
      s.add_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_dependency(%q<bundler>, ["~> 1.0.12"])
      s.add_dependency(%q<yard>, ["~> 0.6.7"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_dependency(%q<rcov>, [">= 0.9.9"])
    end
  else
    s.add_dependency(%q<configliere>, ["~> 0.3.2"])
    s.add_dependency(%q<gorillib>, ["~> 0.0.4"])
    s.add_dependency(%q<icss>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, ["~> 0.8.2"])
    s.add_dependency(%q<rack>, ["~> 1.2.1"])
    s.add_dependency(%q<rack-test>, ["~> 0.5.7"])
    s.add_dependency(%q<rack-flash>, ["~> 0.1.1"])
    s.add_dependency(%q<rack-abstract-format>, ["~> 0.9.9"])
    s.add_dependency(%q<rack-accept-media-types>, ["~> 0.9"])
    s.add_dependency(%q<unicorn>, ["~> 3.4.0"])
    s.add_dependency(%q<haml>, ["~> 3.0.25"])
    s.add_dependency(%q<tilt>, ["~> 1.2.2"])
    s.add_dependency(%q<sinatra>, ["~> 1.1.2"])
    s.add_dependency(%q<RedCloth>, ["~> 4.2.4"])
    s.add_dependency(%q<addressable>, ["~> 2.2.6"])
    s.add_dependency(%q<bundler>, ["~> 1.0.12"])
    s.add_dependency(%q<yard>, ["~> 0.6.7"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rspec>, ["~> 2.5.0"])
    s.add_dependency(%q<rcov>, [">= 0.9.9"])
  end
end

