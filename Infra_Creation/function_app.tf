resource "azurerm_storage_account" "storage_account" {
  name                     = "storageapiandapp"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document = "index.html"
  }
}


resource "azurerm_service_plan" "service_plan" {
  name                = "app-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function_app_api" {
    depends_on = [ azurerm_signalr_service.signalr ]
  name                = "windows-function-app-cbc-ai-speech"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
        https_only         = "true"

  site_config {
    application_stack {
      dotnet_version = "v8.0"
    }
    websockets_enabled = "true"
  }
  app_settings = {
    "AzureSignalRConnectionString" = azurerm_signalr_service.signalr.primary_connection_string
    "FUNCTIONS_INPROC_NET8_ENABLED" = "1"
    "WEBSITE_RUN_FROM_PACKAGE"      = "1" 
  }
}