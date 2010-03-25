module ComcastVm
  class DigitalVoice
    def initialize(phone, pin)
      @agent = WWW::Mechanize.new { |agent| agent.follow_meta_refresh = true }
      @url   = "https://digitalvoice.comcast.net/"
      @phone = phone
      @pin   = pin

      login
    end

    def voicemail?
      voicemail_count > 0
    end

    def voicemail_count
      @main_page.search("//a[@id='Voice Mail']").first.parent.parent.search("span.right").text.strip.to_i
    end
    
    private

    def login
      page = @agent.get(@url)

      login_form = page.form("digiusrform")

      login_form.dvPhoneNum = @phone
      login_form.dvPin      = @pin

      @main_page = @agent.submit(login_form, login_form.buttons.first)
    end
  end
end