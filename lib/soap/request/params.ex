defmodule Soap.Request.Params do
  @moduledoc """
  Documentation for Soap.Request.Options.
  """
  import XmlBuilder, only: [generate: 1, element: 3]
  alias Soap.Wsdl

  @schema_types %{
    "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
  }
  @soap_version_namespaces %{
    "1" => "http://schemas.xmlsoap.org/soap/envelope/",
    "1.2" => "http://www.w3.org/2003/05/soap-envelope"
  }

  @doc """
  Headers generator by soap action and custom headers.
  ## Examples

  """
  @spec build_headers(soap_action :: String.t(), custom_headers :: list()) :: list()
  def build_headers(soap_action, custom_headers) do
    extract_headers(soap_action, custom_headers)
  end

  @doc """
  Returns endpoint url from wsdl.
  """
  @spec get_url(wsdl :: map()) :: String.t()
  def get_url(wsdl) do
    Wsdl.get_endpoint(wsdl)
  end

  @doc """
  Parsing parameters map and generate body xml by given soap action name and body params(Map).
  Returns xml-like string.
  """
<<<<<<< HEAD
  @spec build_body(wsdl :: map(), soap_action :: String.t() | atom(), params :: map()) :: String.t()
  def build_body(wsdl, soap_action, params) do
    params
    |> construct_xml_request_body
=======
  @spec build_body(wsdl :: String.t(), soap_action :: String.t() | atom(), params :: map()) :: String.t()
  def build_body(wsdl, soap_action, params) do
    params
    |> construct_xml_request_body
    |> add_action_tag_wrapper(wsdl, soap_action)
    |> add_body_tag_wrapper
>>>>>>> 468aad47eafea02ee6536f3e63c978349c155544
    |> add_envelop_wrapper(wsdl)
    |> Enum.map(&Tuple.to_list/1)
    |> List.foldl([], &(&1 ++ &2))
    |> List.to_tuple
    |> generate
  end

  defp base_headers(soap_action) do
    [{"SOAPAction", to_string(soap_action)},
     {"Content-Type", "text/xml;charset=UTF-8"}]
  end

  defp extract_headers(soap_action, []), do: base_headers(soap_action)

  defp extract_headers(_, custom_headers), do: custom_headers

  @spec construct_xml_request_body(params :: map() | list()) :: list()
  defp construct_xml_request_body(params) when is_map(params) or is_list(params) do
    params |> Enum.map(&construct_xml_request_body/1)
  end

  @spec construct_xml_request_body(params :: tuple()) :: tuple()
  defp construct_xml_request_body(params) when is_tuple(params) do
    params
    |> Tuple.to_list
    |> Enum.map(&construct_xml_request_body/1)
    |> insert_tag_parameters
    |> List.to_tuple
  end

  @spec construct_xml_request_body(params :: atom() | number()) :: String.t()
  defp construct_xml_request_body(params) when is_atom(params) or is_number(params), do: params |> to_string

  @spec construct_xml_request_body(params :: String.t()) :: String.t()
  defp construct_xml_request_body(params) when is_binary(params), do: params

  @spec tag_parameters(tag_name :: any()) :: any()
  defp tag_parameters(tag_name), do: nil

  @spec insert_tag_parameters(params :: list()) :: list()
  defp insert_tag_parameters(params) when is_list(params) do
    tag_name = params |> List.first

    params |> List.insert_at(1, tag_parameters(tag_name))
  end

  @spec insert_tag_parameters(params :: any()) :: any()
  defp insert_tag_parameters(params), do: params

<<<<<<< HEAD
=======
  defp add_action_tag_wrapper(body, wsdl, soap_action) do
    action_tag =
      wsdl
      |> Wsdl.get_compex_types
      |> Enum.find(fn(x) -> x[:name] == soap_action end)
      |> Map.get(:type)
    [element(action_tag, nil, body)]
  end

  defp add_body_tag_wrapper(body), do: [element(:"#{env_namespace()}:Body", nil, body)]
>>>>>>> 468aad47eafea02ee6536f3e63c978349c155544

  defp add_envelop_wrapper(body, wsdl) do
    soap_version = soap_version() |> to_string
    soap_version_attribute = %{"xmlns:#{env_namespace()}" => @soap_version_namespaces[soap_version]}
    envelop_attributes = @schema_types |> Map.merge(soap_version_attribute) |> Map.merge(custom_namespaces())
<<<<<<< HEAD
    [element(:"env:Envelope", envelop_attributes, body)]
=======
    [element(:"#{env_namespace()}:Envelope", envelop_attributes, body)]
>>>>>>> 468aad47eafea02ee6536f3e63c978349c155544
  end

  defp soap_version, do: Application.fetch_env!(:soap, :globals)[:version]
  defp env_namespace, do: Application.fetch_env!(:soap, :globals)[:env_namespace] || :env
  defp custom_namespaces, do: Application.fetch_env!(:soap, :globals)[:custom_namespaces] || %{}
end
