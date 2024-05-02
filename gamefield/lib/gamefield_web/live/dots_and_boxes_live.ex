defmodule GamefieldWeb.DotsAndBoxesLive do
  use GamefieldWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, indexes_selected: [])
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <h1>Dots and Boxes</h1>
      <div>
        <span>
          Hello, <%= @current_user.email %>
        </span>
      </div>

      <%= if(length(@indexes_selected) > 0) do %>
        <span>
            You just selected: <%= Enum.join(@indexes_selected, ", ") %>
        </span>
      <% end %>

      <.grid n_rows={10} n_columns={10} indexes_selected={@indexes_selected}/>
    """
  end

  attr :n_rows, :integer, required: true
  attr :n_columns, :integer, required: true
  attr :indexes_selected, :list, required: true
  defp grid(assigns) do
    ~H"""
    <%= for row_index <- 0..@n_rows-1 do %>
      <div class="flex justify-around w-full">
        <%= for column_index <- 0..@n_columns-1 do %>
          <.horizontal_line index={column_index + row_index * 2 * @n_columns + row_index} indexes_selected={@indexes_selected}/>
        <% end %>
      </div>
      <div class="flex justify-between w-full">
        <%= for column_index <- 0..@n_columns do %>
          <.vertical_line index={column_index + ((row_index * 2) + 1) * @n_columns + row_index} indexes_selected={@indexes_selected}/>
        <% end %>
      </div>
    <% end %>
    <div class="flex justify-around w-full">
      <%= for column_index <- 0..@n_columns-1 do %>
        <.horizontal_line index={column_index + @n_rows * 2 * @n_columns + @n_rows} indexes_selected={@indexes_selected}/>
      <% end %>
    </div>
    """
  end

  attr :index, :integer, required: true
  attr :indexes_selected, :list, required: true
  defp horizontal_line(assigns) do
    ~H"""
      <button
        phx-click={JS.push("select", value: %{index: @index})}
      >
        <div class={
          "flex-none w-[5vh] h-1 " <> check_selected(assigns)
          }
        />
      </button>
    """
  end

  attr :index, :integer, required: true
  attr :indexes_selected, :list, required: true
  defp vertical_line(assigns) do
    ~H"""
      <button
        phx-click={JS.push("select", value: %{index: @index})}
      >
        <div class={
          "flex-none w-1 h-[5vh] " <> check_selected(assigns)
          } />
      </button>
    """
  end

  defp check_selected(assigns) do
    if (assigns.index in assigns.indexes_selected),
    do: "bg-white",
    else: "bg-black"
  end

  def handle_event("select", %{"index" => index}, socket) do
    socket = update(socket, :indexes_selected, fn prev -> [index | prev] end)
    {:noreply, socket}
  end
end
