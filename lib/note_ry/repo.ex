defmodule NoteRy.Repo do
  use Ecto.Repo,
    otp_app: :note_ry,
    adapter: Ecto.Adapters.Postgres
end
