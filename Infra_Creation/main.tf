resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "azurerm_cognitive_account" "ai_speech" {
  name                = join("-", ["CBC-AI",random_pet.rg_name.id])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "SpeechServices"

  sku_name = "F0"


}

resource "azurerm_signalr_service" "signalr" {
  name                = join("-", ["signalr",random_pet.rg_name.id])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "Free_F1"
    capacity = 1
  }

}