defmodule IntercomTest do
  use ExUnit.Case
  alias ESTree.Tools.Generator
  doctest Intercom

  test "turning maps into JavaScript objects" do
    ast = Intercom.to_javascript_object(%{:foo => "bar"})
    code = Generator.generate(ast)
    assert code == "{\n        foo: 'bar'\n  }"
  end

  test "Intercom boot" do
    ast = Intercom.boot(%{:email => "bob@bob.com"})
    code = Generator.generate(ast)
    assert code == "Intercom('boot',{\n        email: 'bob@bob.com'\n  })"
  end

  test "Secure mode with no secret" do
    opts = %{:email => "bob@bob.com"}
    {:ok, with_hash} = Intercom.inject_user_hash(nil, opts)
    assert with_hash == opts
  end

  test "Secure mode with secret and email" do
    opts = %{:email => "bob@bob.com"}
    {:ok, with_hash} = Intercom.inject_user_hash("foo", opts)
    assert with_hash == Map.merge(opts, %{:user_hash => "4cd76f875cf6760a8f2c2b1c1e621787df84c8c7aeeab2c8bceeb5ce35d5bb7e"})
  end

  test "Secure mode with secret and user_id" do
    opts = %{:user_id => "1234"}
    {:ok, with_hash} = Intercom.inject_user_hash("foo", opts)
    assert with_hash == Map.merge(opts, %{:user_hash => "3d5343ad7262bb7c67ff259831af3a081b2aa3698d214154be22d391a18f951c"})
  end

  test "full snippet" do
    opts = %{:email => "bob@bob.com"}
    {:ok, snippet} = Intercom.snippet(opts, app_id: "foo")
    assert snippet == "<script>(function(){var w=window;var ic=w.Intercom;if(typeof ic===\"function\"){ic('reattach_activator');ic('update',intercomSettings);}else{var d=document;var i=function(){i.c(arguments)};i.q=[];i.c=function(args){i.q.push(args)};w.Intercom=i;function l(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/foo';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s,x);}if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}};})();Intercom('boot',{\n        app_id: 'foo',     email: 'bob@bob.com'\n  });</script>"
  end

  test "full snippet with nonce" do
    opts = %{:email => "bob@bob.com"}
    {:ok, snippet} = Intercom.snippet(opts, app_id: "foo", csp_nonce: "bar")
    assert snippet == "<script nonce=\"bar\">(function(){var w=window;var ic=w.Intercom;if(typeof ic===\"function\"){ic('reattach_activator');ic('update',intercomSettings);}else{var d=document;var i=function(){i.c(arguments)};i.q=[];i.c=function(args){i.q.push(args)};w.Intercom=i;function l(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/foo';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s,x);}if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}};})();Intercom('boot',{\n        app_id: 'foo',     email: 'bob@bob.com'\n  });</script>"
  end

  test "with missing required params" do
    opts = %{:foo => "bar"}
    {:error, reason} = Intercom.snippet(opts, app_id: "foo", csp_nonce: "bar")
    assert  reason == "email or user_id required"
  end
end
