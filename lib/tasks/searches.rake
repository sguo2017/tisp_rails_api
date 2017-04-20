desc "删除以前的搜索记录"
task :remove_old_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE serv_offers_searches")
end