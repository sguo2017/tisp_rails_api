desc "删除以前的搜索记录"
task :clear_goods_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE goods_searches")
	puts('===success===')
end

task :clear_chats_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE chats_searches")
	puts('===success===')
end

task :clear_favorites_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE favorites_searches")
	puts('===success===')
end

task :clear_goods_catalogs_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE goods_catalogs_searches")
	puts('===success===')
end

task :clear_orders_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE orders_searches")
	puts('===success===')
end

task :clear_sms_sends_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE sms_sends_searches")
	puts('===success===')
end

task :clear_sys_msgs_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE sys_msgs_searches")
	puts('===success===')
end

task :clear_users_searches => :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE users_searches")
	puts('===success===')
end