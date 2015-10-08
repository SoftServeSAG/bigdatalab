# bigdatalab
[ ![Codeship Status for SoftServeSAG/bigdatalab](https://codeship.com/projects/6d814050-2d1d-0133-558b-16954c8f6a18/status?branch=develop)](https://codeship.com/projects/98767)

## How to test

```
cd puppet
bundle install
bundle exec rake prep
bundle exec rake rspec:classes
bundle exec rake rspec:acceptance
bundle exec rake clean
```