require 'rufus-scheduler'

def clear_all_searches
  conn=ActiveRecord::Base.connection
  conn.execute("TRUNCATE TABLE goods_searches")
  conn.execute("TRUNCATE TABLE chats_searches")
  conn.execute("TRUNCATE TABLE favorites_searches")
  conn.execute("TRUNCATE TABLE goods_catalogs_searches")
  conn.execute("TRUNCATE TABLE orders_searches")
  conn.execute("TRUNCATE TABLE sms_sends_searches")
  conn.execute("TRUNCATE TABLE sys_msgs_searches")
  conn.execute("TRUNCATE TABLE users_searches")
  conn.close
end

scheduler = Rufus::Scheduler.new
logger=Logger.new(STDOUT)
scheduler.every Const::CLEAN_SEARCH_INTERVAL do
  logger.info '###Starting timing tasks...'
  Thread.new{
    logger.info '###Cleaning the searh records...'
    clear_all_searches
    logger.info '###Searh records have been clean!'
  }
end




