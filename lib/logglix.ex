defmodule Logglix do
  use GenEvent

  @api_host "http://logs-01.loggly.com"

  defmodule MissingLogglyKeyError do
    defexception message: """
      The loggly_key setting is required so that we can report the
      correct environment name to Loggly. Please configure
      loggly_key in your config.exs and environment specific config files
      to have accurate reporting of errors.
      config :logger, :logglix, loggly_key: YOUR_LOGGLY_KEY
    """
  end

  @moduledoc """
    This module contains the GenEvent that you can use to transmit the logs of
    your applications.
    ### Configuring
    By default the LOGGLY_KEY environment variable is used to find
    your API key for Loggly. You can also manually set your API key by
    configuring the :logglix application. 
        config :logger, :logglix,
          loggly_key: System.get_env("LOGGLY_KEY"),
          tags: ["elixir"],
          level: :info,
          environment: :prod

  """

  def init({__MODULE__, name}) do
    {:ok, setup(name, []) }
  end

  @doc """
  Changes backend setup.
  """
  def handle_call({:setup, opts}, %{name: name}) do
    {:ok, :ok, setup(name, opts)}
  end

  @doc """
  Ignore messages where the group leader is in a different node.
  """
  def handle_event({_level, gl, _event}, config) when node(gl) != node() do
    {:ok, config}
  end

  @doc """
  Handles an log event. Ignores the log event if the event level is less than the min log level.
  """
  def handle_event({level, _gl, {Logger, msg, timestamp, metadata}}, config) do
    if meet_level?(level, config.level) do
      log_event(level, msg, timestamp, metadata, config)
    end
    {:ok, config}
  end

  defp meet_level?(_lvl, nil), do: true
  defp meet_level?(lvl, min) do
   Logger.compare_levels(lvl, min) != :lt
  end


  defp take_metadata(metadata, keys) do
    metadatas = Enum.reduce(keys, [], fn key, acc ->
      case Keyword.fetch(metadata, key) do
        {:ok, val} -> [{key, val} | acc]
        :error     -> acc
      end
    end)

    Enum.reverse(metadatas)
  end

  defp get_config(environment, key, default) do
    Keyword.get(environment, key, default)
  end

  defp format_event(level, msg, timestamp, metadata, %{format: format, formatter: Logger.Formatter, metadata: config_metadata}) do
    Logger.Formatter.format(format, level, msg, timestamp, take_metadata(metadata, config_metadata))
  end

  defp format_event(level, msg, timestamp, metadata, %{format: format, formatter: formatter, metadata: config_metadata}) do
    apply(formatter, :format,
          [format, level, msg, timestamp, metadata, config_metadata])
  end

  defp log_event(level, msg, timestamp, metadata, config) do
    output = format_event(level, msg, timestamp, metadata, config)
    HTTPoison.post(config.url, output, %{"content-type": "text/plain"}, timeout: config.timeout)
  end

  defp require_loggly_key(environment) do
    case get_config(environment, :loggly_key, :not_found) do
      :not_found ->
        raise MissingLogglyKeyError
      value -> value
    end
  end

  defp setup(name, opts) do
    environment = Application.get_env(:logger, name, [])
    opts = Keyword.merge(environment, opts)
    Application.put_env(:logger, name, opts)

    format = Keyword.get(opts, :format) |> Logger.Formatter.compile
    loggly_key = require_loggly_key(opts)
    level = get_config(opts, :level, :info)
    tags = get_config(opts, :tags, [])
    log_type = get_config(opts, :type, :inputs)
    timeout = get_config(opts, :timeout, 5000)
    host = get_config(opts, :host, @api_host)
    metadata = get_config(opts, :metadata, [])
    formatter = get_config(opts, :formatter, Logger.Formatter)

    %{name: name,
      url: "#{host}/#{log_type}/#{loggly_key}/tag/#{Enum.join(tags, ",")}",
      format: format,
      formatter: formatter,
      level: level,
      metadata: metadata,
      tags: tags,
      timeout: timeout}
  end

end
