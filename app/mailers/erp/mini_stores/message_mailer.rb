module Erp::MiniStores
  class MessageMailer < Erp::ApplicationMailer
    helper Erp::ApplicationHelper
    
    def sending_admin_email_message_confirmation(message)
      @recipients = ['Sơn Nguyễn <sonnn@hoangkhang.com.vn>']
      
      @message = message
      send_email(@recipients.join("; "), "[THICHLADI.INFO] -#{Time.current.strftime('%Y%m%d')}- LỜI NHẮN TỪ WEBSITE THICHLADI.INFO")
    end
  end
end
