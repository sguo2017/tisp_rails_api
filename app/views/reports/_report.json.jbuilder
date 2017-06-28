json.extract! report, :id, :obj_id, :obj_type, :content, :status, :created_at, :updated_at
json.url report_url(report, format: :json)
