RuCaptcha.configure do
  # Color style, default: :colorful, allows: [:colorful, :black_white]
  # self.style = :colorful
  # Custom captcha code expire time if you need, default: 2 minutes
  # self.expires_in = 120
  # [Requirement / ��Ҫ]
  # Store Captcha code where, this config more like Rails config.cache_store
  # default: Read config info from `Rails.application.config.cache_store`
  # But RuCaptcha requirements cache_store not in [:null_store, :memory_store, :file_store]
  # Ĭ�ϣ���� Rails ���õ� cache_store �����ȡ��ͬ��������Ϣ���������ÿ������еķ�ʽ�����ڴ洢��֤���ַ�
  # ������� [:null_store, :memory_store, :file_store] ֮��ģ������ͨ���������������� RuCaptcha ���� cache_store
  #self.cache_store = :file_store
end