class TextMessage < ActiveRecord::Base
  after_create :process

  def process
    if to == phone_number
      new_sentence = body.split.map {|x| translate(x)}
      body_message = new_sentence.join(" ")
      TextMessage.create(to: from, from: '+12345678910', body: body_message)
    else

      send_outgoing
    end
  end

  def translate(str)
    alpha = ('a'..'z').to_a
    vowels = %w[a e i o u]
    consonants = alpha - vowels

    if vowels.include?(str[0])
      str + 'ay'
    elsif consonants.include?(str[0]) && consonants.include?(str[1])
      str[2..-1] + str[0..1] + 'ay'
    elsif consonants.include?(str[0])
      str[1..-1] + str[0] + 'ay'
    else
      str
    end

  end


 def send_outgoing
  client.message.create{
    To: to,
    From: from,
    Body: body
  }
 end

 private

  def client
   @client || = Twilio::REST::Client.new
  end

  def phone_number
    @phone_number || = Rails.application.secrets.twilio_phone_number
  end

end
