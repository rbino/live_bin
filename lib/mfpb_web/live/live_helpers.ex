defmodule MFPBWeb.LiveHelpers do
  use Phoenix.HTML

  import Phoenix.LiveView.Helpers

  def bin_error(assigns) do
    ~H"""
    <div class="text-center">
      <h1 class="mg"><%= @error_message %></h1>
      <p>Redirecting to <%= link("index", to: "/") %> in 5 seconds.</p>
    </div>
    """
  end
end
