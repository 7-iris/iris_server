defmodule Mqtt.Messenger do
  use GenServer
  alias Hulaaki.Connection
  alias Hulaaki.Message

  # Public API

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def ping, do: GenServer.call(__MODULE__, :ping)

  ## GenServer API

  def init(%{} = state) do
    {:ok, conn_pid} = Connection.start_link(self)
    configuration = [client_id: "some-name", host: "localhost", port: 1883]
    host          = configuration |> Keyword.fetch!(:host)
    port          = configuration |> Keyword.fetch!(:port)
    timeout       = configuration |> Keyword.get(:timeout, 100)

    client_id     = configuration |> Keyword.fetch!(:client_id)
    username      = configuration |> Keyword.get(:username, "")
    password      = configuration |> Keyword.get(:password, "")
    will_topic    = configuration |> Keyword.get(:will_topic, "")
    will_message  = configuration |> Keyword.get(:will_message, "")
    will_qos      = configuration |> Keyword.get(:will_qos, 0)
    will_retain   = configuration |> Keyword.get(:will_retain, 0)
    clean_session = configuration |> Keyword.get(:clean_session, 1)
    keep_alive    = configuration |> Keyword.get(:keep_alive, 100)

    message = Message.connect(client_id, username, password,
                             will_topic, will_message, will_qos,
                             will_retain, clean_session, keep_alive)

    state = Map.merge(%{connection: conn_pid}, state)

    connect_opts = [host: host, port: port, timeout: timeout]
    :ok = state.connection |> Connection.connect(message, connect_opts)
    {:ok, state}
  end

  def handle_call(:ping, _from, state) do
   :ok = state.connection |> Connection.ping
   {:reply, :ok, state}
  end

  def handle_info({:sent, %Message.Connect{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.ConnAck{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:sent, %Message.Publish{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.Publish{qos: qos} = message}, state) do
   case qos do
     1 ->
       message = Message.publish_ack message.id
       :ok = state.connection |> Connection.publish_ack(message)
     _ ->
       :droped
   end

   {:noreply, state}
  end

  def handle_info({:sent, %Message.PubAck{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.PubRec{} = message}, state) do
   message = Message.publish_release message.id
   :ok = state.connection |> Connection.publish_release(message)
   {:noreply, state}
  end

  def handle_info({:sent, %Message.PubRel{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.PubComp{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.PubAck{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:sent, %Message.Subscribe{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.SubAck{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:sent, %Message.Unsubscribe{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.UnsubAck{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:sent, %Message.PingReq{} = message}, state) do
   {:noreply, state}
  end

  def handle_info({:received, %Message.PingResp{} = message}, state) do
   {:noreply, state}
  end

end
