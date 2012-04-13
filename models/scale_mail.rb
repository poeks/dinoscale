module ScaleMail
  
  def self.do(to_address, subject_line, body_str)
    mail = Mail.deliver do
      to to_address
      from "<noreply@#{confit.app.sendgrid.domain}>"
      subject subject_line
      text_part do
        body body_str
      end
    end
  end
  
end

