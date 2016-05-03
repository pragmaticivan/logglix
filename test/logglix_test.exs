defmodule LogglixTest do
  use ExUnit.Case, async: false
  require Logger

  @backend {Logglix, :test}

  Logger.add_backend @backend

end
