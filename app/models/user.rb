class User < ApplicationRecord

  validates :email, 
           uniqueness: true, 
           presence: true
  validates :city, presence: true, inclusion: {in: CITIES}


  self.send_signup_mail(id, conditions)
    subject = ""
    if conditions[:internal_desc] == "Nice"
      subject = "It's nice out! Enjoy a discount on us."
      pre_image_texts = get_pre_image_texts(0)
      gif = "https://media.giphy.com/media/xTiTnyijMsXgn6Bzzy/giphy.gif"
    elsif conditions[:internal_desc] == "Not Nice"
      subject = "Not so nice out? That's okay, enjoy a discount on us."
      pre_image_texts = get_pre_image_texts(1)
      gif = "https://media.giphy.com/media/l2JefZqHH238j3U5i/giphy.gif"
    else
      subject = "Enjoy a discount on us."
      pre_image_texts = get_pre_image_texts(2)
      gif = "https://media.giphy.com/media/l0K3ZRJ1IXfxgmMQU/giphy.gif"
    end
    UserMailer.discount(user, conditions, subject, pre_image_texts, gif).deliver!
  end


end
