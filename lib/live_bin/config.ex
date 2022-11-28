defmodule LiveBin.Config do
  def bin_inactivity_timeout_ms do
    Application.get_env(:live_bin, :bin_inactivity_timeout_ms, :infinity)
  end

  def bin_max_requests do
    # nil is ok as default since any integer is <= nil
    Application.get_env(:live_bin, :bin_max_requests)
  end

  def bin_subdomains? do
    Application.get_env(:live_bin, :use_bin_subdomains, false)
  end
end
