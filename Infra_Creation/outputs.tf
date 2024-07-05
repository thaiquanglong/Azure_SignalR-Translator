output "ai_speech_endpoint" {
  value = azurerm_cognitive_account.ai_speech.endpoint
}

output "ai_speech_key" {
  value = azurerm_cognitive_account.ai_speech.primary_access_key
  sensitive = true
}

output "signalr_hostname" {
  value = azurerm_signalr_service.signalr.hostname
  
}

output "signalr_ip_address" {
  value = azurerm_signalr_service.signalr.ip_address
}

output "signalr_public_port" {
  value = azurerm_signalr_service.signalr.public_port
}

output "signalr_server_port" {
  value = azurerm_signalr_service.signalr.server_port
}

output "signalr_connection_string" {
  value = azurerm_signalr_service.signalr.primary_connection_string
  sensitive = true
}

output "region" {
  value = var.resource_group_location
}

output "function_app_api_default_hostname" {
  value = azurerm_windows_function_app.function_app_api.default_hostname
  
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "primary_web_host" {
  value = azurerm_storage_account.storage_account.primary_web_host
}