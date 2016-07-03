git status
git add --all
git commit -m "config local"
git pull origin master
rvm gemset use getlinks
gem install bundler
bundle install
bundle exec rake db:migrate
rake assets:clean
rake assets:precompile
rake sitemap:refresh
/opt/nginx/sbin/nginx -s reload
sudo chmod 777 -R /www/getlinks/
