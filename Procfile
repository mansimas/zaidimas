web: bundle exec thin start -R config.ru -e $RAILS_ENV -p $PORT
worker:  bundle exec rake jobs:work
sidekiq: bundle exec sidekiq -c 1 -v