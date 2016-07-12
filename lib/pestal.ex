defmodule Pestal do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Pestal.Worker.start_link(arg1, arg2, arg3)
      # worker(Pestal.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pestal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def version do
    Mix.Project.config[:version]
  end

  def send_req do
    {:ok, socket} = :gen_tcp.connect('localhost', 80, [:binary, active: false])
    :ok = :gen_tcp.send(socket, request())
    case :gen_tcp.recv(socket, 0) do
      {:ok, resp} -> IO.inspect(resp)
      {:error, err} -> IO.inspect(err)
    end
  end

  def request do
    """
    GET /my_coupon/ HTTP/1.1\r\n
    Content-Type: text/html\r\n
    Host: localhost\r\n
    \r\n
    """
  end
end
