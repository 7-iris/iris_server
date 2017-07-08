alias Iris.{Repo, Role}
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

user_role = find_or_create_role.("User Role", false)
admin_role = find_or_create_role.("Admin Role", true)
