defmodule Rummage.Ecto.Services.BuildSearchQuery do
  @moduledoc """
  `Rummage.Ecto.Services.BuildSearchQuery` is a service module which serves the
  default search hook, `Rummage.Ecto.Hooks.Search` that comes shipped with `Rummage.Ecto`.

  Has a `Module Attribute` called `search_types`:

  ```elixir
  @search_types ~w(like ilike eq gt lt gteq lteq is_null)a
  @search_exprs ~w(where or_where not_where)a
  ```

  `@search_types` is a collection of all the 8 valid `search_types` that come shipped with
  `Rummage.Ecto`'s default search hook. The types are:

  * `like`: Searches for a `term` in a given `field` of a `queryable`.
  * `ilike`: Searches for a `term` in a given `field` of a `queryable`, in a case insensitive fashion.
  * `eq`: Searches for a `term` to be equal to a given `field` of a `queryable`.
  * `gt`: Searches for a `term` to be greater than to a given `field` of a `queryable`.
  * `lt`: Searches for a `term` to be less than to a given `field` of a `queryable`.
  * `gteq`: Searches for a `term` to be greater than or equal to to a given `field` of a `queryable`.
  * `lteq`: Searches for a `term` to be less than or equal to a given `field` of a `queryable`.
  * `is_null`: Searches for a null value when `term` is true, or not null when `term` is false.

  `@search_exprs` is a collection of 3 valid `search_exprs` that are used to
  apply a `search_type` to a `Ecto.Queryable`. Those expressions are:

  * `where` (DEFAULT): An AND where query expression.
  * `or_where`: An OR where query expression. Behaves exactly like where but
          combines the previous expression with an `OR` operation. Useful
          for optional searches.
  * `not_where`: A NOT where query expression. This can be used while excluding
          a list of entries based on where query.

  Feel free to use this module on a custom search hook that you write.
  """

  import Ecto.Query

  @typedoc ~s(TODO: Finish)
  @type search_expr :: :where | :or_where | :not_where

  @typedoc ~s(TODO: Finish)
  @type search_type :: :like | :ilike | :eq | :gt
                  | :lt | :gteq | :lteq | :is_null

  @search_types ~w(like ilike eq gt lt gteq lteq is_null)a
  @search_exprs ~w(where or_where not_where)a

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using `field`, `search_type`
  and `search_term`.

  ## Examples
  When `search_type` is `where`:
    When `field`, `search_type` and `queryable` are passed with `search_type` of `like`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:where, :like}, "field_!")
        #Ecto.Query<from p in "parents", where: like(p.field_1, ^"%field_!%")>

    When `field`, `search_type` and `queryable` are passed with `search_type` of `ilike`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:where, :ilike}, "field_!")
        #Ecto.Query<from p in "parents", where: ilike(p.field_1, ^"%field_!%")>

    When `field`, `search_type` and `queryable` are passed with `search_type` of `eq`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:where, :eq}, "field_!")
        #Ecto.Query<from p in "parents", where: p.field_1 == ^"field_!">

    When `field`, `search_type` and `queryable` are passed with `search_type` of `gt`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:where, :gt}, "field_!")
        #Ecto.Query<from p in "parents", where: p.field_1 > ^"field_!">

    When `field`, `search_type` and `queryable` are passed with `search_type` of `lt`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:where, :lt}, "field_!")
        #Ecto.Query<from p in "parents", where: p.field_1 < ^"field_!">

    When `field`, `search_type` and `queryable` are passed with `search_type` of `gteq`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:where, :gteq}, "field_!")
        #Ecto.Query<from p in "parents", where: p.field_1 >= ^"field_!">

    When `field`, `search_type` and `queryable` are passed with `search_type` of `lteq`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:where, :lteq}, "field_!")
        #Ecto.Query<from p in "parents", where: p.field_1 <= ^"field_!">

  When `search_type` is `or_where`:

  When `field`, `search_type` and `queryable` are passed with `search_type` of `like`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:or_where, :like}, "field_!")
        #Ecto.Query<from p in "parents", or_where: like(p.field_1, ^"%field_!%")>

  When `field`, `search_type` and `queryable` are passed with `search_type` of `ilike`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:or_where, :ilike}, "field_!")
        #Ecto.Query<from p in "parents", or_where: ilike(p.field_1, ^"%field_!%")>

  When `field`, `search_type` and `queryable` are passed with `search_type` of `eq`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:or_where, :eq}, "field_!")
        #Ecto.Query<from p in "parents", or_where: p.field_1 == ^"field_!">

  When `field`, `search_type` and `queryable` are passed with `search_type` of `gt`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:or_where, :gt}, "field_!")
        #Ecto.Query<from p in "parents", or_where: p.field_1 > ^"field_!">

  When `field`, `search_type` and `queryable` are passed with `search_type` of `lt`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:or_where, :lt}, "field_!")
        #Ecto.Query<from p in "parents", or_where: p.field_1 < ^"field_!">

  When `field`, `search_type` and `queryable` are passed with `search_type` of `gteq`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:or_where, :gteq}, "field_!")
        #Ecto.Query<from p in "parents", or_where: p.field_1 >= ^"field_!">

  When `field`, `search_type` and `queryable` are passed with `search_type` of `lteq`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:or_where, :lteq}, "field_!")
        #Ecto.Query<from p in "parents", or_where: p.field_1 <= ^"field_!">

  When `field`, `search_type` and `queryable` are passed with an invalid `search_type`
  and `search_expr`:

        iex> alias Rummage.Ecto.Services.BuildSearchQuery
        iex> import Ecto.Query
        iex> queryable = from u in "parents"
        #Ecto.Query<from p in "parents">
        iex> BuildSearchQuery.run(queryable, :field_1, {:pizza, :cheese}, "field_!")
        ** (RuntimeError) Unknown {search_expr, search_type}, {:pizza, :cheese}
        search_type should be one of #{inspect @search_types}
        search_expr should be one of #{inspect @search_exprs}


  """
  @spec run(Ecto.Query.t, {__MODULE__.search_expr(), __MODULE__.search_type()},
            String.t, term) :: {Ecto.Query.t}
  def run(queryable, field, {search_expr, search_type}, search_term)
      when search_type in @search_types and search_expr in @search_exprs
    do
    apply(__MODULE__, String.to_atom("handle_" <> to_string(search_type)),
          [queryable, field, search_term, search_expr])
  end
  def run(_, _, search_tuple, _) do
    raise "Unknown {search_expr, search_type}, #{inspect search_tuple}\n" <>
      "search_type should be one of #{inspect @search_types}\n" <>
      "search_expr should be one of #{inspect @search_exprs}"
  end

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using
  `field`, `search_term` and `search_expr` when the `search_type` is `like`.

  Checkout [Ecto.Query.API.like/2](https://hexdocs.pm/ecto/Ecto.Query.API.html#like/2)
  for more info.

  NOTE: Be careful of [Like Injections](https://githubengineering.com/like-injection/)

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_like(queryable, :field_1, "field_!", :where)
      #Ecto.Query<from p in "parents", where: like(p.field_1, ^"%field_!%")>

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_like(queryable, :field_1, "field_!", :or_where)
      #Ecto.Query<from p in "parents", or_where: like(p.field_1, ^"%field_!%")>

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_like(queryable, :field_1, "field_!", :not_where)
      #Ecto.Query<from p in "parents", where: not like(p.field_1, ^"%field_!%")>

  """
  @spec handle_like(Ecto.Query.t(), atom(), String.t(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_like(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      like(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_like(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      like(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_like(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      not like(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using
  `field`, `search_term` and `search_expr` when the `search_type` is `ilike`.

  Checkout [Ecto.Query.API.ilike/2](https://hexdocs.pm/ecto/Ecto.Query.API.html#ilike/2)
  for more info.

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_ilike(queryable, :field_1, "field_!", :where)
      #Ecto.Query<from p in "parents", where: ilike(p.field_1, ^"%field_!%")>

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_ilike(queryable, :field_1, "field_!", :or_where)
      #Ecto.Query<from p in "parents", or_where: ilike(p.field_1, ^"%field_!%")>

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_ilike(queryable, :field_1, "field_!", :not_where)
      #Ecto.Query<from p in "parents", where: not ilike(p.field_1, ^"%field_!%")>

  """
  @spec handle_ilike(Ecto.Query.t(), atom(), String.t(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_ilike(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      ilike(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_ilike(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      ilike(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end
  def handle_ilike(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      not ilike(field(b, ^field), ^"%#{String.replace(search_term, "%", "\\%")}%"))
  end

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using
  `field`, `search_term` and `search_expr` when the `search_type` is `eq`.

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_eq(queryable, :field_1, "field_!", :where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 == ^\"field_!\">

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_eq(queryable, :field_1, "field_!", :or_where)
      #Ecto.Query<from p in \"parents\", or_where: p.field_1 == ^\"field_!\">

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_eq(queryable, :field_1, "field_!", :not_where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 != ^\"field_!\">

  """
  @spec handle_eq(Ecto.Query.t(), atom(), term(),
                  __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_eq(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) == ^search_term)
  end
  def handle_eq(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) == ^search_term)
  end
  def handle_eq(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) != ^search_term)
  end

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using
  `field`, `search_term` and `search_expr` when the `search_type` is `gt`.

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_gt(queryable, :field_1, "field_!", :where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 > ^\"field_!\">

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_gt(queryable, :field_1, "field_!", :or_where)
      #Ecto.Query<from p in \"parents\", or_where: p.field_1 > ^\"field_!\">

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_gt(queryable, :field_1, "field_!", :not_where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 <= ^\"field_!\">

  """
  @spec handle_gt(Ecto.Query.t(), atom(), term(),
                  __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_gt(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) > ^search_term)
  end
  def handle_gt(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) > ^search_term)
  end
  def handle_gt(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) <= ^search_term)
  end

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using
  `field`, `search_term` and `search_expr` when the `search_type` is `lt`.

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_lt(queryable, :field_1, "field_!", :where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 < ^\"field_!\">

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_lt(queryable, :field_1, "field_!", :or_where)
      #Ecto.Query<from p in \"parents\", or_where: p.field_1 < ^\"field_!\">

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_lt(queryable, :field_1, "field_!", :not_where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 >= ^\"field_!\">

  """
  @spec handle_lt(Ecto.Query.t(), atom(), term(),
                  __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_lt(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) < ^search_term)
  end
  def handle_lt(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) < ^search_term)
  end
  def handle_lt(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) >= ^search_term)
  end

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using
  `field`, `search_term` and `search_expr` when the `search_type` is `gteq`.

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_gteq(queryable, :field_1, "field_!", :where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 >= ^\"field_!\">

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_gteq(queryable, :field_1, "field_!", :or_where)
      #Ecto.Query<from p in \"parents\", or_where: p.field_1 >= ^\"field_!\">

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_gteq(queryable, :field_1, "field_!", :not_where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 < ^\"field_!\">

  """
  @spec handle_gteq(Ecto.Query.t(), atom(), term(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_gteq(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) >= ^search_term)
  end
  def handle_gteq(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) >= ^search_term)
  end
  def handle_gteq(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) < ^search_term)
  end

  @doc """
  Builds a searched `queryable` on top of the given `queryable` using
  `field`, `search_term` and `search_expr` when the `search_type` is `lteq`.

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_lteq(queryable, :field_1, "field_!", :where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 <= ^\"field_!\">

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_lteq(queryable, :field_1, "field_!", :or_where)
      #Ecto.Query<from p in \"parents\", or_where: p.field_1 <= ^\"field_!\">

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_lteq(queryable, :field_1, "field_!", :not_where)
      #Ecto.Query<from p in \"parents\", where: p.field_1 > ^\"field_!\">

  """
  @spec handle_lteq(Ecto.Query.t(), atom(), term(),
                    __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_lteq(queryable, field, search_term, :where) do
    queryable
    |> where([..., b],
      field(b, ^field) <= ^search_term)
  end
  def handle_lteq(queryable, field, search_term, :or_where) do
    queryable
    |> or_where([..., b],
      field(b, ^field) <= ^search_term)
  end
  def handle_lteq(queryable, field, search_term, :not_where) do
    queryable
    |> where([..., b],
      field(b, ^field) > ^search_term)
  end

  @doc """
  Builds a searched `queryable` on `field` is_nil (when `term` is true),
  or not is_nil (when `term` is false), based on `search_expr` given.

  Checkout [Ecto.Query.API.like/2](https://hexdocs.pm/ecto/Ecto.Query.API.html#is_nil/1)
  for more info.

  Assumes that `search_expr` is in #{inspect @search_exprs}.

  ## Examples

  When `search_expr` is `:where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_is_null(queryable, :field_1, true, :where)
      #Ecto.Query<from p in "parents", where: is_nil(p.field_1)>
      iex> BuildSearchQuery.handle_is_null(queryable, :field_1, false, :where)
      #Ecto.Query<from p in "parents", where: not is_nil(p.field_1)>

  When `search_expr` is `:or_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_is_null(queryable, :field_1, true, :or_where)
      #Ecto.Query<from p in "parents", or_where: is_nil(p.field_1)>
      iex> BuildSearchQuery.handle_is_null(queryable, :field_1, false, :or_where)
      #Ecto.Query<from p in "parents", or_where: not is_nil(p.field_1)>

  When `search_expr` is `:not_where`

      iex> alias Rummage.Ecto.Services.BuildSearchQuery
      iex> import Ecto.Query
      iex> queryable = from u in "parents"
      #Ecto.Query<from p in "parents">
      iex> BuildSearchQuery.handle_is_null(queryable, :field_1, true, :not_where)
      #Ecto.Query<from p in "parents", where: not is_nil(p.field_1)>
      iex> BuildSearchQuery.handle_is_null(queryable, :field_1, false, :not_where)
      #Ecto.Query<from p in "parents", where: is_nil(p.field_1)>

  """
  @spec handle_is_null(Ecto.Query.t(), atom(), boolean(),
                      __MODULE__.search_expr()) :: Ecto.Query.t()
  def handle_is_null(queryable, field, true, :where)do
    queryable
    |> where([..., b],
      is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, true, :or_where)do
    queryable
    |> or_where([..., b],
      is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, true, :not_where)do
    queryable
    |> where([..., b],
      not is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, :false, :where) do
    queryable
    |> where([..., b],
      not is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, :false, :or_where) do
    queryable
    |> or_where([..., b],
      not is_nil(field(b, ^field)))
  end
  def handle_is_null(queryable, field, :false, :not_where) do
    queryable
    |> where([..., b],
      is_nil(field(b, ^field)))
  end
end
