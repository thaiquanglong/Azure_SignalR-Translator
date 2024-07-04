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