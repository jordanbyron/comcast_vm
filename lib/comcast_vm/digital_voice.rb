module ComcastVm
  class DigitalVoice
    attr_reader :main_page, :voicemail
    
    def initialize(phone, pin)
      @agent = WWW::Mechanize.new { |agent| agent.follow_meta_refresh = true }
      @url   = "https://digitalvoice.comcast.net/"
      @phone = phone
      @pin   = pin

      login
      find_voicemail
    end

    def voicemail?
      voicemail_count > 0
    end

    def voicemail_count
      @voicemail.length
      #@main_page.search("//a[@id='Voice Mail']").first.parent.parent.search("span.right").text.strip.to_i
    end
    
    private

    def login
      page = @agent.get(@url)

      login_form = page.form("digiusrform")

      login_form.dvPhoneNum = @phone
      login_form.dvPin      = @pin

      @main_page = @agent.submit(login_form, login_form.buttons.first)
    end
    
    def find_voicemail
      @voicemail = []
      
      @main_page.search("div.dashboard").each do |voicemail|
        number = voicemail.children[3].text.strip
        @voicemail << Voicemail.new(number)
      end
    end
  end
end