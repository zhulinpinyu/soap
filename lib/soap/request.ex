defmodule Soap.Request do
  @moduledoc """
  Documentation for Soap.Request.
  """
  alias Soap.Request.Params

  @doc """
  Executing with parsed wsdl and headers with body map.
  Calling HTTPoison request by Map with method, url, body, headers, options keys.
  """
  @spec call(wsdl :: map(), soap_action :: String.t(), params :: any(), headers :: any()) :: any()
  def call(wsdl, soap_action, params, headers \\ []) do
    url = Params.get_url(wsdl)
    headers = Params.build_headers(soap_action, headers)
    body = Params.build_body(wsdl, soap_action, params)

    HTTPoison.post!(url, body, headers)
  end
end
