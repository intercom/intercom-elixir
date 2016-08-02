defmodule Intercom do
  alias ESTree.Tools.Builder
  alias ESTree.Tools.Generator
  alias Intercom.Escaping

  def to_javascript_object(dict) when is_map(dict) do
    props = Enum.map(dict, fn {k, v} ->
      Builder.property(
        Builder.identifier(k),
        v |> Escaping.html_escape |> Builder.literal
      )
    end)
    Builder.object_expression(props)
  end

  def boot({:ok, opts}), do: {:ok, boot(opts)}
  def boot({:error, reason}), do: {:error, reason}

  def boot(opts) when is_map(opts) do
    Builder.call_expression(
      Builder.identifier(:Intercom),
      [
        Builder.literal(:boot),
        to_javascript_object(opts)
      ]
    )
  end

  def inject_user_hash(secret, opts) when is_map(opts) do
    key = cond do
      Map.has_key?(opts, :user_id) -> :user_id
      Map.has_key?(opts, :email) -> :email
      true -> {:error, "email or user_id required"}
    end

    case key do
      {:error, reason} -> {:error, reason}
      key ->
        {:ok, case secret do
          nil -> opts
          _ -> Map.merge(opts, %{:user_hash => :sha256
            |> :crypto.hmac(secret, Map.fetch!(opts, key))
            |> Base.encode16
            |> String.downcase
          })
        end}
    end
  end

  def snippet(props, opts) when is_map(props) do
    app_id = opts[:app_id]
    secret = opts[:secret]
    nonce_attr = case opts[:csp_nonce] do
      nil -> ""
      nonce -> " nonce=\"#{nonce}\""
    end
    base = "<script#{nonce_attr}>(function(){var w=window;var ic=w.Intercom;if(typeof ic===\"function\"){ic('reattach_activator');ic('update',intercomSettings);}else{var d=document;var i=function(){i.c(arguments)};i.q=[];i.c=function(args){i.q.push(args)};w.Intercom=i;function l(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/#{app_id}';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s,x);}if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}};})();"
    ast = secret |> inject_user_hash(Map.merge(props, %{:app_id => app_id})) |> boot
    case ast do
      {:ok, tree} ->
        {:ok, base <> Generator.generate(tree) <> ";</script>"}
      x -> x
    end
  end
end
