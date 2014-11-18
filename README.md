RubyMe: A platform for sharing blogs
=======

RubyMe, you know, a platform for sharing blog.
Site url: ****************

## How to Install

Make sure mysql already started.
```bash
git clone git@github.com:jasonZYJ/RubyMe.git
cd RubyMe
# A ruby script to RTF
ruby setup.rb
# Then change config at database.yml and settings.yml

RAILS_ENV=development rails s
# start delayed_job for async sending email and uploading photo
RAILS_ENV=development bin/delayed_job start
```

## How to Test

We use rspec & capybarato test.
```bash
RAILS_ENV=test rails s
# Make sure already installed firefox
bundle exec rspec -fd
```
