defmodule BankWeb.Email do
  import Bamboo.Email

  def cashout_email(user, amount_format) do
    new_email(
      to: user.email,
      from: "support@bank.com",
      subject: "Cashout Performed",
      html_body: "<p>Hi, #{user.name}. <br><br> Your cash out has been successfully completed. <br> Amount: #{amount_format}</p>",
      text_body: "Hi, #{user.name}. Your cash out has been successfully completed. Amount: #{amount_format}"
    )
  end
end