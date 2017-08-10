alias Iris.{Repo, Role, User, Device}
import Ecto.Query, only: [from: 2]

find_or_create_role = fn role_name, admin ->
  case Repo.all(from r in Role, where: r.title == ^role_name and r.admin == ^admin) do
    [] ->
      IO.puts "Role: #{role_name} does not exists, creating"
      %Role{}
      |> Role.changeset(%{title: role_name, admin: admin})
      |> Repo.insert!()
     [role] ->
      IO.puts "Role: #{role_name} already exists, skipping"
      role
  end
end

find_or_create_user = fn email, role ->
  case Repo.all(from u in User, where: u.email == ^email) do
    [] ->
      IO.puts "User: #{email} does not exists, creating"
      %User{}
      |> User.changeset(%{email: email, role_id: role.id})
      |> Repo.insert!()
    [user] ->
      IO.puts "User: #{email} already exists, skipping"
      user
  end
end

find_or_create_device = fn name, client_id, access_token, user ->
  case Repo.all(from u in Device, where: u.name == ^name) do
    [] ->
      IO.puts "Device: #{name} does not exists, creating"
      %Device{}
      |> Device.changeset(%{name: name, password: "sagapo", client_id: client_id, access_token: access_token, status: true, user_id: user.id})
      |> Repo.insert!()
    [user] ->
      IO.puts "Device: #{name} already exists, skipping"
      user
  end
end

user_role = find_or_create_role.("User Role", false)
admin_role = find_or_create_role.("Admin Role", true)
admin_user = find_or_create_user.("admin@dev.com", admin_role)
simple_user = find_or_create_user.("user@dev.com", user_role)
find_or_create_device.("iris_server", "iris_server", "access1", admin_user)
find_or_create_device.("test_device", "client2", "access2", simple_user)
