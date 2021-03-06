defmodule Mqtt.Messenger do
  use GenServer
  alias Hulaaki.Connection
  alias Hulaaki.Message
  require Logger

  # Public API

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def ping, do: GenServer.call(__MODULE__, :ping)
  def publish(opts), do: GenServer.call(__MODULE__, {:publish, opts})

  ## GenServer API

  def init(%{} = state) do
    {:ok, conn_pid} = Connection.start_link(self())
    configuration = Application.get_env(:iris, Mqtt.Messenger)
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

    case Connection.connect(state.connection, message, connect_opts) do
      :ok ->
        Logger.info "Connection to mqtt established" 
        {:ok, state}
      {:error, _error} ->
        Logger.info "Cannot establish connection with mqtt"
        {:ok, state}
    end
  end

  def handle_call({:publish, opts}, _from, state) do
     topic  = opts |> Keyword.fetch!(:topic)
     msg    = opts |> Keyword.fetch!(:message)
     dup    = opts |> Keyword.fetch!(:dup)
     qos    = opts |> Keyword.fetch!(:qos)
     retain = opts |> Keyword.fetch!(:retain)

     message =
       case qos do
         0 ->
           Message.publish(topic, msg, dup, qos, retain)
         _ ->
           id = opts |> Keyword.fetch!(:id)
           Message.publish(id, topic, msg, dup, qos, retain)
       end

     :ok = state.connection |> Connection.publish(message)
     {:reply, :ok, state}
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
