defmodule MFPB.Config do
  def bin_inactivity_timeout_ms do
    Application.get_env(:mfpb, :bin_inactivity_timeout_ms, :infinity)
  end

  def bin_max_requests do
    # nil is ok as default since any integer is <= nil
    Application.get_env(:mfpb, :bin_max_requests)
  end
end
