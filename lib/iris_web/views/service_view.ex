defmodule IrisWeb.ServiceView do
  use IrisWeb, :view

  def render("index.json", %{services: services}) do
    %{data: render_many(services, IrisWeb.ServiceView, "service.json")}
  end

  def render("show.json", %{service: service}) do
    render_one(service, IrisWeb.ServiceView, "service.json")
  end

  def render("service.json", %{service: service}) do
    %{id: service.id,
      name: service.name,
      description: service.description,
      icon: service.icon,
      token: service.token,
      type: service.type}
  end
end
