defmodule Pestal do
  # use Application
  use GenServer

  defstruct attempts: 0, socket: nil, url: nil, host: nil, options: []

  # # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # # for more information on OTP Applications
  # def start(_type, _args) do
  #   import Supervisor.Spec, warn: false

  #   # Define workers and child supervisors to be supervised
  #   children = [
  #     # Starts a worker by calling: Pestal.Worker.start_link(arg1, arg2, arg3)
  #     # worker(Pestal.Worker, [arg1, arg2, arg3]),
  #   ]

  #   # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
  #   # for other strategies and supported options
  #   opts = [strategy: :one_for_one, name: Pestal.Supervisor]
  #   Supervisor.start_link(children, opts)
  # end

  def start(dest, options) do
    GenServer.start(__MODULE__, {dest, options}, name: __MODULE__)
  end

  def start_link(dest, options) do
    GenServer.start_link(__MODULE__, {dest, options}, name: __MODULE__)
  end

  def init(host, options) do
    state = %Pestal { 
      url: URI.parse(host), 
      host: host, 
      options: options
    }
    {:ok, state}
  end

  def request(client, method, url, body, headers, opts \\ []) do
    GenServer.call(client, {:request, method, url, body, headers, opts})
  end

  def handle_call({:request, _method, _url, _body, _headers, _opts}, _from, state) do
    # {:ok, socket} = :gen_tcp.connect(to_charlist(path.url.host), path.url.port, [:binary, active: false])
    # :ok = :gen_tcp.send(socket, headers(method, url))
    # handle_resp(socket)
    send_req(state)
  end

  def send_req(%Pestal {attempts: 0} = state) do
    {:reply, {:error, :closed}, state}
  end

  def send_req(%Pestal {socket: nil} = state) do
    case connect_socket(state) do
      {:ok, state} -> 
        send_req(state)
      {:error, state} -> 
        {:reply, {:error, :closed}, state}
    end
  end

  def connect_socket(state) do
    case new_socket(state) do
      {:ok, socket} -> 
        {:ok, %Pestal {state | socket: socket}}
      {:error, msg} ->
        {:error, msg, state}
    end
  end

  def handle_resp(socket) do
    case :gen_tcp.recv(socket, 0, :infinity) do
      {:ok, resp} -> resp
      {:error, err} -> err
    end
  end

  def headers(method, url) do
    """
    #{method} / HTTP/1.1\r\n
    Content-Type: text/html\r\n
    Host: #{url.host}\r\n
    \r\n
    """
  end

  def version do
    Mix.Project.config[:version]
  end
end
