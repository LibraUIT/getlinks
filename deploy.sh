git add .
git commit -m "config local"
git pull origin master
bundle install
bundle exec rake db:migrate assets:clean assets:precompile
/opt/nginx/sbin/nginx -s reload
sudo chmod 777 -R /www/getlinks/
