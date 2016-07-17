defmodule Pestal.Socket do
  def connect(host, port, options, timeout, true) do
    :ssl.connect(host, port, options, timeout)
  end

  def connect(host, port, options, timeout, false) do
    :gen_tcp.connect(host, port, options, timeout)
  end

  def recv(socket, true) do
    :ssl.recv(socket, 0)
  end
  
  def recv(socket, false) do
    :prim_inet.recv(socket, 0)
  end

  def recv(socket, true, timeout) do
    :ssl.recv(socket, 0, timeout);
  end

  def recv(socket, false, timeout) do
    :prim_inet.recv(socket, 0, timeout)
  end

  def send(socket, request, true) do
    :ssl.send(socket, request)
  end

  def send(socket, request, false) do
    :prim_inet.send(socket, request, [])
  end

  def close(socket, true) do
    :ssl.close(socket)
  end

  def close(socket, false) do
    :gen_tcp.close(socket)
  end

  def setopts(socket, options, true) do
    :ssl.setopts(socket, options)
  end

  def setopts(socket, options, false) do
    :inet.setopts(socket, options)
  end
end