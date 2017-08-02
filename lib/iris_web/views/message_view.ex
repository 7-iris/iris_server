defmodule IrisWeb.MessageView do
  use IrisWeb, :view

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, IrisWeb.MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    render_one(message, IrisWeb.MessageView, "message.json")
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      title: message.title,
      text: message.text,
      priority: message.priority,
      link: message.link,
      service_token: message.service_token}
  end
end
