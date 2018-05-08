defmodule Weblica.ETSSupervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    table = :ets.new(:food_store, [:set, :public])

    children = [%{id: Weblica.ETSGenServer, start: {Weblica.ETSGenServer, :start_link, [table]}}]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
