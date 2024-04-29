defmodule FibonacciElixir.Utils.TypedEmbeddedSchema do
  @moduledoc """
  A module that provides a typed embedded schema.

  Extension of `TypedEctoSchema` that combines it with `Domo` for stricter type validation
  as well as providing utility methods from casting and validating input maps or structs.
  The rationale is to have a consistent method that can cast and validate to and from
  untyped maps to a typed structure. It's main use will be to convert data incoming from
  controllers to be passed in to the context boundary.

  ## Usage

    use FibonacciElixir.Utils.TypedEmbeddedSchema

    alias AgiDb.Projects.UpsertPropertyCommand
    alias AgiDb.Workspaces.Workspace

    @primary_key false
    typed_embedded_schema do
      field(:name, :string) :: String.t()
      field(:workspace_id, :string) :: Workspace.id()
      embeds_many(:properties, UpsertPropertyCommand)
    end

  ```elixir
  > {:ok, command} = CreateProjectCommand.cast_and_validate(conn.body_params)
  ```
  """
  defmacro __using__(domo_opts \\ []) do
    quote do
      use TypedEctoSchema
      use Domo, unquote(Keyword.merge(domo_opts, skip_defaults: true))

      import Ecto.Changeset
      import Domo.Changeset

      @spec cast_and_validate(map() | struct()) :: {:ok, struct()} | Ecto.Changeset.t()
      def cast_and_validate(attrs) do
        case changeset(attrs) do
          %Ecto.Changeset{valid?: true} = cs -> {:ok, Ecto.Changeset.apply_changes(cs)}
          err -> err
        end
      end

      @spec changeset(map() | struct()) :: Ecto.Changeset.t()
      def changeset(attrs) do
        changeset(struct(__MODULE__), attrs)
      end

      @spec changeset(struct(), map() | struct()) :: Ecto.Changeset.t()
      def changeset(changeset, attrs) do
        changeset
        |> cast_fields(attrs)
        |> cast_embeds()
        |> validate_type()
      end

      defp cast_fields(changeset, attrs) do
        cast(changeset, sanitize(attrs), __schema__(:fields) -- __schema__(:embeds))
      end

      defp sanitize(%_struct{} = attrs), do: Map.from_struct(attrs)
      defp sanitize(attrs), do: attrs

      defp cast_embeds(changeset) do
        cast_embeds(changeset, __schema__(:embeds))
      end

      defp cast_embeds(changeset, []) do
        changeset
      end

      defp cast_embeds(changeset, [name | rest]) do
        cast_embeds(cast_embed(changeset, name), rest)
      end
    end
  end
end
